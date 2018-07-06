#!/usr/bin/env bash
# making a new release


# modules
msu_require "console"


# module variables
{
  # shellcheck disable=SC2034
  DEPS="xargs hub"
}
RELEASE=""


log "prompting for new version number"
MSU_VERSION=""
ask "New version number" MSU_VERSION


log "mark that we are in RELEASE mode using the version number in \${RELEASE}"
RELEASE=${MSU_VERSION}
export RELEASE


log "creating directory for releases"
RELEASE_DIR="releases/v${MSU_VERSION}"
RELEASE_TARBALL="releases/msu-${MSU_VERSION}.tar.gz"
rm --force --recursive "${RELEASE_DIR}" "${RELEASE_TARBALL}"
mkdir --parents "${RELEASE_DIR}"


log "copying the contents of the working directory"
release_contents=(
  dist/docs/
  lib/
  install.sh
  CHANGELOG.md
  LICENSE
  README.md
)
for release_content in "${release_contents[@]}" ; do
  mkdir --parents "${RELEASE_DIR}/$(dirname "${release_content}")"
  cp --force --parents --recursive "${release_content}" "${RELEASE_DIR}"
done


log "generating metadata"
MSU_BUILD_HASH=$(git rev-parse HEAD)
MSU_BUILD_DATE=$(git show -s --format=%ci "${MSU_BUILD_HASH}")
{
  echo "MSU_BUILD_HASH='${MSU_BUILD_HASH}'"
  echo "MSU_BUILD_DATE='${MSU_BUILD_DATE}'"
} >> "${RELEASE_DIR}"/lib/metadata.sh


log "creating a tarball of the release"
tar --create --gzip --file "${RELEASE_TARBALL}" "${RELEASE_DIR}/"


log "creating a new github release"
hub release create -a ${RELEASE_TARBALL} v${MSU_VERSION}


success "New MSU release: v${MSU_VERSION}"
