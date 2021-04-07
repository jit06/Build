#!/bin/bash
# Volumio Builder for Odroid C1

echo "=============================================================="
echo "==                       STEP 1                             =="
echo "=============================================================="

VARIANT="custom-odroidc1"

echo 'Cloning Volumio Node Backend'
git clone --depth 1 -b master --single-branch https://github.com/volumio/Volumio2.git /volumio
echo 'Cloning Volumio Classic UI'
git clone --depth 1 -b dist --single-branch https://github.com/volumio/Volumio2-UI.git "/volumio/http/www"
echo 'Cloning Volumio Contemporary UI'
git clone --depth 1 -b dist3 --single-branch https://github.com/volumio/Volumio2-UI.git "/volumio/http/www3"


echo "Adding os-release infos"
{
    echo "VOLUMIO_BUILD_VERSION=\"$(git rev-parse HEAD)\""
    echo "VOLUMIO_FE_VERSION=\"$(git --git-dir "/volumio/http/www/.git" rev-parse HEAD)\""
    echo "VOLUMIO_BE_VERSION=\"$(git --git-dir "/volumio/.git" rev-parse HEAD)\""
    echo "VOLUMIO_ARCH=\"armv7\""
} >> "/etc/os-release"
rm -rf /volumio/http/www/.git
rm -rf /volumio/http/www3/.git


echo "=============================================================="
echo "==                  Volumio config C1                       =="
echo "=============================================================="
sh scripts/volumioconfig_C1.sh

echo "Base System Installed"

echo "=============================================================="
echo "==                       STEP 2                             =="
echo "=============================================================="
###Dirty fix for mpd.conf TODO use volumio repo
cp volumio/etc/mpd.conf "/etc/mpd.conf"

CUR_DATE=$(date)
# Write some Version informations
echo "Writing system information"
echo "VOLUMIO_VARIANT=\"${VARIANT}\"
VOLUMIO_TEST=\"FALSE\"
VOLUMIO_BUILD_DATE=\"${CUR_DATE}\"
" >> "/etc/os-release"


echo "=============================================================="
echo "==                    configure C1                          =="
echo "=============================================================="
sh scripts/configure_C1.sh


echo "=============================================================="
echo "==                       STEP 3                             =="
echo "=============================================================="
echo "Cleaning man and caches"
rm -rf /usr/share/man/* /usr/share/groff/* /usr/share/info/*
rm -rf /usr/share/lintian/* /usr/share/linda/* /var/cache/man/*

echo "Stripping binaries"
find /lib/ -type f  -exec strip --strip-all > /dev/null 2>&1 {} ';'
find /bin/ -type f  -exec strip --strip-all > /dev/null 2>&1 {} ';'
find /usr/sbin -type f  -exec strip --strip-all > /dev/null 2>&1 {} ';'
find /usr/local/bin/ -type f  -exec strip --strip-all > /dev/null 2>&1 {} ';'
