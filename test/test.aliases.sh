#!/usr/bin/env bash
# tests against lib/aliases.sh


MSU_EXTERNAL_LIB="${BATS_TMPDIR:-/tmp}/test-aliases"


function setup() {
  # shellcheck disable=SC2015
  mkdir -p "${MSU_EXTERNAL_LIB}"
}


function teardown() {
  rm -rf "${MSU_EXTERNAL_LIB:-/tmp}/*"
}


@test "aliases.sh loads aliases into the current environment" {
  . lib/aliases.sh
  alias fs.join
  alias net.dl
}


@test "aliases.sh loads aliases from external modules" {
  local mod="${MSU_EXTERNAL_LIB}/aliases"
  mkdir -p "${mod}"
  echo "alias humansshouldriseup='echo external'" > "${mod}/aliases.sh"
  . lib/aliases.sh
  alias humansshouldriseup | grep "external"
}


@test "\${MSU_EXTERNAL_LIB}/aliases.sh overides all" {
  local alias_override="${MSU_EXTERNAL_LIB}/aliases.sh"
  local mod="${MSU_EXTERNAL_LIB}/overide"
  mkdir -p "${mod}"
  echo "alias bedaring='echo override'" > "${alias_override}"
  echo "alias bedaring='echo external'" > "${mod}/aliases.sh"
  . lib/aliases.sh
  alias bedaring | grep "override"
}
