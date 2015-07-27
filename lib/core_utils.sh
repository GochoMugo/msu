#
# useful utilities
#


# modules
msu_require "console"
msu_require "format"


# module variables
DEPS="git"


# upgrade myself
function upgrade() {
  log "upgrading myself"
  LIB=$(dirname ${MSU_LIB})
  BIN=$(dirname $(which msu))
  wget -qO- http://git.io/vTE0s | LIB=${LIB} BIN=${BIN} bash
}


# install module(s)
function install() {
  mkdir -p ${MSU_EXTERNAL_LIB}
  for dir in "$@"
  do
    local module_name
    local remote_mark=$(echo ${dir} | grep -Eo "[a-Z0-9]+:" | grep -Eo "[^:]*")
    if [ ${remote_mark} ] ; then
      # requires cloning
      local tmpdir="/tmp/.msu.clones"
      local shorthand=$(echo ${dir} | grep -Eo ":.*" | cut -b 2-)
      local url
      remote_mark=$(echo ${remote_mark} | tr '[A-Z]' '[a-z]')
      case ${remote_mark} in
        "gh" )
          url="https://github.com/${shorthand}.git"
        ;;
      esac
      rm -rf ${tmpdir}
      mkdir -p ${tmpdir}
      pushd ${tmpdir} > /dev/null
      git clone --depth=1 --quiet ${url}
      [ $? ] || {
        cross ${shorthand}
        continue
      }
      module_name=$(ls | head -n 1)
      install ${module_name}
      popd > /dev/null
    else
      # simple copying
      module_name=$(basename ${dir})
      rm -rf ${MSU_EXTERNAL_LIB}/${module_name}
      cp -rf ${dir} ${MSU_EXTERNAL_LIB} > /dev/null
      if [ $? -eq 0 ] ; then
        generate_metadata ${module_name}
        tick ${module_name}
      else
        cross ${module_name}
      fi
    fi
  done
}


# generate metadata for an installed module
function generate_metadata() {
  pushd ${MSU_EXTERNAL_LIB}/${1} > /dev/null
  if [ ! -d .git ] || [ $(git rev-list --all --count 2> /dev/null || echo 0) -eq 0 ]
  then
    error "can not generate metadata without at least one git commit"
    return 1
  fi
  echo "author=$(git show -s --format='%an <%ae>')" >> metadata.sh
  echo "build=$(git rev-parse HEAD)" >> metadata.sh
  echo "date=$(git show -s --format=%ci)" >> metadata.sh
  popd > /dev/null
}


# show metadata for an installed module
function show_metadata() {
  local metadata_file=${MSU_EXTERNAL_LIB}/${1}/metadata.sh
  if [ ! -f "${metadata_file}" ]
  then
    error "metadata for ${1} not found"
    return 1
  fi
  local metadata=$(cat ${metadata_file})
  function echo_value() {
    local value=$(echo "${metadata}" | grep ${1} | grep -Eo '[!=].*$' | cut -b 2-)
    echo -e "    ${1}\t${value}"
  }
  echo -e " ${clr_white}${1}${clr_reset}"
  echo_value "author"
  echo_value "build"
  echo_value "date"
}


# uninstall module(s)
function uninstall() {
  for dir in "$@"
  do
    path=${MSU_EXTERNAL_LIB}/${dir}
    [ -e ${path} ] && {
      rm -rf ${path} > /dev/null
      if [ $? ] ; then
        tick ${dir}
      else
        cross "${dir} - failed"
      fi
    } || {
      tick "${dir} (not installed)"
    }
  done
}
