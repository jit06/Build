### Custom Buildscripts for Volumio on Odroid C1

This project if a fork of the original Volumio build (which is Copyright Michelangelo Guarise - 2016)
This is unofficial and based on my tiny-ubuntu image which is itself based on hardkernel's ubuntu 18.04. 

Please note that there is no bluetooth nor I2C support.

This build script should also work on original hardkernel's ubuntu 18.04 if you upgrade & dist-upgrade it before (you will also need to install git).

#### How to use
Get the image in the release section and flash it on an emmc or sdcard (at least 4 GB)

#### How to build
- use an emmc or sdcard flashed with tiny-ubuntu for odroid C1 (https://github.com/jit06/tiny-ubuntu)
- Boot the Odroid C1 and ssh to it
- Clone this repo on the C1 : git clone -b master https://github.com/jit06/Build
- As root, launch the script build_C1.sh
- When finished, just reboot

Beware that after a reboot :
- The hostname is changed 
- ssh via root is no more possible
- the user volumio is added

### Features
Features should be the same as the original volumio (no guaranty, through).

Main differences are :
- if using an emmc, any SDCard that is present at boot will be automatically mounted as /mnt/SDCARD
- USB volumes are "hot mounted" to /mnt/USB when inserted

SDCarc and USB are both in the MPD music path, so Volumio can find any supported music format they contain.

Note that Hifi shield modules (snd-soc-pcm5102 and snd-soc-odroid-dac) are not loaded by default. If you need them, you can use rc.local to load them with a modprobe
