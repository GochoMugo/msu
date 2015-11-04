
# modules

There are **internal** and **external** modules. Internal modules are shipped with `msu`. External modules are those you install on your own.


## internal modules:

All internal modules can be found in the `lib` directory in this repo. These modules offer the `msu` backbone and useful utilities.


## external modules:

Anybody can install their own modules.

> Internal modules **always** take precedence over external modules

On installation, these modules are placed at `${MSU_EXTERNAL_LIB}`, which by default is `${HOME}/.msu`.


### structure

A valid module can be:
  * a single script, say `sample.sh`
  * a directory with many scripts, say
```
my-module/
|-- aliases.sh  # place your aliases here
|-- script.sh
`-- inner-dir
    |-- script.sh
    `-- another-script.sh
```

> Nested directories are allowed.


### dependencies checking

If a module defines the `${DEPS}` variable, `msu` will check if the dependencies are installed. Note that `msu` will **not error** if one or more of the dependencies are missing, it will just give a **warning** to the user. This is by design! ([more discussion on this is required](https://github.com/GochoMugo/msu/issues/2))

Example:

```bash
DEPS="git node npm"
```


### installing

You can install external modules, by simple copying the module contents to the external library directory (`${MSU_EXTERNAL_LIB}`). Also, `msu install` can help.

```bash
⇒ msu install my-module
```

You can also install remote modules from github, using shorthands. For example if https://github.com/GochoMugo/submarine is a module you want to install:

```bash
⇒ msu install gh:GochoMugo/submarine
```

> Note the `gh:` part! It is **case-insensitive**!


### aliases auto-loading

If a module has an `aliases.sh` file in its root, it will get auto-loaded into the shell. `msu` has its own aliases that it adds **but** they can be overridden by modules as desired.

**Conflicts** can happen when, say two modules both try to create an alias with the same name. `msu` has no way to detect this. The best way to avoid this is to use a short prefix in front of your aliases.

Example:

```sh
alias pr.dance='msu run my-module.dance'
```


## module name:

A valid module filename:
  * has the extension `.sh`
  * has no `.` (dot) except that preceding the extension

Examples:
  * `foobar.sh` - valid
  * `foo-bar.sh` - valid
  * `foo_bar.sh` - valid
  * `foo.bar.sh` - **invalid**

