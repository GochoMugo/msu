# handling npm functions
#
# Copyright (c) 2015 GochoMugo <mugo@forfuture.co.ke>


# modules
msu_require console
msu_require fs


# mod vars
DEPS="npm"
NODE_HOME=~/node_modules
NODE_BIN=${NODE_HOME}/.bin
NODE_TRACK=~/.node_modules


# creates symbolic links for node_modules
# ${1} - name of the module
function ln_mod() {
  [ ${PWD} == ${HOME} ] && return # dont link if in $HOME
  mkdir -p node_modules # ensure node_modules/ exists
  for pkg in "$@"
  do
    [ -d ${NODE_HOME}/${pkg} ] && {
      rm -rf $PWD/node_modules/${pkg}
      ln -sf ${NODE_HOME}/${pkg} $PWD/node_modules/${pkg}
      tick "${pkg}: linked"
    } || {
      cross "${pkg}: missing"
    }
  done
}


# linking an node module executable in a node_modules/ in cwd
function ln_bin() {
  mkdir -p node_modules/.bin/
  for pkg in "$@"
  do
    [ -x ${NODE_BIN}/${pkg} ] && {
      rm -rf node_modules/.bin/$pkg
      ln -fs ${NODE_BIN}/$pkg node_modules/.bin/$pkg
      tick "${pkg}: linked"
    } || {
      cross "${pkg}: missing"
    }
  done
}


# installing a node module in my top-most node_modules directory
function g() {
  pushd ~
  for pkg in "$@"
  do
    npm install ${pkg}
  done
  for pkg in "$@"
  do
    [ -d ${NODE_HOME}/${pkg} ] && {
      tick "${pkg}: installed"
      gtrack ${pkg}
    } || {
      cross "${pkg}: could not be installed"
    }
  done
  popd
}


# install node module globally* and link too
function gln() {
  g "$@"
  ln "$@"
}


# track globally installed node modules
function gtrack() {
  pkgs="$@"
  [[ -z ${pkgs} ]] && pkgs="$(ls ${NODE_HOME} | tr '\n' ' ')"
  touch ${NODE_TRACK}
  for pkg in ${pkgs}
  do
    cat ${NODE_TRACK} | grep -e "^$pkg$" > /dev/null
    [ $? -ne 0 ] && {
      append ${NODE_TRACK} "${pkg}"
      tick "${pkg}: tracked"
    } || {
      tick "${pkg} (already tracked)"
    }
  done
}


# restore globally installed node modules from ~/.node_modules
function grestore() {
  pkgs="$(cat ~/.node_modules | tr '\n' ' ')"
  pushd ~
  for pkg in ${pkgs}
  do
    [ -d "${NODE_HOME}/${pkg}" ] || npm install ${pkg}
  done
  popd
  success "restored successfully"
}


# removing a globally installed node module
function gremove() {
  pushd ~
  for pkg in "$@"
  do
    rm -r node_modules/${pkg}
    mv -f .node_modules .node_modules_tmp # temporary file
    cat .node_modules_tmp | grep -Ev "^${pkg}$" > .node_modules
    tick "removed ${pkg}"
  done
  rm .node_modules_tmp
  popd
}


# updates my top-most (global) node_modules
function gupdate() {
  pushd ~
  ls node_modules | xargs -I{} npm install {}
  popd
}


# check if node module is installed globally
function ginstalled() {
  for pkg in "$@"
  do
    [ -d ${NODE_HOME}/${pkg} ] && {
      tick ${pkg}
     } || {
      cross ${pkg}
     }
  done
}
