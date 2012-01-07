#!/bin/bash
#
# License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
#
# Filip Oscadal <filip@mxd.cz> http://mxd.cz/
# No Rights Reserved 2012, feel free to modify, use and distribute.
#
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
      cd "$1"
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
