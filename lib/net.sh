#!/usr/bin/env bash
# networking (without sucking)
#
# Copyright (c) 2015 GochoMugo <mugo@forfuture.co.ke>


# modules
msu_require "console"


# module variables
{
  # shellcheck disable=SC2034
  DEPS="wget"
}
DL_FILE=".msu.download"


# track a download
# ${1} - name of download
# ${2} - url of the download
function track() {
  echo "${1}=${2}" >> "${DL_FILE}"
}


# check tracked downloads
function check() {
  if [ -f "${DL_FILE}" ] ; then
    local names
    names=$(grep -Eo ".*=" "${DL_FILE}" | grep -Eo "[a-Z]*")
    for name in ${names}
    do
      list "${name}"
    done
  else
    cross "tracking file missing"
  fi
}


# for large downloads
# ${1} - name of download
# ${2} - url of download (Optional)
function download() {
  local name
  local url
  local data

  name=${1}
  url=${2}
  data=''

  # we require a name
  if [ ! "${1}" ] ; then
    error "we require a name"
    return 1
  fi

  # read tracking file, if it exists
  if [ -e "${DL_FILE}" ]
  then
    data=$(cat "${DL_FILE}")
  fi

  if [ "${url}" ]
  then # new download
    track "${name}" "${url}"
  elif [ "${name}" ]
  then # tracked download
    url=$(echo "${data}" | grep -E "${name}" | grep -Eo "=.*" | cut -b 2-)
  fi

  # download
  if [ "${url}" ] ; then
    wget -c "${url}"
    if [ $? ]
    then
      echo "${data}" | grep -Ev "${name}" > "${DL_FILE}"
      tick "${name}"
    else
      cross "${name} (could not download)"
    fi
  else
    echo "${data}" | grep -Eo "=.*" | cut -b 2- | xargs -I{} wget -c {}
    if [ $? ]
    then
      rm -rf "${DL_FILE}"
      success "done"
    else
      error "did not complete successfully"
    fi
  fi
}
