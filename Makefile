# Makefile for Developers and CI
# https://github.com/GochoMugo/grunt-install
#
# Copyright (c) 2015 Gocho Mugo <mugo@forfuture.co.ke>
# Licensed under the MIT License

test:
	./bats/bin/bats test/test.*.sh
	make clean

deps:
	git clone --depth=1 https://github.com/sstephenson/bats.git bats

clean:
	rm -rf lib/tmp_* npm-debug.log

.PHONY: deps test clean
