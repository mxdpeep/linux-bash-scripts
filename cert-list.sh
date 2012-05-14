#!/bin/bash

# Written by Filip Oščádal <filip@mxd.cz> <http://mxd.cz/>
# Distributed under license GPLv3+ GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY. YOU USE AT YOUR OWN RISK. THE AUTHOR
# WILL NOT BE LIABLE FOR DATA LOSS, DAMAGES, LOSS OF PROFITS OR ANY
# OTHER  KIND OF LOSS WHILE USING OR MISUSING THIS SOFTWARE.
# See the GNU General Public License for more details.


# check for installed app
which certutil >/dev/null 2>&1
if [ $? -eq 1 ]
then
  echo -e "Installing libnss3-tools package...\n"
  sudo apt-get install libnss3-tools
fi
which certutil >/dev/null 2>&1
if [ $? -eq 1 ]
then
  echo -e "Libnss3-tools are not installed!\n"
  exit 1
fi

# list certificates
certutil -L -d sql:$HOME/.pki/nssdb

echo -e "\nDone.\n"
exit 0
