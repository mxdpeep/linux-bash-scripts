#!/bin/bash

# Author: Fred Brooker <original@fredbrooker.cz>
# URL: http://fredbrooker.cz/


if [ $# -eq 0 ]
then
	echo -e "\nFix filenames recursively.\n\nSyntax: $(basename $0) <folder>\n"
	exit 1
else
	if [ -n "$1" ]
	then
		if [ -d "$1" ]
		then
			echo "Processing folder: $1"
		else
			echo "Invalid folder: $1"
			exit 1
		fi
	fi
fi

which detox >/dev/null 2>&1
if [ $? -eq 1 ]
then
	echo "Installing detox package..."
	sudo apt-get install detox
fi
which detox >/dev/null 2>&1
if [ $? -eq 1 ]
then
	echo "Detox is not installed!"
	exit 1
fi

detox --special --remove-trailing -r -v -s utf_8 "$1"
detox --special --remove-trailing -r -v -s lower "$1"
sync

echo -e "\nDone.\n"
exit 0
