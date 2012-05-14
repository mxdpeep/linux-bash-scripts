#!/bin/bash

# Written by Filip Oščádal <filip@mxd.cz> <http://mxd.cz/>
# Distributed under license GPLv3+ GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY. YOU USE AT YOUR OWN RISK. THE AUTHOR
# WILL NOT BE LIABLE FOR DATA LOSS, DAMAGES, LOSS OF PROFITS OR ANY
# OTHER  KIND OF LOSS WHILE USING OR MISUSING THIS SOFTWARE.
# See the GNU General Public License for more details.


# check syntax
if [ $# -eq 0 ]
then
  echo -e "\nCheck validity of PDF files recursively.\n\nSyntax: $(basename $0) <folder>\n"
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

# check for installed app
which pdfinfo >/dev/null 2>&1
if [ $? -eq 1 ]
then
  echo -e "Installing xpdf-utils package...\n"
  sudo apt-get install xpdf-utils
fi
which pdfinfo >/dev/null 2>&1
if [ $? -eq 1 ]
then
  echo -e "Xpdf-utils are not installed!\n"
  exit 1
fi

# recurse any directories first
for i in *
do
  if [ -d "$i" ]
  then
    echo "Recursing into directory: $i"
    $0 "$i"
  fi
done

# check pdf files (or recurse .pdf directories)
for i in *.pdf
do
  if [ -d "$i" ]
  then
    echo "Recursing into directory: $i"
    $0 "$i"
  fi
  if [ -f "$i" ]
  then
    echo "Checking: $i"
    /usr/bin/pdfinfo "$i" >/dev/null 2>&1
    if [ $? -ne 0 ]
    then
      echo "Invalid PDF file: $i"
      mv "$i" "invalid-pdf-$i"
    fi
  fi
done

sync

echo -e "\nDone.\n"
exit 0
