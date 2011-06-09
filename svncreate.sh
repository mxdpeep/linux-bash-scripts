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

# change to match your SVN repositories location!
P='/home/svn'

# check syntax
if [ -z "$1" ]
then
  echo "\nCreates a new SVN repository.\n\nSyntax: $(basename $0) <folder>\n"
  exit 1
fi

# check install app
which svnadmin > /dev/null 2>&1
if [ $? -eq 1 ]
then
  echo "Installing subversion package..."
  sudo apt-get install subversion
fi
which svnadmin > /dev/null 2>&1
if [ $? -eq 1 ]
then
  echo "Subversion not installed!\n"
  exit 1
fi

# check path and create folder
if [ -d "$P/$1" ]
then
  echo "Folder $P/$1 already exists!\n"
  exit 1
fi
if [ -d "$P" ]
then
  sudo mkdir "$P/$1"
else
  echo "Invalid folder: $P\n"
  exit 1
fi

# setup svn repository
sudo svnadmin create "$P/$1"
sudo chown -R www-data:subversion "$P/$1"
if [ $? -eq 1 ]
then
  echo "Warning: ownership change failed!\n"
fi
sudo chmod -R g+rws "$P/$1"

# restart Apache
sudo /etc/init.d/apache2 force-reload 2>/dev/null
if [ $? -eq 1 ]
then
  echo "Warning: is Apache 2 installed?\n"
fi

echo "Done."
exit 0
