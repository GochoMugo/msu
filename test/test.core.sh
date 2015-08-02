#!/usr/bin/env bats
# tests against ./lib/core.sh


MSU_LIB="${PWD}/lib"


source ./lib/core.sh


function setup() {
  MSU_REQUIRE_LOCK=''
  MSU_EXTERNAL_LIB_OLD="${MSU_EXTERNAL_LIB}"
  unset MSU_EXTERNAL_LIB
  source lib/core.sh
}


function teardown() {
  rm -rf lib/tmp_*
  MSU_EXTERNAL_LIB="${MSU_EXTERNAL_LIB_OLD}"
}


@test "defaults to \${HOME}/.msu if \${MSU_EXTERNAL_LIB} is not set" {
  unset MSU_EXTERNAL_LIB
  source lib/core.sh
  [ "${MSU_EXTERNAL_LIB}" == "${HOME}/.msu" ]
}


@test "uses the environment variable \${MSU_EXTERNAL_LIB} if set" {
  local libpath="${BATS_TMPDIR:-'.'}/var-testing"
  MSU_EXTERNAL_LIB="${libpath}"
  . lib/core.sh
  [ "${MSU_EXTERNAL_LIB}" == "${libpath}" ]
}


@test "check_deps shows warning if a dependency is not found" {
  DEPS="missing-cmd" msu__check_deps | grep "not found"
}


@test "\`check_deps' exits silently if all dependences exist" {
  [ $(DEPS="echo" msu__check_deps | wc -w) -eq 0 ]
}


@test "\`check_deps' exits silently if \${DEPS} is not defined" {
  [ $(msu__check_deps | wc -w) -eq 0 ]
}


@test "\`require' echos error and exits with a non-zero status if module is missing" {
  run msu_require missing
  [ "${status}" -eq 1 ]
  echo "${output}" | grep "error"
}


@test "\`require' loads a module once" {
  tmp_mod=lib/tmp_once.sh
  echo "echo red" > "${tmp_mod}"
  msu_require tmp_once
  rm "${tmp_mod}"
  run msu_require tmp_once
  [ "${status}" -eq 0 ]
}


@test "\`require' checks deps automatically" {
  tmp_mod=lib/tmp_deps.sh
  echo "DEPS=\"echo missing\"" > "${tmp_mod}"
  msu_require tmp_deps | grep "not found"
}


@test "\`require' loads scripts in nested directories" {
  tmp_dir=lib/tmp_nest/another/one/
  tmp_mod="${tmp_dir}/sample.sh"
  mkdir -p "${tmp_dir}"
  echo "" > "${tmp_mod}"
  run msu_require tmp_nest.another.one.sample
  [ "${status}" -eq 0 ]
}


@test "\`require' loads external modules" {
  tmp_dir=~/.msu/gocho-msu-test/
  tmp_mod="${tmp_dir}"/sample.sh
  mkdir -p "${tmp_dir}"
  echo "" > "${tmp_mod}"
  run msu_require gocho-msu-test.sample
  [ "${status}" -eq 0 ]
  rm -r "${tmp_dir}"
}


@test "\`run' runs a function in a module" {
  tmp_mod=lib/tmp_run.sh
  echo -e "function hey() { \n echo \${1} \n }" > "${tmp_mod}"
  run msu_run tmp_run.hey gocho
  echo "${output}"
  [ "${status}" -eq 0 ]
  echo "${output}" | grep "gocho"
}
