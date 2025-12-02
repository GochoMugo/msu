#!/usr/bin/env bats
# tests against ./lib/core_utils.sh


function setup() {
  MSU_LIB="${PWD}"/lib
  MSU_EXTERNAL_LIB="${BATS_TEST_TMPDIR}/external-modules"
  source lib/core.sh
  source lib/core_utils.sh
}


function test_is_module_installed() {
  local status="${1}"
  local output="${2}"
  local module_name="${3}"
  [ "${status}" -eq 0 ]
  grep "${sym_tick} ${module_name}" <<< "${output}"
  [ -d "${MSU_EXTERNAL_LIB}/${module_name}" ]
}


@test "\`for_each_line_in_file' runs a command for each line in the file" {
  local file="${BATS_TEST_TMPDIR}/file"
  echo -e "first\nsecond" > "${file}"
  [ "$(wc -l "${file}" | cut -d ' ' -f 1)" == 2 ]
  declare -a lines 
  function track() {
    lines+=("${1}")
  }
  for_each_line_in_file track "${file}"
  [ "${#lines[@]}" == 2 ]
  [ "${lines[0]}" == "first" ]
  [ "${lines[1]}" == "second" ]
}


@test "\`get_latest_version' returns the latest version of msu" {
  get_latest_version | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$'
}


@test "\`get_major_version' returns the major part of a semver version" {
  [[ "$(get_major_version 0.2.3)" == 0 ]]
  [[ "$(get_major_version 1.2.3)" == 1 ]]
  [[ "$(get_major_version 12.23.34)" == 12 ]]
}


@test "\`get_minor_version' returns the minor part of a semver version" {
  [[ "$(get_minor_version 1.0.3)" == 0 ]]
  [[ "$(get_minor_version 1.2.3)" == 2 ]]
  [[ "$(get_minor_version 12.23.34)" == 23 ]]
}


@test "\`get_patch_version' returns the major part of a semver version" {
  [[ "$(get_patch_version 1.2.0)" == 0 ]]
  [[ "$(get_patch_version 1.2.3)" == 3 ]]
  [[ "$(get_patch_version 12.23.34)" == 34 ]]
}


@test "\`has_command' checks if command is available" {
  has_command "cat"          # I can be almost certain that `cat` is available.
  ! has_command "dog"        # no dog person here? 
}


@test "\`install' installs one or more modules" {
  mod1="${BATS_TEST_TMPDIR}/mod1"
  mod2="${BATS_TEST_TMPDIR}/mod2"
  mod3="${BATS_TEST_TMPDIR}/parent/mod3"
  mkdir -p "${mod1}" "${mod2}" "${mod3}"
  run install "${mod1}" "${mod2}" "${mod3}"
  [ "${status}" -eq 0 ]
  mods=("mod1" "mod2" "mod3")
  for mod in "${mods[@]}" ; do
    grep "${sym_tick} ${mod}" <<< "${output}"
    [ -d "${MSU_EXTERNAL_LIB}/${mod}" ]
  done
}


@test "\`install' fails if module exists" {
  mod="${BATS_TEST_TMPDIR}/mod"
  mkdir -p "${mod}"

  # first install works
  run install "${mod}"
  [ "${status}" -eq 0 ]
  grep "${sym_tick} mod" <<< "${output}"

  # install again should fail
  run install "${mod}"
  [ "${status}" -eq 1 ]
  grep "error: module already installed: mod" <<< "${output}"

  # install can be forced
  run install "${mod}" --force
  [ "${status}" -eq 0 ]
  grep "${sym_tick} mod" <<< "${output}"

  # or use -f
  run install "${mod}" -f
  [ "${status}" -eq 0 ]
  grep "${sym_tick} mod" <<< "${output}"
}


