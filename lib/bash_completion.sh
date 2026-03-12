#!/usr/bin/env bash
# Bash completion for msu
#
# Copyright (c) 2015 GochoMugo <mugo@forfuture.co.ke>


# Completion function for the msu command.
msu__complete() {
  # COMP_WORDS, COMP_CWORD, and COMPREPLY are set by bash for completion.
  local cur="${COMP_WORDS[COMP_CWORD]}"

  # Complete the sub-command when at the first argument position.
  # Keep this list in sync with the case statement in lib/msu.sh.
  if [ "${COMP_CWORD}" -eq 1 ]; then
    local subcommands="execute h help i im install install-many list ls nk nuke r re require run u um uninstall uninstall-many up upgrade v version w where x"
    # shellcheck disable=SC2207
    COMPREPLY=( $(compgen -W "${subcommands}" -- "${cur}") )
    return 0
  fi

  # Complete arguments for each sub-command.
  # Keep this in sync with the sub-commands in lib/msu.sh.
  case "${COMP_WORDS[1]}" in
    "h" | "help" )
      # shellcheck disable=SC2207
      COMPREPLY=( $(compgen -W "$(msu__installed_modules)" -- "${cur}") )
      ;;
    "re" | "require" )
      # shellcheck disable=SC2207
      COMPREPLY=( $(compgen -W "$(msu__installed_modules)" -- "${cur}") )
      ;;
    "i" | "install" )
      # shellcheck disable=SC2207
      COMPREPLY=( $(compgen -W "-f --force" -- "${cur}") )
      ;;
    "im" | "install-many" )
      # shellcheck disable=SC2207
      COMPREPLY=( $(compgen -W "-f --force" -- "${cur}") )
      ;;
    "u" | "uninstall" )
      # shellcheck disable=SC2207
      COMPREPLY=( $(compgen -W "$(msu__installed_modules) -f --force" -- "${cur}") )
      ;;
    "um" | "uninstall-many" )
      # shellcheck disable=SC2207
      COMPREPLY=( $(compgen -W "-f --force" -- "${cur}") )
      ;;
    "v" | "version" )
      # shellcheck disable=SC2207
      COMPREPLY=( $(compgen -W "$(msu__installed_modules)" -- "${cur}") )
      ;;
    "w" | "where" )
      # shellcheck disable=SC2207
      COMPREPLY=( $(compgen -W "$(msu__installed_modules)" -- "${cur}") )
      ;;
  esac
}


# Returns the names of installed external modules.
msu__installed_modules() {
  local external_lib="${MSU_EXTERNAL_LIB:-${HOME}/.msu}"
  local mod
  [ -d "${external_lib}" ] || return 0
  for mod in "${external_lib}"/*; do
    [ -d "${mod}" ] && basename "${mod}"
  done
}


# Register the completion function for the msu command.
complete -F msu__complete msu
