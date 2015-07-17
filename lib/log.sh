# ask (and you shall be told)
#
# Copyright (c) 2015 GochoMugo <mugo@forfuture.co.ke>

msu_require colors

# logs to console
#  ${1}  message to write to console
#  ${2} what color to use. 0 - info(blue), 1- success(green),
#    2 - error(red)
#  ${LOG_TITLE} for setting title of logging
log() {
  local color=${COLOR_BLUE}
  [ ${2} ] && {
    [ ${2} -eq 1 ] && color=${COLOR_GREEN}
    [ ${2} -eq 2 ] && color=${COLOR_RED}
  }
  echo -e "${COLOR_WHITE}${LOG_TITLE:-log}: ${color}${1}${COLOR_RESET}"
}
