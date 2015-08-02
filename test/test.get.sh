#!/usr/bin/env bats
# tests against get.sh


function teardown() {
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
  local hash="49b0104a2e962e6da5dac12f1860e7898505090c"
  cat get.sh | BUILD="${hash}" bash
  cd /tmp/msu
  [ "$(git rev-parse HEAD)" == "${hash}" ]
  cd ..
}
