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
  echo -e "\nImport remote CA certificate.\n\nSyntax: $(basename $0) <remotehost> [<port>]\n"
  exit 1
fi

# check for installed app
which certutil > /dev/null 2>&1
if [ $? -eq 1 ]
then
  echo -e "Installing libnss3-tools package...\n"
  sudo apt-get install libnss3-tools
fi
which certutil > /dev/null 2>&1
if [ $? -eq 1 ]
then
  echo -e "Libnss3-tools are not installed!\n"
  exit 1
fi

# set variables
REMHOST=$1
REMPORT=${2:-443}

# setup redirects
exec 6>&1
exec > $REMHOST

# import remote certificate
echo | openssl s_client -connect ${REMHOST}:${REMPORT} 2>&1 |sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p'
certutil -d sql:$HOME/.pki/nssdb -A -t TC -n "$REMHOST" -i $REMHOST

# restore redirects
exec 1>&6 6>&-

echo -e "\nDone.\n"
exit 0
