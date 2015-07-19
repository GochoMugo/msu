# Get me the MSU

set -e

GIT_URL=https://github.com/GochoMugo/msu.git
CLONE_DIR=msu
BASHRC=~/.bashrc
BIN=${BIN:-${HOME}/bin}
LIB=${LIB:-${BIN}}
MSU_LIB=${LIB}/msu-lib
MSU_EXE=${BIN}/msu
MARKER=" >>>"


echo "${MARKER} changing to /tmp"
pushd /tmp

echo "${MARKER} cloning repo for source code"
rm -fr ${CLONE_DIR}
git clone ${GIT_URL} ${CLONE_DIR}

echo "${MARKER} checking if ${BIN} is in path"
echo ${PATH} | grep ${BIN} > /dev/null || {
  echo "${MARKER} ${BIN} not in path. Adding it to ${BASHRC}. You need to restart your terminal for this to take effect!"
  echo "" >> ${BASHRC}
  echo "# added by msu" >> ${BASHRC}
  echo "export PATH=${BIN}:\${PATH}" >> ${BASHRC}
}

echo "${MARKER} changing to repo directory"
cd ${CLONE_DIR}

echo "${MARKER} generating metadata"
MSU_BUILD_HASH=$(git rev-parse HEAD)
MSU_BUILD_DATE=$(git show -s --format=%ci ${MSU_BUILD_HASH})
echo "MSU_BUILD_HASH=${MSU_BUILD_HASH}" >> lib/metadata.sh
echo "MSU_BUILD_DATE='${MSU_BUILD_DATE}'" >> lib/metadata.sh

echo "${MARKER} copying library"
mkdir -p ${MSU_LIB}
cp -r lib/* ${MSU_LIB}

echo "${MARKER} linking executable"
rm -f ${MSU_EXE}
ln -sf ${MSU_LIB}/msu.sh ${MSU_EXE}

echo "${MARKER} will load aliases automatically"
loader="[ -s "${MSU_EXE}" ] && . "${MSU_EXE}" aliases"
cat ${BASHRC} | grep "${loader}" > /dev/null || {
  echo "" >> ${BASHRC}
  echo "# loading aliases from msu"  >> ${BASHRC}
  echo ${loader} >> ${BASHRC}
}

echo "${MARKER} changing to previous directory"
popd

echo "${MARKER} finished"
