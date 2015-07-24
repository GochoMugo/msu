# how you live with no aliases
#
# Copyright (c) 2015 GochoMugo <mugo@forfuture.co.ke>


# external library
MSU_EXTERNAL_LIB=${MSU_EXTERNAL_LIB:-${HOME}/.msu}


# fs
alias fs.join="msu run fs.joindirs"
alias fs.trash="msu run fs.trash"
alias fs.untrash="msu run fs.untrash"


# net
alias net.ch="msu run net.check"
alias net.dl="msu run net.download"


# external module aliases
if [ -d ${MSU_EXTERNAL_LIB} ]
then
  modules=$(ls ${MSU_EXTERNAL_LIB})
  for module in ${modules}
  do
    alias_file=${MSU_EXTERNAL_LIB}/${module}/aliases.sh
    [ -f ${alias_file} ] && source ${alias_file}
  done
  unset alias_file
  unset module
  unset modules
fi


# top-most aliases file
[ -f ${MSU_EXTERNAL_LIB}/aliases.sh ] && source ${MSU_EXTERNAL_LIB}/aliases.sh
echo
