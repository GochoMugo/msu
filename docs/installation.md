
# installation

There are different ways of installing `msu`.

1. The preferred way is to use the **OFFICIAL RELEASE**. Download
   the latest tarball at https://github.com/GochoMugo/msu/releases/latest:

  ```bash
  ⇒ tar xvf msu-x.x.x.tar.gz
  ⇒ cd msu-x.x.x/
  ⇒ ./install.sh
  ```

The following methods use the master branch instead of official releases. Also,
the manpages are **not** installed in these cases. They include:

1. **manual install**

  ```bash
  ⇒ git clone https://github.com/GochoMugo/msu.git
  ⇒ cd msu/
  ⇒ ./install.sh
  ```

  You clone this repo and run the `install.sh` script. This method is
  preferable if you will be hacking on the project.


## default setup:

The **default** setup installs the library at `${HOME}/lib` and the executable
at `${HOME}/bin`. The manpages are installed at `${HOME}/share/man/`.

**benefits:**

* allows installing without requiring `sudo`


**caveats:**

* installs the `msu` for the current user only. Other users on the system will have to install on their own.


## custom setup:

Installation has been made simple by using environment variables. To change
the directory to put the library in, say `/usr/lib/`, you use the `${LIB}`
variable.

To change the directory to put the executable in, say `/usr/bin/`, you use
the `${BIN}` variable.

To change the directory to put the manpages in, say `/usr/share/man`, you
use the `${MAN}` variable.

As an example, *(using all variables. you can use one or more variables)*

```bash
⇒ LIB=/usr/lib BIN=/usr/bin/ MAN=/usr/share/man ./install.sh
```

> Ensure you have enough **permissions** to write to the `${LIB}`, `${BIN}`
> and `${MAN}` directories.
