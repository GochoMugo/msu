# Makefile for Developers and CI
#
# Copyright (c) 2015 Gocho Mugo <mugo@forfuture.co.ke>
# Licensed under the MIT License

test: docs static-analysis unit-tests
	bash test/misc/*.sh
	make clean

static-analysis: ./*.sh lib/*.sh
	@echo "executing static analysis"
	@PATH="${HOME}/.cabal/bin:${PATH}" shellcheck $?

unit-tests: test/test.*.sh
	./deps/bats/bin/bats $?

deps:
	./deps/install-deps.sh
	@echo ' >>> updating package index, using cabal'
	cabal update --verbose=0
	@echo ' >>> installing shellcheck, using cabal'
	cabal install shellcheck
	@echo ' >>> installing bats, using git submodule'
	git submodule init
	git submodule update

build: docs

docs:
	for file in $$(ls docs/man/**/*.txt) ; do \
		a2x --doctype manpage --format manpage $${file} ; \
	done

release:
	./lib/msu.sh execute release.sh

clean:
	rm -rf lib/tmp_* _test* \
		npm-debug.log \
		docs/man/**/*.1 docs/man/**/*.3 \
		docs/man/**/*.xml \
		msu-*/

.PHONY: deps test unit-tests static-analysis clean build docs release
