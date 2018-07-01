# Makefile for Developers and CI
#
# Copyright (c) 2015 Gocho Mugo <mugo@forfuture.co.ke>
# Licensed under the MIT License

DOCKER_IMAGE=gochomugo/msu:test

# Run tests ***
test: test.image

# Run tests in bare-metal mode
test.bare: doc test.lint test.unit test.doc clean

# Run tests in Docker container
test.image: image
	docker run --rm --tty $(DOCKER_IMAGE)

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
test.doc:
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

# Build image; usually for testing or building docs.
image:
	docker build --file ./test/Dockerfile --tag $(DOCKER_IMAGE) .

.PHONY: clean deps doc image release test test.bare test.doc test.image test.lint test.unit static-analysis unit-tests build docs
