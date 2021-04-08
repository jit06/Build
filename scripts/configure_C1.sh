#!/bin/bash
# Volumio configure for Odroid C1

#Edimax Power Saving Fix + Alsa modprobe
cp -r volumio/etc/modprobe.d /etc/
#Hosts file
cp -p volumio/etc/hosts /etc/hosts
#Dhcp conf file
cp volumio/etc/dhcp/dhclient.conf /etc/dhcp/dhclient.conf
cp volumio/etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf
#Samba conf file
cp volumio/etc/samba/smb.conf /etc/samba/smb.conf
#Udev confs file (NET)
cp -r volumio/etc/udev /etc/
#Udisks-glue for USB
cp -r volumio/etc/udisks-glue.conf /etc/udisks-glue.conf
#Polkit for USB mounts
cp -r volumio/etc/polkit-1/localauthority/50-local.d/50-mount-as-pi.pkla /etc/polkit-1/localauthority/50-local.d/50-mount-as-pi.pkla
#Inittab file
cp volumio/etc/inittab /etc/inittab
#MOTD
cp volumio/etc/motd /etc/motd
#SSH
cp volumio/etc/ssh/sshd_config /etc/ssh/sshd_config
#Mpd
cp volumio/etc/mpd.conf /etc/mpd.conf
chmod 777 /etc/mpd.conf
#Volumio SystemD Services
cp -r volumio/lib /
# Network
cp -r volumio/etc/network/* /etc/network
# Wpa Supplicant
echo " " > /etc/wpa_supplicant/wpa_supplicant.conf
chmod 777 /etc/wpa_supplicant/wpa_supplicant.conf
#Shairport
cp volumio/etc/shairport-sync.conf /etc/shairport-sync.conf
chmod 777 /etc/shairport-sync.conf
#nsswitch
cp volumio/etc/nsswitch.conf /etc/nsswitch.conf
#firststart
cp volumio/bin/firststart.sh /bin/firststart.sh
#hotspot
cp volumio/bin/hotspot.sh /bin/hotspot.sh
#dynswap
cp volumio/bin/dynswap.sh /bin/dynswap.sh
#Wireless
cp volumio/bin/wireless.js /volumio/app/plugins/system_controller/network/wireless.js
#Volumio Log Rotate
cp volumio/bin/volumiologrotate /bin/volumiologrotate
#dhcpcd
cp -rp volumio/etc/dhcpcd.conf /etc/
#wifi pre script
cp volumio/bin/wifistart.sh /bin/wifistart.sh
chmod a+x /bin/wifistart.sh
#udev script
cp volumio/bin/rename_netiface0.sh /bin/rename_netiface0.sh
chmod a+x /bin/rename_netiface0.sh
#Plymouth & upmpdcli files
cp -rp volumio/usr/*  /usr/
#SSH
cp volumio/bin/volumiossh.sh /bin/volumiossh.sh
chmod a+x /bin/volumiossh.sh
#LAN HOTPLUG
cp volumio/etc/default/ifplugd /etc/default/ifplugd
#TRIGGERHAPPY
cp -r volumio/etc/triggerhappy /etc

echo 'Done Copying Custom Volumio System Files'
