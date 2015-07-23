#
# useful utilities
#


# modules
msu_require "console"


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
    cp -r ${dir} ${MSU_EXTERNAL_LIB} > /dev/null
    if [ $? ] ; then
      tick ${dir}
    else
      cross ${dir}
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
