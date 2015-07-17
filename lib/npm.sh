# handling npm functions
#
# Copyright (c) 2015 GochoMugo <mugo@forfuture.co.ke>


# creates symbolic links for node_modules
# ${1} - name of the module
ln() {
  [ ${PWD} == ${HOME} ] && return
  mkdir -p node_modules
  for pkg in "$@"
  do
    rm -rf $PWD/node_modules/${pkg}
    ln -sf ~/node_modules/${pkg} $PWD/node_modules/${pkg}
  done
}


# linking an node module executable in a node_modules/ in cwd
ln_bin() {
  mkdir -p node_modules/.bin/
  for pkg in "$@"
  do
    rm -rf node_modules/.bin/$pkg
    ln -fs ~/node_modules/.bin/$pkg node_modules/.bin/$pkg
  done
}

# installing a node module in my top-most node_modules directory
g() {
  pushd ~
  for pkg in "$@"
  do
    npm install ${pkg}
  done
  npmg_track "$@"
  popd
}

# install node module globally* and link too
gln() {
  npmg "$@"
  npmln "$@"
}

# track globally installed node modules
gtrack() {
  pkgs="$@"
  [[ -z $pkgs ]] && pkgs="$(ls ~/node_modules | tr '\n' ' ')"
  touch ~/.node_modules
  for pkg in $pkgs
  do
    cat ~/.node_modules | grep -e "^$pkg$" > /dev/null
    [ $? -ne 0 ] && echo "$pkg" >> ~/.node_modules
  done
}

# restore globally installed node modules from ~/.node_modules
grestore() {
  pkgs="$(cat ~/.node_modules | tr '\n' ' ')"
  pushd ~
  for pkg in $pkgs
  do
    [ -d "~/node_modules/$pkg" ] || npm install $pkg
  done
  popd
}

# removing a globally installed node module
gremove() {
  pushd ~
  for pkg in "$@"
  do
    rm -r node_modules/$pkg
    mv -f .node_modules .node_modules_tmp # temporary file
    cat .node_modules_tmp | grep -Ev "^${pkg}$" > .node_modules
  done
  rm .node_modules_tmp
  popd
}

# updates my top-most (global) node_modules
gupdate() {
  pushd ~
  ls node_modules | xargs -I{} npm install {}
  popd
}

# check if node module is installed globally
ginstalled() {
  for pkg in "$@"
  do
    [ -d ~/node_modules/${pkg} ] && {
      echo -e "${fmt_clr_green} ${fmt_sym_tick} ${pkg} ${fmt_clr_reset}"
     } || {
      echo -e "${fmt_clr_red} ${fmt_sym_cross} ${pkg} ${fmt_clr_reset}"
     }
  done
}
