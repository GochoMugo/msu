#
# The Core functionalities
#


set -e


# we expect the the executable exports a variable MSU_LIB whose
# value is the path to the library holding this and other modules


# mod vars
MSU_REQUIRE_LOCK= # lock to ensure we dont source an already-sourced file


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
    source ${MSU_LIB}/${1}.sh
    msu__check_deps
    MSU_REQUIRE_LOCK=:${1}:${MSU_REQUIRE_LOCK}
  }
}


# load all modules
function msu_load() {
  mods=$(ls ${MSU_LIB} | grep -Eo "^[a-Z]*")
  for mod in ${mods}
  do
    msu_require ${mod}
  done
}


# run a single function
function msu_run() {
  local module=$(echo ${1} | grep -Eo ".*\." | grep -Eo "[a-Z0-9]+")
  local func=$(echo ${1} | grep -Eo "\..*" | cut -b 2- )
  msu_require ${module}
  ${func} ${@:2}
}
