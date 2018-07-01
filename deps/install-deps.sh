#!/usr/bin/env bash
#
# Installing dependencies on different systems


echo
echo "  we are now installing dependencies"
echo "  using \`sudo' where seems necessary"
echo "  therefore, you might be prompted for your password"
echo "  for root privileges to be effected."
echo


# check if command is available
function has() {
  command -v "${1}" > /dev/null 2>&1
}

# informing user, when we are unaware of how to install a dependency
# ${1} - main command used to install packages in a distro
# ${@:2} - commands that are required
function missing_stub() {
  echo
  echo " ! Ensure you have the following installed: ${@:2}"
  echo " ! If it's possible to install it using \'${1}\',"
  echo " !   open up an issue, or even better, send"
  echo " !   a pull request to the repo."
  echo
}

# Debian-based distro
has "apt-get" && {
  # we are running our tests on a ubuntu machine
  # we need to ensure our tests does not hang waiting for user input
  APT_FLAGS=
  if [[ -n "${CI}" ]] ; then APT_FLAGS="-y -qq" ; fi
  echo " >>> updating package index, using apt-get"
  # shellcheck disable=SC2086
  sudo apt-get ${APT_FLAGS} update
  echo " >>> installing asciidoc, cabal-install, using apt-get"
  # shellcheck disable=SC2086
  sudo apt-get install ${APT_FLAGS} asciidoc cabal-install
  missing_stub "apt-get" "hub"
  exit
}


# Fedora
has "yum" && {
  echo " >>> updating package index, using yum"
  sudo yum update
  echo " >>> installing cabal-install, using yum"
  sudo yum install cabal-install
  missing_stub "yum" "a2x" "hub"
  exit
}


# openSUSE:Tumbleweed
has "zypper" && {
  echo " >>> installing cabal-install, using zypper"
  sudo zypper in cabal-install
  missing_stub "zypper" "a2x" "hub"
  exit
}


# Mac OS X with homebrew
has "brew" && {
  echo " >>> installing cabal-install, using zypper"
  brew install cabal-install
  missing_stub "brew" "a2x" "hub"
  exit
}


# Mac OS X with MacPorts
has "port" && {
  echo " >>> installing hs-cabal-install, using port"
  port install hs-cabal-install
  missing_stub "port" "a2x" "hub"
  exit
}
