#!/bin/bash
#
# License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
#
# Filip Oscadal <filip@mxd.cz> http://mxd.cz/ * No Rights Reserved 2011.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY. YOU USE AT YOUR OWN RISK. THE AUTHOR
# WILL NOT BE LIABLE FOR DATA LOSS, DAMAGES, LOSS OF PROFITS OR ANY
# OTHER  KIND OF LOSS WHILE USING OR MISUSING THIS SOFTWARE.
# See the GNU General Public License for more details.


if [ -z "$1" ]
then
  echo -e "\nRestores the home folder from backup. CAUTION - ALL CURRENT HOME FOLDER DATA WILL BE ERASED!\n\nSyntax: $(basename $0) <partition> <backup_file>\nExample: $(basename $0) home-backup-10.10.2010.tar.gz\n"
  exit 1
fi

if [ -f "$1" ]
then
  cd ~
  sudo rm -rf .[^.]*
  sudo rm -rf ..*
  sudo tar xvpzf $1
  sync
  echo -e "\nRelog now!\n"
else
  echo "Invalid file: $1"
  exit 1
fi

echo "Done."
exit 0
