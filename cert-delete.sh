#!/bin/sh
#
# License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
#
# Filip Oscadal <filip@mxd.cz> http://mxd.cz No Rights Reserved 2011.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY. YOU USE AT YOUR OWN RISK. THE AUTHOR
# WILL NOT BE LIABLE FOR DATA LOSS, DAMAGES, LOSS OF PROFITS OR ANY
# OTHER  KIND OF LOSS WHILE USING OR MISUSING THIS SOFTWARE.
# See the GNU General Public License for more details.

# check syntax
if [ -z "$1" ]
then
  echo "\nSyntax: $(basename $0) <name>\n"
  exit 1
fi

# delete certificate by name
certutil -D -n $1 -d sql:$HOME/.pki/nssdb

exit 0
