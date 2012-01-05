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


# check syntax
if [ -z "$1" ]
then
  echo -e "\nCreates a new git repository.\n\nSyntax: $(basename $0) <name>\n"
  exit 1
fi

if [ -d "$1.git" ]
then
  echo -e "Invalid folder: $1.git"
  exit 1
else
  mkdir "$1.git"
  cd "$1.git"
  git --bare init
fi

echo -e "\nDone.\n"
exit 0
