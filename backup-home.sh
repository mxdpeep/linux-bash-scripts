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


# CHANGE THIS TO MATCH YOUR BACKUP MEDIA LOCATION!

P='/media/backup'


# run
if [ -d "$P" ]
then
  cd ~
  sudo tar cvpzf "$P/home-backup-`date +%d.%m.%Y`.tar.gz" --one-file-system --exclude=/.cache --exclude-caches-all .
else
  echo -e "Invalid folder: $P\n"
  exit 1
fi

echo -e "\nDone.\n"
exit 0
