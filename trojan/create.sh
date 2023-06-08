#!/bin/bash

USERNAME=$1
EXPIRED_AT=$2

source /var/lib/ipvps.conf

if [[ "$IP" = "" ]]; then
    DOMAIN=$(cat /etc/xray/domain)
else
    DOMAIN=$IP
fi

# shellcheck disable=SC2002
TLS="$(cat ~/log-install.txt | grep -w "Trojan WS TLS" | cut -d: -f2 | sed 's/ //g')"
# shellcheck disable=SC2002
NTLS="$(cat ~/log-install.txt | grep -w "Trojan WS none TLS" | cut -d: -f2 | sed 's/ //g')"
UUID=$(cat /proc/sys/kernel/random/uuid)
TROJAN_LINK_TLS="trojan://${UUID}@isi_bug_disini:${TLS}?path=%2Ftrojan-ws&security=tls&host=${DOMAIN}&type=ws&sni=${DOMAIN}#${USERNAME}"
TROJAN_LINK_GRPC="trojan://${UUID}@${DOMAIN}:${TLS}?mode=gun&security=tls&type=grpc&serviceName=trojan-grpc&sni=bug.com#${USERNAME}"
TROJAN_LINK_NTLS="trojan://${UUID}@isi_bug_disini:${NTLS}?path=%2Ftrojan-ws&security=none&host=${DOMAIN}&type=ws#${USERNAME}"

# shellcheck disable=SC2027
# shellcheck disable=SC2086
# shellcheck disable=SC1004
sed -i '/#trojanws$/a\#! '"$USERNAME $EXPIRED_AT"'\
},{"password": "'""${UUID}""'","email": "'""${USERNAME}""'"' /etc/xray/config.json
# shellcheck disable=SC2027
# shellcheck disable=SC2086
# shellcheck disable=SC1004
sed -i '/#trojangrpc$/a\#! '"$USERNAME $EXPIRED_AT"'\
},{"password": "'""${UUID}""'","email": "'""${USERNAME}""'"' /etc/xray/config.json

systemctl restart xray > /dev/null 2>&1

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "           TROJAN ACCOUNT"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Remarks       : ${USERNAME}"
echo "Host/IP       : ${DOMAIN}"
echo "Wildcard      : (bug.com).${DOMAIN}"
echo "Port TLS      : ${TLS}"
echo "Port none TLS : ${NTLS}"
echo "Port gRPC     : ${TLS}"
echo "Key           : ${UUID}"
echo "Path          : /trojan-ws"
echo "ServiceName   : trojan-grpc"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Link TLS      : ${TROJAN_LINK_TLS}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Link none TLS : ${TROJAN_LINK_NTLS}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Link gRPC     : ${TROJAN_LINK_GRPC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Expired At    : ${EXPIRED_AT} "
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
