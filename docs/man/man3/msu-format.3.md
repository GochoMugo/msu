% msu-format(3)
%
% November 2025


NAME
----

msu-format - formatting symbols


SYNOPSIS
--------

Formatting symbols, quite useful when working with the 'console'
module.

    msu_require "format"


DESCRIPTION
-----------

To underline text:

    > echo -e "${txt_underline}this is underlined${txt_nounderline}"

To bolden text:

    > echo -e "${txt_bold}this is bold${txt_normal}"

To color text:

    > echo -e "${clr_blue}this is blue${clr_reset}"
    > echo -e "${clr_green}this is green${clr_reset}"
    > echo -e "${clr_red}this is red${clr_reset}"
    > echo -e "${clr_white}this is white${clr_reset}"

To add symbols:

    > echo -e "${sym_tick}"
    > echo -e "${sym_cross}"
    > echo -e "${sym_smile}"
    > echo -e "${sym_frown}"
    > echo -e "${sym_danger}"
    > echo -e "${sym_note}"
    > echo -e "${sym_peace}"
    > echo -e "${sym_arrow_right}"

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
