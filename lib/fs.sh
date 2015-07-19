# file system (fs)
#
# Copyright (c) 2015 GochoMugo <mugo@forfuture.co.ke>


# modules
msu_require console


# module variables
TRASH_DIR=/tmp/trash


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


# append to file (handles symlinks well)
# ${1} - path of the file
# ${2} - string to write
function append() {
  touch ${1}
  local realpath=$(readlink -f ${1})
  echo ${2} >> ${realpath}
}
