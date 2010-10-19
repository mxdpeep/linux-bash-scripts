#!/bin/sh
#
# Distributed under the terms of the GNU General Public License v3
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY. YOU USE AT YOUR OWN RISK. THE AUTHOR
# WILL NOT BE LIABLE FOR DATA LOSS, DAMAGES, LOSS OF PROFITS OR ANY
# OTHER  KIND OF LOSS WHILE USING OR MISUSING THIS SOFTWARE.
# See the GNU General Public License for more details.

if [ $# -eq 0 ]
then
  echo "\nChecks validity of PDF files.\n\nSyntax: $(basename $0) folder\n"
  exit 1
else
  if [ -n "$1" ]
  then
    if [ -d "$1" ] 
    then
      cd "$1"
    else
      echo Invalid folder: "$1"
      exit 1
    fi
  fi
fi
which pdfinfo > /dev/null 2>&1
if [ $? -eq 1 ]
then
  echo Installing xpdf-utils package...
  sudo apt-get install xpdf-utils
fi
which pdfinfo > /dev/null 2>&1
if [ $? -eq 1 ]
then
  echo xpdf-utils not installed!
  exit 1
fi
for file in `ls -1 $1/* 2>/dev/null`
do
  if [ -f "$file" ]
  then
    /usr/bin/pdfinfo "$file" > /dev/null 2>&1
    if [ $? -ne 0 ]
    then
      echo "Renamed file: $file"
      mv "$file" "Invalid-PDF-$file"
    fi
  fi
done
echo "Done."
exit 0
