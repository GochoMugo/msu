#!/usr/bin/env bats
# tests against ./lib/core_utils.sh


BASHRC_TMP=~/.bashrc.msu

cp ~/.bashrc ~/.bashrc~ # backup

MSU_LIB="${PWD}"/lib
source lib/core.sh
source lib/core_utils.sh
source lib/format.sh


function setup() {
  mv ~/.bashrc "${BASHRC_TMP}"
  touch ~/.bashrc
}


function teardown() {
  mv "${BASHRC_TMP}" ~/.bashrc
  rm -rf /tmp/msu
}


@test "gets the \${MSU_EXTERNAL_LIB} readily set" {
  [ ! -z "${MSU_EXTERNAL_LIB}" ]
}


@test "\`upgrade' runs upgrade" {
  skip
}


@test "\`install' installs one or more modules" {
  MSU_EXTERNAL_LIB="${BATS_TMPDIR:-'.'}"/install
  source lib/core_utils.sh
  mod1="${BATS_TMPDIR}/mod1"
  mod2="${BATS_TMPDIR}/mod2"
  mkdir -p "${mod1}" "${mod2}"
  rm -rf "${MSU_EXTERNAL_LIB}/mod1" "${MSU_EXTERNAL_LIB}/mod2"
  run install "${mod1}" "${mod2}"
  [ "${status}" -eq 0 ]
  echo "${output}" | grep "${sym_tick}"
  [ -d "${MSU_EXTERNAL_LIB}"/mod1 ]
  [ -d "${MSU_EXTERNAL_LIB}"/mod2 ]
}


@test "\`install' installs from github" {
  MSU_EXTERNAL_LIB="${BATS_TMPDIR}/gh"
  source lib/core_utils.sh
  samplemodule="GH:GochoMugo/msu"
  run install "${samplemodule}"
  [ "${status}" -eq 0 ]
  echo "${output}" | grep "${sym_tick}"
  [ -d "${MSU_EXTERNAL_LIB}/msu" ]
}


@test "\`install' installs from bitbucket" {
  MSU_EXTERNAL_LIB="${BATS_TMPDIR}/bt"
  source lib/core_utils.sh
  samplemodule="BT:GochoMugo/msu-test"
  run install "${samplemodule}"
  [ "${status}" -eq 0 ]
  echo "${output}" | grep "${sym_tick}"
  [ -d "${MSU_EXTERNAL_LIB}/msu-test" ]
}


@test "\`install_from_list' installs from a list in a file" {
  MSU_EXTERNAL_LIB="${BATS_TMPDIR}/install-many"
  source lib/core_utils.sh
  listpath="${BATS_TMPDIR}/list.install"
  echo "GH:GochoMugo/msu" > ${listpath}
  run install_from_list "${listpath}"
  [ "${status}" -eq 0 ]
  echo "${output}" | grep "${sym_tick}"
  [ -d "${MSU_EXTERNAL_LIB}/msu" ]
}


@test "\`uninstall' uninstalls one or more modules" {
  MSU_EXTERNAL_LIB="${BATS_TMPDIR}/uninstall"
  source lib/core_utils.sh
  mkdir -p "${MSU_EXTERNAL_LIB}/mod1" "${MSU_EXTERNAL_LIB}/mod2"
  run uninstall mod1 mod2
  [ "${status}" -eq 0 ]
  echo "${output}" | grep "${sym_tick}"
  [ ! -d "${MSU_EXTERNAL_LIB}/mod1" ]
  [ ! -d "${MSU_EXTERNAL_LIB}/mod2" ]
}


@test "\`uninstall_from_list' uninstall from a list in a file" {
  MSU_EXTERNAL_LIB="${BATS_TMPDIR}/uninstall-many"
  source lib/core_utils.sh
  mkdir -p "${MSU_EXTERNAL_LIB}/mod1"
  listpath="${BATS_TMPDIR}/list.uninstall"
  echo "mod1" > ${listpath}
  run uninstall_from_list ${listpath}
  [ "${status}" -eq 0 ]
  echo "${output}" | grep "${sym_tick}"
  [ ! -d "${MSU_EXTERNAL_LIB}/mod1" ]
}


