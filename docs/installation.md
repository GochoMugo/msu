
# installation

## default setup:

The **default** setup installs the library at `${HOME}/lib` and the
executable at `${HOME}/bin`. The manpages are installed at
`${HOME}/share/man/`.

**benefits:**

* allows installing without requiring `sudo`

**caveats:**

* installs the `msu` for the current user only. Other users on the
  system will have to install on their own.


## custom setup:

Installation can be easily customized using environment variables.

1. Set the `${LIB}` variable to the directory to put the library in,
   e.g. `/usr/lib/`.
1. Set the `${BIN}` variable to the directory to put the executable
   in, e.g. `/usr/bin/`. 
1. Set the `${MAN}` variable to the directory to put the manpages
   in, e.g. `/usr/share/man`.
   
As an example, *(using all variables; you can use one or more variables)*

```bash
⇒ LIB=/usr/lib BIN=/usr/bin/ MAN=/usr/share/man ./install.sh
```

> Ensure you have enough **permissions** to write to the configured
> directories.
