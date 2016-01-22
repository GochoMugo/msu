#!/usr/bin/env bash
# making a new release


# modules
msu_require "console"


# module variables
DEPS="hub"
RELEASE=""


# clean up directory
make clean


# ask for new version number
MSU_VERSION=""
ask "New version number" MSU_VERSION


# mark that we are in RELEASE mode using the version number
RELEASE=${MSU_VERSION}
export RELEASE


# building any raw files
make build


# run the tests
make test


# creating a new github release
hub release create ${MSU_VERSION}


# we are done
success "New MSU release: v${MSU_VERSION}"
