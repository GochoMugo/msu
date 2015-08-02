#!/usr/bin/env bash
# file system (fs)
#
# Copyright (c) 2015 GochoMugo <mugo@forfuture.co.ke>


# modules
msu_require "console"


# module variables
{
  # shellcheck disable=SC2034
  DEPS=
}
TRASH_DIR=/tmp/trash


# safely removing files
# note that these files are destroyed when temp files are cleaned up
# ${*} files/directories to trash
function trash() {
  echo -e "${clr_red:-''} ${sym_danger:-''} !! will be PERMANENTLY DELETED on system restart ${clr_reset:-''}"
  for file in "${@}"
  do
    local destination
    destination="${TRASH_DIR:-'.'}"/"${file}"
    mkdir -p "${destination}" 
    mv "${file}" "${destination}"
    if [ $? ]
    then
      tick "${file}"
    else
      cross "${file}"
    fi
  done
}


# un-trash files
# ${*} files/directories to untrash
function untrash() {
  for file in "$@"
  do
    mv "${TRASH_DIR:-''}"/"${file}" "${file}"
    if [ $? ]
    then
      tick "${file}"
    else
      cross "${file}"
    fi
  done
}


# join two or more directories into the first directory
# ${1} - destination directory
# ${@:2} - source directories
function joindirs() {
  local maindir="${1}"
  shift
  for dir in "${@}"
  do
    mv -i "${dir:-'.'}"/* "${maindir}"
    rmdir "${dir}"
    if [ $? ]
    then
      tick "${dir}"
    else
      cross "${dir}"
    fi
  done
}


# append to file (handles symlinks well)
# ${1} - path of the file
# ${@:2} - string to write
function append() {
  touch "${1}"
  local realpath
  realpath=$(readlink -f "${1}")
  echo "${@:2}" >> "${realpath}"
}
