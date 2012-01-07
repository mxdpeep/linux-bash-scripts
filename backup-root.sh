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


# backup root filesystem
cd /
sudo tar cvpzf "$P/root-backup-`date +%d.%m.%Y`.tar.gz" --one-file-system --exclude=/proc --exclude=/media --exclude=/lost+found --exclude=/sys --exclude=/tmp --exclude=/mnt --exclude=/media --exclude=/dev /

echo -e "\nDone.\n"
exit 0
