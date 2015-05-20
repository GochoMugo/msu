# msu (my-shell-utils)
#
# Copyright (c) 2015 GochoMugo <mugo@forfuture.co.ke>

# metadata
MSU_AUTHOR_NAME=GochoMugo
MSU_AUTHOR_EMAIL=mugo@forfuture.co.ke

# mod vars
MSU_REQUIRE_LOCK=

# determine root (dir holding this dir)
[ ! -e msu.sh ] && {
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

msu_run() {
  local module=$(echo ${1} | grep -Eo ".*\." | grep -Eo "[a-Z0-9]+")
  local func=$(echo ${1} | grep -Eo "\..*" | cut -b 2- )
  msu_require ${module}
  msu_${func} ${@:2}
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
  "--" | "run" )
    msu_run ${@:2}
  ;;
  "help" )
    echo
    echo " msu by ${MSU_AUTHOR_NAME} <${MSU_AUTHOR_EMAIL}"
    echo
    echo " Available Commands:"
    echo "    load          loads the whole library"
    echo "    require       require a library module"
    echo "    -- | run      run a module function"
    echo "    upgrade       uprgade to the latest version"
    echo "    help          show help information"
  ;;
  * )
    # do nothing. we might be sourced
  ;;
esac

