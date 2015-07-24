
# aliases

`msu` has aliases that can be loaded into your shell. If installed to load aliases, the available aliases are added.

External modules can also add aliases by having an `aliases.sh` file in the root of the directory. `msu` will automatically load the aliases.

A top-most aliases file at `${MSU_EXTERNAL_LIB}/aliases.sh` can be used to override any other aliases, including the internal ones.

Sample aliases file:

```bash
alias my-alias='msu run my-module.func'
alias another-alias='msu run my-module.another_func'
```
