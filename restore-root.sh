#!/bin/bash

# Author: Fred Brooker <original@fredbrooker.cz>
# URL: http://fredbrooker.cz/


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
