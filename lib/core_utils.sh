#!/usr/bin/env bash
# useful utilities

# shellcheck disable=2181


# modules
msu_require "console"
msu_require "format"
msu_require "metadata"


# module variables
{
  # shellcheck disable=2034
  DEPS="git"
}


# Executes a command for each line in the specified file.
# The command is passed the line as the only argument.
# ${1} - function
# ${2} - path to file
function for_each_line_in_file() {
  # ensure the file exists, otherwise the `cat` command will hang
  if [ ! -f "${2}" ]
  then
    error "file does NOT exist"
    return 1
  fi
  # read the list into a variable
  local mods
  mods="$(cat "${2}")"
  for mod in ${mods}
  do
    ${1} "${mod}"
  done
}


# Returns the version of the latest release.
function get_latest_version() {
  curl --silent https://api.github.com/repos/GochoMugo/msu/releases/latest |\
      grep tag_name |\
      grep -Eo '[0-9]+\.[0-9]+\.[0-9]+'
}


# Returns the major part of a semver version.
# ${1} - semver version
function get_major_version() {
  grep -Eo '^[0-9]+' <<< "${1}"
}


# Returns the minor part of a semver version.
# ${1} - semver version
function get_minor_version() {
  grep -Eo '\.[0-9]+\.' <<< "${1}" | sed -e s/\\.//g
}


# Returns the patch version of a semver version.
# ${1} - semver version
function get_patch_version() {
  grep -Eo '[0-9]+$' <<< "${1}"
}


# checking if command is available on the system.
# ${1} - command to check for.
function has_command() {
  command -v "${1}" > /dev/null 2>&1
}


# Installs modules.
# ${*} - module names
function install() {
  local do_force=
  declare -a modules

  for opt in "${@}" ; do
    case "${opt}" in
        "-f" | "--force" )
          do_force=1
          ;;
        * )
          modules+=("${opt}")
          ;;
    esac
  done

  mkdir -p "${MSU_EXTERNAL_LIB}"
  for dir in "${modules[@]}" ; do
    local module_name
    local remote_mark
    remote_mark=$(echo "${dir}" | grep -Eo "[a-zA-Z0-9]+:" | grep -Eo "[^:]*")
    if [ "${remote_mark}" ] ; then
      # requires cloning
      local tmpdir
      local shorthand
      local version
      local url
      tmpdir="/tmp/.msu.clones"
      remote_mark=$(echo "${remote_mark}" | tr '[:upper:]' '[:lower:]')
      shorthand="${dir##*:}"
      version="${shorthand##*#}"
      if [ "${version}" == "${shorthand}" ] ; then
        version=""
      fi
      shorthand="${shorthand%%#*}"
      case "${remote_mark}" in
        "gh" )
          url="https://github.com/${shorthand}.git"
        ;;
        "ghs" )
          url="git@github.com:${shorthand}.git"
        ;;
        "bt" )
          url="https://bitbucket.org/${shorthand}.git"
        ;;
        "bts" )
          url="git@bitbucket.org:${shorthand}.git"
        ;;
        "gl" )
          url="https://gitlab.com/${shorthand}.git"
        ;;
        "gls" )
          url="git@gitlab.com:${shorthand}.git"
        ;;
      esac
      rm -rf "${tmpdir}"
      mkdir -p "${tmpdir}"
      pushd "${tmpdir}" > /dev/null || return 1
      git clone --branch="${version:-master}" --depth=1 --quiet "${url}"
      if [ ! $? ]
      then
        cross "${shorthand}"
        continue
      fi
      install "$(ls)"
      popd > /dev/null || return 1
    else
      dir="$(readlink -f "${dir}")"
      module_name="$(basename "${dir}")"
      if [ -e "${MSU_EXTERNAL_LIB}/${module_name}" ] ; then
        if [ -z "${do_force}" ] ; then
          echo "error: module already installed: ${module_name}" > /dev/stderr
          return 1
        else
          rm -rf "${MSU_EXTERNAL_LIB:?}/${module_name}"
        fi
      fi
      cp -r "${dir}" "${MSU_EXTERNAL_LIB}" > /dev/null
      tick "${module_name}"
    fi
  done
}


# install many
function install_from_list() {
  for_each_line_in_file install "${1}"
}


# Returns 0 if the first version is greater than the
# second version. Otherwise returns 1.
# ${1} - first version
# ${2} - second version
function is_semver_gt() {
  local version1
  local version2
  version1="${1}"
  version2="${2}"

  local version1_major
  local version2_major
  version1_major=$(get_major_version "${version1}")
  version2_major=$(get_major_version "${version2}")

  if [[ "${version1_major}" -gt "${version2_major}" ]] ; then
    echo 0
    return 0
  elif [[ "${version1_major}" -lt "${version2_major}" ]] ; then
    echo 1
    return 1
  fi

  local version1_minor
  local version2_minor
  version1_minor=$(get_minor_version "${version1}")
  version2_minor=$(get_minor_version "${version2}")

  if [[ "${version1_minor}" -gt "${version2_minor}" ]] ; then
    echo 0
    return 0
  elif [[ "${version1_minor}" -lt "${version2_minor}" ]] ; then
    echo 1
    return 1
  fi

  local version1_patch
  local version2_patch
  version1_patch=$(get_patch_version "${version1}")
  version2_patch=$(get_patch_version "${version2}")

  if [[ "${version1_patch}" -gt "${version2_patch}" ]] ; then
    echo 0
    return 0
  fi

  echo 1
  return 1
}


