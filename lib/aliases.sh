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


# npm
alias npm.g="msu run npm.g"
alias npm.ginstalled="msu run npm.ginstalled"
alias npm.gln="msu run npm.gln"
alias npm.gremove="msu run npm.gremove"
alias npm.grestore="msu run npm.grestore"
alias npm.gtrack="msu run npm.gtrack"
alias npm.gupdate="msu run npm.gupdate"
alias npm.ln="msu run npm.ln_mod"
alias npm.ln_bin="msu run npm.ln_bin"


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
