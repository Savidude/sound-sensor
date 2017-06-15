#!/usr/bin/env bash

destination="/usr/local/src/RaspberryAgent"
currentDir=$PWD
if [ ! -d "$destination" ]
then
    mkdir $destination
fi

# installing dependencies
echo ===========================Installing Dependencies
sudo apt-get update
echo ===Installing python-pip
sudo apt-get install python-pip
echo ===Installing paho-mqtt
sudo pip install paho-mqtt
echo ===Installing configparser
sudo pip install configparser

# installing mosquitto
echo ===========================Installing Mosquitto
mkdir mosquitto
cd mosquitto
sudo wget http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key
sudo apt-key add mosquitto-repo.gpg.key
cd /etc/apt/sources.list.d/
sudo wget http://repo.mosquitto.org/debian/mosquitto-jessie.list
sudo apt-get update
sudo apt-get install mosquitto
sudo service mosquitto start

#moving project folder to local directory
echo ===========================Moving project folder to local directory
sudo cp -r $currentDir/src $destination
sudo chmod 755 $destination/src/client.py
sudo update-rc.d -f RaspberryService.sh remove
sudo cp $currentDir/RaspberryService.sh /etc/init.d
sudo chmod 755 /etc/init.d/RaspberryService.sh
sudo update-rc.d RaspberryService.sh defaults
sudo service RaspberryService.sh start