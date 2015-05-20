# networking (without sucking)
#
# Copyright (c) 2015 GochoMugo <mugo@forfuture.co.ke>


# for large downloads
msu_download() {
  [ ${2} ] && {
    # new download
    echo wget -c ${1}=${2} >> .download
    wget ${2}
  } || {
    local data=$(cat .download)
    if [ ! ${1} ] ; then
      # download ALL
      echo ${data} | grep -Eo "=.*" | cut -b 2- | xargs wget -c
    else
      # download just the ONE
      echo ${data} | grep -E ${1} | grep -Eo "=.*" | cut -b 2- | xargs wget -c
    fi
  }
  # finished downloading (successfully)
  if [ $? ] ; then
    echo ${data} | grep -Ev ${1} > .download
  fi
}

