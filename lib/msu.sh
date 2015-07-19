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
  "a" | "aliases" )
    source ${MSU_LIB}/aliases.sh
  ;;
  "l" | "load" )
    msu_load
  ;;
  "r" | "require" )
    msu_require ${2}
  ;;
  "u" | "upgrade" )
    LIB=$(dirname ${MSU_LIB})
    BIN=$(dirname $(which msu))
    wget -qO- http://git.io/vTE0s | LIB=${LIB} BIN=${BIN} bash
  ;;
  "-" | "run" )
    msu_run ${@:2}
  ;;
  "h" | "help" )
    echo
    echo " msu by ${MSU_AUTHOR_NAME} <${MSU_AUTHOR_EMAIL}>"
    echo
    echo " Available Commands:"
    echo "    l | load              load the whole library"
    echo "    r | require <mod>     require the library module <mod>"
    echo "    - | run <mod>.<func>  run the function <func> in module <mod>"
    echo "    u | upgrade           upgrade to the latest version"
    echo "    h | help              show this help information"
    echo "    v | version           show version information"
    echo
  ;;
  "v" | "version" )
    echo "  version   ${MSU_VERSION}"
    echo "  build     ${MSU_BUILD_HASH:-?}"
    echo "  date      ${MSU_BUILD_DATE:-?}"
  ;;
  * )
    # do nothing
  ;;
esac
