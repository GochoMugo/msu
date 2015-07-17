# msu (my-shell-utils)
#
# Copyright (c) 2015 GochoMugo <mugo@forfuture.co.ke>


# metadata
MSU_AUTHOR_NAME=GochoMugo
MSU_AUTHOR_EMAIL=mugo@forfuture.co.ke


# module variables

[ -L ${BASH_SOURCE[0]} ] && EXE=$(readlink $(which msu)) # using symbolic link
[ ${EXE} ] || EXE=${BASH_SOURCE[0]} # file executed directly
export MSU_LIB="$(dirname ${EXE})" # directory holding our library


# modules
source ${MSU_LIB}/core.sh


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
    echo " msu by ${MSU_AUTHOR_NAME} <${MSU_AUTHOR_EMAIL}>"
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