function new_mod() {
  rm -rf "${1}"
  mkdir -p "${1}"
  pushd "${1}" > /dev/null
  git init
  git config --local user.email "mugo@forfuture.co.ke"
  git config --local user.name  "GochoMugo"
  touch first
  git add first
  git commit -m "Init"
  popd > /dev/null
}


@test "\`install' through \`generate_metadata' generates module metadata" {
  MSU_EXTERNAL_LIB="${BATS_TMPDIR}"/gen-metadata
  local sample_module="${BATS_TMPDIR}"/sample-metadata
  source lib/core_utils.sh
  new_mod "${sample_module}"
  run install "${sample_module}"
  [ "${status}" -eq 0 ]
  [ -f "${MSU_EXTERNAL_LIB}/sample-metadata/metadata.sh" ]
}


@test "\`generate_metadata' ignores if there are no git commits" {
  MSU_EXTERNAL_LIB="${BATS_TMPDIR}/gen-md"
  source lib/core_utils.sh
  mkdir -p "${MSU_EXTERNAL_LIB}/sample"
  ! generate_metadata "sample"
  cd "${MSU_EXTERNAL_LIB}/sample"
  git init
  cd -
  ! generate_metadata "sample"
}


@test "\`show_metadata' shows module metadata" {
  MSU_EXTERNAL_LIB="${BATS_TMPDIR}/show-metadata"
  local sample_module="${BATS_TMPDIR}/show-me-some"
  source lib/core_utils.sh
  new_mod "${sample_module}"
  run install "${sample_module}"
  run show_metadata "show-me-some"
  [ "${status}" -eq 0 ]
  echo "${output}" | grep "author" | grep "GochoMugo" # author
  echo "${output}" | grep "build" # build hash
  echo "${output}" | grep "date" # date
}


@test "\`has_command' checks if command is available" {
  has_command "cat"          # I can be almost certain that `cat` is available.
  ! has_command "gochomugo"  # last time i checked i didn't create the program.
}


@test "\`is_superuser' checks if script is run as superuser" {
  ! is_superuser
  sudo ./lib/msu.sh run core_utils.is_superuser
}


@test "\`list_modules' lists installed modules" {
  MSU_EXTERNAL_LIB="${BATS_TMPDIR}/list-modules"
  local sample_module="${BATS_TMPDIR}/a-stupid-module-ofcos"
  source lib/core_utils.sh
  new_mod "${sample_module}"
  run install "${sample_module}"
  run list_modules
  echo "${output}" | grep "internal modules"
  echo "${output}" | grep "console"
  echo "${output}" | grep "external modules"
  echo "${output}" | grep "a-stupid-module-ofcos"
  run list_modules --internal
  ! echo "${output}" | grep "external modules"
  run list_modules --external
  ! echo "${output}" | grep "internal modules"
}


@test "\`nuke' nukes msu entirely" {
  LIB="${BATS_TMPDIR}/nuke-lib"
  BIN="${BATS_TMPDIR}/nuke-bin"
  MAN="${BATS_TMPDIR}/nuke-man"
  LIB="${LIB}" BIN="${BIN}" MAN="${MAN}" ./install.sh
  MSU_ASSUME_YES="yes" "${BIN}/msu" nuke
  [ ! -d "${LIB}/msu" ]
  [ ! -e "${BIN}/msu" ]
  [ ! -e "${MAN}/man1/msu.1" ]
  [ ! -e "${MAN}/man3/msu.3" ]
  ! grep "${MSU_LOAD_STRING}" ~/.bashrc
  ! grep "# added by msu" ~/.bashrc
  [ ! -d "/tmp/msu" ]
  [ ! -e "/tmp/nuke_msu" ]
  [ ! -d "/tmp/.msu.clones" ]
}

