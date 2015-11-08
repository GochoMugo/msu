
# Hacking on `msu`

> You believe in the project, and now you want to make it better, with **code**


## dependencies:

We are using [shellcheck](https://github.com/koalaman/shellcheck) and
[bats](https://github.com/sstephenson/bats) to run our tests. To ensure
reproducibility, we are using git submodules.


## prepare environment:

Installing the dependencies:

```bash
$ make deps
```


## running tests:

Running static analysis and bash tests:

```bash
$ make test
```