# checking if script is run as root/superuser.
function is_superuser() {
  [[ "$(id -u)" == "0" ]]
}


# listing installed modules.
function list_modules() {
  local is_header_printed=
  if [ ! -d "${MSU_EXTERNAL_LIB}" ] ; then
    return
  fi
  for mod in "${MSU_EXTERNAL_LIB}"/* ; do
    if [ ! -d "${mod}" ] ; then
      continue
    fi
    if [ -z "${is_header_printed}" ] ; then
      # shellcheck source=lib/format.sh
      echo -e "${clr_white:?}external modules${clr_reset:?}"
      is_header_printed=1
    fi
    echo -e "\\t$(basename "${mod}")"
  done
}


# nuke msu entirely
function nuke() {
  # just ask to ensure we really want to nuke
  log "you are about to remove the msu executable, internal and external libraries"
  log "this action will change your ~/.bashrc! You may want to back it up in case shit happens!"
  yes_no "I want to nuke msu" || return 1

  local nuke_script="/tmp/nuke_msu.${RANDOM}"
  {
    echo "echo - removing load string from ~/.bashrc"
    echo "cp ~/.bashrc /tmp/bashrc.msu"
    echo "grep -v '${MSU_INSTALL_LOAD_STRING}' /tmp/bashrc.msu > ~/.bashrc"
    echo "rm /tmp/bashrc.msu"
    echo "echo - removing external modules"
    echo "rm -rf '${MSU_EXTERNAL_LIB}'"
    echo "echo - removing core"
    echo "rm -rf '${MSU_LIB}'"
    echo "echo - removing manpages"
    echo "rm -rf ${MSU_INSTALL_MAN}/man1/msu*"
    echo "rm -rf ${MSU_INSTALL_MAN}/man3/msu*"
    echo "echo - removing executable"
    echo "rm -f '${MSU_EXE}'"
    echo "echo !! Just nuked msu !!"
  } > "${nuke_script}"
  # running the nuke script
  bash "${nuke_script}"
}


# show metadata for an installed module
function show_metadata() {
  local metadata_file
  metadata_file="${MSU_EXTERNAL_LIB}/${1}/metadata.sh"
  if [ ! -f "${metadata_file}" ] ; then
    error "module metadata not found: ${1}"
    return 1
  fi
  # shellcheck disable=SC1090
  source "${metadata_file}"
  echo -e " ${clr_white}${1}${clr_reset}"
  echo -e "    author\\t${clr_white}${author:?}${clr_reset}"
  echo -e "    build\\t${clr_white}${build:?}${clr_reset}"
  echo -e "    date\\t${clr_white}${date:?}${clr_reset}"
}


# uninstall module(s)
function uninstall() {
  for dir in "$@" ; do
    path="${MSU_EXTERNAL_LIB}/${dir}"
    if [ -e "${path}" ] ; then
      rm -rf "${path}" > /dev/null
      tick "${dir}"
    else
      tick "${dir} (not installed)"
    fi
  done
}


# uninstall many
function uninstall_from_list() {
  for_each_line_in_file uninstall "${1}"
}


# upgrade myself
function upgrade() {
  log "upgrading myself"
  local version
  version="${1}"

  LIB=${MSU_INSTALL_LIB:-$(dirname "${MSU_LIB}")}
  BIN=${MSU_INSTALL_BIN:-$(readlink -f "$(dirname "$(command -v msu)")")}
  MAN=${MSU_INSTALL_MAN}

  if [ ! "${MAN}" ] ; then
    for path in ${MANPATH//\:/\n} ; do
      if [ -f "${path}/man1/msu.1" ] ; then
        MAN=${path}
        break
      fi
    done
  fi

  [ ! "${version}" ] && {
    version=$(get_latest_version)
    if [ ! "${version}" ] ; then
      error "network request error"
      return 3
    fi

    if ! is_semver_gt "${version}" "${MSU_VERSION}" > /dev/null ; then
      log "you have the latest version"
      return 2
    fi
  }

  pushd /tmp > /dev/null || return 1
  wget "https://github.com/GochoMugo/msu/releases/download/${version}/msu-${version}.tar.gz" -q > /dev/null
  tar xvf "msu-${version}.tar.gz" > /dev/null 2>&1
  cd "msu-${version}" || {
    error "could not \`cd' into directory with extracted contents"
    return 1
  }
  LIB="${LIB}" BIN="${BIN}" MAN="${MAN}" ./install.sh
  popd > /dev/null || return 1
}
