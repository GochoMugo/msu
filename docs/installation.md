
# installation

## methods:

There are different ways of installing `msu`.

1. **automated install**

  ```bash
  ⇒ wget -qO- https://git.io/vTE0s | bash
  ```

  This downloads the `get.sh` script in the repo and runs it using **bash**. It's easier and faster.

1. **manual install**

  ```bash
  ⇒ git clone https://github.com/GochoMugo/msu.git
  ⇒ cd msu/
  ⇒ ./install.sh
  ```

  You clone this repo and run the `install.sh` script. This method is preferable if you will be hacking on the project.

1. **zip download install (using unzip)**

  ```bash
  ⇒ wget "https://github.com/GochoMugo/msu/archive/master.zip"
  ⇒ unzip msu-master.zip -d msu
  ⇒ cd msu
  ⇒ ./install.sh
  ```

1. **zip download install (using 7-zip)**

  ```bash
  ⇒ wget "https://github.com/GochoMugo/msu/archive/master.zip"
  ⇒ sudo apt-get install p7zip-full    # installs 7zip
  ⇒ 7z l msu-master.zip
  ⇒ 7z x msu-master.zip
  ⇒ ./install.sh
  ```

  7zip is preferred here due to its high compression ratio capabilities you can use any other software you prefer.


## default setup:

The **default** setup installs the library at `${HOME}/lib` and the executable at `${HOME}/bin`.
The manpages are installed at `${HOME}/share/man/`.

**benefits:**

* allows installing without requiring `sudo`


**caveats:**

* installs the `msu` for the current user only. Other users on the system will have to install on their own.


## custom setup:

Installation has been made simple by using environment variables. To change the directory to put the library in, say `/usr/lib/`, you use the `${LIB}` variable.

To change the directory to put the executable in, say `/usr/bin/`, you use the `${BIN}` variable.

To change the directory to put the manpages in, say `/usr/share/man`, you use the `${MAN}` variable.

By default, the latest build of `msu` is downloaded and installed. To install a specific build version, use the `${BUILD}` variable, say `9482e161c974bc0cebf823fc0fe8a3caed14a8a0`. This is useful for debugging purposes and rollbacks.

> Use of `${BUILD}` is **not** applicable to manual installs.

As an example, *(using all variables. you can use one or more variables)*

```bash
⇒ wget -qO- https://git.io/vTE0s | LIB=/usr/lib BIN=/usr/bin/ BUILD=9482e161c974bc0cebf823fc0fe8a3caed14a8a0 bash # automated install
⇒ LIB=/usr/lib BIN=/usr/bin/ MAN=/usr/share/man ./install.sh # manual install
```

> Ensure you have enough **permissions** to write to the `${LIB}`, `${BIN}` and `${MAN}` directories.
