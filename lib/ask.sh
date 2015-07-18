# ask (and you shall be told)
#
# Copyright (c) 2015 GochoMugo <mugo@forfuture.co.ke>


# modules
msu_require format


# asks user a question
#
# ${1} question to ask user
function ask() {
  echo -e -n "    ${clr_white}${1}${clr_reset} "
  read ANSWER
}


# asks a yes or no question
# ${1} question to ask
# ${2} default answer
# return 0 (yes), 1 (no)
function yes_no() {
  local show="y|N"
  local exit_code=1
  case ${2} in
    "Y" | "y" )
      show="Y|n"
      exit_code=0
    ;;
  esac
  question="${1} (${show})?"
  ask "${question}" 0
  case $ANSWER  in
    "Y" | "y" )
      exit_code=0
    ;;
    "N" | "n" )
      exit_code=1
    ;;
  esac
  return ${exit_code}
}
