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


# upgrade myself
function upgrade() {
  log "upgrading myself"
  LIB=${MSU_INSTALL_LIB:-$(dirname "${MSU_LIB}")}
  BIN=${MSU_INSTALL_BIN:-$(dirname "$(command -v msu)")}
  MAN=${MSU_INSTALL_MAN}
  if [ ! "${MAN}" ]
  then
    for path in ${MANPATH//\:/\n}
    do
      if [ -f "${path}/man1/msu.1" ]
      then
        MAN=${path}
        break
      fi
    done
  fi

  if [ "${1}" ]
  then
    head=$(echo "${1}" | tr '[:upper:]' '[:lower:]')
    case "${head}" in
      "head" )
        wget -qO- http://git.io/vTE0s | LIB="${LIB}" BIN="${BIN}" MAN="${MAN}" bash
      ;;
      * )
        version="${1}"
      ;;
    esac
    [ ! "${version}" ] && return
  fi

  # upgrade using tarball
  pushd /tmp > /dev/null || return 1
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
  wget "https://github.com/GochoMugo/msu/releases/download/${version}/msu-${version}.tar.gz" -q > /dev/null
  tar xvf "msu-${version}.tar.gz" > /dev/null 2>&1
  cd "msu-${version}" || {
    error "could not \`cd' into directory with extracted contents"
    return 1
  }
  LIB="${LIB}" BIN="${BIN}" MAN="${MAN}" ./install.sh
  popd > /dev/null || return 1
}


# install module(s)
# ${*} module names
function install() {
  mkdir -p "${MSU_EXTERNAL_LIB}"
  for dir in "${@}"
  do
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
      shorthand=$(echo "${dir}" | sed --regexp-extended --expression=s/^.+:\([^\#]+\).*/\\1/)
      version=$(echo "${dir}" | grep '#' | sed --regexp-extended --expression=s/.+\#\(.+\)$/\\1/)
      remote_mark=$(echo "${remote_mark}" | tr '[:upper:]' '[:lower:]')
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
      module_name=$(echo "${shorthand}" | grep -Eo '\/.*$' | cut -b 2-)
      install "${module_name}"
      popd > /dev/null || return 1
    else
      # simple copying
      # for faster development, we may be in a module's repo and want to
      # install it without leaving the directory (or using $PWD)
      if [ "${dir}" == "." ] ; then dir="${PWD}" ; fi
      module_name="$(basename "${dir}")"
      rm -rf "${MSU_EXTERNAL_LIB:-'.'}/${module_name}"
      cp -rf "${dir}" "${MSU_EXTERNAL_LIB}" > /dev/null
      if [ $? -eq 0 ] ; then
        generate_metadata "${module_name}"
        tick "${module_name}"
      else
        cross "${module_name}"
      fi
    fi
  done
}


# generate metadata for an installed module
function generate_metadata() {
  pushd "${MSU_EXTERNAL_LIB}/${1}" > /dev/null || return 1
  if [ ! -d .git ] || [ "$(git rev-list --all --count 2> /dev/null || echo 0)" -eq 0 ]
  then
    error "can not generate metadata without at least one git commit"
    return 1
  fi
  {
    echo "author=$(git show -s --format='%an <%ae>')"
    echo "build=$(git rev-parse HEAD)"
    echo "date=$(git show -s --format=%ci)"
  } >> metadata.sh
  popd > /dev/null || return 1
}


# show metadata for an installed module
function show_metadata() {
  local metadata_file
  metadata_file="${MSU_EXTERNAL_LIB}/${1}/metadata.sh"
  if [ ! -f "${metadata_file}" ]
  then
    error "metadata for '${1}' not found"
    return 1
  fi
  local metadata
  metadata=$(cat "${metadata_file}")
  function echo_value() {
    local value
    value=$(echo "${metadata}" | grep "${1}" | grep -Eo '[!=].*$' | cut -b 2-)
    echo -e "    ${1}\\t${value}"
  }
  echo -e " ${clr_white:-''}${1}${clr_reset:-''}"
  echo_value "author"
  echo_value "build"
  echo_value "date"
}


# uninstall module(s)
function uninstall() {
  for dir in "$@"
  do
    path="${MSU_EXTERNAL_LIB}/${dir}"
    if [ -e "${path}" ]
    then
      rm -rf "${path}" > /dev/null
      if [ $? ] ; then
        tick "${dir}"
      else
        cross "${dir} - failed"
      fi
    else
      tick "${dir} (not installed)"
    fi
  done
}


# get to install/uninstall from a list
# ${1} - install/uninstall function
# ${2} - path to file
function get_from_list() {
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


# install many
function install_from_list() {
  get_from_list install "${1}"
}


# uninstall many
function uninstall_from_list() {
  get_from_list uninstall "${1}"
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
# ${1} - toggle option e.g. '-i', '--internal', '-e', '--external'
function list_modules() {
  local internal
  local external
  internal=true
  external=true

  # processing switch
  case "${1}" in
    "-i" | "--internal" )
      external=false
      ;;
    "-e" | "--external" )
      internal=false
      ;;
  esac

  # output function.
  function output() {
    for mod in ${1}
    do
      # ignore "aliases.sh"
      if [[ "${mod}" != "aliases.sh" ]]
      then
        list "${mod//\.sh/}"
      fi
    done
  }

  # list internal modules, if allowed
  [[ "${internal}" == "true" ]] && {
    echo -e "\\n${clr_white}internal modules${clr_reset}"
    # shellcheck disable=SC2010
    output "$(ls "${MSU_LIB}" | grep -E "\\.sh$")"
  }

  # list external modules, if allowed
  [[ "${external}" == "true" ]] && {
    echo -e "\\n${clr_white}external modules${clr_reset}"
    if [ -d "${MSU_EXTERNAL_LIB}" ]
    then
      output "$(ls "${MSU_EXTERNAL_LIB}")"
    else
      echo -e "${clr_red:-}no modules found${clr_reset}"
    fi
  }
}


# nuke msu entirely
function nuke() {
  # just ask to ensure we really want to nuke
  log "you are about to remove the msu executable, internal and external libraries"
  log "this action will change your ~/.bashrc! You may want to back it up in case shit happens!"
  yes_no "I want to nuke msu" || return 1

  local nuke_script="/tmp/nuke_msu"
  {
    echo "echo - removing load string from ~/.bashrc"
    echo "cp ~/.bashrc /tmp/bashrc.msu"
    echo "grep -v '${MSU_INSTALL_LOAD_STRING}' /tmp/bashrc.msu > ~/.bashrc"
    echo "cp ~/.bashrc /tmp/bashrc.msu"
    echo "grep -v '# added by msu' /tmp/bashrc.msu > ~/.bashrc"
    echo "rm /tmp/bashrc.msu"
    echo "echo - removing external libraries"
    echo "rm -rf '${MSU_EXTERNAL_LIB}'"
    echo "echo - removing internal libraries"
    echo "rm -rf '${MSU_LIB}'"
    echo "echo - removing manpages"
    echo "rm -rf ${MSU_INSTALL_MAN}/**/msu*"
    echo "echo - removing executable"
    echo "rm -f  '${MSU_EXE}'"
    echo "echo - extra removal actions"
    echo "rm -rf /tmp/msu" # we need to nuke the location of installation clone
    echo "rm -rf /tmp/.msu.clones"
    echo "echo - removing this nuke script"
    echo "rm -f '${nuke_script}'"
    echo "echo !! Just nuked msu !!"
  } > "${nuke_script}"
  # running the nuke script
  bash "${nuke_script}"
}
