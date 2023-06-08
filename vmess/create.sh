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
TLS="$(cat ~/log-install.txt | grep -w "Vmess WS TLS" | cut -d: -f2 | sed 's/ //g')"
# shellcheck disable=SC2002
NTLS="$(cat ~/log-install.txt | grep -w "Vmess WS none TLS" | cut -d: -f2 | sed 's/ //g')"
UUID=$(cat /proc/sys/kernel/random/uuid)


# shellcheck disable=SC2027
# shellcheck disable=SC2086
# shellcheck disable=SC1004
sed -i '/#vmess$/a\### '"${USERNAME} ${EXPIRED_AT}"'\
},{"id": "'""${UUID}""'","alterId": '"0"',"email": "'""${USERNAME}""'"' /etc/xray/config.json
# shellcheck disable=SC2027
# shellcheck disable=SC2086
# shellcheck disable=SC1004
sed -i '/#vmessgrpc$/a\### '"${USERNAME} ${EXPIRED_AT}"'\
},{"id": "'""${UUID}""'","alterId": '"0"',"email": "'""${USERNAME}""'"' /etc/xray/config.json


JSON_TLS=$(jq -n \
    --arg username "${USERNAME}" \
    --arg domain "${DOMAIN}" \
    --arg uuid "${UUID}" \
    '{v: "2", ps: $username, add: $domain, port: "443", id: $uuid, aid: "0", net: "ws", path: "/vmess", type: "none", host: "", tls: "tls"}')
JSON_NTLS=$(jq -n \
    --arg username "${USERNAME}" \
    --arg domain "${DOMAIN}" \
    --arg uuid "${UUID}" \
    '{v: "2", ps: $username, add: $domain, port: "80", id: $uuid, aid: "0", net: "ws", path: "/vmess", type: "none", host: "", tls: "tls"}')
JSON_GRPC=$(jq -n \
    --arg username "${USERNAME}" \
    --arg domain "${DOMAIN}" \
    --arg uuid "${UUID}" \
    '{v: "2", ps: $username, add: $domain, port: "443", id: $uuid, aid: "0", net: "grpc", path: "vmess-grpc", type: "none", host: "", tls: "tls"}')
VMESS_LINK_TLS="vmess://$(echo ${JSON_TLS} | base64 -w 0)"
VMESS_LINK_NTLS="vmess://$(echo ${JSON_NTLS} | base64 -w 0)"
VMESS_LINK_GRPC="vmess://$(echo ${JSON_GRPC} | base64 -w 0)"

systemctl restart xray > /dev/null 2>&1

service cron restart > /dev/null 2>&1

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "        Vmess Account"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Remarks        : ${USERNAME}"
echo "Domain         : ${DOMAIN}"
echo "Wildcard       : (bug.com).${DOMAIN}"
echo "Port TLS       : ${TLS}"
echo "Port none TLS  : ${NTLS}"
echo "Port gRPC      : ${TLS}"
echo "id             : ${UUID}"
echo "alterId        : 0"
echo "Security       : auto"
echo "Network        : ws"
echo "Path           : /vmess"
echo "ServiceName    : vmess-grpc"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Link TLS       : ${VMESS_LINK_TLS}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Link none TLS  : ${VMESS_LINK_NTLS}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Link gRPC      : ${VMESS_LINK_GRPC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Expired On     : ${EXPIRED_AT}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
