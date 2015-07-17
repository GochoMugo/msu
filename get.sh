# Get me the MSU

set -e

GIT_URL=https://github.com/GochoMugo/msu.git
BIN=${HOME}/bin
CLONE_DIR=msu
BASHRC=~/.bashrc
MSU_LIB=${BIN}/msu-lib
MSU_EXE=${BIN}/msu
MARKER=" >>>"
VERSION=

echo "${MARKER} changing to /tmp"
pushd /tmp

echo "${MARKER} cloning repo for source code"
rm -fr ${CLONE_DIR}
git clone ${GIT_URL} ${CLONE_DIR}

echo "${MARKER} checking if ${BIN} is in path"
echo ${PATH} | grep ${BIN} > /dev/null || {
  echo "⇒ ${BIN} not in path. Adding it"
  echo "" >> ${BASHRC}
  echo "# added by msu" >> ${BASHRC}
  echo "export PATH=${BIN}:\${PATH}" >> ${BASHRC}
  echo "    !! you may need to restart your terminal !!"
}

echo "${MARKER} changing to repo directory"
cd ${CLONE_DIR}

echo "${MARKER} generating metadata"
echo "MSU_VERSION=$(git rev-parse HEAD)" >> lib/metadata.sh

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
