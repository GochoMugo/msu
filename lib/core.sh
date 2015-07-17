#
# The Core functionalities
#


# mod vars
MSU_REQUIRE_LOCK= # lock to ensure we dont source an already-sourced file


# loads all utils
msu_load() {
  ls ${LIB} | xargs source
}


# require a module
msu_require() {
  echo ${MSU_REQUIRE_LOCK} | grep -E :${1}: || {
    source ${LIB}/${1}.sh
    MSU_REQUIRE_LOCK=:${1}:${MSU_REQUIRE_LOCK}
  }
}

msu_run() {
  local module=$(echo ${1} | grep -Eo ".*\." | grep -Eo "[a-Z0-9]+")
  local func=$(echo ${1} | grep -Eo "\..*" | cut -b 2- )
  msu_require ${module}
  msu_${func} ${@:2}
}
