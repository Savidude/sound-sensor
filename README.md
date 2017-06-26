# sound-sensor

### Getting Started

#### Setting up the RaspberryPi
1. Get the local IP address of the raspberrypi
```shell
$ ifconfig
```
2. Run the following commands on your RaspberryPi
```shell
$ git clone https://github.com/Savidude/sound-sensor.git
$ cd raspberryPi-agent/src
$ nano config.ini
```
3. Paste the local IP address as the Broker IP, and exit nano
4. Setup the RaspberryPi with the servo motor as follows. (TowerPro SG90: orange - pin 7, red - pin 2, brown - pin 6)
![RaspberryPi Setup](https://github.com/savidude/sound-sensor/blob/master/raspberryPi-agent/images/RaspberryPi.png "RaspberryPi Setup")
5. Run the startup scripts
```shell
$ cd ..
$ sudo sh RaspberryAgent.sh
```

#### Setting up the Nodemcu (V3)
1. Flash Nodemcu [Firmware](http://www.whatimade.today/flashing-the-nodemcu-firmware-on-the-esp8266-linux-guide/) into device.
2. Download and run [ESPlorer](https://esp8266.ru/esplorer/).
3. Clone the project and open [init.lua](https://github.com/savidude/sound-sensor/blob/master/esp8266-agent/lua/init.lua) in ESPlorer.
4. Setup the Nodemcu with the sound sensor as shown (Vcc - Vin, GND - GND, OUT - D5)
![Nodemcu Setup](https://github.com/savidude/sound-sensor/blob/master/esp8266-agent/images/nodemcu.png "Nodemcu Setup")
5. Set the WiFi SSID and password, mqtt_broker_ip, and angle in the file.
6. Save file to ESP.
