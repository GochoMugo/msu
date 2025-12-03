
# msu

> A minimal Shell framework and CLI tool that makes writing, sharing
> and using bash scripts easy

[![Tests](https://github.com/GochoMugo/msu/workflows/Tests/badge.svg)](https://github.com/GochoMugo/msu/actions/workflows/test.yml)

* Introductory blog posts: [hack with msu](https://mugo.gocho.live/posts/hack-with-msu/), [very first post](https://mugo.gocho.live/posts/msu-introduction/)
* [Project Principles](#principles)
* [Showcase of modules using `msu`][showcase]
* [Documentation](#documentation)


## features:

> **`msu` wishlist**

* [x] [easy installation][installation]
* [x] small but comprehensive internal library
* [x] support external modules
* [x] auto-loading aliases from modules
* [x] install external modules from git repos
* [x] highly tested
* [x] self upgrade
* [x] manpages
* [ ] load/unload aliases
* [ ] error catching/handling
* [ ] bash completion
* [ ] compatibility for other shell types e.g. zsh


## installation:

See the [installation instructions][installation].


## documentation:

You can always browse msu documentation using `man`:

```bash
$ man 1 msu       # command
$ man 3 msu       # library
```

More documentation is placed in the
[`docs/`](https://github.com/GochoMugo/msu/tree/master/docs/) directory:

* [installation][installation]
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
[showcase]:https://github.com/GochoMugo/msu/wiki/Showcase "showcase of modules using msu"
[hacking]:https://github.com/GochoMugo/msu/blob/master/docs/hack.md "Hacking on msu"
