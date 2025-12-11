
# Contributing to `msu`

## dependencies

We are using:

* [bats](https://github.com/bats-core/bats-core) - test runner
* [hub](http://hub.github.com/) - GitHub terminal client
* [pandoc](https://github.com/jgm/pandoc) - markup converter
* [shellcheck](https://github.com/koalaman/shellcheck) - static analysis

Installing the dependencies using homebrew:

```bash
$ make deps
```


## tests

Running all tests:

```bash
$ make test
```

Running subset of tests:

```bash
$ make test.doc           # run tests on documentation
$ make test.lint          # run linting tests
$ make test.unit          # run unit tests
```


## docs

Building the manpages:

```bash
$ make doc
```
