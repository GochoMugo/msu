
# core

This module is **automatically** loaded into the module. It is readily available for use by modules.


## `${MSU_LIB}`

An absolute path to the directory holding the `msu` library. It is mostly useful for internal modules.


## `${MSU_EXTERNAL_LIB}`

An absolute path to the directory holding the `msu` external modules. Again, it is mostly useful for internal modules.


## `msu_require()`

Load a module.

Example:

```bash
msu_require "console"
```

## `msu_run()`

Run a function in a module.

Example:

```bash
msu_run console.log "logged to console!!!"
```
