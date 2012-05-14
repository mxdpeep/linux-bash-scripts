#!/bin/bash

# Written by Filip Oščádal <filip@mxd.cz> <http://mxd.cz/>
# Distributed under license GPLv3+ GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY. YOU USE AT YOUR OWN RISK. THE AUTHOR
# WILL NOT BE LIABLE FOR DATA LOSS, DAMAGES, LOSS OF PROFITS OR ANY
# OTHER  KIND OF LOSS WHILE USING OR MISUSING THIS SOFTWARE.
# See the GNU General Public License for more details.


# check for installed app
which openssl >/dev/null 2>&1
if [ $? -eq 1 ]
then
  echo -e "Installing openssl package...\n"
  sudo apt-get install openssl
fi
which openssl >/dev/null 2>&1
if [ $? -eq 1 ]
then
  echo -e "Openssl is not installed!\n"
  exit 1
fi

# generate SSL keys and certificates
sudo openssl genrsa -des3 -out server.key 4096
sudo openssl rsa -in server.key -out server.key.insecure
sudo mv server.key server.key.secure
sudo cp server.key.insecure server.key
sudo openssl req -new -key server.key -out server.csr
sudo openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
sudo cp server.crt /etc/ssl/certs
sudo cp server.key /etc/ssl/private

# turn on SSL module
sudo a2enmod ssl

# modification notice
echo -e "\nModify /etc/apache2/sites-available/default-ssl and restart Apache:\n\nSSLEngine on\nSSLCertificateFile /etc/ssl/certs/server.crt\nSSLCertificateKeyFile /etc/ssl/private/server.key\n"

echo -e "\nDone.\n"
exit 0
