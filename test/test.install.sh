#!/usr/bin/env bats
# tests against ./install.sh


BASHRC_TMP=~/.bashrc.msu


cp ~/.bashrc ~/.bashrc~ # backup


function setup() {
  mv ~/.bashrc "${BASHRC_TMP}"
  touch ~/.bashrc
}


function teardown() {
  [ -e ~/bin/msu ]  && rm -rf ~/bin/msu
  [ -e "${BIN}/msu" ] && rm -rf "${BIN:-'.'}/msu"
  [ -d ~/lib/msu ]  && rm -rf ~/lib/msu
  [ -d "${LIB}/msu" ] && rm -rf "${LIB:-'.'}/msu"
  mv "${BASHRC_TMP}" ~/.bashrc
}


@test "test-run install (requires NO sudo or other variables)" {
  ./install.sh
}


@test "uses \${LIB} to prefix destination directory for library" {
  local lib="${BATS_TMPDIR}/some-lib"
  rm -rf "${lib}/msu"
  LIB="${lib}" ./install.sh
  [ -d "${lib}/msu" ]
}


@test "uses \${BIN} to prefix destination directory for executable" {
  local bin="${BATS_TMPDIR}/some-bin"
  rm -rf "${bin:-'.'}/msu"
  BIN="${bin}" ./install.sh
  [ -x "${bin}/msu" ]
}


@test "adds \${BIN} to ~/.bashrc if not in \${PATH}" {
  local bin="${BATS_TMPDIR:-'.'}/another-bin"
  BIN="${bin}" ./install.sh
  cat ~/.bashrc | grep "export PATH=\"${bin}\":\${PATH}"
}


@test "generates metadata" {
  ./install.sh
  local data=$(cat ~/lib/msu/metadata.sh)
  local path_regexp="'.+'"
  echo "${data}"
  echo "${data}" | grep -E "MSU_INSTALL_LIB=${path_regexp}"
  echo "${data}" | grep -E "MSU_INSTALL_BIN=${path_regexp}"
  echo "${data}" | grep -E "MSU_INSTALL_MAN=${path_regexp}"
  echo "${data}" | grep -E "MSU_BUILD_HASH='[a-z0-9]+'"
  echo "${data}" | grep -E "MSU_BUILD_DATE='.+'"
}


@test "links executable in path to that in library" {
  ./install.sh
  local realpath=$(readlink ~/bin/msu)
  [ -x ~/bin/msu ]
  [ "${realpath}" == "$(readlink -f ~/lib/msu/msu.sh)" ]
}


@test "adds loader string for loading msu" {
  ./install.sh
  cat ~/.bashrc | grep -E ". msu require load"
}


@test "spits out version information when done" {
  local version_info=$(./install.sh)
  local expected=$(msu version)
  echo "${version_info}" | grep "${expected}"
}
