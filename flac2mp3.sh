#!/bin/bash

# Author: Fred Brooker <original@fredbrooker.cz>
# URL: http://fredbrooker.cz/


if [ $# -eq 0 ]
then
	echo -e "\nConvert FLAC files to MP3 recursively.\n\nSyntax: $(basename $0) <folder>\n"
	exit 1
fi
if [ -n "$1" ]
then
	if [ -d "$1" ]
	then
		cd "$1"
	else
		echo -e "Invalid folder: $1\n"
		exit 1
	fi
fi

which flac >/dev/null 2>&1
if [ $? -eq 1 ]
then
	echo -e "Installing flac package...\n"
	sudo apt-get install flac
fi
which flac >/dev/null 2>&1
if [ $? -eq 1 ]
then
	echo -e "Flac is not installed!\n"
	exit 1
fi
which lame >/dev/null 2>&1
if [ $? -eq 1 ]
then
	echo -e "Installing lame package...\n"
	sudo apt-get install lame
fi
which lame >/dev/null 2>&1
if [ $? -eq 1 ]
then
	echo -e "Lame is not installed!\n"
	exit 1
fi

for i in *
do
	if [ -d "$i" ]
	then
		echo "Recursing into directory: $i"
		$0 "$i"
	fi
done

for i in *.flac
do
	if [ -d "$i" ]
	then
		echo "Recursing into directory: $i"
		$0 "$i"
	fi
	if [ -f "$i" ]
	then
		echo "Converting: $i"
		flac -d "$i"
		lame -b 320 "${i%.flac}.wav" "${i%.flac}.mp3"
	fi
done

sync

echo -e "\nDone.\n"
exit 0
