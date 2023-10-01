#!/bin/bash

which openssl >/dev/null 2>&1
if [ $? -eq 1 ]; then
  echo -e "Installing openssl package...\n"
  sudo apt-get install -yqq openssl
fi

which openssl >/dev/null 2>&1
if [ $? -eq 1 ]; then
  echo -e "ERROR: openssl is not installed!\n"
  exit 1
fi

sudo openssl genrsa -aes256 -passout pass:foobar -out server.key 4096
sudo openssl rsa -in server.key -passin pass:foobar -out server.key.insecure
sudo mv server.key server.key.secure
sudo cp server.key.insecure server.key
sudo openssl req -new -key server.key -out server.csr -subj '/CN=127.0.0.1' -sha256
sudo openssl x509 -req -days 3652 -in server.csr -signkey server.key -out server.crt
sudo cp server.crt /etc/ssl/certs
sudo cp server.key /etc/ssl/private

sudo a2enmod ssl

echo -e "\nDone.\n"
