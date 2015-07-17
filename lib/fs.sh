# file system (fs)
#
# Copyright (c) 2015 GochoMugo <mugo@forfuture.co.ke>


# modules
msu_require console


# module variables
TRASH_DIR=/tmp/trash


# creating a directory and moving into it
# ${1} - name of the new directory
function mkd() {
  mkdir -p ${1}
  cd ${1}
}


# safely removing files
# note that these files are destroyed when temp files are cleaned up
function trash() {
  echo -e "${clr_red} ${sym_danger} !! will be PERMANENTLY DELETED on system restart ${clr_reset}"
  mkdir -p ${TRASH_DIR}
  for file in "$@"
  do
    mv ${file} ${TRASH_DIR} && {
      tick ${file}
    } || {
      cross ${file}
    }
  done
}


# un-trash files
function untrash() {
  for file in "$@"
  do
    mv ${TRASH_DIR}/${file} ${file} && {
      tick ${file}
    } || {
      cross ${file}
    }
  done
}


# join two or more directories into the first directory
function joindirs() {
  local maindir="${1}"
  shift
  for dir in ${@}
  do
    mv -i ${dir}/* ${maindir}
    rmdir ${dir}
    [ $? ] && {
      tick ${dir}
    } || {
      cross ${dir}
    }
  done
}
