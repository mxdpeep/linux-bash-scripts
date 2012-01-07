#!/bin/bash
#
# License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
#
# Filip Oscadal <filip@mxd.cz> http://mxd.cz/
# No Rights Reserved 2012, feel free to modify, use and distribute.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY. YOU USE AT YOUR OWN RISK. THE AUTHOR
# WILL NOT BE LIABLE FOR DATA LOSS, DAMAGES, LOSS OF PROFITS OR ANY
# OTHER  KIND OF LOSS WHILE USING OR MISUSING THIS SOFTWARE.
# See the GNU General Public License for more details.


# kill running Chrome
killall chrome

# try to fix SQLite
file ~/.config/google-chrome/Default/* | grep SQLite | cut -d: -f1 |xargs -n1 -d '\n' sh -c 'sqlite3 "$0" .schema 2>&1 >/dev/null | grep -q "is locked" && {echo "fixing $0"; mv "$0" tmp.$$; cp tmp.$$ "$0"; rm tmp.$$;}'

echo -e "\nDone.\n"
exit 0
