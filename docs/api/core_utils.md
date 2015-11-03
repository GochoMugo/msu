
# core_utils

```bash
msu_require "core_utils"
```

Utilities that are important to the core.

## upgrade()

Upgrades `msu` itself.


## install([mod [, mod [, ...]]])

Install one or more modules.


## uninstall([mod [, mod [, ...]]])

Uninstalls one or more modules.


## has_command(command)

Return `0` if `command` is available on the system. Otherwise, return non-zero status code.


## is_superuser()

Return `0` if we are running as superuser/root. Otherwise, return `1`.


## list_modules([scope])

List the installed modules. To view only internal modules, pass `scope` as `--internal` or `-i`.
To view only external modules, pass `scope` as `--external` or `-e`.