@test "\`install' installs from github/gitlab/bitbucket" {
  run install "BT:GochoMugo/msu-test"
  test_is_module_installed "${status}" "${output}" "msu-test"
  rm -rf "${MSU_EXTERNAL_LIB}"

  run install "bts:GochoMugo/msu-test"
  test_is_module_installed "${status}" "${output}" "msu-test"
  rm -rf "${MSU_EXTERNAL_LIB}"

  run install "gh:GochoMugo/msu"
  test_is_module_installed "${status}" "${output}" "msu"
  rm -rf "${MSU_EXTERNAL_LIB}"

  run install "GHS:GochoMugo/msu"
  test_is_module_installed "${status}" "${output}" "msu"
  rm -rf "${MSU_EXTERNAL_LIB}"

  run install "GL:GochoMugo/msu-test"
  test_is_module_installed "${status}" "${output}" "msu-test"
  rm -rf "${MSU_EXTERNAL_LIB}"

  run install "gls:GochoMugo/msu-test"
  test_is_module_installed "${status}" "${output}" "msu-test"
  rm -rf "${MSU_EXTERNAL_LIB}"
}


@test "\`install' supports versions (git tags)" {
  samplemodule="GL:GochoMugo/msu-test#v0.0.0"
  run install "GL:GochoMugo/msu-test#v0.0.0"
  test_is_module_installed "${status}" "${output}" "msu-test"
  pushd "${MSU_EXTERNAL_LIB}/msu-test"
  [ "$(git describe --tags)" == "v0.0.0" ]
}


@test "\`install_from_list' installs from a list in a file" {
  listpath="${BATS_TEST_TMPDIR}/list"
  echo "GH:GochoMugo/msu" > ${listpath}
  echo "GL:GochoMugo/msu-test" >> ${listpath}
  run install_from_list "${listpath}"
  [ "${status}" -eq 0 ]
  grep "${sym_tick} msu" <<< "${output}"
  grep "${sym_tick} msu-test" <<< "${output}"
  [ -d "${MSU_EXTERNAL_LIB}/msu" ]
  [ -d "${MSU_EXTERNAL_LIB}/msu-test" ]
}


@test "\`is_semver_gt' compares 2 versions correctly" {
  [[ $(is_semver_gt 0.0.1 0.0.0) == 0 ]]
  [[ $(is_semver_gt 0.1.0 0.0.0) == 0 ]]
  [[ $(is_semver_gt 1.0.0 0.0.0) == 0 ]]
  [[ $(is_semver_gt 0.1.0 0.0.1) == 0 ]]
  [[ $(is_semver_gt 0.1.1 0.1.0) == 0 ]]
  [[ $(is_semver_gt 1.0.0 0.1.0) == 0 ]]
  [[ $(is_semver_gt 1.0.1 1.0.0) == 0 ]]
  [[ $(is_semver_gt 1.1.0 1.0.1) == 0 ]]
  [[ $(is_semver_gt 1.1.1 1.1.0) == 0 ]]

  [[ $(is_semver_gt 0.0.0 0.0.1) == 1 ]]
  [[ $(is_semver_gt 0.0.0 0.1.0) == 1 ]]
  [[ $(is_semver_gt 0.0.0 1.0.0) == 1 ]]
  [[ $(is_semver_gt 0.0.1 0.1.0) == 1 ]]
  [[ $(is_semver_gt 0.1.0 0.1.1) == 1 ]]
  [[ $(is_semver_gt 0.1.0 1.0.0) == 1 ]]
  [[ $(is_semver_gt 1.0.0 1.0.1) == 1 ]]
  [[ $(is_semver_gt 1.0.1 1.1.0) == 1 ]]
  [[ $(is_semver_gt 1.1.0 1.1.1) == 1 ]]
}


@test "\`is_superuser' checks if script is run as superuser" {
  local bin="${BATS_TEST_TMPDIR}/bin"
  PATH="${bin}:${PATH}"
  mkdir -p "${bin}"
  touch "${bin}/id"
  chmod +x "${bin}/id"

  # A normal user with id 1000.
  echo 'echo 1000' > "${bin}/id"
  ! is_superuser

  # Root user.
  echo 'echo 0' > "${bin}/id"
  is_superuser
}


