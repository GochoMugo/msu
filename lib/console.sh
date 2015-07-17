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
