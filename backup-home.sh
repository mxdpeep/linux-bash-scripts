#!/bin/bash

# Author: Fred Brooker <original@fredbrooker.cz>
# URL: http://fredbrooker.cz/


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
