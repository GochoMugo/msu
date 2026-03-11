#!/usr/bin/env bash
# Bash completion for msu

# Returns the names of installed external modules.
_msu_installed_modules() {
  local external_lib="${MSU_EXTERNAL_LIB:-${HOME}/.msu}"
  local mod
  [ -d "${external_lib}" ] || return 0
  for mod in "${external_lib}"/*; do
    [ -d "${mod}" ] && basename "${mod}"
  done
}

# Completion function for the msu command.
_msu_complete() {
  # COMP_WORDS, COMP_CWORD, and COMPREPLY are set by bash for completion.
  local cur="${COMP_WORDS[COMP_CWORD]}"

  # Complete the sub-command when at the first argument position.
  # Keep this list in sync with the case statement in lib/msu.sh.
  if [ "${COMP_CWORD}" -eq 1 ]; then
    local subcommands="env re require r run x execute i install im install-many u uninstall um uninstall-many up upgrade ls list nk nuke h help v version w where"
    # shellcheck disable=SC2207
    COMPREPLY=( $(compgen -W "${subcommands}" -- "${cur}") )
    return 0
  fi

  # Complete with installed module names for commands that accept them.
  # Keep this list in sync with the sub-commands in lib/msu.sh that take a module name.
  case "${COMP_WORDS[1]}" in
    "u" | "uninstall" | "h" | "help" | "v" | "version" | "w" | "where" )
      # shellcheck disable=SC2207
      COMPREPLY=( $(compgen -W "$(_msu_installed_modules)" -- "${cur}") )
      return 0
      ;;
  esac
}

# Register the completion function for the msu command.
complete -F _msu_complete msu
