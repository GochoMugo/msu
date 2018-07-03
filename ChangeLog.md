
# Change Log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).


## Unreleased

Added:

* Support installing modules from GitLab using shorthand

Fixed:

* Reduce noise during installation


## [0.3.0][0.3.0] - 19/03/2016

Added:

* check dependencies aggressively, on installation

Removed:

* the `fs` and `net` modules are removed, to keep `msu` minimal


## [0.2.0][0.2.0] - 26/02/2016

Added:

* add command, `nuke`, for nuking `msu` (issue #19)
* add support for SSH in installing modules from private, remote repos (issue #18)
* allow assuming "yes" in a `yes_no` question, using `${MSU_ASSUME_YES}`

Fixed:

* fix using backspace as first key-press in password prompt
* fix unnecessary logging to a file named `log` when using `msu` in a shebang
* fix listing external modules, when directory at `${MSU_EXTERNAL_LIB}` does **not** exist
* fix listing internal modules i.e. only list the `*.sh` files


## [0.1.0][0.1.0] - 13/02/2016

Added:

* add the alias `msu.reload` for reloading aliases
* add support for use in shebang e.g `#!/usr/bin/env msu`

Changed:

* prefix all aliases added by msu library with `msu`

Fixed:

* Fix path to executable, if executed directly (not through symlink)


## [0.0.0][0.0.0] - 24/01/2016

This is the very first version of `msu`.


<!-- Release links are placed here for easier updating -->
[0.0.0]:https://github.com/GochoMugo/msu/releases/tag/0.0.0
[0.1.0]:https://github.com/GochoMugo/msu/releases/tag/0.1.0
[0.2.0]:https://github.com/GochoMugo/msu/releases/tag/0.2.0
[0.3.0]:https://github.com/GochoMugo/msu/releases/tag/0.3.0
