#!/usr/bin/env bash
# msu (my-shell-utils)
#
# Copyright (c) 2015 GochoMugo <mugo@forfuture.co.ke>


#set -e errexit


MSU_EXE="${BASH_SOURCE[0]}"
MSU_REAL_EXE=$(readlink -f "${MSU_EXE}")
MSU_LIB=$(dirname "${MSU_REAL_EXE}") # directory holding our library
export MSU_EXE
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
  "env" )
    msu__load
  ;;
  "re" | "require" )
    msu_require "${2:-''}"
  ;;
  "r" | "run" )
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
    msu_run core_utils.upgrade "${2}"
  ;;
  "ls" | "list" )
    msu_run core_utils.list_modules "${2}"
  ;;
  "nk" | "nuke" )
    msu_run core_utils.nuke
  ;;
  "h" | "help" )
    echo
    echo " msu by ${MSU_AUTHOR_NAME} <${MSU_AUTHOR_EMAIL}>"
    echo
    echo " usage:"
    echo "    msu require|install|uninstall <mod>..."
    echo "    msu execute|install-many|uninstall-many <path>"
    echo "    msu run <mod>.<func>"
    echo "    msu list [scope]"
    echo "    msu upgrade [version]"
    echo "    msu version [mod]"
    echo
    echo " commands:"
    echo "    re | require        require the library module <mod>"
    echo "    r  | run            run the function <func> in module <mod>"
    echo "    x  | execute        execute file at the path <path>"
    echo "    i  | install        install the module(s) <mod>..."
    echo "    im | install-many   install from module-list at path <path>"
    echo "    u  | uninstall      uninstall the module(s) <mod>..."
    echo "    um | uninstall-many uninstall from module-list at path <path>"
    echo "    ls | list           list installed modules"
    echo "    up | upgrade        upgrade to the latest version"
    echo "    nk | nuke           nuke msu entirely"
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
    # maybe, we are being used in a shebang e.g. #!/usr/bin/env msu
    if [ "${1}" ]
    then
        FILE="$(readlink -f "${1}" 2> /dev/null)"
        if [ -r "${FILE}" ]
        then
            msu_execute "${FILE}" "${@:2}"
        fi
    fi
    # otherwise, we just ignore it!
  ;;
esac
