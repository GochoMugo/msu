#!/usr/bin/env python
# we are trying to construct a valid URL to fetch the tarball

# modules
import sys
import traceback
try:
  import requests
  import semver
except:
  # exit with status code (2) - missing dependencies
  traceback.print_exc()
  sys.exit(2)

# module variables
version = sys.argv[1] if len(sys.argv) is 2 else "0.0.0"
url = "https://api.github.com/repos/GochoMugo/msu/releases/latest"

# make the API request
try:
  r = requests.get(url)
  # ensure we made a successful request
  r.raise_for_status()
except:
  # exit with status code (3) - request error
  sys.exit(3)

# the response data
res = r.json()

# check if it is a new version
new_version = res['tag_name'].lstrip('v')
is_newer = semver.compare(version, new_version) is -1

# exit with code (1) - no newer version
if is_newer is not True:
  sys.exit(1)

# print the latest version
print new_version
