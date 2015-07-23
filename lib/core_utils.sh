#
# useful utilities
#


# modules
msu_require console


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
      local dir_name=$(ls | head -n 1)
      install ${dir_name}
      popd > /dev/null
    else
      # simple copying
      cp -rf ${dir} ${MSU_EXTERNAL_LIB} > /dev/null
      if [ $? ] ; then
        tick ${dir}
      else
        cross ${dir}
      fi
    fi
  done
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
