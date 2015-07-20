# Makefile for Developers and CI
# https://github.com/GochoMugo/grunt-install
#
# Copyright (c) 2015 Gocho Mugo <mugo@forfuture.co.ke>
# Licensed under the MIT License

test:
	./bats/bin/bats test/test.*.sh
	make clean

deps:
	git clone https://github.com/sstephenson/bats.git bats

clean:
	rm -rf _TEST_* npm-debug.log

.PHONY: deps test clean
