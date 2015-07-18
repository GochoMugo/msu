# msu (my-shell-utils)
#
# Copyright (c) 2015 GochoMugo <mugo@forfuture.co.ke>


[ -L ${BASH_SOURCE[0]} ] && EXE=$(readlink $(which msu)) # using symbolic link
[ ${EXE} ] || {
  EXE=${BASH_SOURCE[0]} # file executed directly
  EXE=$(echo ${EXE} | grep -Eo "[a-Z]{1}.*")
  EXE=${PWD}/${EXE}
}
export MSU_LIB="$(dirname ${EXE})" # directory holding our library


# modules
source ${MSU_LIB}/core.sh # so LOW-LEVEL
msu_require metadata


# parse command line arguments
case ${1} in
  "aliases" )
    source ${MSU_LIB}/aliases.sh
  ;;
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
    echo " msu by ${MSU_AUTHOR_NAME} <${MSU_AUTHOR_EMAIL}>"
    echo
    echo " Available Commands:"
    echo "    load          loads the whole library"
    echo "    require       require a library module"
    echo "    -- | run      run a module function"
    echo "    upgrade       uprgade to the latest version"
    echo "    help          show help information"
    echo "    version       show version information"
    echo
  ;;
  "version" )
    echo "  version   ${MSU_VERSION}"
    echo "  build     ${MSU_BUILD_HASH:-?}"
    echo "  date      ${MSU_BUILD_DATE:-?}"
  ;;
  * )
    # do nothing. we might be sourced
  ;;
esac
