#!/usr/bin/env bash
# useful utilities


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
  BIN=${MSU_INSTALL_BIN:-$(dirname "$(which msu)")}
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
  pushd /tmp > /dev/null
  [ ! "${version}" ] && {
    version=$(python "${MSU_LIB}/get-latest-version.py" "${MSU_VERSION}")
    status=$?
    case "${status}" in
      1 )
        log "you have the latest version"
      ;;
      2 )
        error "required python dependencies are missing"
        echo "${version}"
      ;;
      3 )
        error "network request error"
        echo "${version}"
      ;;
    esac
    [ "${status}" -ne 0 ] && exit ${status}
  }
  wget "https://github.com/GochoMugo/msu/releases/download/${version}/msu-${version}.tar.gz" -q > /dev/null
  tar xvf "msu-${version}.tar.gz" > /dev/null 2>&1
  cd "msu-${version}" || {
    error "could not \`cd' into directory with extracted contents"
    return 1
  }
  LIB="${LIB}" BIN="${BIN}" MAN="${MAN}" ./install.sh
  popd > /dev/null
}


# install module(s)
# ${*} module names
function install() {
  mkdir -p "${MSU_EXTERNAL_LIB}"
  for dir in "${@}"
  do
    local module_name
    local remote_mark
    remote_mark=$(echo "${dir}" | grep -Eo "[a-Z0-9]+:" | grep -Eo "[^:]*")
    if [ "${remote_mark}" ] ; then
      # requires cloning
      local tmpdir
      local shorthand
      local url
      tmpdir="/tmp/.msu.clones"
      shorthand=$(echo "${dir}" | grep -Eo ":.*" | cut -b 2-)
      remote_mark=$(echo "${remote_mark}" | tr '[:upper:]' '[:lower:]')
      case "${remote_mark}" in
        "gh" )
          url="https://github.com/${shorthand}.git"
        ;;
        "bt" )
          url="https://bitbucket.org/${shorthand}.git"
        ;;
      esac
      rm -rf "${tmpdir}"
      mkdir -p "${tmpdir}"
      pushd "${tmpdir}" > /dev/null
      git clone --depth=1 --quiet "${url}"
      if [ ! $? ]
      then
        cross "${shorthand}"
        continue
      fi
      module_name=$(echo "${shorthand}" | grep -Eo '\/.*$' | cut -b 2-)
      install "${module_name}"
      popd > /dev/null
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
  pushd "${MSU_EXTERNAL_LIB}/${1}" > /dev/null
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
  popd > /dev/null
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
    echo -e "    ${1}\t${value}"
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


# checking if command is available on the system.
# ${1} - command to check for.
function has_command() {
  command -v "${1}" > /dev/null 2>&1
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
    echo -e "\n${clr_white}internal modules${clr_reset}"
    output "$(ls "${MSU_LIB}")"
  }

  # list external modules, if allowed
  [[ "${external}" == "true" ]] && {
    echo -e "\n${clr_white}external modules${clr_reset}"
    output "$(ls "${MSU_EXTERNAL_LIB}")"
  }
}

