#!/bin/bash
#
# License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
#
# Filip Oscadal <filip@mxd.cz> http://mxd.cz/ * No Rights Reserved 2011.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY. YOU USE AT YOUR OWN RISK. THE AUTHOR
# WILL NOT BE LIABLE FOR DATA LOSS, DAMAGES, LOSS OF PROFITS OR ANY
# OTHER  KIND OF LOSS WHILE USING OR MISUSING THIS SOFTWARE.
# See the GNU General Public License for more details.


# check installed app
which pmi > /dev/null 2>&1
if [ $? -eq 1 ]
then
  echo -e "Installing powermanagement-interface package...\n"
  sudo apt-get install powermanagement-interface
fi

which powermanagement-interface > /dev/null 2>&1
if [ $? -eq 1 ]
then
  echo -e "powermanagement-interface not installed!\n"
  exit 1
fi

sync
pmi action suspend

echo -e "\nDone.\n"
exit 0
