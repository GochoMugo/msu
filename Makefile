# Makefile for Developers and CI
#
# Copyright (c) 2015 Gocho Mugo <mugo@forfuture.co.ke>
# Licensed under the MIT License

test:
	~/.cabal/bin/shellcheck ./*.sh lib/*.sh
	./deps/bats/bin/bats test/test.*.sh
	[ "$${RELEASE}" ] && bash test/misc/*.sh
	make clean

deps:
	git submodule init
	git submodule update
	make cabal shellcheck

cabal:
	./deps/install-cabal.sh
	cabal update --verbose=0 # ensure we do not bloat our logs

shellcheck:
	cd deps/shellcheck && cabal install --verbose=0

build: docs

docs:
	a2x --doctype manpage --format docs/man/man1/msu.1.txt

release:
	./lib/msu.sh execute release.sh

clean:
	rm -rf lib/tmp_* _test* npm-debug.log docs/man/**/*.1

.PHONY: deps cabal shellcheck test clean docs
