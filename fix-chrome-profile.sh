#!/bin/sh
#
# Distributed under the terms of the GNU General Public License v3
#
# Filip Oscadal <filip@mxd.cz> http://mxd.cz No Rights Reserved 2010.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY. YOU USE AT YOUR OWN RISK. THE AUTHOR
# WILL NOT BE LIABLE FOR DATA LOSS, DAMAGES, LOSS OF PROFITS OR ANY
# OTHER  KIND OF LOSS WHILE USING OR MISUSING THIS SOFTWARE.
# See the GNU General Public License for more details.

killall chrome
file ~/.config/google-chrome/Default/* | grep SQLite | cut -d: -f1 |xargs -n1 -d '\n' sh -c 'sqlite3 "$0" .schema 2>&1 >/dev/null | grep -q "is locked" && {echo "fixing $0";mv "$0" tmp.$$;cp tmp.$$ "$0";rm tmp.$$;}'
