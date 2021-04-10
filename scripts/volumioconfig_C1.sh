#!/bin/bash

NODE_VERSION=8.11.1


#Adding Main user Volumio
echo "------------- Adding Volumio User"
groupadd volumio
useradd -c volumio -d /home/volumio -m -g volumio -G adm,dialout,cdrom,floppy,audio,dip,video,plugdev,netdev,lp,systemd-journal -s /bin/bash -p '$6$tRtTtICB$Ki6z.DGyFRopSDJmLUcf3o2P2K8vr5QxRx5yk3lorDrWUhH64GKotIeYSNKefcniSVNcGHlFxZOqLM6xiDa.M.' volumio


#Global BashRC Aliases"
echo '------------- Setting BashRC for custom system calls'
echo ' ## System Commands ##
alias reboot="sudo /sbin/reboot"
alias poweroff="sudo /sbin/poweroff"
alias halt="sudo /sbin/halt"
alias shutdown="sudo /sbin/shutdown"
alias apt-get="sudo /usr/bin/apt-get"
alias systemctl="/bin/systemctl"
alias iwconfig="iwconfig wlan0"
alias come="echo 'se fosse antani'"
## Utilities thanks to http://www.cyberciti.biz/tips/bash-aliases-mac-centos-linux-unix.html ##
## Colorize the ls output ##
alias ls="ls --color=auto"
## Use a long listing format ##
alias ll="ls -la"
## Show hidden files ##
alias l.="ls -d .* --color=auto"
## get rid of command not found ##
alias cd..="cd .."
## a quick way to get out of current directory ##
alias ..="cd .."
alias ...="cd ../../../"
alias ....="cd ../../../../"
alias .....="cd ../../../../"
alias .4="cd ../../../../"
alias .5="cd ../../../../.."
# install with apt-get
alias updatey="sudo apt-get --yes"
## Read Like humans ##
alias df="df -H"
alias du="du -ch"
alias makemeasandwich="echo 'What? Make it yourself'"
alias sudomakemeasandwich="echo 'OKAY'"
alias snapclient="/usr/sbin/snapclient"
alias snapserver="/usr/sbin/snapserver"
alias mount="sudo /bin/mount"
alias systemctl="sudo /bin/systemctl"
alias killall="sudo /usr/bin/killall"
alias service="sudo /usr/sbin/service"
alias ifconfig="sudo /sbin/ifconfig"
# tv-service
alias tvservice="/opt/vc/bin/tvservice"
# vcgencmd
alias vcgencmd="/opt/vc/bin/vcgencmd"
' >> /etc/bash.bashrc


#Sudoers Nopasswd
echo '------------- Adding Safe Sudoers NoPassw permissions'
SUDOERS_FILE="/etc/sudoers.d/volumio-user"
cat > ${SUDOERS_FILE} << EOF
# Add permissions for volumio user
volumio ALL=(ALL) ALL
volumio ALL=(ALL) NOPASSWD: /sbin/poweroff,/sbin/shutdown,/sbin/reboot,/sbin/halt,/bin/systemctl,/usr/bin/apt-get,/usr/sbin/update-rc.d,/usr/bin/gpio,/bin/mount,/bin/umount,/sbin/iwconfig,/sbin/iwlist,/sbin/ifconfig,/usr/bin/killall,/bin/ip,/usr/sbin/service,/etc/init.d/netplug,/bin/journalctl,/bin/chmod,/sbin/ethtool,/usr/sbin/alsactl,/bin/tar,/usr/bin/dtoverlay,/sbin/dhclient,/usr/sbin/i2cdetect,/sbin/dhcpcd,/usr/bin/alsactl,/bin/mv,/sbin/iw,/bin/hostname,/sbin/modprobe,/sbin/iwgetid,/bin/ln,/usr/bin/unlink,/bin/dd,/usr/bin/dcfldd,/opt/vc/bin/vcgencmd,/opt/vc/bin/tvservice,/usr/bin/renice,/bin/rm,/bin/kill,/usr/sbin/i2cset
volumio ALL=(ALL) NOPASSWD: /bin/sh /volumio/app/plugins/system_controller/volumio_command_line_client/commands/kernelsource.sh, /bin/sh /volumio/app/plugins/system_controller/volumio_command_line_client/commands/pull.sh
EOF
chmod 0440 ${SUDOERS_FILE}

