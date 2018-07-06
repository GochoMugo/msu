# Makefile for Developers and CI
#
# Copyright (c) 2015 Gocho Mugo <mugo@forfuture.co.ke>
# Licensed under the MIT License

# Image tag
DOCKER_IMAGE=gochomugo/msu:dev


### test

# Run tests (DEFAULT, alias: test.image)
test: image test.image

# Run linting tests (alias: test.image.lint)
test.lint: image test.image.lint

# Run unit tests (alias: test.image.unit)
test.unit: image test.image.unit

# Run tests on documentation (alias: test.image.doc)
test.doc: image test.image.doc


### test.image

# Run tests in container
test.image: test.image.lint test.image.unit test.image.doc

# Run linting tests in container
test.image.lint:
	@echo "**** test.image.lint"
	@docker run --rm --tty $(DOCKER_IMAGE) make test.bare.lint

# Run unit tests in container
test.image.unit:
	@echo "**** test.image.unit"
	@docker run --rm --tty $(DOCKER_IMAGE) make test.bare.unit

# Run tests on documentation in bare-metal mode
test.image.doc:
	@echo "**** test.image.doc"
	@docker run --rm --tty $(DOCKER_IMAGE) make test.bare.doc


### test.bare

# Run tests in bare-metal mode
test.bare: test.bare.lint test.bare.unit test.bare.doc

# Run linting tests in bare-metal mode
test.bare.lint: ./*.sh lib/*.sh
	@echo "**** test.bare.lint"
	@PATH="${HOME}/.cabal/bin:${PATH}" shellcheck $?

# Run unit tests in bare-metal mode
test.bare.unit: test/test.*.sh
	@make doc.bare
	@echo "**** test.bare.unit"
	@./deps/bats/bin/bats $?

# Run tests on documentation in bare-metal mode
test.bare.doc: doc.bare
	@echo "**** test.bare.doc"
	@bash test/misc/test.docs.sh


### deps

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


### doc

# Generate documentation (alias: doc.image)
doc: doc.image

# Generate documentation in container
doc.image:
	@echo "**** doc.image"
	@mkdir -p dist/
	@docker run \
		--env CHOWN_UID=$$(id --user) \
		--env CHOWN_GID=$$(id --group) \
		--rm \
		--tty \
		--volume $$(pwd)/dist:/opt/gochomugo/msu/dist \
		$(DOCKER_IMAGE) \
		make doc.image_
doc.image_: doc.bare
	@chown -R ${CHOWN_UID}:${CHOWN_GID} dist/

# Generate documentation in bare-metal mode
doc.bare: clean.doc
	@echo "**** doc.bare"
	@echo "a2x --doctype manpage --format manpage"
	@for file in $$(ls docs/man/**/*.txt) ; do \
		echo " $${file}" ; \
		mkdir -p "dist/$$(dirname $${file})" ; \
		a2x \
			--destination-dir "dist/$$(dirname $${file})" \
		  --doctype manpage \
			--format manpage \
			$${file} ; \
	done


### release

# Draft release
release: test clean doc
	@./bin/msu execute release.sh


### clean

# Clean up working directory
clean: clean.doc
	@echo "**** clean"
	@rm -rf lib/tmp_* _test*

# Clean up generated docs
clean.doc:
	@echo "**** clean.doc"
	@rm -rf dist/docs


### image

# Build image; usually for testing or building docs.
image:
	@echo "**** image"
	@docker build --tag $(DOCKER_IMAGE) .


.PHONY: \
	clean clean.doc \
	deps \
	doc doc.bare doc.image \
	image \
	release \
	test test.lint test.unit \
	test.bare test.bare.lint test.bare.unit \
	test.image test.image.lint test.image.unit
