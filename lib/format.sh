#!/usr/bin/env bash
# formatting
#
# Copyright (c) 2015 GochoMugo <mugo@forfuture.co.ke>

# shellcheck disable=SC2034

{ # we need this for shellcheck to disable error

  # formatting text
  txt_underline=$(tput smul)
  txt_nounderline=$(tput rmul)
  txt_bold=$(tput bold)
  txt_normal=$(tput sgr0)


  # colors
  clr_blue="\\033[0;34m"
  clr_green="\\033[0;32m"
  clr_red="\\033[0;31m"
  clr_reset="\\e[0m"
  clr_white="\\033[1;37m"


  # symbols
  sym_tick="✓"
  sym_cross="✗"
  sym_smile="☺"
  sym_frown="☹"
  sym_danger="☠"
  sym_note="☛"
  sym_peace="✌"
  sym_arrow_right="⇒"
}
