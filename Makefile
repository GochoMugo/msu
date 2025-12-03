# Makefile for Developers and CI
#
# Copyright (c) 2015 Gocho Mugo <mugo@forfuture.co.ke>
# Licensed under the MIT License

# Show this help information.
help:
	@echo
	@echo "  clean			Clean up"
	@echo "  clean.doc		Clean up generated documentation"
	@echo "  clean.test		Clean up test outputs"
	@echo "  deps			Install dependencies using homebrew"
	@echo "  doc			Generate documentation"
	@echo "  help			Show this help information"
	@echo "  release		Draft new release"
	@echo "  test			Run all tests"
	@echo "  test.doc		Run tests on documentation"
	@echo "  test.lint		Run linting tests"
	@echo "  test.unit		Run unit tests"
	@echo

# Clean up.
clean: clean.test clean.doc

# Clean up generated documentation.
clean.doc:
	@echo "**** clean.doc"
	@rm -rf dist/docs

# Clean up test outputs.
clean.test:
	@echo "**** clean.test"
	@rm -rf lib/tmp_* _test*

# Install dependencies
deps:
	@echo "**** installing bats using brew"
	@brew install bats-core@1.11.0
	@echo "**** installing hub using brew"
	@brew install hub@2.14.2
	@echo "**** installing pandoc using brew"
	@brew install pandoc@3.5
	@echo "**** installing shellcheck using brew"
	@brew install shellcheck@0.10.0

# Generate documentation
doc: clean.doc
	@echo "**** doc"
	@echo "a2x --doctype manpage --format manpage"
	@for file in $$(ls docs/man/**/*.md) ; do \
		echo " $${file}" ; \
		mkdir -p "dist/$$(dirname $${file})" ; \
		pandoc \
			$${file} -s -t man \
			-o "dist/$$(dirname $${file})/$$(basename $${file} .md)" ; \
	done

# Draft new release.
release: test clean doc
	@./bin/msu execute release.sh

# Run all tests.
test: test.lint test.unit test.doc

# Run tests on documentation.
test.doc: doc
	@echo "**** test.doc"
	@bash test/misc/test.docs.sh

# Run linting tests.
test.lint: ./*.sh lib/*.sh
	@echo "**** test.lint"
	@shellcheck $?

# Run unit tests.
test.unit: test/test.*.sh
	@make doc
	@echo "**** test.unit"
	@bats --print-output-on-failure --timing $?

.PHONY: \
	clean clean.doc clean.test \
	deps \
	doc \
	help \
	release \
	test test.doc test.lint test.unit
