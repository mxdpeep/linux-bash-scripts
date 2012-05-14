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
  echo -e "\nFix filenames recursively.\n\nSyntax: $(basename $0) <folder>\n"
  exit 1
else
  if [ -n "$1" ]
  then
    if [ -d "$1" ]
    then
      cd "$1" 2>/dev/null
      if [ $? -ne 0 ]
      then
        exit 1
      fi
    else
      echo "Invalid folder: $1"
      exit 1
    fi
  fi
fi

# check for installed app
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

# recurse any folders and execute detox 1st round
for i in *
do
  if [ -d "$i" ]
  then
    echo "Recursing into directory: $i"
    $0 "$i"
  fi
  if [ -f "$i" ]
  then
    detox -s utf_8 "$i" >/dev/null 2>&1
  fi
done

# recurse any folders and execute detox 2nd round
for i in *
do
  if [ -d "$i" ]
  then
    echo "Recursing into directory: $i"
    $0 "$i"
  fi
  if [ -f "$i" ]
  then
    detox -s lower "$i" >/dev/null 2>&1
  fi
done

sync

echo -e "\nDone.\n"
exit 0
