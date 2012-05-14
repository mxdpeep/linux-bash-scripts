#!/bin/bash

# Written by Filip Oščádal <filip@mxd.cz> <http://mxd.cz/>
# Distributed under license GPLv3+ GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY. YOU USE AT YOUR OWN RISK. THE AUTHOR
# WILL NOT BE LIABLE FOR DATA LOSS, DAMAGES, LOSS OF PROFITS OR ANY
# OTHER  KIND OF LOSS WHILE USING OR MISUSING THIS SOFTWARE.
# See the GNU General Public License for more details.


# check syntax
if [ -z "$1" ]
then
  echo -e "\nCreates new git repository.\n\nSyntax: $(basename $0) <name>\n"
  exit 1
fi

# check for installed app
which git >/dev/null 2>&1
if [ $? -eq 1 ]
then
  echo "Installing git-core package..."
  sudo apt-get install git-core
fi
which git >/dev/null 2>&1
if [ $? -eq 1 ]
then
  echo -e "git is not installed!\n"
  exit 1
fi

# git initialization
if [ -d "$1.git" ]
then
  echo -e "Invalid folder: $1.git"
  exit 1
else
  mkdir "$1.git"
  cd "$1.git"
  git --bare init
fi

echo -e "\nDone.\n"
exit 0
