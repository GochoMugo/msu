
# msu

> A small Shell framework that makes writing bash scripts less sucky

[![Terminal Lover](https://img.shields.io/badge/terminal-lover-blue.svg?style=flat-square)](https://github.com/GochoMugo) [![Travis](https://img.shields.io/travis/GochoMugo/msu.svg?style=flat-square)](https://travis-ci.org/GochoMugo/msu)

* [An Introductory Post on `msu`](https://gochomugo.github.io/musings/msu-introduction/)!
* [Project Principles](#principles)
* [Showcase of modules using `msu`][showcase]
* [Documentation](#documentation)


## features:

> **`msu` wishlist**

* [x] [automated/manual installation][installation]
* [x] [small but comprehensive internal library](https://github.com/GochoMugo/msu/blob/master/docs/api.md)
* [x] support external modules
* [x] auto-loading aliases modules
* [x] install module from github/bitbucket
* [x] [highly tested](https://travis-ci.org/GochoMugo/msu)
* [x] self upgrade
* [ ] load/unload aliases
* [ ] error catching/handling
* [ ] bash completion
* [ ] compatibility for other shell types e.g. zsh


## installation:

See the [installation instructions][installation].


## documentation:

Documentation is placed in the [`docs/`](https://github.com/GochoMugo/msu/tree/master/docs/) directory:

* [installation][installation]
* [API][api]
* [showcase][showcase]
* [hacking on msu][hacking]


<a name="principles"></a>
## principles:

1. **Little added complexity.** `msu` should **not** warrant the user to learn scripting all over again. An existing script should be converted into a module with less effort.
1. **Minimal**. `msu` core should be as little as possible. How? Use common algorithms and data structures. Avoid doing something too fancy.
1. **Highly configurable**. Using environment variables and command-line switches, `msu` should be configurable in all its operations, including installation.


## license:

__The MIT License (MIT)__

Copyright &copy; 2015-2016 GochoMugo <mugo@forfuture.co.ke>


[installation]:https://github.com/GochoMugo/msu/tree/master/docs/installation.md "msu installation"
[api]:https://github.com/GochoMugo/msu/tree/master/docs/api.md "msu API"
[showcase]:https://github.com/GochoMugo/msu/blob/master/docs/showcase.md "showcase of modules using msu"
[hacking]:https://github.com/GochoMugo/msu/blob/master/docs/hack.md "Hacking on msu"

