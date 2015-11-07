#!/usr/bin/env bats
# tests against lib/msu.sh


@test "\`msu' exports \${MSU_LIB}" {
  . lib/msu.sh
  [ "${MSU_LIB}" ]
}


@test "\`msu' sets \${MSU_LIB} to library, if its a symbolic link" {
  ./install.sh
  . msu
  [ "${MSU_LIB}" == "$(readlink -f ~/lib/msu)" ]
}


@test "\`msu' sets \${MSU_LIB} to library, if executed directly" {
  . ./lib/msu.sh
  [ "$(readlink -f ${MSU_LIB})" == "$(readlink -f ${PWD}/lib)" ]
}


@test "\`msu require' loads a module" {
  [ ! "$(command -v log)" ]
  . msu require console
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
