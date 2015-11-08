#!/usr/bin/env bash
#
# Installing `cabal` on different systems


echo
echo "  we are now installing \`cabal'"
echo "  using \`sudo' where seems necessary"
echo "  therefore, you might be prompted for your password"
echo "  for root privileges to be effected."
echo


# check if command is available
function has() {
  command "${1}" > /dev/null 2>&1
}


# Debian-based distro
has "apt-get" && {
  sudo apt-get update -qq
  sudo apt-get install -qq -y cabal-install
  exit
}


# Fedora
has "yum" && {
  sudo yum update
  sudo yum install cabal-install
  exit
}


# openSUSE:Tumbleweed
has "zypper" && {
  zypper in cabal-install
  exit
}


# Mac OS X with homebrew
has "brew" && {
  brew install cabal-install
  exit
}


# Mac OS X with MacPorts
has "port" && {
  port install hs-cabal-install
  exit
}

