# msu (my-shell-utils)
#
# Copyright (c) 2015 GochoMugo <mugo@forfuture.co.ke>

# mod vars
MSU_REQUIRE_LOCK=

# determine root (dir holding this dir)
command -v msu > /dev/null 2>&1 && {
  ROOT=$(dirname $(which msu))
  LIB=${ROOT}/msu-lib
} || {
  ROOT=.
  LIB=${ROOT}/lib
}

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

# parse command line arguments
case ${1} in
  "load" )
    msu_load
  ;;
  "require" )
    msu_require ${2}
  ;;
  "upgrade" )
    wget -qO- http://git.io/vTE0s | bash
  ;;
  * )
    # do nothing. we might be sourced
  ;;
esac

