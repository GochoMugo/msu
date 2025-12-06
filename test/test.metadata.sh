#!/usr/bin/env bats
# tests against lib/metadata.sh


setup() {
  BATS_TEST_TMPDIR="$(readlink -f "${BATS_TEST_TMPDIR}")"
}


@test "metadata contains version & contact information" {
  source lib/metadata.sh
  [ "${MSU_AUTHOR_NAME}" ]
  [ "${MSU_AUTHOR_EMAIL}" ]
  [ "${MSU_INSTALL_LOAD_STRING}" ]
  grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' <<< "${MSU_VERSION}"
}
