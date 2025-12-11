#!/usr/bin/env bash
#
# Copyright (c) 2015 Gocho Mugo <mugo@forfuture.co.ke>
# Licensed under the MIT License

# ensure manpages were created
for md in docs/man/**/*.md
do
  manpage="dist/$(sed 's/\.md//' <<< "${md}")"
  [ -f "${manpage}" ] || {
    echo "ERROR: manpage missing: ${manpage} for ${txt}"
    exit 1
  }
  echo " ${md} -> ${manpage}"
done
