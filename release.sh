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


log "clean up working directory"
make clean


log "prompting for new version number"
MSU_VERSION=""
ask "New version number" MSU_VERSION


log "mark that we are in RELEASE mode using the version number in \${RELEASE}"
RELEASE=${MSU_VERSION}
export RELEASE


log "run the tests"
make test


log "generating documentation"
make doc


log "creating directory for releases"
RELEASE_DIR="msu-${MSU_VERSION}"
RELEASE_TARBALL="msu-${MSU_VERSION}.tar.gz"
mkdir "${RELEASE_DIR}"


log "copying the contents of the working directory"
# shellcheck disable=SC2010
ls \
  | grep -Ev "deps|get.sh|Makefile|package.json|msu-|release.sh|test" \
  | xargs -I{} cp -rf {} "${RELEASE_DIR}/"
rm "${RELEASE_DIR}"/docs/man/**/*.txt


log "generating metadata"
MSU_BUILD_HASH=$(git rev-parse HEAD)
MSU_BUILD_DATE=$(git show -s --format=%ci "${MSU_BUILD_HASH}")
{
  echo "MSU_BUILD_HASH='${MSU_BUILD_HASH}'"
  echo "MSU_BUILD_DATE='${MSU_BUILD_DATE}'"
} >> "${RELEASE_DIR}"/lib/metadata.sh


log "creating a tarball of the release"
tar czf "${RELEASE_TARBALL}" "${RELEASE_DIR}/"


log "creating a new github release"
hub release create -a ${RELEASE_TARBALL} ${MSU_VERSION}


success "New MSU release: v${MSU_VERSION}"