@test "\`list_modules' lists installed modules" {
  # no modules
  run list_modules
  [ "${status}" -eq 0 ]
  [ "$(wc -l <<< "${output}")" -eq 1 ]

  # 1 module installed
  mkdir -p "${MSU_EXTERNAL_LIB}/mod1"
  run list_modules
  [ "${status}" -eq 0 ]
  grep "external modules" <<< "${output}"
  grep "mod1" <<< "${output}"
  [ "$(wc -l <<< "${output}")" -eq 2 ]

  # 2 modules installed
  mkdir -p "${MSU_EXTERNAL_LIB}/mod2"
  run list_modules
  [ "${status}" -eq 0 ]
  grep "mod1" <<< "${output}"
  grep "mod2" <<< "${output}"
  [ "$(wc -l <<< "${output}")" -eq 3 ]
}


@test "\`nuke' nukes msu entirely" {
  HOME="${BATS_TEST_TMPDIR}/msu"
  PATH="${HOME}/bin:${PATH}"
  source lib/metadata.sh
  ./install.sh
  [ -d "${HOME}/lib/msu" ]
  [ -e "${HOME}/bin/msu" ]
  [ -e "${HOME}/share/man/man1/msu.1" ]
  [ -e "${HOME}/share/man/man3/msu.3" ]
  grep "${MSU_INSTALL_LOAD_STRING}" "${HOME}/.bashrc"

  MSU_ASSUME_YES="yes" msu nuke
  [ ! -d "${HOME}/lib/msu" ]
  [ ! -e "${HOME}/bin/msu" ]
  [ ! -e "${HOME}/share/man/man1/msu.1" ]
  [ ! -e "${HOME}/share/man/man3/msu.3" ]
  ! grep "${MSU_INSTALL_LOAD_STRING}" "${HOME}/.bashrc"
}


@test "\`show_metadata' shows module metadata" {
  local sample_module="${MSU_EXTERNAL_LIB}/mod"
  mkdir -p "${sample_module}"
  {
    echo "author=john@example.com"
    echo "build=abc123"
    echo "date=2025-12-02"
  } > "${sample_module}/metadata.sh"
  run show_metadata "mod"
  [ "${status}" -eq 0 ]
  echo "${output}" | grep "author" | grep "john@example.com"
  echo "${output}" | grep "build" | grep "abc123"
  echo "${output}" | grep "date" | grep "2025-12-02"
}


@test "\`uninstall' uninstalls modules" {
  mkdir -p "${MSU_EXTERNAL_LIB}/mod1" "${MSU_EXTERNAL_LIB}/mod2"
  run uninstall mod1 mod2
  [ "${status}" -eq 0 ]
  local module_names=(mod1 mod2)
  for mod in "${module_names[@]}" ; do
    grep "${sym_tick} ${mod}" <<< "${output}"
    [ ! -d "${MSU_EXTERNAL_LIB}/${mod}" ]
  done

  # uninstall reports if module not installed
  run uninstall mod1
  [ "${status}" -eq 0 ]
  grep "${sym_tick} mod1 (not installed)" <<< "${output}"
}


@test "\`uninstall_from_list' uninstalls from a list in a file" {
  listpath="${BATS_TMPDIR}/list"
  mkdir -p "${MSU_EXTERNAL_LIB}/mod1"
  mkdir -p "${MSU_EXTERNAL_LIB}/mod2"
  echo "mod1" > ${listpath}
  echo "mod2" >> ${listpath}
  run uninstall_from_list ${listpath}
  [ "${status}" -eq 0 ]
  grep "${sym_tick} mod1" <<< "${output}"
  grep "${sym_tick} mod2" <<< "${output}"
  [ ! -d "${MSU_EXTERNAL_LIB}/mod1" ]
  [ ! -d "${MSU_EXTERNAL_LIB}/mod2" ]
}


@test "\`upgrade' upgrades to latest version" {
  skip "Upgrading is untested for now"
}
