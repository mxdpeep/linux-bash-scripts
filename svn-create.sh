#!/bin/bash

# Written by Filip Oščádal <filip@mxd.cz> <http://mxd.cz/>
# Distributed under license GPLv3+ GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY. YOU USE AT YOUR OWN RISK. THE AUTHOR
# WILL NOT BE LIABLE FOR DATA LOSS, DAMAGES, LOSS OF PROFITS OR ANY
# OTHER  KIND OF LOSS WHILE USING OR MISUSING THIS SOFTWARE.
# See the GNU General Public License for more details.


# CHANGE THIS TO MATCH YOUR SVN REPOSITORIES LOCATION!

P='/home/svn'


# check syntax
if [ -z "$1" ]
then
  echo -e "\nCreates new Subversion repository.\n\nSyntax: $(basename $0) <name>\n"
  exit 1
fi

# check for install app
which svnadmin >/dev/null 2>&1
if [ $? -eq 1 ]
then
  echo "Installing subversion package..."
  sudo apt-get install subversion
fi
which svnadmin >/dev/null 2>&1
if [ $? -eq 1 ]
then
  echo -e "Subversion is not installed!\n"
  exit 1
fi

# check the path and create folder
if [ -d "$P/$1" ]
then
  echo -e "Folder $P/$1 already exists!\n"
  exit 1
fi
if [ -d "$P" ]
then
  sudo mkdir "$P/$1"
else
  echo -e "Invalid folder: $P\n"
  exit 1
fi

# setup svn repository
sudo svnadmin create "$P/$1"
sudo chown -R www-data:subversion "$P/$1"
if [ $? -eq 1 ]
then
  echo -e "Warning: ownership change failed!\n"
fi
sudo chmod -R g+rws "$P/$1"

# restart Apache
sudo /etc/init.d/apache2 force-reload 2>/dev/null
if [ $? -eq 1 ]
then
  echo -e "Warning: is Apache 2 installed?\n"
fi

echo -e "\nDone.\n"
exit 0
