#
# tests against lib/aliases.sh
#


function teardown() {
  unalias fs.join
  unalias net.dl
  unalias npm.g
}


@test "\`msu aliases' loads aliases into the current environment" {
  . lib/msu.sh aliases
  alias fs.join
  alias net.dl
  alias npm.g
}
