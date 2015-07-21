#
# tests against ./lib/core.sh
#


source ./lib/core.sh


MSU_LIB=${PWD}/lib


function setup() {
  MSU_REQUIRE_LOCK=""
}


function teardown() {
  rm -f lib/tmp_*.sh
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


@test "\`run' runs a function in a module" {
  tmp_mod=lib/tmp_run.sh
  echo -e "function hey() { \n echo \${1} \n }" > ${tmp_mod}
  run msu_run tmp_run.hey gocho
  [ "${status}" -eq 0 ]
  echo ${output} | grep "gocho"
}


@test "\`upgrade' runs upgrade" {
  skip
}