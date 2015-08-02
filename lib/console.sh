#!/usr/bin/env bash
# write to the console
#
# Copyright (c) 2015 GochoMugo <mugo@forfuture.co.ke>


msu_require "format"


# writes to console with colors
#  ${1}  message to write to console
#  ${2} what color to use. 0 - info(blue), 1- success(green),
#    2 - error(red)
#  ${LOG_TITLE} for setting title of logging
function write_text() {
  local title
  local text
  local color_index
  text=${2}
  color_index=${3}
  if [ "$3" ]
  then
    title="${clr_white:-''}${1}: "
  else
    text="${1}"
    color_index="${2}"
  fi
  local color=${clr_blue:-''}
  case "${color_index}" in
    "1" )
      color=${clr_green:-''}
    ;;
    "2" )
      color=${clr_red:-''}
    ;;
  esac
  echo -e "${title}${color}${text}${clr_reset:-''}"
}


# normal logging
# ${@} text
function log() {
  write_text "${LOG_TITLE:-log} ${*}" 0
}


# success logging
# ${@} text
function success() {
  write_text "${LOG_TITLE:-success} ${*}" 1
}


# error logging
# ${@} text
function error() {
  write_text "${LOG_TITLE:-error} ${*}" 2
}


# put a tick
# ${@} text
function tick() {
  write_text "${sym_tick:-tick} ${*}" 1
}


# put an x
# ${@} text
function cross() {
  write_text "${sym_cross:-cross} ${*}" 2
}


# list
# ${@} text
function list() {
  write_text "${sym_arrow_right:-list} ${*}" 0
}


# asks user a question
#
# ${1} question to ask user
# ${2} variable to assign the result to
# ${3} clear/hidden (0-clear, 1-hidden)
#
# reference: http://stackoverflow.com/questions/1923435/how-do-i-echo-stars-when-reading-password-with-read
function ask() {
  local clear
  clear=0
  if [ "${3}" ]
  then
    clear="${3}"
  fi
  echo -e -n "    ${clr_white}${1}${clr_reset}  "
  if [ "${clear}" -eq 0 ]
  then
    read -r "${2}"
  else
    local password=''
    local prompt=''
    local charcount=''
    while IFS='' read -p "${prompt}" -r -s -n 1 char
    do
        if [[ "${char}" == $'\0' ]]
        then
            break
        fi
        # Backspace
        if [[ "${char}" == $'\177' ]]
        then
          if [ "${charcount}" -gt 0 ] ; then
                charcount=$((charcount-1))
                prompt=$'\b \b'
                password="${password%?}"
            else
                prompt=''
            fi
        else
            charcount=$((charcount+1))
            prompt='*'
            password="${password}${char}"
        fi
    done
    eval "${2}=\${password}"
    echo
  fi
}


# asks a yes or no question
# ${1} question to ask
# ${2} default answer (defaults to "N")
# return 0 (yes), 1 (no)
function yes_no() {
  local show="y|N"
  local answer=''
  local exit_code=1
  case "${2:-''}" in
    "Y" | "y" )
      show="Y|n"
      exit_code=0
    ;;
  esac
  question="${1} (${show})?"
  ask "${question}" answer
  case "${answer}" in
    "Y" | "y" )
      exit_code=0
    ;;
    "N" | "n" )
      exit_code=1
    ;;
  esac
  return ${exit_code}
}
