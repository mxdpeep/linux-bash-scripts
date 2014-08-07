#!/bin/bash

# Author: Fred Brooker <original@fredbrooker.cz>
# URL: http://fredbrooker.cz/


if [ -z "$1" ]
then
	echo -e "\nRestores the home folder from backup. CAUTION - ALL CURRENT HOME FOLDER DATA WILL BE ERASED!\n\nSyntax: $(basename $0) <partition> <backup_file>\nExample: $(basename $0) home-backup-10.10.2010.tar.gz\n"
	exit 1
fi

# remove everything in your home except . and .. folders, then restore your home from the backup
if [ -f "$1" ]
then
	cd ~
	sudo rm -rf .[^.]*
	sudo rm -rf ..*
	sudo tar xvpzf $1
	sync
	echo -e "\nPlease log out now!\n"
else
	echo "Invalid file: $1"
	exit 1
fi

echo -e "\nDone.\n"
exit 0
