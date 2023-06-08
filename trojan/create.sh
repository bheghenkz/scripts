#!/bin/bash

USERNAME=$1
EXPIRED_AT=$2

DOMAIN=$(cat /usr/local/etc/xray/domain)
ISP=$(cat /usr/local/etc/xray/org)
CITY=$(cat /usr/local/etc/xray/city)

# shellcheck disable=SC2002
TLS="443"
# shellcheck disable=SC2002
NTLS="80"
UUID=$(cat /proc/sys/kernel/random/uuid)
TROJAN_LINK_TLS="trojan://${UUID}@${DOMAIN}:${TLS}?path=/trojan&security=tls&host=${DOMAIN}&type=ws&sni=${DOMAIN}#${USERNAME}"
TROJAN_LINK_GRPC="trojan://${UUID}@${DOMAIN}:${TLS}?security=tls&encryption=none&type=grpc&serviceName=trojan-grpc&sni=${DOMAIN}#${USERNAME}"
TROJAN_LINK_NTLS="trojan://${UUID}@${DOMAIN}:${NTLS}?path=/trojan&security=none&host=${DOMAIN}&type=ws#${USERNAME}"

# shellcheck disable=SC2027
# shellcheck disable=SC2086
# shellcheck disable=SC1004
sed -i '/#trojan$/a\#& '"$USERNAME $EXPIRED_AT"'\
},{"password": "'""${UUID}""'","email": "'""${USERNAME}""'"' /usr/local/etc/xray/config.json
# shellcheck disable=SC2027
# shellcheck disable=SC2086
# shellcheck disable=SC1004
sed -i '/#trojan-grpc$/a\#& '"$USERNAME $EXPIRED_AT"'\
},{"password": "'""${UUID}""'","email": "'""${USERNAME}""'"' /usr/local/etc/xray/config.json

systemctl restart xray > /dev/null 2>&1

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "           TROJAN ACCOUNT"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Remarks       : ${USERNAME}"
echo "ISP           : ${ISP}"
echo "CITY          : ${CITY}"
echo "HOST/IP       : ${DOMAIN}"
echo "Wildcard      : (bug.com).${DOMAIN}"
echo "Port TLS      : ${TLS}"
echo "Port none TLS : ${NTLS}"
echo "Port gRPC     : ${TLS}"
echo "Alt Port TLS  : 2053, 2083, 2087, 2096, 8443"
echo "Alt Port NTLS : 8080, 8880, 2052, 2082, 2086, 2095"
echo "Key           : ${UUID}"
echo "Path          : /trojan"
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
