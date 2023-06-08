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
TLS="$(cat ~/log-install.txt | grep -w "Vless WS TLS" | cut -d: -f2 | sed 's/ //g')"
# shellcheck disable=SC2002
NTLS="$(cat ~/log-install.txt | grep -w "Vless WS none TLS" | cut -d: -f2 | sed 's/ //g')"
UUID=$(cat /proc/sys/kernel/random/uuid)
VLESS_LINK_TLS="vless://${UUID}@${DOMAIN}:${TLS}?path=/vless&security=tls&encryption=none&type=ws#${USERNAME}"
VLESS_LINK_NTLS="vless://${UUID}@${DOMAIN}:${NTLS}?path=/vless&encryption=none&type=ws#${USERNAME}"
VLESS_LINK_GRPC="vless://${UUID}@${DOMAIN}:${TLS}?mode=gun&security=tls&encryption=none&type=grpc&serviceName=vless-grpc&sni=bug.com#${USERNAME}"

# shellcheck disable=SC2027
# shellcheck disable=SC2086
# shellcheck disable=SC1004
sed -i '/#vless$/a\#& '"${USERNAME} ${EXPIRED_AT}"'\
},{"id": "'""${UUID}""'","email": "'""${USERNAME}""'"' /etc/xray/config.json
# shellcheck disable=SC2027
# shellcheck disable=SC2086
# shellcheck disable=SC1004
sed -i '/#vlessgrpc$/a\#& '"${USERNAME} ${EXPIRED_AT}"'\
},{"id": "'""${UUID}""'","email": "'""${USERNAME}""'"' /etc/xray/config.json

systemctl restart xray > /dev/null 2>&1

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "        Vless Account"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Remarks        : ${USERNAME}"
echo "Domain         : ${DOMAIN}"
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
