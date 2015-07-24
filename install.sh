#
# Installs msu
#

set -e


BASHRC=~/.bashrc
BIN=${BIN:-${HOME}/bin}
LIB=${LIB:-${HOME}/lib}
MSU_LIB=${LIB}/msu
MSU_EXE=${BIN}/msu
MARKER=" >>>"


echo "${MARKER} checking if ${BIN} is in path"
echo ${PATH} | grep ${BIN} > /dev/null || {
  echo "${MARKER} ${BIN} not in path. Adding it to ${BASHRC}. You need to restart your terminal for this to take effect!"
  echo "" >> ${BASHRC}
  echo "# added by msu" >> ${BASHRC}
  echo "export PATH=${BIN}:\${PATH}" >> ${BASHRC}
}


echo "${MARKER} copying library"
[ ${MSU_EXE} == ${MSU_LIB} ] && {
  MSU_LIB=${MSU_LIB}-lib
}
rm -rf ${MSU_LIB}
mkdir -p ${MSU_LIB}
cp -r lib/* ${MSU_LIB}


echo "${MARKER} generating metadata"
MSU_BUILD_HASH=$(git rev-parse HEAD)
MSU_BUILD_DATE=$(git show -s --format=%ci ${MSU_BUILD_HASH})
echo "MSU_BUILD_HASH=${MSU_BUILD_HASH}" >> ${MSU_LIB}/metadata.sh
echo "MSU_BUILD_DATE='${MSU_BUILD_DATE}'" >> ${MSU_LIB}/metadata.sh


echo "${MARKER} linking executable"
mkdir -p $(dirname ${MSU_EXE})
rm -f ${MSU_EXE}
ln -sf ${MSU_LIB}/msu.sh ${MSU_EXE}


echo "${MARKER} will load aliases automatically"
loader="[ -f \"${MSU_LIB}/aliases.sh\" ] && . \"${MSU_LIB}/aliases.sh\""
cat ${BASHRC} | grep "${loader}" > /dev/null || {
  echo "" >> ${BASHRC}
  echo "# loading aliases from msu"  >> ${BASHRC}
  echo ${loader} >> ${BASHRC}
}


echo "${MARKER} finished installing"

echo
${MSU_EXE} version
echo
