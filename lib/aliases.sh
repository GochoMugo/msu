#!/usr/bin/env bash
# how you live with no aliases
#
# Copyright (c) 2015 GochoMugo <mugo@forfuture.co.ke>


# external library
MSU_EXTERNAL_LIB="${MSU_EXTERNAL_LIB:-${HOME}/.msu}"


# general
alias x="msu run"

# this allows reloading the aliases, useful after installing new
# modules
alias msu.reload=". msu require load"

# fs
alias msu.fs.join="msu run fs.joindirs"
alias msu.fs.trash="msu run fs.trash"
alias msu.fs.untrash="msu run fs.untrash"


# net
alias msu.net.ch="msu run net.check"
alias msu.net.dl="msu run net.download"


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
[ -f "${MSU_EXTERNAL_LIB}/aliases.sh" ] && source "${MSU_EXTERNAL_LIB}/aliases.sh"
echo > /dev/null
