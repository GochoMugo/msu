#!/usr/bin/env bash
# tests against lib/aliases.sh


function setup() {
  BATS_TEST_TMPDIR="$(readlink -f "${BATS_TEST_TMPDIR}")"
  MSU_EXTERNAL_LIB="${BATS_TEST_TMPDIR:-/tmp}/aliases"
  # shellcheck disable=SC2015
  mkdir -p "${MSU_EXTERNAL_LIB}"
}


@test "aliases.sh loads builtin aliases" {
  source lib/aliases.sh
  alias x | grep 'msu run'
  alias msu.reload | grep -E "'$(bash -c 'source lib/metadata.sh && echo ${MSU_INSTALL_LOAD_STRING} | grep -Eo \&\&.+\$ | cut -c 4-')'"
}


@test "aliases.sh loads aliases from external modules" {
  local mod1="${MSU_EXTERNAL_LIB}/mod1"
  local mod2="${MSU_EXTERNAL_LIB}/mod2"
  mkdir -p "${mod1}" "${mod2}"
  echo "alias foo='test #1'" > "${mod1}/aliases.sh"
  echo "alias bar='test #2'" > "${mod2}/aliases.sh"
  source lib/aliases.sh
  alias foo | grep "'test #1'"
  alias bar | grep "'test #2'"
}


@test "aliases.sh overrides aliases using \${MSU_EXTERNAL_LIB}/aliases.sh" {
  local alias_override="${MSU_EXTERNAL_LIB}/aliases.sh"
  local mod="${MSU_EXTERNAL_LIB}/mod"
  mkdir -p "${mod}"
  echo "alias foo='test #1'" >> "${alias_override}"
  echo "alias foo='test #2'" >> "${mod}/aliases.sh"
  source lib/aliases.sh
  alias foo | grep "'test #1'"
}
