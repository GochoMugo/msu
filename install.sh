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
MSU_LOAD_STRING="# loading msu
. msu require load"


function check() {
  command -v "${1}" > /dev/null 2>&1 || {
    echo "\`${1}' is NOT available. It is required for: ${2}" > /dev/stderr
    exit 1
  }
}


function check_deps() {
  check "bash" "runtime"
  check "cat" "file reading, stream concat"
  check "command" "command lookup/execution"
  check "cp" "file copying"
  check "cut" "stream cutting"
  check "dirname" "path manipulation"
  check "echo" "line printing"
  check "git" "install, self-upgrade, module-install, metadata gen."
  check "grep" "regexp matching"
  check "id" "check user id"
  check "ln" "symlink creation"
  check "mkdir" "directory creation"
  check "mv" "file renaming"
  check "popd" "pop directory from stack"
  check "pushd" "push directory onto stack"
  check "python" "self-upgrade"
  check "readlink" "handling symlinks"
  check "rm" "file removal"
  check "tar" "self-upgrade"
  check "tput" "formatting styles"
  check "tr" "character translation"
  check "wget" "self-upgrade"
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
echo "${MANPATH:-}" | grep "${MSU_MAN}" > /dev/null || {
  echo "${MARKER} ${MSU_MAN} not in manpath. Adding it to ${BASHRC}."
  echo "${MARKER} !! You need to restart your terminal for this to take effect!"
  {
    echo ""
    echo "# added by msu"
    echo "export MANPATH=\"${MSU_MAN}\":\${MANPATH}"
  } >> "${BASHRC}"
}


# there are cases where manpages are not generated yet
if [ -f docs/man/man1/msu.1 ] && [ -f docs/man/man3/msu.3 ]
then
  echo "${MARKER} copying manpages"
  mkdir -p "${MSU_MAN}/man1" "${MSU_MAN}/man3"
  cp -r docs/man/man1/*.1 "${MSU_MAN}/man1" || true
  cp -r docs/man/man3/*.3 "${MSU_MAN}/man3" || true
fi


# tarballs do NOT ship with the .git directory
# instead, the metadata is generated at release time
if [ -d .git ]
then
  echo "${MARKER} generating metadata"
  MSU_BUILD_HASH=$(git rev-parse HEAD)
  MSU_BUILD_DATE=$(git show -s --format=%ci "${MSU_BUILD_HASH}")
  {
    echo "MSU_BUILD_HASH='${MSU_BUILD_HASH}'"
    echo "MSU_BUILD_DATE='${MSU_BUILD_DATE}'"
  } >> "${MSU_LIB}"/metadata.sh
fi


echo "${MARKER} linking executable"
mkdir -p "$(dirname "${MSU_EXE}")"
rm -f "${MSU_EXE}"
ln -sf "${MSU_LIB}"/msu.sh "${MSU_EXE}"


echo "${MARKER} make bash load msu into environment on start"
grep "${MSU_LOAD_STRING}" "${BASHRC}" > /dev/null || {
  {
    echo ""
    echo "${MSU_LOAD_STRING}"
  } >> "${BASHRC}"
}


echo "${MARKER} storing installation configuration"
{
  echo "MSU_INSTALL_LIB='${LIB}'"
  echo "MSU_INSTALL_BIN='${BIN}'"
  echo "MSU_INSTALL_MAN='${MAN}'"
  echo "MSU_INSTALL_LOAD_STRING='${MSU_LOAD_STRING}'"
} >> "${MSU_LIB}"/metadata.sh



echo "${MARKER} finished installing"
echo "${MARKER} !! Restart your terminal to load msu into environment"

echo
"${MSU_EXE}" version
echo
