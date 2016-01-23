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
	cabal update --verbose=0
	cabal install shellcheck

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

.PHONY: deps test clean docs
