set -e

GIT_URL=https://github.com/GochoMugo/msu.git
BIN=${HOME}/Bin
CLONE_DIR=msu
BASHRC=~/.bashrc
MSU_LIB=${BIN}/msu-lib
MSU_EXE=${BIN}/msu

echo "⇒ changing to /tmp"
cd /tmp

echo "⇒ cloning repo for source code"
git clone ${GIT_URL} ${CLONE_DIR}

echo "⇒ checking if ${BIN} is in path"
echo ${PATH} | grep ${BIN} > /dev/null || {
  echo "⇒ ${BIN} not in path. Adding it"
  echo "" >> ${BASHRC}
  echo "# added by msu" >> ${BASHRC}
  echo "export PATH=${BIN}:\${PATH}" >> ${BASHRC}
  echo "    !! you may need to restart your terminal !!"
}

echo "⇒ copying library"
mkdir -p ${MSU_LIB}
cp -r lib/ ${MSU_LIB}

echo "⇒ copying executable"
cp msu.sh ${MSU_EXE}

echo "⇒ finished"

