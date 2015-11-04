
# fs


```bash
msu_require "fs"
```

File-system utilities.


## append(filepath, content)

Appends `content` to the file at `filepath`. It resolves symbolic links.


## joindirs(destdir, dir1 [, dir2 [, ...]])

Joins source directories `dir1`, `dir2`, `...` into destination directory `destdir`. The result is one directory with all content from the source directories merged into the destination directory.

Alias: `fs.join`


## trash([path1 [, path2 [, ...]]])

Removes files and directories at paths `path1`, `path2`, `...`. These files are removed on system startup.

Alias: `fs.trash`


## untrash([path1 [, path2 [, ...]]])

Reverses trashing of files and directories that were originally at paths `path1`, `path2`, `...`. These files are removed on system startup.

Alias: `fs.untrash`

