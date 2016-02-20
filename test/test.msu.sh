#!/usr/bin/env bats
# tests against lib/msu.sh


@test "\`msu' sets \${MSU_LIB} to library, if its a symbolic link" {
  msu_ln="${BATS_TMPDIR}/msu"
  ln -sf "${PWD}/lib/msu.sh" "${msu_ln}"
  . "${msu_ln}"
  [ "$(readlink -f ${MSU_LIB})" == "$(readlink -f ${PWD}/lib)" ]
}


@test "\`msu' sets \${MSU_LIB} to library, if executed directly" {
  . ./lib/msu.sh
  [ "$(readlink -f ${MSU_LIB})" == "$(readlink -f ${PWD}/lib)" ]
}


@test "\`msu require' loads a module" {
  [ ! "$(command -v log)" ]
  . ./lib/msu.sh require console
  command -v log
  command -v success
  command -v error
}


@test "\`msu upgrade' upgrades msu" {
  skip
}


@test "\`msu run' runs a module function" {
  run lib/msu.sh run console.log ian
  [ "${status}" -eq 0 ]
  echo "${output}" | grep "ian"
}


@test "\`msu help' shows help information" {
  run lib/msu.sh help
  [ "${status}" -eq 0 ]
  echo "${output}" | grep "help information"
}


@test "\`msu version' shows version information" {
  run lib/msu.sh version
  [ "${status}" -eq 0 ]
  echo "${output}" | grep "version"
  echo "${output}" | grep "build"
  echo "${output}" | grep "date"
}


@test "\`msu' does not error if run without arguments" {
  run lib/msu.sh
  [ "${status}" -eq 0 ]
}


@test "\`msu' can be used in a shebang" {
  bang_sh="${BATS_TMPDIR}/bang.sh"
  shebang="#!/usr/bin/env msu.sh"
  {
    echo "${shebang}"
    echo "msu_require 'console'"
    echo "log 'LOGGED'"
  } > "${bang_sh}"
  chmod +x "${bang_sh}"
  PATH="${PWD}/lib:${PATH}" run ${bang_sh}
  echo "${output}"
  [ "${status}" -eq 0 ]
  echo "${output}"
  echo "${output}" | grep "LOGGED"
}
