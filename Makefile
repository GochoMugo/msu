# Makefile for Developers and CI
# https://github.com/GochoMugo/grunt-install
#
# Copyright (c) 2015 Gocho Mugo <mugo@forfuture.co.ke>
# Licensed under the MIT License

test:
	~/.cabal/bin/shellcheck ./*.sh lib/*.sh
	./bats/bin/bats test/test.*.sh
	make clean

deps: bats cabal shellcheck

bats:
	rm -rf bats/
	git clone --depth=1 https://github.com/sstephenson/bats.git bats

cabal:
	sudo apt-get update -qq
	sudo apt-get install -y -qq cabal-install
	cabal update --verbose=0 # ensure we do not bloat our logs

shellcheck:
	rm -rf shellcheck/
	git clone --depth=1 https://github.com/koalaman/shellcheck shellcheck
	cd shellcheck && cabal install --verbose=0

clean:
	rm -rf lib/tmp_* npm-debug.log

.PHONY: deps bats cabal shellcheck test clean
