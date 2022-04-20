#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

clear

echo "   ___            ___  _  _ ___  ___ _             _  __ _              "
echo "  |   \ _  _ _ _ |   \| \| / __|/ __| |___ _  _ __| |/ _| |__ _ _ _ ___ "
echo "  | |) | || | ' \| |) | .' \__ \ (__| / _ \ || / _' |  _| / _' | '_/ -_)"
echo "  |___/ \_, |_||_|___/|_|\_|___/\___|_\___/\_,_\__,_|_| |_\__,_|_| \___|"
echo "        |__/                                                            "
echo ""
echo "Script version 1 for V1 release"
echo "Welcome to DynDNSCloudflare installation script"
echo "This script will install DynDNSCloudflare on your system"
echo "If you had a previous installation, it will be overwritten"
echo ""
echo "It will install the following packages:"
echo " - curl"
echo " - zip"
echo " - node.js 16.X"
echo " - npm"
echo " - npm-node-fetch"
echo " - npm-typescript (globally)"
echo " - npm-ts-node (globally)"
echo ""
echo "This script will create a service file in /etc/systemd/system/DynDNSCloudflare.service"
echo "The sourcecode can be found in /usr/local/DynDNSCloudflare/"
echo "It will create a folder /etc/DynDNSCloudflare/ where all the config files are linked to"
echo ""
read -p "-- Press Enter to continue --" </dev/tty

echo "Installing curl"
apt-get update > /dev/null
apt-get install curl -y &> /dev/null
apt-get install zip -y &> /dev/null

echo "Getting node.js install script"
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - &> /dev/null

echo "Installing node.js"
sudo apt-get install -y nodejs &> /dev/null

echo "Current node version:"
node --version

echo "Installing npm packages"
npm install -g typescript &> /dev/null
npm install -g ts-node &> /dev/null

echo "Removing old DynDNSCloudflare folder"
rm -rf /tmp/V1-release.zip &> /dev/null
rm -rf /usr/local/DynDNSCloudflare &> /dev/null
rm -rf /etc/DynDNSCloudflare &> /dev/null
rm -f /etc/systemd/system/DynDNSCloudflare.service &> /dev/null

echo "Getting source code and unzipping"
wget https://github.com/BakxY/DynDNSCloudflare/archive/refs/tags/V1-release.zip -P /tmp/ &> /dev/null
unzip /tmp/V1-release.zip -d /usr/local/ &> /dev/null
mv /usr/local/DynDNSCloudflare-1-release /usr/local/DynDNSCloudflare

echo "Moving service file"
mv /usr/local/DynDNSCloudflare/DynDNSCloudflare.service /etc/systemd/system/DynDNSCloudflare.service

echo "Reloading systemd"
systemctl daemon-reload

echo "Linking config files"
mkdir /etc/DynDNSCloudflare
ln -s /usr/local/DynDNSCloudflare/src/resources/configs/main.conf /etc/DynDNSCloudflare/main.conf
ln -s /usr/local/DynDNSCloudflare/src/resources/configs/record_list.conf /etc/DynDNSCloudflare/record_list.conf
ln -s /usr/local/DynDNSCloudflare/src/resources/configs/zones.conf /etc/DynDNSCloudflare/zones.conf

echo "Starting DynDNSCloudflare"
systemctl start DynDNSCloudflare.service

echo "DynDNSCloudflare is now installed"
echo "Bye!"
