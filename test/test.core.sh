#!/usr/bin/env bats
# tests against ./lib/core.sh

bats_require_minimum_version 1.5.0


function setup() {
  unset MSU_EXTERNAL_LIB
  MSU_LIB="${BATS_TEST_TMPDIR}"
}


@test "Exits with error if \${MSU_LIB} is not set" {
  unset MSU_LIB
  run bash lib/core.sh
  [ "${status}" -eq 1 ]
  grep 'core: library path not set' <<< "${output}"
}


@test "sets \${MSU_EXTERNAL_LIB} to \${HOME}/.msu if not set" {
  unset MSU_EXTERNAL_LIB
  source lib/core.sh
  [ "${MSU_EXTERNAL_LIB}" == "${HOME}/.msu" ]
}


@test "does not override environment variable \${MSU_EXTERNAL_LIB} if set" {
  local libpath="${BATS_TEST_TMPDIR:-'.'}/var-testing"
  MSU_EXTERNAL_LIB="${libpath}"
  source lib/core.sh
  [ "${MSU_EXTERNAL_LIB}" == "${libpath}" ]
}


@test "'msu__check_deps' shows a warning if a dependency is not found" {
  DEPS="command missing-cmd"
  source lib/core.sh
  run -0 msu__check_deps
  ! grep "\`command' not found" <<< "${output}"
  grep "\`missing-cmd' not found" <<< "${output}"
}


@test "'msu__check_deps' exits silently if all dependencies exist" {
  DEPS="command"
  source lib/core.sh
  run -0 msu__check_deps
  [ "$(wc -w <<< "${output}")" -eq 0 ]
}


@test "'msu__check_deps' exits silently if \${DEPS} is not defined" {
  source lib/core.sh
  run -0 msu__check_deps
  [ "$(wc -w <<< "${output}")" -eq 0 ]
}


@test "'msu_require' loads modules" {
  MSU_LIB="${BATS_TEST_TMPDIR}/internal"
  MSU_EXTERNAL_LIB="${BATS_TEST_TMPDIR}/external"
  internal_mod="${MSU_LIB}/sample_internal.sh"
  external_mod="${MSU_EXTERNAL_LIB}/sample_external.sh"
  sample_output="${BATS_TEST_TMPDIR}/output.txt"
  mkdir -p "${MSU_LIB}" "${MSU_EXTERNAL_LIB}"
  source lib/core.sh
  [ "${MSU_REQUIRE_LOCK}" == "" ]

  # Test loading internal module
  echo "echo foo > "${sample_output}"" > "${internal_mod}"
  msu_require sample_internal
  [ "${MSU_REQUIRE_LOCK}" == ":${internal_mod}:" ]
  grep foo "${sample_output}"

  # Test that it's not loaded again
  echo "echo bar > "${sample_output}"" > "${internal_mod}"
  msu_require sample_internal
  [ "${MSU_REQUIRE_LOCK}" == ":${internal_mod}:" ]
  grep foo "${sample_output}"

  # Test again that it's not loaded at all
  rm "${internal_mod}"
  msu_require sample_internal # should not error since it was loaded already

  # Test loading external module
  echo "echo baz > "${sample_output}"" > "${external_mod}"
  msu_require sample_external
  [ "${MSU_REQUIRE_LOCK}" == ":${external_mod}::${internal_mod}:" ]
  grep baz "${sample_output}"

  # Test that it's not loaded again
  rm "${external_mod}"
  msu_require sample_external # should not error

  # Test that internal modules have higher precedence than external modules
  internal_mod="${MSU_LIB}/override.sh"
  external_mod="${MSU_EXTERNAL_LIB}/override.sh"
  echo "echo internal > "${sample_output}"" > "${internal_mod}"
  echo "echo external > "${sample_output}"" > "${external_mod}"
  msu_require override
  grep internal "${sample_output}"
  ! grep external "${sample_output}"
}


@test "'msu_require' checks dependencies automatically" {
  MSU_EXTERNAL_LIB="${BATS_TEST_TMPDIR}"
  external_mod="${MSU_EXTERNAL_LIB}/sample_external.sh"
  echo "DEPS='command missing'" > "${external_mod}"
  source lib/core.sh

  run -0 msu_require sample_external
  grep "warning: \`missing' not found" <<< "${output}"
}


@test "'msu_require' loads scripts in nested directories" {
  MSU_EXTERNAL_LIB="${BATS_TEST_TMPDIR}"
  external_mod="${MSU_EXTERNAL_LIB}/nested/inside/this/sample_external.sh"
  sample_output="${BATS_TEST_TMPDIR}/output.txt"
  mkdir -p "$(dirname "${external_mod}")"
  echo 'echo foo > "${sample_output}"' > "${external_mod}"
  source lib/core.sh

  msu_require nested/inside/this/sample_external
  grep foo "${sample_output}"
  [ "${MSU_REQUIRE_LOCK}" == ":${external_mod}:" ]
}


@test "'msu_require' echoes error and exits with a non-zero status if module fails to load" {
  MSU_EXTERNAL_LIB="${BATS_TEST_TMPDIR}"
  echo 'unknown_command' > "${MSU_EXTERNAL_LIB}/failing.sh"
  source lib/core.sh
  run -1 msu_require failing
  grep "error: msu_require: failed to load module 'failing'" <<< "${output}"
  [ "$(wc -w <<< "${MSU_REQUIRE_LOCK}")" -eq 0 ]
}


@test "'msu_require' echoes error and exits with a non-zero status if module is missing" {
  source lib/core.sh
  run -1 msu_require missing
  grep "error: msu_require: did not find module 'missing'" <<< "${output}"
  [ "$(wc -w <<< "${MSU_REQUIRE_LOCK}")" -eq 0 ]
}


@test "'msu_run' runs a function in a module" {
  MSU_LIB="${PWD}/lib"
  MSU_EXTERNAL_LIB="${BATS_TEST_TMPDIR}"
  sample_output="${BATS_TEST_TMPDIR}/output.txt"
  cat > "${MSU_EXTERNAL_LIB}/sample_external.sh" <<EOF
  function foo() {
    echo \$1-\$2-\$3 > "${sample_output}"
  }
EOF
  source lib/core.sh

  msu_run sample_external.foo bar 'abc def' baz
  grep 'bar-abc def-baz' "${sample_output}"
  [ ! "$(type -t foo)" ]

  run -1 msu_run sample_external.missing
  grep "error: msu_run: can not find function 'missing'" <<< "${output}"
}
