#!/bin/bash

USERNAME=$1
EXPIRED_AT=$2

source /var/lib/dnsvps.conf

if [[ "$DNS" = "" ]]; then
    DOMAIN=$(cat /usr/local/etc/xray/domain)
else
    DOMAIN=$DNS
fi

ISP=$(cat /usr/local/etc/xray/org)
CITY=$(cat /usr/local/etc/xray/city)
# shellcheck disable=SC2002
TLS="443"
# shellcheck disable=SC2002
NTLS="80"
UUID=$(cat /proc/sys/kernel/random/uuid)
VLESS_LINK_TLS="vless://${UUID}@${DOMAIN}:${TLS}?path=/vless&security=tls&encryption=none&host=${DOMAIN}&type=ws&sni=${DOMAIN}#${USERNAME}"
VLESS_LINK_NTLS="vless://${UUID}@${DOMAIN}:${NTLS}?path=/vless&security=none&encryption=none&host=${DOMAIN}&type=ws#${USERNAME}"
VLESS_LINK_GRPC="vless://${UUID}@${DOMAIN}:${TLS}?security=tls&encryption=none&type=grpc&serviceName=vless-grpc&sni=${DOMAIN}#${USERNAME}"

# shellcheck disable=SC2027
# shellcheck disable=SC2086
# shellcheck disable=SC1004
sed -i '/#vless$/a\#= '"${USERNAME} ${EXPIRED_AT}"'\
},{"id": "'""${UUID}""'","email": "'""${USERNAME}""'"' /usr/local/etc/xray/config.json
# shellcheck disable=SC2027
# shellcheck disable=SC2086
# shellcheck disable=SC1004
sed -i '/#vless-grpc$/a\#= '"${USERNAME} ${EXPIRED_AT}"'\
},{"id": "'""${UUID}""'","email": "'""${USERNAME}""'"' /usr/local/etc/xray/config.json

systemctl restart xray > /dev/null 2>&1

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "        Vless Account"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Remarks        : ${USERNAME}"
echo "Domain         : ${DOMAIN}"
echo "ISP            : ${ISP}"
echo "City           : ${CITY}"
echo "Wildcard       : (bug.com).${DOMAIN}"
echo "Port TLS       : ${TLS}"
echo "Port none TLS  : ${NTLS}"
echo "id             : ${UUID}"
echo "Encryption     : none"
echo "Network        : ws"
echo "Path           : /vless"
echo "Path           : vless-grpc"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Link TLS       : ${VLESS_LINK_TLS}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Link none TLS  : ${VLESS_LINK_NTLS}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Link gRPC      : ${VLESS_LINK_GRPC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Expired On     : ${EXPIRED_AT}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
