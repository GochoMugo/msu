
# net

```bash
msu_require "net"
```

Networking utilities.


## `track(label, url)`

Save the download with label `label` for downloading an asset at the url `url`. This saves the information in the file `.msu.download` in the current directory.


## `check([label1 [, label2 [, ...]]])`

Checks if the downloads with labels `label1`, `label2`, `...` are tracked.


## `download(label, url)`

Downloads an asset at url `url` using the label `label` for tracking. Note that the file is **not** saved with the name `label`.
