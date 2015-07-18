#
# The Core functionalities
#


# we expect the the executable exports a variable MSU_LIB whose
# value is the path to the library holding this and other modules


# mod vars
MSU_REQUIRE_LOCK= # lock to ensure we dont source an already-sourced file


# load all modules
msu_load() {
  ls ${MSU_LIB} | xargs source
}


# require a module
msu_require() {
  echo ${MSU_REQUIRE_LOCK} | grep -E :${1}: > /dev/null || {
    source ${MSU_LIB}/${1}.sh
    MSU_REQUIRE_LOCK=:${1}:${MSU_REQUIRE_LOCK}
  }
}


# run a single function
msu_run() {
  local module=$(echo ${1} | grep -Eo ".*\." | grep -Eo "[a-Z0-9]+")
  local func=$(echo ${1} | grep -Eo "\..*" | cut -b 2- )
  msu_require ${module}
  ${func} ${@:2}
}
