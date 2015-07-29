#!/usr/bin/env bash
# msu (my-shell-utils)
#
# Copyright (c) 2015 GochoMugo <mugo@forfuture.co.ke>


[ -L "${BASH_SOURCE[0]}" ] && EXE=$(readlink -f "${BASH_SOURCE[0]}") # using symbolic link
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
  "r" | "require" )
    msu_require ${2}
  ;;
  "-" | "run" )
    msu_run ${@:2}
  ;;
  "i" | "install" )
    msu_run core_utils.install ${@:2}
  ;;
  "u" | "uninstall" )
    msu_run core_utils.uninstall ${@:2}
  ;;
  "up" | "upgrade" )
    msu_run core_utils.upgrade
  ;;
  "h" | "help" )
    echo
    echo " msu by ${MSU_AUTHOR_NAME} <${MSU_AUTHOR_EMAIL}>"
    echo
    echo " Available Commands:"
    echo "    r  | require <mod>       require the library module <mod>"
    echo "    -  | run <mod>.<func>    run the function <func> in module <mod>"
    echo "    i  | install <mod>...    install the module(s) <mod>..."
    echo "    u  | uninstall <mod>...  uninstall the module(s) <mod>..."
    echo "    up | upgrade             upgrade to the latest version"
    echo "    h  | help                show this help information"
    echo "    v  | version [mod]       show version information of module [mod] or msu itself"
    echo
    echo " See https://github.com/GochoMugo/msu/issues for bug reporting"
    echo " and feature requests"
    echo
  ;;
  "v" | "version" )
    if [ ${2} ]
    then
      msu_run core_utils.show_metadata ${2}
    else
      echo "  version   ${MSU_VERSION}"
      echo "  build     ${MSU_BUILD_HASH:-?}"
      echo "  date      ${MSU_BUILD_DATE:-?}"
    fi
  ;;
  * )
    # do nothing
  ;;
esac
