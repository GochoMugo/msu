#!/usr/bin/env bash
#
# Copyright (c) 2015-2016 Gocho Mugo <mugo@forfuture.co.ke>
# Licensed under the MIT License

# ensure manpages were created
txts="$(ls docs/man/**/*.txt)"
for txt in ${txts}
do
  manpage="dist/$(echo "${txt}" | sed 's/\.txt//')"
  [ -f "${manpage}" ] || {
    echo "ERROR: manpage missing: ${manpage} for ${txt}"
    exit 1
  }
done
