#!/bin/bash

# Written by Filip Oščádal <filip@mxd.cz> <http://mxd.cz/>
# Distributed under license GPLv3+ GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY. YOU USE AT YOUR OWN RISK. THE AUTHOR
# WILL NOT BE LIABLE FOR DATA LOSS, DAMAGES, LOSS OF PROFITS OR ANY
# OTHER  KIND OF LOSS WHILE USING OR MISUSING THIS SOFTWARE.
# See the GNU General Public License for more details.


# check syntax
if [ -z "$2" ]
then
  echo -e "\nRestores the partition from backup. CAUTION - ALL DATA WILL BE ERASED!\n\nSyntax: $(basename $0) <partition> <backup_file>\nExample: $(basename $0) sda1 root-backup-10.10.2010.tar.gz\n"
  exit 1
fi

# mount partition, remove any data left, extract backup and create special folders
if [ -f "$2" ]
then
  sudo mount -t ext4 "/dev/$1" "/mnt/$1"
  cd "/mnt/$1"
  sudo rm -rf *
  sudo tar xvpzf $2
  sudo mkdir proc media lost+found sys mnt media dev
  sudo umount "/mnt/$1"
  sync
  echo -e "\nPlease reboot the machine now!\n"
else
  echo "Invalid file: $2"
  exit 1
fi

echo -e "\nDone.\n"
exit 0
