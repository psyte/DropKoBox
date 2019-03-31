#!/bin/sh
#load config
. `dirname $0`/config.sh

#create work dirs
[ ! -e "$DROPKOBOX" ] && mkdir -p "$DROPKOBOX" >/dev/null 2>&1
[ ! -e "$LIBRARY" ] && mkdir -p "$LIBRARY" >/dev/null 2>&1
[ ! -e "$SD" ] && mkdir -p "$SD" >/dev/null 2>&1

if [ ! -e $CONFIG ]; then
  echo "[DropKoBox]" > $CONFIG
  echo "# Add your DropKoBox token below" >> $CONFIG
  echo "Token=xxxxyyyyyzzzz" >> $CONFIG
  echo "# Remove the # from the following line to uninstall DropKoBox" >> $CONFIG
  echo "#UNINSTALL" >> $CONFIG
fi

#bind mount to subfolder of SD card on reboot
mountpoint -q "$SD"
if [ $? -ne 0 ]; then
  mount --bind "$LIBRARY" "$SD"
  echo sd add /dev/mmcblk1p1 >> /tmp/nickel-hardware-status
fi