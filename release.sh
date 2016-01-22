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


log "building any raw files"
make build


log "run the tests"
make test


log "creating directory for releases"
RELEASE_DIR="msu-${MSU_VERSION}"
RELEASE_TARBALL="msu-${MSU_VERSION}.tar.gz"
mkdir "${RELEASE_DIR}"


log "copying the contents of the working directory"
# shellcheck disable=SC2010
ls \
  | grep -Ev "deps|get.sh|install.sh|Makefile|package.json|msu\-|release.sh|test" \
  | xargs -I{} cp -rf {} "${RELEASE_DIR}/"


log "creating a tarball of the release"
tar czf "${RELEASE_TARBALL}" "${RELEASE_DIR}/"


log "creating a new github release"
hub release create -a ${RELEASE_TARBALL} ${MSU_VERSION}


success "New MSU release: v${MSU_VERSION}"
