#!/bin/bash

sudo apt purge nvidia-*
sudo apt autoremove --purge
sudo apt autoclean

sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update
sudo ubuntu-drivers list
