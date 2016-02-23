#!/usr/bin/env bats
# tests against get.sh


BASHRC_TMP=~/.bashrc.msu

cp ~/.bashrc ~/.bashrc~ # backup


function setup() {
  mv ~/.bashrc "${BASHRC_TMP}"
  touch ~/.bashrc
}


function teardown() {
  mv "${BASHRC_TMP}" ~/.bashrc
  rm -rf /tmp/msu
}


@test "test-run get.sh" {
  cat get.sh | bash
}


@test "clones to /tmp/msu" {
  cat get.sh | bash
  [ -d /tmp/msu ]
}


@test "removes existing directory at /tmp/msu before cloning" {
  mkdir -p /tmp/msu
  cat get.sh | bash
  [ -d /tmp/msu ]
}


@test "clones to a depth of 1 by default" {
  cat get.sh | bash
  cd /tmp/msu
  [ "$(git rev-list HEAD --count)" -eq 1 ]
  cd ..
}


@test "clone for a certain build" {
  local hash="9bc50798b321b134a0d471a8584fba4fc0c15b06"
  cat get.sh | BUILD="${hash}" bash
  cd /tmp/msu
  [ "$(git rev-parse HEAD)" == "${hash}" ]
  cd ..
}


@test "download url resolves successfully" {
  wget https://git.io/vTE0s -O _test_get.sh
  real="$(cat get.sh)"
  downloaded="$(cat _test_get.sh)"
  [ "${real}" == "${downloaded}" ]
}

