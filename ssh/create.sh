#!/bin/bash

USERNAME=$1
PASSWORD=$2
EXPIRED_AT=$3

IP=$(curl -sS ifconfig.me)
DOMAIN=$(cat /etc/xray/domain)

# shellcheck disable=SC2006
# shellcheck disable=SC2002
PORT_SSH_WS=`cat ~/log-install.txt | grep -w "SSH Websocket" | cut -d: -f2 | awk '{print $1}'`
# shellcheck disable=SC2006
# shellcheck disable=SC2002
PORT_SSH_WSS=`cat /root/log-install.txt | grep -w "SSH SSL Websocket" | cut -d: -f2 | awk '{print $1}'`
# shellcheck disable=SC2006
# shellcheck disable=SC2002
PORT_OPEN_SSH=$(cat /root/log-install.txt | grep -w "OpenSSH" | cut -f2 -d: | awk '{print $1}')
# shellcheck disable=SC2006
# shellcheck disable=SC2002
PORT_STUNNEL4="$(cat ~/log-install.txt | grep -w "Stunnel4" | cut -d: -f2)"

useradd -e "${EXPIRED_AT}" -s /bin/false -M "${USERNAME}" &> /dev/null

echo -e "${PASSWORD}\n${PASSWORD}\n" | passwd "${USERNAME}" &> /dev/null

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "            SSH Account"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Username    : ${USERNAME}"
echo "Password    : ${PASSWORD}"
echo "Expired On  : ${EXPIRED_AT}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "IP          : ${IP}"
echo "Host        : ${DOMAIN}"
echo "OpenSSH     : ${PORT_OPEN_SSH}"
echo "SSH WS      : ${PORT_SSH_WS}"
echo "SSH SSL WS  : ${PORT_SSH_WSS}"
echo "SSL/TLS     : ${PORT_STUNNEL4}"
echo "UDPGW       : 7100-7900"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Payload WSS"
echo "GET wss://isi_bug_disini HTTP/1.1[crlf]Host: ${DOMAIN}[crlf]Upgrade: websocket[crlf][crlf]"
echo "Payload WS"
echo "GET / HTTP/1.1[crlf]Host: ${DOMAIN}[crlf]Upgrade: websocket[crlf][crlf]"
