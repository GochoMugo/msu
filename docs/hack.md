
# Hacking on `msu`

> You believe in the project, and now you want to make it better, with **code**


## dependencies:

We are using:

* [bats](https://github.com/bats-core/bats-core) - test runner
* [hub](http://hub.github.com/) - GitHub terminal client
* [pandoc](https://github.com/jgm/pandoc) - markup converter
* [shellcheck](https://github.com/koalaman/shellcheck) - static analysis

Installing the dependencies using homebrew:

```bash
$ make deps
```


## running tests:

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


## building docs:

You can build the manpages using:

```bash
$ make doc
```
