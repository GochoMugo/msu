#
# tests against lib/aliases.sh
#


MSU_EXTERNAL_LIB=${BATS_TMPDIR}/test-aliases


function setup() {
  mkdir -p ${MSU_EXTERNAL_LIB}
  [ alias fs.join ] && unalias fs.join || echo
  [ alias net.dl  ] && unalias net.dl || echo
  [ alias humansshouldriseup  ] && unalias humansshouldriseup || echo
}


function teardown() {
  rm -rf ${MSU_EXTERNAL_LIB}/*
}


@test "aliases.sh loads aliases into the current environment" {
  . lib/aliases.sh
  alias fs.join
  alias net.dl
}


@test "aliases.sh loads aliases from external modules" {
  mod=${MSU_EXTERNAL_LIB}/aliases
  mkdir -p ${mod}
  echo "alias humansshouldriseup='echo external'" > ${mod}/aliases.sh
  . lib/aliases.sh
  alias humansshouldriseup | grep "external"
}


@test "\${MSU_EXTERNAL_LIB}/aliases.sh overides all" {
  alias_override=${MSU_EXTERNAL_LIB}/aliases.sh
  mod=${MSU_EXTERNAL_LIB}/overide
  mkdir -p ${mod}
  echo "alias humansshouldriseup='echo override'" > ${alias_override}
  echo "alias humansshouldriseup='echo external'" > ${mod}/aliases.sh
  . lib/aliases.sh
  alias humansshouldriseup | grep "override"
}
