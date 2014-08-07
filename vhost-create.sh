#!/bin/bash

# Author: Fred Brooker <original@fredbrooker.cz>
# URL: http://fredbrooker.cz/


# CHANGE THESE VARIABLES TO MATCH YOUR CONFIGURATION!

ADMIN=filip@mxd.cz
VHOST_CONF=/etc/apache2/sites-available/
WWW_ROOT=/home/www
OWNER=www-data:www-data
CHMOD=0755

if [ $# -eq 0 ]
then
	echo -e "\nCreate virtual hosts.\n\nSyntax: $(basename $0) <domain.tld>\n"
	exit 1
fi

DOMAIN=$1
sudo mkdir -p $WWW_ROOT/$DOMAIN
sudo mkdir -p $WWW_ROOT/dev.$DOMAIN
sudo mkdir -p $WWW_ROOT/beta.$DOMAIN

sudo chown $OWNER $WWW_ROOT/$DOMAIN
sudo chown $OWNER $WWW_ROOT/dev.$DOMAIN
sudo chown $OWNER $WWW_ROOT/beta.$DOMAIN

sudo chmod $CHMOD $WWW_ROOT/$DOMAIN
sudo chmod $CHMOD $WWW_ROOT/dev.$DOMAIN
sudo chmod $CHMOD $WWW_ROOT/beta.$DOMAIN

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

sudo echo -e $CONF1 > $VHOST_CONF/$DOMAIN
sudo echo -e $CONF2 > $VHOST_CONF/dev.$DOMAIN
sudo echo -e $CONF3 > $VHOST_CONF/beta.$DOMAIN

sync

sudo a2ensite $DOMAIN dev.$DOMAIN beta.$DOMAIN
sudo /etc/init.d/apache2 graceful

echo -e "\nDone.\n"
exit 0
