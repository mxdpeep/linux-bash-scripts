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


# CHANGE THESE TO MATCH YOUR CONFIGURATION!

ADMIN=filip@mxd.cz
VHOST_CONF=/etc/apache2/sites-available/
WWW_ROOT=/home/www


# check syntax
if [ $# -eq 0 ]
then
  echo -e "\nCreate virtual host configuration file.\n\nSyntax: $(basename $0) <domain>\n"
  exit 1
fi


# create web folders
DOMAIN=$1
sudo mkdir -p $WWW_ROOT/$DOMAIN
sudo mkdir -p $WWW_ROOT/dev.$DOMAIN
sudo mkdir -p $WWW_ROOT/beta.$DOMAIN
# set owner
sudo chown www-data:www-data $WWW_ROOT/$DOMAIN
sudo chown www-data:www-data $WWW_ROOT/dev.$DOMAIN
sudo chown www-data:www-data $WWW_ROOT/beta.$DOMAIN
# set rights
sudo chmod 0755 $WWW_ROOT/$DOMAIN
sudo chmod 0755 $WWW_ROOT/dev.$DOMAIN
sudo chmod 0755 $WWW_ROOT/beta.$DOMAIN

# setup content for naked domain
CONF1="<VirtualHost *:80>\n\
  ServerName $DOMAIN\n\
  ServerAlias www.$DOMAIN\n\
  ServerAdmin $ADMIN\n\
  DocumentRoot $WWW_ROOT/$DOMAIN\n\n\
  <Directory $WWW_ROOT/$DOMAIN>\n\
    Options Indexes FollowSymLinks MultiViews\n\
    AllowOverride all\n\
    Order allow,deny\n\
    Allow from all\n\
  </Directory>\n\n\
  ErrorLog /var/log/apache2/$DOMAIN-error.log\n\
  CustomLog /var/log/apache2/$DOMAIN-access.log combined\n\
</VirtualHost>"

# setup content for development subdomain
CONF2="<VirtualHost *:80>\n\
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

# setup content for beta subdomain
CONF3="<VirtualHost *:80>\n\
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

# write files
sudo echo -e $CONF1 > $VHOST_CONF/$DOMAIN
sudo echo -e $CONF2 > $VHOST_CONF/dev.$DOMAIN
sudo echo -e $CONF3 > $VHOST_CONF/beta.$DOMAIN

sync

# add all sites and reload Apache
sudo a2ensite $DOMAIN dev.$DOMAIN beta.$DOMAIN
sudo /etc/init.d/apache2 graceful

echo -e "\nDone.\n"
exit 0
