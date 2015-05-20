# ask (and you shall be told)
#
# Copyright (c) 2015 GochoMugo <mugo@forfuture.co.ke>

msu_require colors

# asks user a question
#
# ${1}  question to ask user
# ${2}  any value - be silent. Use global variable ${ANSWER},
#   Otherwise echo ${answer}
msu_ask() {
  echo -e -n "    ${COLOR_WHITE}${1}${COLOR_RESET} "
  read ANSWER
  [ ${2} ] && return || echo ${ANSWER}
}


# asks a yes or no question
# ${1} question to ask
# ${2} default answer
# return 0 (yes), 1 (no)
msu_ask_bool() {
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

