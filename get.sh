#!/usr/bin/env bash
# Get me The MSU


set -o errexit
set -o nounset


GIT_URL=https://github.com/GochoMugo/msu.git
BUILD="${BUILD:-}"
CLONE_DIR=msu
MARKER=" >>>"

pushd /tmp > /dev/null

echo "${MARKER} cloning repo"
rm -fr ${CLONE_DIR}
if [ "${BUILD}" ] ; then
  git clone --quiet ${GIT_URL} ${CLONE_DIR}
  pushd ${CLONE_DIR} > /dev/null
  echo "${MARKER} checking out build ${BUILD}"
  git checkout --quiet "${BUILD}"
  popd > /dev/null
else
  git clone --depth=1 --quiet ${GIT_URL} ${CLONE_DIR}
fi

echo "${MARKER} running installation script"
pushd ${CLONE_DIR} > /dev/null
LIB="${LIB:-}" BIN="${BIN:-}" ./install.sh
popd > /dev/null

popd > /dev/null
