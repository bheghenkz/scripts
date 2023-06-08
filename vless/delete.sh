#!/bin/bash

USERNAME=$1
EXPIRED_AT=$2

sed -i "/^#& ${USERNAME} ${EXPIRED_AT}/,/^},{/d" /etc/xray/config.json

systemctl restart xray > /dev/null 2>&1