echo volumio > /etc/hostname
chmod 777 /etc/hostname
chmod 777 /etc/hosts


################
#Volumio System#---------------------------------------------------
################
  echo "------------- Installing required packages"
  apt-get -y install alsa-base alsa-utils nodejs mpd mpc shairport-sync hostapd avahi-daemon avahi-utils samba libcurl4 libavahi-compat-libdnssd1 cifs-utils isc-dhcp-server psmisc minizip npm

  echo "------------- Installing Volumio Modules"
  cd /volumio
  wget https://repo.volumio.org/Volumio2/node_modules_arm-${NODE_VERSION}.tar.gz
  tar xf node_modules_arm-${NODE_VERSION}.tar.gz
  rm node_modules_arm-${NODE_VERSION}.tar.gz
  
  echo "------------- Setting proper ownership"
  chown -R volumio:volumio /volumio

  echo "------------- Creating Data Path"
  mkdir /data
  chown -R volumio:volumio /data

  echo "------------- Creating ImgPart Path"
  mkdir /imgpart
  chown -R volumio:volumio /imgpart

  echo "------------- disable initial network management and wpa"
  systemctl disable network-manager
  systemctl mask network-manager
  systemctl disable wpa_supplicant
  systemctl mask wpa_supplicant

  echo "------------- Tune system for volumio"
  ln -s /usr/bin/shairport-sync /usr/local/bin/shairport-sync
  ln -s /usr/bin/node /usr/local/bin
  systemctl disable smbd
  systemctl disable nmbd
  sed -i "s/exit 0/mkdir \/var\/log\/samba;systemctl start smbd; systemctl start nmbd/" /etc/rc.local
  echo "exit 0" >> /etc/rc.local
  

  echo "------------- Changing os-release permissions"
  chown volumio:volumio /etc/os-release
  chmod 777 /etc/os-release
  
  echo "------------- Installing Snapcast for multiroom"
  wget https://repo.volumio.org/Volumio2/Binaries/arm/snapserver -P /usr/sbin/
  wget https://repo.volumio.org/Volumio2/Binaries/arm/snapclient -P  /usr/sbin/
  chmod a+x /usr/sbin/snapserver
  chmod a+x /usr/sbin/snapclient

  echo "------------- Installing Zsync"
  rm /usr/bin/zsync
  wget https://repo.volumio.org/Volumio2/Binaries/arm/zsync -P /usr/bin/
  chmod a+x /usr/bin/zsync

  echo "------------- Adding special version for edimax dongle"
  wget https://repo.volumio.org/Volumio2/Binaries/arm/hostapd-edimax -P /usr/sbin/
  chmod a+x /usr/sbin/hostapd-edimax

  echo "interface=wlan0
