
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

As an example,

```bash
⇒ wget -qO- http://git.io/vTE0s | LIB=/usr/lib BIN=/usr/bin/ bash
```
