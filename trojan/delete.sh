#!/bin/bash

USERNAME=$1
EXPIRED_AT=$2

sed -i "/^#& ${USERNAME} ${EXPIRED_AT}/,/^},{/d" /usr/local/etc/xray/config.json

systemctl restart xray
