# Get me the MSU

set -e

GIT_URL=https://github.com/GochoMugo/msu.git
BUILD=${BUILD:-""}
CLONE_DIR=msu
MARKER=" >>>"

pushd /tmp > /dev/null

echo "${MARKER} cloning repo"
rm -fr ${CLONE_DIR}
if [ ${BUILD} ] ; then
  git clone --quiet ${GIT_URL} ${CLONE_DIR}
  cd ${CLONE_DIR}
  echo "${MARKER} checking out build ${BUILD}"
  git checkout --quiet ${BUILD}
  cd ..
else
  git clone --depth=1 --quiet ${GIT_URL} ${CLONE_DIR}
fi

echo "${MARKER} running installation script"
cd ${CLONE_DIR}
LIB=${LIB} BIN=${BIN} ./install.sh
cd ..

popd > /dev/null
