#
# tests against ./lib/core.sh
#


MSU_LIB=$PWD/lib
source lib/core.sh
source lib/core_utils.sh
source lib/format.sh


@test "gets the \${MSU_EXTERNAL_LIB} readily set" {
  [ ! -z ${MSU_EXTERNAL_LIB} ]
}


@test "\`upgrade' runs upgrade" {
  skip
}


@test "\`install' installs one or more modules" {
  MSU_EXTERNAL_LIB=${BATS_TMPDIR}/install
  source lib/core_utils.sh
  mod1="${BATS_TMPDIR}/mod1"
  mod2="${BATS_TMPDIR}/mod2"
  mkdir -p ${mod1} ${mod2}
  rm -rf "${MSU_EXTERNAL_LIB}/mod1" "${MSU_EXTERNAL_LIB}/mod2"
  run install ${mod1} ${mod2}
  [ "${status}" -eq 0 ]
  echo ${output} | grep "${sym_tick}"
  [ -d ${MSU_EXTERNAL_LIB}/mod1 ]
  [ -d ${MSU_EXTERNAL_LIB}/mod2 ]
}


@test "\`install' installs from github" {
  MSU_EXTERNAL_LIB=${BATS_TMPDIR}/github
  source lib/core_utils.sh
  samplemodule="GH:GochoMugo/msu"
  run install ${samplemodule}
  [ "${status}" -eq 0 ]
  echo ${output} | grep "${sym_tick}"
  [ -d ${MSU_EXTERNAL_LIB}/msu ]
}


@test "\`uninstall' uninstalls one or more modules" {
  MSU_EXTERNAL_LIB=${BATS_TMPDIR}/uninstall
  source lib/core_utils.sh
  mkdir -p ${MSU_EXTERNAL_LIB}/mod1 ${MSU_EXTERNAL_LIB}/mod2
  run uninstall mod1 mod2
  [ "${status}" -eq 0 ]
  echo ${output} | grep "${sym_tick}"
  [ ! -d ${MSU_EXTERNAL_LIB}/mod1 ]
  [ ! -d ${MSU_EXTERNAL_LIB}/mod2 ]
}
