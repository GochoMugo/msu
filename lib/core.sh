#!/usr/bin/env bash
# The Core


# we expect the executable exports a variable $MSU_LIB whose
# value is the path to the library holding this and other modules
if [ ! "${MSU_LIB}" ]
then
  # without this path, we can not do anything! We should exit now!
  echo "error: core: library path not set '${MSU_LIB}'"
  exit 1
fi


# mod vars
MSU_REQUIRE_LOCK='' # lock to ensure we don't source an already-sourced file
MSU_EXTERNAL_LIB="${MSU_EXTERNAL_LIB:-${HOME}/.msu}"
export MSU_EXTERNAL_LIB


# check dependencies
function msu__check_deps() {
  if [ ! "${DEPS}" ]
  then
    return
  fi
  for cmd in ${DEPS}
  do
    command -v "${cmd}" > /dev/null 2>&1 || {
      echo "warning: \`${cmd}' not found"
    }
  done
}


# require a module
function msu_require() {
  # shellcheck disable=SC2001
  echo "${MSU_REQUIRE_LOCK}" | grep -E ":${1}:" > /dev/null || {
    local fullpath
    fullpath=$(echo "${1}" | sed 's/\.*$//g' | sed 's/\./\//g')
    # internal modules have precedence
    # shellcheck source=/dev/null
    source "${MSU_LIB}/${fullpath}.sh" > /dev/null 2>&1 || {
      # external libs
      # shellcheck source=/dev/null
      source "${MSU_EXTERNAL_LIB}/${fullpath}.sh" > /dev/null 2>&1 || {
        echo "error: require: failed to load module '$(echo "${1}" | sed 's/\.$//g')'"
        exit 1
      }
    }
    msu__check_deps
    MSU_REQUIRE_LOCK=":${1}:${MSU_REQUIRE_LOCK}"
  }
}


# run a single function
function msu_run() {
  local module
  local func
  module=$(echo "${1}" | grep -Eo ".*\.")
  func=$(echo "${1}" | grep -Eo "\.[^.]+$" | cut -b 2-)
  msu_require "${module}"
  if [ "${func}" ]
  then
    ${func} "${@:2}"
  else
    echo "error: run: can not find function '${func}'"
  fi
}


# execute a file
function msu_execute() {
  # shellcheck source=/dev/null
  source "${1}"
}
