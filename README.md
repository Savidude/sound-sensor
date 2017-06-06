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
4. Run the startup scripts
```shell
$ cd ..
$ sudo sh RaspberryAgent.sh
```
