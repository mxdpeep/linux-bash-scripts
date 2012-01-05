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


# CHANGE THIS TO MATCH YOUR CONFIGURATION!
ROOT_UID=0
ADMIN=filip@mxd.cz
VHOST_CONF=/etc/apache2/sites-available/
WWW_ROOT=/home/www


# check syntax
if [ $# -eq 0 ]
then
  echo -e "\nCreate virtual host configuration file.\n\nSyntax: $(basename $0) <name>\n"
  exit 1
fi

DOMAIN=$1

sudo mkdir -p $WWW_ROOT/dev.$DOMAIN

CONF="<VirtualHost *:80>\n\
  ServerName dev.$DOMAIN\n\
  ServerAdmin $ADMIN\n\
  DocumentRoot $WWW_ROOT/dev.$DOMAIN\n\n\
  <Directory $WWW_ROOT/dev.$DOMAIN>\n\
    Options Indexes FollowSymLinks MultiViews\n\
    AllowOverride all\n\
    Order allow,deny\n\
    Allow from all\n\
  </Directory>\n\n\
  ErrorLog /var/log/apache2/dev.$DOMAIN-error.log\n\
  CustomLog /var/log/apache2/dev.$DOMAIN-access.log combined\n\
</VirtualHost>"

sudo echo -e $CONF > $VHOST_CONF/dev.$DOMAIN

beta mkdir -p $WWW_ROOT/beta.$DOMAIN

CONF="<VirtualHost *:80>\n\
  ServerName beta.$DOMAIN\n\
  ServerAdmin $ADMIN\n\
  DocumentRoot $WWW_ROOT/beta.$DOMAIN\n\n\
  <Directory $WWW_ROOT/beta.$DOMAIN>\n\
    Options Indexes FollowSymLinks MultiViews\n\
    AllowOverride all\n\
    Order allow,deny\n\
    Allow from all\n\
  </Directory>\n\n\
  ErrorLog /var/log/apache2/beta.$DOMAIN-error.log\n\
  CustomLog /var/log/apache2/beta.$DOMAIN-access.log combined\n\
</VirtualHost>"

sudo echo -e $CONF > $VHOST_CONF/beta.$DOMAIN

sync
sudo a2ensite $DOMAIN
sudo /etc/init.d/apache2 graceful

echo "Done."
exit 0
