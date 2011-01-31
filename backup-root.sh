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


# change to match your backup media location!
P='/media/backup'


if [ -d "$P" ]
then
  cd /
  sudo tar cvpzf "$P/root-backup-`date +%d.%m.%Y`.tar.gz" --one-file-system --exclude=/proc --exclude=/media --exclude=/lost+found --exclude=/sys --exclude=/tmp --exclude=/mnt --exclude=/media --exclude=/dev /
else
  echo "Invalid folder: $P\n"
fi
