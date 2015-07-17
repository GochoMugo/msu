# write to the console
#
# Copyright (c) 2015 GochoMugo <mugo@forfuture.co.ke>

msu_require format

# writes to console with colors
#  ${1}  message to write to console
#  ${2} what color to use. 0 - info(blue), 1- success(green),
#    2 - error(red)
#  ${LOG_TITLE} for setting title of logging
function write() {
  local color=${clr_blue}
  [ ${2} ] && {
    [ ${2} -eq 1 ] && color=${clr_green}
    [ ${2} -eq 2 ] && color=${clr_red}
  }
  echo -e "${clr_white}${LOG_TITLE:-log}: ${color}${1}${clr_reset}"
}


# normal logging
function log() {
  write ${1:-""} 0
}


# success logging
function success() {
  write ${1:-""} 1
}


# error logging
function error() {
  write ${1:-""} 2
}
