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


function new_mod() {
  rm -rf ${1}
  mkdir -p ${1}
  pushd ${1} > /dev/null
  git init
  git config --local user.email "mugo@forfuture.co.ke"
  git config --local user.name  "GochoMugo"
  touch first
  git add first
  git commit -m "init"
  popd > /dev/null
}


@test "\`install' through \`generate_metadata' generates module metadata" {
  MSU_EXTERNAL_LIB=${BATS_TMPDIR}/gen-metadata
  local sample_module=${BATS_TMPDIR}/sample-metadata
  source lib/core_utils.sh
  new_mod ${sample_module}
  run install ${sample_module}
  [ "${status}" -eq 0 ]
  [ -f ${MSU_EXTERNAL_LIB}/sample-metadata/metadata.sh ]
}


@test "\`generate_metadata' ignores if there are no git commits" {
  MSU_EXTERNAL_LIB=${BATS_TMPDIR}/gen-md
  source lib/core_utils.sh
  mkdir -p ${MSU_EXTERNAL_LIB}/sample
  ! generate_metadata "sample"
  cd ${MSU_EXTERNAL_LIB}/sample
  git init
  cd -
  ! generate_metadata "sample"
}


@test "\`show_metadata' shows module metadata" {
  MSU_EXTERNAL_LIB=${BATS_TMPDIR}/show-metadata
  local sample_module=${BATS_TMPDIR}/show-me-some
  source lib/core_utils.sh
  new_mod ${sample_module}
  run install ${sample_module}
  run show_metadata "show-me-some"
  [ "${status}" -eq 0 ]
  echo ${output}
  echo "${output}" | grep "author" | grep "GochoMugo" # author
  echo "${output}" | grep "build" # build hash
  echo "${output}" | grep "date" # date
}
