# write to the console
#
# Copyright (c) 2015 GochoMugo <mugo@forfuture.co.ke>

msu_require format

# writes to console with colors
#  ${1}  message to write to console
#  ${2} what color to use. 0 - info(blue), 1- success(green),
#    2 - error(red)
#  ${LOG_TITLE} for setting title of logging
function write_text() {
  local title
  local text=${2}
  local color_index=$3
  [ $3 ] && {
    title="${clr_white}${1}: "
  } || {
    text=${1}
    color_index=${2}
  }
  local color=${clr_blue}
  [ ${color_index} ] && {
    [ ${color_index} -eq 1 ] && color=${clr_green}
    [ ${color_index} -eq 2 ] && color=${clr_red}
  }
  echo -e "${title}${color}${text}${clr_reset}"
}


# normal logging
function log() {
  write_text ${LOG_TITLE:-log} "${1:-""}" 0
}


# success logging
function success() {
  write_text ${LOG_TITLE:-success} "${1:-""}" 1
}


# error logging
function error() {
  write_text ${LOG_TITLE:-error} "${1:-""}" 2
}


# put a tick
function tick() {
  write_text "${sym_tick} ${1}" 1
}


# put an x
function cross() {
  write_text "${sym_cross} ${1}" 2
}


# list
function list() {
  write_text "${sym_arrow_right} ${1}" 0
}


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
