#!/bin/sh

# The env command retrieves the current environment variables.
# msg=$(env)
# logger -t dhcp $msg

[ "$ACTION" == "update" ] && exit 0

ignored_macaddrs_file=$(uci -q get telegramopenwrt.global.ignored_macaddrs_file)
if grep -q "$MACADDR" $ignored_macaddrs_file; then
	echo "Ignored macaddr found in ignore list"
    exit 0
fi

# python3 /root/telegram-openwrt/notify-on-hotplug-dhcp.py
# exit 0

msg=$(echo -e "DHCP Event\nACTION: $ACTION\nHOSTNAME: $HOSTNAME\nIP: $IPADDR\nMAC: $MACADDR")
/sbin/telebot "$msg"

[ "$ACTION" == "add" ] || exit 0

known_macs=$(uci -q get telegramopenwrt.global.known_macaddrs_file)
if ! grep -iq "$MACADDR" "$known_macs"; then
    echo "$MACADDR $IPADDR $HOSTNAME" >> "$known_macs"
    msg="IP $IPADDR assigned to a new device ($HOSTNAME) with MAC addr $MACADDR"
	# msg=$(echo "*Device:* ${name}"$'\n'"*Data:* ${date}"$'\n'"*IP:* ${ip}"$'\n'"*MACADDR:* ${macaddr}")
	/sbin/telebot "$msg"
else
	echo "Ignored macaddr found in ignore list"
fi

exit 0