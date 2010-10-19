#!/bin/sh
#
# Distributed under the terms of the GNU General Public License v3
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY. YOU USE AT YOUR OWN RISK. THE AUTHOR
# WILL NOT BE LIABLE FOR DATA LOSS, DAMAGES, LOSS OF PROFITS OR ANY
# OTHER  KIND OF LOSS WHILE USING OR MISUSING THIS SOFTWARE.
# See the GNU General Public License for more details.

# change to match your SVN repositories location!
SVN='/home/svn'

if [ -z "$1" ]; then
  echo "\nCreates a new SVN repository.\n\nSyntax: $(basename $0) folder\n"
  exit 1
else
  which svnadmin > /dev/null 2>&1
  if [ $? -eq 1 ]
  then
    echo Installing subversion package...
    sudo apt-get install subversion
  fi
  which svnadmin > /dev/null 2>&1
  if [ $? -eq 1 ]
  then
    echo "Subversion not installed!\n"
    exit 1
  fi
  if [ -d "$SVN" ]
  then
    cd "$SVN"
  else
    echo "Check rights of: $SVN\n"
    exit 1
  fi
  if [ -d "$SVN/$1" ]
  then
    echo "Folder already exists.\n"
    exit 1
  fi
  sudo mkdir "$1"
  sudo svnadmin create "$SVN/$1"
  sudo chown -R www-data:subversion "$1" 2>/dev/null
  if [ $? -eq 1 ]
  then
    echo "Is Apache2 installed?\n"
    exit 1
  fi
  sudo chmod -R g+rws "$1" 2>/dev/null
  sudo /etc/init.d/apache2 force-reload 2>/dev/null
  if [ $? -eq 1 ]
  then
    echo "Is Apache2 installed?\n"
    exit 1
  fi
  echo "Done."
  exit 0
fi
