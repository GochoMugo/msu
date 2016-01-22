#!/usr/bin/env bash
#
# Installing dependencies, such as `cabal`, on different systems


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

# informing user, when we are unaware of how to install a dependency
# ${1} - main command used to install packages in a distro
function missing_stub() {
  echo " ! Ensure you have the commands 'a2x' and 'hub' installed"
  echo " ! If it's possible to install it using \'${1}\',"
  echo " !   open up an issue, or even better, send"
  echo " !   a pull request to the repo."
}

# Debian-based distro
has "apt-get" && {
  sudo apt-get update -qq
  sudo apt-get install --no-install-recommends -qq -y cabal-install asciidoc libxml2-utils
  exit
}


# Fedora
has "yum" && {
  sudo yum update
  sudo yum install cabal-install
  missing_stub "yum"
  exit
}


# openSUSE:Tumbleweed
has "zypper" && {
  sudo zypper in cabal-install
  missing_stub "zypper"
  exit
}


# Mac OS X with homebrew
has "brew" && {
  brew install cabal-install
  missing_stub "brew"
  exit
}


# Mac OS X with MacPorts
has "port" && {
  port install hs-cabal-install
  missing_stub "port"
  exit
}