ssid=Volumio
channel=4
driver=rtl871xdrv
hw_mode=g
auth_algs=1
wpa=2
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
wpa_passphrase=volumio2" >> /etc/hostapd/hostapd-edimax.conf
  chmod -R 777 /etc/hostapd/hostapd-edimax.conf

  echo "------------- Cleanup"
  apt-get clean
  rm -rf tmp/*


echo "------------- Setting proper permissions for ping"
chmod u+s /bin/ping

echo "------------- Creating Volumio Folder Structure"
# Media Mount Folders
mkdir -p /mnt/NAS
mkdir -p /media
ln -s /media /mnt/USB

#Internal Storage Folder
mkdir /data/INTERNAL

#UPNP Folder
mkdir /mnt/UPNP

#Permissions
chmod -R 777 /mnt
chmod -R 777 /media
chmod -R 777 /data/INTERNAL

# Symlinking Mount Folders to Mpd's Folder
ln -s /mnt/NAS /var/lib/mpd/music
ln -s /mnt/USB /var/lib/mpd/music
ln -s /data/INTERNAL /var/lib/mpd/music

echo "------------- Prepping MPD environment"
touch /var/lib/mpd/tag_cache
chmod 777 /var/lib/mpd/tag_cache
chmod 777 /var/lib/mpd/playlists

echo "------------- Setting mpdignore file"
echo "@Recycle
#recycle
$*
System Volume Information
$RECYCLE.BIN
RECYCLER
" > /var/lib/mpd/music/.mpdignore

echo "------------- Setting mpc to bind to unix socket"
export MPD_HOST=/run/mpd/socket

echo "------------- Setting Permissions for /etc/modules"
chmod 777 /etc/modules

echo "------------- Adding Volumio Parent Service to Startup"
ln -s /lib/systemd/system/volumio.service /etc/systemd/system/multi-user.target.wants/volumio.service

echo "------------- Adding First start script"
ln -s /lib/systemd/system/firststart.service /etc/systemd/system/multi-user.target.wants/firststart.service

echo "------------- Adding Iptables Service"
ln -s /lib/systemd/system/iptables.service /etc/systemd/system/multi-user.target.wants/iptables.service

echo "------------- Enable Volumio Log Rotation Service"
ln -s /lib/systemd/system/volumiologrotate.service /etc/systemd/system/multi-user.target.wants/volumiologrotate.service

echo "------------- Setting Mpd to SystemD instead of Init"
systemctl enable mpd.service

echo "------------- Preventing un-needed dhcp servers to start automatically"
systemctl disable isc-dhcp-server.service
systemctl disable dhcpd.service

echo "------------- Linking Volumio Command Line Client"
ln -s /volumio/app/plugins/system_controller/volumio_command_line_client/volumio.sh /usr/local/bin/volumio
chmod a+x /usr/local/bin/volumio

echo "------------- Adding Shairport-Sync User"
getent group shairport-sync &>/dev/null || groupadd -r shairport-sync >/dev/null
getent passwd shairport-sync &> /dev/null || useradd -r -M -g shairport-sync -s /usr/bin/nologin -G audio shairport-sync >/dev/null

echo "------------- Semistandard"
ln -s /volumio/node_modules/semistandard/bin/cmd.js /bin/semistandard

#####################
#Audio Optimizations#-----------------------------------------
#####################

echo "------------- Adding Users to Audio Group"
usermod -a -G audio volumio
usermod -a -G audio mpd

echo "------------- Setting RT Priority to Audio Group"
echo '@audio - rtprio 99
@audio - memlock unlimited' >> /etc/security/limits.conf

echo "------------- Alsa tuning"
echo "Creating Alsa state file"
touch /var/lib/alsa/asound.state
echo '#' > /var/lib/alsa/asound.state
chmod 777 /var/lib/alsa/asound.state

#####################
#Network Settings and Optimizations#-----------------------------------------
#####################


echo "------------- Tuning LAN"
echo 'fs.inotify.max_user_watches = 524288' >> /etc/sysctl.conf

echo "------------- Wireless"
ln -s /lib/systemd/system/wireless.service /etc/systemd/system/multi-user.target.wants/wireless.service

echo "------------- Configuring hostapd"
echo "interface=wlan0
ssid=Volumio
channel=4
driver=nl80211
hw_mode=g
auth_algs=1
wpa=2
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
wpa_passphrase=volumio2
" >> /etc/hostapd/hostapd.conf

echo "------------- Hostapd conf files"
cp /etc/hostapd/hostapd.conf /etc/hostapd/hostapd.tmpl
chmod -R 777 /etc/hostapd

echo "------------- Empty resolv.conf.head for custom DNS settings"
touch /etc/resolv.conf.head

echo "------------- Setting fallback DNS with OpenDNS nameservers"
echo "# OpenDNS nameservers
nameserver 208.67.222.222
nameserver 208.67.220.220" > /etc/resolv.conf.tail.tmpl
chmod 666 /etc/resolv.conf.*
ln -s /etc/resolv.conf.tail.tmpl /etc/resolv.conf.tail
