#!/bin/sh

if [ "$ACTION" != "add" ]; then
  exit 1
fi

. `dirname $0`/config.sh

# create work dirs
[ ! -e "$DROPKOBOX" ] && mkdir -p "$DROPKOBOX" >/dev/null 2>&1
[ ! -e "$LIBRARY" ] && mkdir -p "$LIBRARY" >/dev/null 2>&1
[ ! -e "$SD" ] && mkdir -p "$SD" >/dev/null 2>&1

#check if dropkoboxrc contains the line "UNINSTALL"
if grep -q '^UNINSTALL$' $CONFIG; then
    echo "Uninstalling DropKoBox!" > $DROPKOBOX/dropkobox.log
    rm -f /etc/udev/rules.d/97-dropkobox.rules
    rm -rf /usr/local/dropkobox/
    exit 0
fi

echo "Call python code" > $DROPKOBOX/dropkobox.log
# run python script
/usr/bin/python3 `dirname $0`/dropkobox.py $LIBRARY $CONFIG &> $DROPKOBOX/dropkobox.log

#bind mount to subfolder of SD card (library refresh trick)
mountpoint -q "$SD"
if [ $? -ne 0 ]; then
  echo "Bind mounting to SD" >> $DROPKOBOX/dropkobox.log
  mount --bind "$LIBRARY" "$SD"
fi
echo sd add /dev/mmcblk1p1 >> /tmp/nickel-hardware-status


