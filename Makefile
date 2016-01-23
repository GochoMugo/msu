# Makefile for Developers and CI
#
# Copyright (c) 2015 Gocho Mugo <mugo@forfuture.co.ke>
# Licensed under the MIT License

test: docs static-analysis unit-tests
	bash test/misc/*.sh
	make clean

static-analysis: ./*.sh lib/*.sh
	~/.cabal/bin/shellcheck $?

unit-tests: test/test.*.sh
	./deps/bats/bin/bats $?

deps:
	./deps/install-deps.sh
	git submodule init
	git submodule update
	make cabal shellcheck

cabal:
	cabal update --verbose=0 # ensure we do not bloat our logs

shellcheck:
	cd deps/shellcheck && cabal install --verbose=0

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

.PHONY: deps cabal shellcheck test clean docs
