#
# The Core functionalities
#


# we expect the the executable exports a variable MSU_LIB whose
# value is the path to the library holding this and other modules


# mod vars
MSU_REQUIRE_LOCK= # lock to ensure we dont source an already-sourced file
MSU_EXTERNAL_LIB=${MSU_EXTERNAL_LIB:-${HOME}/.msu}


# check dependencies
function msu__check_deps() {
  for cmd in ${DEPS}
  do
    command -v ${cmd} > /dev/null 2>&1 || {
      echo "warning: \`${cmd}' not found"
    }
  done
}


# require a module
function msu_require() {
  echo ${MSU_REQUIRE_LOCK} | grep -E :${1}: > /dev/null || {
    local fullpath=$(echo ${1} | sed 's/\.*$//g' | sed 's/\./\//g')
    source ${MSU_LIB}/${fullpath}.sh > /dev/null 2>&1 || {
      echo "error: require: failed to load module '${1}'"
      exit 1
    }
    msu__check_deps
    MSU_REQUIRE_LOCK=:${1}:${MSU_REQUIRE_LOCK}
  }
}


# run a single function
function msu_run() {
  local module=$(echo ${1} | grep -Eo ".*\.")
  local func=$(echo ${1} | grep -Eo "\.[^.]+$" | cut -b 2-)
  msu_require ${module}
  ${func} ${@:2}
}


# upgrade myself
function msu_upgrade() {
  LIB=$(dirname ${MSU_LIB})
  BIN=$(dirname $(which msu))
  wget -qO- http://git.io/vTE0s | LIB=${LIB} BIN=${BIN} bash
}
