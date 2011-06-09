#!/bin/sh
#
# License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
#
# Filip Oscadal <filip@mxd.cz> http://mxd.cz No Rights Reserved 2011.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY. YOU USE AT YOUR OWN RISK. THE AUTHOR
# WILL NOT BE LIABLE FOR DATA LOSS, DAMAGES, LOSS OF PROFITS OR ANY
# OTHER  KIND OF LOSS WHILE USING OR MISUSING THIS SOFTWARE.
# See the GNU General Public License for more details.

# check syntax
if [ $# -eq 0 ]
then
  echo "\nChecks validity of PDF files recursively.\n\nSyntax: $(basename $0) <folder>\n"
  exit 1
fi
if [ -n "$1" ]
then
  if [ -d "$1" ] 
  then
    cd "$1"
  else
    echo "Invalid folder: $1\n"
    exit 1
  fi
fi

# check installed app
which pdfinfo > /dev/null 2>&1
if [ $? -eq 1 ]
then
  echo "Installing xpdf-utils package...\n"
  sudo apt-get install xpdf-utils
fi
which pdfinfo > /dev/null 2>&1
if [ $? -eq 1 ]
then
  echo "xpdf-utils not installed!\n"
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
    /usr/bin/pdfinfo "$i" > /dev/null 2>&1
    if [ $? -ne 0 ]
    then
      echo "Invalid PDF file: $i"
      mv "$i" "invalid-pdf-$i"
    fi
  fi
done

sync

echo "Done."
exit 0
