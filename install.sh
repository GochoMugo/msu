#!/usr/bin/env bash
# Installs msu


set -o errexit
set -o nounset


BASHRC="${HOME}/.bashrc"
BIN="${BIN:-${HOME}/bin}"
LIB="${LIB:-${HOME}/lib}"
MAN="${MAN:-${HOME}/share/man}"
MSU_LIB="${LIB}/msu"
MSU_EXE="${BIN}/msu"
MSU_MAN="${MAN}"
MARKER=" >>>"


function check() {
  command -v "${1}" > /dev/null 2>&1 || {
    echo "\`${1}' is NOT available. It is required for: ${2}" > /dev/stderr
    exit 1
  }
}


function check_deps() {
  check "wget" "self-upgrade, downloading files"
  check "git" "self-upgrade, install modules from github"
  check "tput" "formatting styles"
}


echo "${MARKER} checking if all dependencies are available"
check_deps


echo "${MARKER} checking if ${BIN} is in \${PATH}"
echo "${PATH}" | grep "${BIN}" > /dev/null || {
  echo "${MARKER} ${BIN} not in path. Adding it to ${BASHRC}. You need to restart your terminal for this to take effect!"
  {
    echo ""
    echo "# added by msu"
    echo "export PATH=\"${BIN}\":\${PATH}"
  } >> "${BASHRC}"
}


echo "${MARKER} copying library"
[ "${MSU_EXE}" == "${MSU_LIB}" ] && {
  MSU_LIB="${MSU_LIB}-lib"
}
rm -rf "${MSU_LIB}"
mkdir -p "${MSU_LIB}"
cp -r lib/* "${MSU_LIB}"


echo "${MARKER} checking if ${MSU_MAN} is in \${MANPATH}"
echo "${MANPATH}" | grep "${MSU_MAN}" > /dev/null || {
  echo "${MARKER} ${MSU_MAN} not in manpath. Adding it to ${BASHRC}. You need to restart your terminal for this to take effect!"
  {
    echo ""
    echo "# added by msu"
    echo "export MANPATH=\"${MSU_MAN}\":\${MANPATH}"
  } >> "${BASHRC}"
}


echo "${MARKER} copying manpages"
mkdir -p "${MAN}/man1" "${MAN}/man3"
cp -r docs/man/man1/*.1 "${MAN}/man1"
#cp -r docs/man/man3/*.3 "${MAN}/man3"


echo "${MARKER} generating metadata"
MSU_BUILD_HASH=$(git rev-parse HEAD)
MSU_BUILD_DATE=$(git show -s --format=%ci "${MSU_BUILD_HASH}")
{
  echo "MSU_INSTALL_LIB='${MSU_LIB}'"
  echo "MSU_INSTALL_EXE='${MSU_EXE}'"
  echo "MSU_INSTALL_MAN='${MSU_MAN}'"
  echo "MSU_BUILD_HASH='${MSU_BUILD_HASH}'"
  echo "MSU_BUILD_DATE='${MSU_BUILD_DATE}'"
} >> "${MSU_LIB}"/metadata.sh


echo "${MARKER} linking executable"
mkdir -p "$(dirname "${MSU_EXE}")"
rm -f "${MSU_EXE}"
ln -sf "${MSU_LIB}"/msu.sh "${MSU_EXE}"


echo "${MARKER} make bash load msu into environment on start"
loader=". msu require load"
grep "${loader}" "${BASHRC}" > /dev/null || {
  {
    echo ""
    echo "# loading msu"
    echo "${loader}"
  } >> "${BASHRC}"
}


echo "${MARKER} finished installing"
echo "${MARKER} !! Restart your terminal to load msu into environment"

echo
"${MSU_EXE}" version
echo
