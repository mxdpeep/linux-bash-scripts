#!/bin/bash

# Written by Filip Oščádal <filip@mxd.cz> <http://mxd.cz/>
# Distributed under license GPLv3+ GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY. YOU USE AT YOUR OWN RISK. THE AUTHOR
# WILL NOT BE LIABLE FOR DATA LOSS, DAMAGES, LOSS OF PROFITS OR ANY
# OTHER  KIND OF LOSS WHILE USING OR MISUSING THIS SOFTWARE.
# See the GNU General Public License for more details.


# "touch .ignorebackup" in folders to be skipped

# CHANGE THIS VARIABLE TO MATCH YOUR BACKUP MEDIA LOCATION!

P='/media/backup'


if [ -d "$P" ]
then
  cd ~
  sudo tar cvpzf "$P/home-backup-`date +%d.%m.%Y`.tar.gz" --one-file-system --exclude-tag-under=.ignorebackup --exclude=/.cache --exclude-caches-all .
else
  echo -e "Invalid folder: $P\n"
  exit 1
fi

echo -e "\nDone.\n"
exit 0
