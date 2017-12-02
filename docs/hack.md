
# Hacking on `msu`

> You believe in the project, and now you want to make it better, with **code**


## dependencies:

We are using:

* [shellcheck](https://github.com/koalaman/shellcheck) - static analysis
* [bats](https://github.com/sstephenson/bats) - test runner
* [a2x](http://linux.die.net/man/1/a2x) - asciidoc converter
* [hub](http://hub.github.com/) - Github terminal client

To ensure reproducibility, we are using git submodules.


## prepare environment:

Installing (some of) the dependencies:

```bash
$ make deps
```


## running tests:

Running tests fully:

```bash
$ make test
```

Some of the different types of tests can be invoked separately.

```bash
$ make test.lint          # run static analysis
$ make test.unit          # run unit tests
$ make test.doc           # run tests on documentation
```


## building docs:

You can build the manpages using:

```bash
$ make doc
```
