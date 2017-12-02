# Makefile for Developers and CI
#
# Copyright (c) 2015 Gocho Mugo <mugo@forfuture.co.ke>
# Licensed under the MIT License

# Run tests ***
test: test.lint test.unit test.doc clean

# Run linting (static-analysis) tests
test.lint: ./*.sh lib/*.sh
	@PATH="${HOME}/.cabal/bin:${PATH}" shellcheck $?
static-analysis: test.lint # DEPRECATED

# Run unit tests
test.unit: test/test.*.sh
	./deps/bats/bin/bats $?
unit-tests: # DEPRECATED
	@echo " !!! 'make unit-tests' is deprecated. Use 'make test.unit' instead."
	make test.unit

# Run tests on documentation
test.doc: doc
	bash test/misc/docs.sh

# Install dependencies
deps:
	./deps/install-deps.sh
	@echo ' >>> updating package index, using cabal'
	cabal update --verbose=0
	@echo ' >>> installing shellcheck, using cabal'
	cabal install shellcheck
	@echo ' >>> installing bats, using git submodule'
	git submodule init
	git submodule update

# Generate documentation
doc:
	@echo "a2x --doctype manpage --format manpage"
	@for file in $$(ls docs/man/**/*.txt) ; do \
		echo " $${file}" ; \
		a2x --doctype manpage --format manpage $${file} ; \
	done
docs: # DEPRECATED
	@echo " !!! 'make docs' is deprecated. Use 'make doc' instead."
	make doc

# Draft release
release:
	./lib/msu.sh execute release.sh

# Clean up working directory
clean:
	rm -rf lib/tmp_* _test* \
		npm-debug.log \
		docs/man/**/*.1 docs/man/**/*.3 \
		docs/man/**/*.xml \
		msu-*/

build: # DEPRECATED
	@echo " !!! 'make build' is deprecated. It is no longer of use."
	make doc

.PHONY: clean deps doc release test test.doc test.lint test.unit static-analysis unit-tests build docs
