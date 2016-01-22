#!/usr/bin/env bash
# msu (my-shell-utils)
#
# Copyright (c) 2015 GochoMugo <mugo@forfuture.co.ke>


#set -e errexit


[ -L "${BASH_SOURCE[0]}" ] && EXE=$(readlink -f "${BASH_SOURCE[0]}") # using symbolic link
[ "${EXE}" ] || {
  EXE="${BASH_SOURCE[0]}" # file executed directly
  EXE="${PWD}/${EXE}"
}
MSU_LIB=$(dirname "${EXE}") # directory holding our library
export MSU_LIB


# modules
# shellcheck source=lib/core.sh
source "${MSU_LIB}/core.sh" # so LOW-LEVEL
msu_require "metadata"      # how you like me now?


# warn user, if we are running as root/superuser.
msu_run core_utils.is_superuser && {
  echo
  echo " !!         you are running as SUPERUSER        !! "
  echo " !! with much power, comes great responsibility !! "
  echo " !!           you have been WARNED!             !! "
  echo
}


# parse command line arguments
case "${1:-''}" in
  "r" | "require" )
    msu_require "${2:-''}"
  ;;
  "-" | "run" )
    msu_run "${@:2}"
  ;;
  "x"  | "execute" )
    msu_execute "${2:-''}" "${@:3}"
  ;;
  "i" | "install" )
    msu_run core_utils.install "${@:2}"
  ;;
  "im" | "install-many" )
    msu_run core_utils.install_from_list "${2}"
  ;;
  "u" | "uninstall" )
    msu_run core_utils.uninstall "${@:2}"
  ;;
  "um" | "uninstall-many" )
    msu_run core_utils.uninstall_from_list "${2}"
  ;;
  "up" | "upgrade" )
    msu_run core_utils.upgrade
  ;;
  "ls" | "list" )
    msu_run core_utils.list_modules "${2}"
  ;;
  "h" | "help" )
    echo
    echo " msu by ${MSU_AUTHOR_NAME} <${MSU_AUTHOR_EMAIL}>"
    echo
    echo " usage:"
    echo "    msu require|install|uninstall <mod>..."
    echo "    msu execute|install-many|uninstall-many <path>"
    echo "    msu run <mod>.<func>"
    echo "    msu version [mod]"
    echo
    echo " commands:"
    echo "    r  | require        require the library module <mod>"
    echo "    -  | run            run the function <func> in module <mod>"
    echo "    x  | execute        execute file at the path <path>"
    echo "    i  | install        install the module(s) <mod>..."
    echo "    im | install-many   install from module-list at path <path>"
    echo "    u  | uninstall      uninstall the module(s) <mod>..."
    echo "    um | uninstall-many uninstall from module-list at path <path>"
    echo "    ls | list           list installed modules"
    echo "    up | upgrade        upgrade to the latest version"
    echo "    h  | help           show this help information"
    echo "    v  | version        show version information of module [mod] or msu itself"
    echo
    echo " for more help information, see msu(1)"
    echo
    echo " see https://github.com/GochoMugo/msu/issues for bug reporting"
    echo " and feature requests"
    echo
  ;;
  "v" | "version" )
    if [ "${2}" ]
    then
      msu_run core_utils.show_metadata "${2}"
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
