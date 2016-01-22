#!/usr/bin/bash
#
# Copyright (c) 2015-2016 Gocho Mugo <mugo@forfuture.co.ke>
# Licensed under the MIT License

# ensure manpages were created
for txt in "$(ls docs/man/**/*.txt)"
do
  manpage=$(echo "${txt}" | sed 's/\.txt//')
  [ -f "${manpage}" ] || {
    echo "ERROR: manpage missing: ${manpage} for ${txt}"
    exit 1
  }
done
