
# installation

## default

The **default** setup installs the library and executable at `${HOME}/bin`.

**benefits:**

* allows installing without requiring `sudo`


**caveats:**

* installs the utils only for the current user. Other users will have to install on their own


## custom

Installation has been made simple by using environment variables. To change the directory to put the library in, say `/usr/lib/`, you use the `LIB` variable.

To change the directory to put the executable in, say `/usr/bin/`, you use the `BIN` variable.

By default, the latest build of `msu` is downloaded and installed. To install a specific build version, use the `${BUILD}` variable, say `9482e161c974bc0cebf823fc0fe8a3caed14a8a0`. This is useful for debugging purposes and rollbacks.

As an example, *(using all variables. you can use one or more)*

```bash
⇒ wget -qO- http://git.io/vTE0s | LIB=/usr/lib BIN=/usr/bin/ BUILD=9482e161c974bc0cebf823fc0fe8a3caed14a8a0 bash
```

> Ensure you have enough **permissions** to write to the `${LIB}` and `${BIN}` directories.
