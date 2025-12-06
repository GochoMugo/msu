#!/usr/bin/env bats
# tests against ./install.sh


function setup() {
  BATS_TEST_TMPDIR="$(readlink -f "${BATS_TEST_TMPDIR}")"
  HOME="${BATS_TEST_TMPDIR}"
  PATH="${HOME}/bin:${PATH}"
  mkdir -p "${HOME}/bin"
}


@test "install.sh does not use sudo" {
  echo 'echo SUDO used > /dev/stderr && exit 1' > "${HOME}/bin/sudo"
  chmod +x "${HOME}/bin/sudo"
  ./install.sh
}


@test "install.sh installs to default locations" {
  ./install.sh
  [ -f "${HOME}/bin/msu" ]
  [ -f "${HOME}/lib/msu/msu.sh" ]
  [ -f "${HOME}/share/man/man1/msu.1" ]
}


@test "install.sh uses \${BASHRC} to set path to .bashrc file" {
  local bashrc="${HOME}/.bashrc.${RANDOM}"
  [ ! -f "${bashrc}" ]
  BASHRC="${bashrc}" ./install.sh
  [ -f "${bashrc}" ]
  source lib/metadata.sh
  grep "${MSU_INSTALL_LOAD_STRING}" "${bashrc}"
}


@test "install.sh uses \${LIB} to prefix destination directory for library" {
  local lib="${HOME}/lib.${RANDOM}"
  [ ! -d "${lib}" ]
  LIB="${lib}" ./install.sh
  [ -d "${lib}/msu" ]
  [ -f "${lib}/msu/msu.sh" ]
}


@test "install.sh uses \${BIN} to prefix destination directory for executable" {
  local bin="${HOME}/bin.${RANDOM}"
  [ ! -d "${bin}" ]
  BIN="${bin}" ./install.sh
  [ -d "${bin}" ]
  [ -x "${bin}/msu" ]
}


@test "install.sh uses \${MAN} to set prefix destination directory for manpages" {
  local man="${HOME}/man.${RANDOM}"
  [ ! -d "${man}" ]
  MAN="${man}" ./install.sh
  [ -d "${man}/man1" ]
  [ -d "${man}/man3" ]
  [ -f "${man}/man1/msu.1" ]
  [ -f "${man}/man3/msu.3" ]
}


@test "install.sh adds \${BIN} to ~/.bashrc if not in \${PATH}" {
  local bin="${HOME}/bin.${RANDOM}"
  ! grep "${bin}" <<< "## ${PATH//:/ ## } ##"
  BIN="${bin}" ./install.sh
  cat "${HOME}/.bashrc"
  source "${HOME}/.bashrc"
  grep "## ${bin} ##" <<< "## ${PATH//:/ ## } ##"
}


@test "install.sh adds \${MAN} to ~/.bashrc if not in \${MANPATH}" {
  local man="${HOME}/man.${RANDOM}"
  ! grep "${man}" <<< "## ${MANPATH//:/ ## } ##"
  MAN="${man}" ./install.sh
  source "${HOME}/.bashrc"
  grep "${man}" <<< "## ${MANPATH//:/ ## } ##"
}


@test "install.sh adds loader string to ~/.bashrc if not found" {
  [ ! -f "${HOME}/.bashrc" ]
  ./install.sh
  source lib/metadata.sh
  grep "${MSU_INSTALL_LOAD_STRING}" "${HOME}/.bashrc"

  # it should not modify .bashrc again
  source "${HOME}/.bashrc"
  local sha="$(sha256sum "${HOME}/.bashrc")"
  ./install.sh
  [ "$(sha256sum "${HOME}/.bashrc")" == "${sha}" ]
}


@test "install.sh generates metadata" {
  ./install.sh
  source "${HOME}/lib/msu/metadata.sh"
  grep -E "^[a-z0-9]+$" <<< "${MSU_BUILD_HASH}"
  grep -E "^.+$" <<< "${MSU_BUILD_DATE}"
  grep "${HOME}/lib" <<< "${MSU_INSTALL_LIB}"
  grep "${HOME}/bin" <<< "${MSU_INSTALL_BIN}"
  grep "${HOME}/share/man" <<< "${MSU_INSTALL_MAN}"
}


@test "install.sh links executable in path to that in library" {
  ./install.sh
  [ -x "${HOME}/bin/msu" ]
  [ "$(readlink -f "${HOME}/bin/msu")" == "${HOME}/lib/msu/msu.sh" ]
}


@test "install.sh spits out version information when done" {
  run ./install.sh
  source lib/metadata.sh
  grep "${MSU_VERSION}" <<< "${output}"
}
