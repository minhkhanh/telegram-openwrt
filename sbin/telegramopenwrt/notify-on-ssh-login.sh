#!/bin/sh

## add cmd to end of /etc/pam.d/sshd
## custom event - send message to telegram
# session optional pam_exec.so seteuid /sbin/telegramopenwrt/notify-on-ssh-login.sh

# python3 /sbin/telegramopenwrt/notify-on-ssh-login.py
# exit 0

if [ "$PAM_TYPE" == "open_session" ]; then
	msg=$(echo -e "SSH Alert - connect\nHost: $(uname -n)\nUser: $PAM_USER\nRemote host: $PAM_RHOST\nService: $PAM_SERVICE\nTTY: $PAM_TTY")
	/sbin/telebot "$msg"
	exit 0
elif [ "$PAM_TYPE" == "close_session" ]; then
    msg=$(echo -e "SSH Alert - disconnect\nHost: $(uname -n)\nUser: $PAM_USER\nRemote host: $PAM_RHOST\nService: $PAM_SERVICE\nTTY: $PAM_TTY")
	/sbin/telebot "$msg"
    exit 0
fi