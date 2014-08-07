#!/bin/bash

# Author: Fred Brooker <original@fredbrooker.cz>
# URL: http://fredbrooker.cz/


which pmi >/dev/null 2>&1
if [ $? -eq 1 ]
then
	echo -e "Installing powermanagement-interface package...\n"
	sudo apt-get install powermanagement-interface
fi
which powermanagement-interface >/dev/null 2>&1
if [ $? -eq 1 ]
then
	echo -e "powermanagement-interface not installed!\n"
	exit 1
fi

sync
pmi action suspend

echo -e "\nDone.\n"
exit 0
