#
# tests against ./lib/core.sh
#


source ./lib/core.sh


MSU_LIB=${PWD}/lib


function setup() {
  MSU_REQUIRE_LOCK=""
  MSU_EXTERNAL_LIB_OLD=${MSU_EXTERNAL_LIB}
  unset MSU_EXTERNAL_LIB
  source lib/core.sh
}


function teardown() {
  rm -rf lib/tmp_*
  MSU_EXTERNAL_LIB=${MSU_EXTERNAL_LIB_OLD}
}


@test "defaults to \${HOME}/.msu if \${MSU_EXTERNAL_LIB} is not set" {
  unset MSU_EXTERNAL_LIB
  source lib/core.sh
  [ ${MSU_EXTERNAL_LIB} == "${HOME}/.msu" ]
}


@test "uses the environment variable \${MSU_EXTERNAL_LIB} if set" {
  local libpath=${BATS_TMPDIR}/var-testing
  MSU_EXTERNAL_LIB=${libpath}
  . lib/core.sh
  [ ${MSU_EXTERNAL_LIB} == ${libpath} ]
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
  echo ${output} | grep "error"
}


@test "\`require' loads a module once" {
  tmp_mod=lib/tmp_once.sh
  echo "echo red" > ${tmp_mod}
  msu_require tmp_once
  rm ${tmp_mod}
  run msu_require tmp_once
  [ "${status}" -eq 0 ]
}


@test "\`require' checks deps automatically" {
  tmp_mod=lib/tmp_deps.sh
  echo "DEPS=\"echo missing\"" > ${tmp_mod}
  msu_require tmp_deps | grep "not found"
}


@test "\`require' loads scripts in nested directories" {
  tmp_dir=lib/tmp_nest/another/one/
  tmp_mod=${tmp_dir}/sample.sh
  mkdir -p ${tmp_dir}
  echo "" > ${tmp_mod}
  run msu_require tmp_nest.another.one.sample
  [ "${status}" -eq 0 ]
}


@test "\`require' loads external modules" {
  tmp_dir=~/.msu/gocho-msu-test/
  tmp_mod=${tmp_dir}/sample.sh
  mkdir -p ${tmp_dir}
  echo "" > ${tmp_mod}
  run msu_require gocho-msu-test.sample
  [ "${status}" -eq 0 ]
  rm -r ${tmp_dir}
}


@test "\`run' runs a function in a module" {
  tmp_mod=lib/tmp_run.sh
  echo -e "function hey() { \n echo \${1} \n }" > ${tmp_mod}
  run msu_run tmp_run.hey gocho
  echo ${output}
  [ "${status}" -eq 0 ]
  echo ${output} | grep "gocho"
}


@test "\`upgrade' runs upgrade" {
  skip
}


@test "\`install' installs one or more modules" {
  MSU_EXTERNAL_LIB=${BATS_TMPDIR}/install
  source lib/core.sh
  mod1="${BATS_TMPDIR}/mod1"
  mod2="${BATS_TMPDIR}/mod2"
  mkdir -p ${mod1} ${mod2}
  rm -rf "${MSU_EXTERNAL_LIB}/mod1" "${MSU_EXTERNAL_LIB}/mod2"
  run msu_install ${mod1} ${mod2}
  [ "${status}" -eq 0 ]
  echo ${output} | grep "installed"
  [ -d ${MSU_EXTERNAL_LIB}/mod1 ]
  [ -d ${MSU_EXTERNAL_LIB}/mod2 ]
}


@test "\`uninstall' uninstalls one or more modules" {
  MSU_EXTERNAL_LIB=${BATS_TMPDIR}/uninstall
  source lib/core.sh
  mkdir -p ${MSU_EXTERNAL_LIB}/mod1 ${MSU_EXTERNAL_LIB}/mod2
  run msu_uninstall mod1 mod2
  [ "${status}" -eq 0 ]
  echo ${output} | grep "uninstalled"
  [ ! -d ${MSU_EXTERNAL_LIB}/mod1 ]
  [ ! -d ${MSU_EXTERNAL_LIB}/mod2 ]
}
