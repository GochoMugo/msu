% msu-core_utils(3)
%
% November 2025


NAME
----
msu-core_utils - utilities for use with msu core.


SYNOPSIS
--------
These utilities help build up the msu ecosystem by offering functions
very common in working with msu.

    msu_require "core_utils"


DESCRIPTION
-----------
*upgrade(['VERSION'])*

   > Upgrades msu to version 'VERSION', if it is passed. Otherwise, the
   function defaults to upgrading to the latest version. If 'VERSION'
   equals 'HEAD' (case-insensitive), the master branch of the source
   code repo is used instead.'HEAD' is useful in obtaining changes
   before new releases are made. This hits the network to check for
   new releases and download tarballs.

*install(['MODULE']...)*

   > Installs the modules 'MODULE'... into the directory pointed to by
   `${MSU_EXTERNAL_LIB}`. To install remote modules, we require
   prefix shorthands:

   > * gh:  - for public Github repos
   * ghs: - for private GitHub repos
   * bt:  - for public Bitbucket repos
   * bts: - for private Bitbucket repos
   * gl:  - for public GitLab repos
   * gls: - for private GitLab repos

*install-many('PATH')*

   > Using a file at path 'PATH' containing a '\n'-delimited list of modules,
   installs the listed modules. Shorthands can be used in this list. This
   is useful in bootstrapping new machines.

*uninstall(['MODULE']...)*

   > Uninstalls the modules 'MODULE'... from the directory pointed to by
   `${MSU_EXTERNAL_LIB}`. This is almost synonymous to `rm -rf 'MODULE'`.

*uninstall-many('PATH')*

   > Using a file at path 'PATH' containing a '\n'-delimited list of modules,
   uninstall the listed modules. As expected, shorthands can not be used
   here.

*has_command('COMMAND')*

   > Return 0 if 'COMMAND' is available on the system. Otherwise, return a
   non-zero return code.

*is_superuser()*

   > Return 0 if we are running as super-user (root). Otherwise, return 1.

*list_modules(['SCOPE'])*

   > List installed modules, both internal and external modules. Using 'SCOPE',
   we can limit the listed modules. If 'SCOPE' equals '-i'/'--internal',
   only internal modules are listed. If 'SCOPE' equals '-e'/'--external',
   only external modules are listed.


RESOURCES
---------
Source code: https://github.com/GochoMugo/msu

Issue tracker: https://github.com/GochoMugo/msu/issues


AUTHOR
------
*msu* is developed and maintained by Gocho Mugo.


COPYING
-------
THE MIT LICENSE (MIT)

Copyright \(C) 2015 Gocho Mugo \<mugo@forfuture.co.ke>
