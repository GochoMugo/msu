#!/usr/bin/env bash
# how you live with no aliases
#
# Copyright (c) 2015 GochoMugo <mugo@forfuture.co.ke>


# external library
MSU_EXTERNAL_LIB="${MSU_EXTERNAL_LIB:-${HOME}/.msu}"


# general

# help: msu run
alias x="msu run"

# help: reload msu into environment
alias msu.reload=". msu env"


# external module aliases
if [ -d "${MSU_EXTERNAL_LIB}" ]
then
  modules=$(ls "${MSU_EXTERNAL_LIB}")
  for module in ${modules}
  do
    alias_file=${MSU_EXTERNAL_LIB}/${module}/aliases.sh
    # shellcheck source=/dev/null
    [ -f "${alias_file}" ] && source "${alias_file}"
  done
  unset alias_file
  unset module
  unset modules
fi


# top-most aliases file
# shellcheck source=/dev/null
if [ -f "${MSU_EXTERNAL_LIB}/aliases.sh" ]
then
  source "${MSU_EXTERNAL_LIB}/aliases.sh"
fi
