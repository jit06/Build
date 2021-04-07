#!/bin/bash
# Volumio configure for Odroid C1

#Edimax Power Saving Fix + Alsa modprobe
cp -r volumio/etc/modprobe.d /root/etc/
#Hosts file
cp -p volumio/etc/hosts /root/etc/hosts
#Dhcp conf file
cp volumio/etc/dhcp/dhclient.conf /root/etc/dhcp/dhclient.conf
cp volumio/etc/dhcp/dhcpd.conf /root/etc/dhcp/dhcpd.conf
#Samba conf file
cp volumio/etc/samba/smb.conf /root/etc/samba/smb.conf
#Udev confs file (NET)
cp -r volumio/etc/udev /root/etc/
#Udisks-glue for USB
cp -r volumio/etc/udisks-glue.conf /root/etc/udisks-glue.conf
#Polkit for USB mounts
cp -r volumio/etc/polkit-1/localauthority/50-local.d/50-mount-as-pi.pkla /root/etc/polkit-1/localauthority/50-local.d/50-mount-as-pi.pkla
#Inittab file
cp volumio/etc/inittab /root/etc/inittab
#MOTD
cp volumio/etc/motd /root/etc/motd
#SSH
cp volumio/etc/ssh/sshd_config /root/etc/ssh/sshd_config
#Mpd
cp volumio/etc/mpd.conf /root/etc/mpd.conf
chmod 777 /root/etc/mpd.conf
#Log via JournalD in RAM
#cp volumio/etc/systemd/journald.conf /root/etc/systemd/journald.conf
#Volumio SystemD Services
cp -r volumio/lib /root/
# Network
cp -r volumio/etc/network/* /root/etc/network
# Wpa Supplicant
echo " " > /root/etc/wpa_supplicant/wpa_supplicant.conf
chmod 777 /root/etc/wpa_supplicant/wpa_supplicant.conf
#Shairport
cp volumio/etc/shairport-sync.conf /root/etc/shairport-sync.conf
chmod 777 /root/etc/shairport-sync.conf
#nsswitch
cp volumio/etc/nsswitch.conf /root/etc/nsswitch.conf
#firststart
cp volumio/bin/firststart.sh /root/bin/firststart.sh
#hotspot
cp volumio/bin/hotspot.sh /root/bin/hotspot.sh
#dynswap
cp volumio/bin/dynswap.sh /root/bin/dynswap.sh
#Wireless
cp volumio/bin/wireless.js /root/volumio/app/plugins/system_controller/network/wireless.js
#Volumio Log Rotate
cp volumio/bin/volumiologrotate /root/bin/volumiologrotate
#dhcpcd
cp -rp volumio/etc/dhcpcd.conf /root/etc/
#wifi pre script
cp volumio/bin/wifistart.sh /root/bin/wifistart.sh
chmod a+x /root/bin/wifistart.sh
#udev script
cp volumio/bin/rename_netiface0.sh /root/bin/rename_netiface0.sh
chmod a+x /root/bin/rename_netiface0.sh
#Plymouth & upmpdcli files
cp -rp volumio/usr/*  /root/usr/
#SSH
cp volumio/bin/volumiossh.sh /root/bin/volumiossh.sh
chmod a+x /root/bin/volumiossh.sh
#CPU TWEAK
#cp volumio/bin/volumio_cpu_tweak /root/bin/volumio_cpu_tweak
#chmod a+x /root/bin/volumio_cpu_tweak
#LAN HOTPLUG
cp volumio/etc/default/ifplugd /root/etc/default/ifplugd
#TRIGGERHAPPY
cp -r volumio/etc/triggerhappy /root/etc

echo 'Done Copying Custom Volumio System Files'
