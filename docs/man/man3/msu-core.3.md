% msu-core(3)
%
% November 2025


NAME
----

msu-core - this is the core library for msu.


SYNOPSIS
--------

This module is automatically loaded into each module, internal or
external. It is readily available for use by module code without
need to 'msu_require' it.


DESCRIPTION
-----------

*msu_require(MODULE)*

   > Loads the module 'MODULE' into environment.

   > For example,

      msu_require "console"

*msu_run(MODULE.FUNC, [PARAMS]...)*

   > Run the function with name 'FUNC' in module 'MODULE'.
   > Parameters 'PARAMS' are passed to the function.

   > For example,

      msu_run console.log "log to console"

*`${MSU_LIB}`*

   > Absolute path to the directory holding the internal library.
   > It is mostly useful for internal modules.

*`${MSU_EXTERNAL_LIB}`*

   > Absolute path to the directory holding the external modules.
   > Again, it is mostly useful for internal modules.


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
