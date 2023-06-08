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


# shellcheck disable=SC2027
# shellcheck disable=SC2086
# shellcheck disable=SC1004
sed -i '/#vmess$/a\#@ '"${USERNAME} ${EXPIRED_AT}"'\
},{"id": "'""${UUID}""'","alterId": '"0"',"email": "'""${USERNAME}""'"' /usr/local/etc/xray/config.json
# shellcheck disable=SC2027
# shellcheck disable=SC2086
# shellcheck disable=SC1004
sed -i '/#vmess-grpc$/a\#@ '"${USERNAME} ${EXPIRED_AT}"'\
},{"id": "'""${UUID}""'","alterId": '"0"',"email": "'""${USERNAME}""'"' /usr/local/etc/xray/config.json


JSON_TLS=$(jq -n \
    --arg username "${USERNAME}" \
    --arg domain "${DOMAIN}" \
    --arg uuid "${UUID}" \
    '{v: "2", ps: $username, add: $domain, port: "443", id: $uuid, aid: "0", net: "ws", path: "/vmess", type: "none", host: "", tls: "tls"}')
JSON_NTLS=$(jq -n \
    --arg username "${USERNAME}" \
    --arg domain "${DOMAIN}" \
    --arg uuid "${UUID}" \
    '{v: "2", ps: $username, add: $domain, port: "80", id: $uuid, aid: "0", net: "ws", path: "/vmess", type: "none", host: "", tls: "none"}')
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
echo "ISP            : ${ISP}"
echo "City           : ${CITY}"
echo "Domain         : ${DOMAIN}"
echo "Wildcard       : (bug.com).${DOMAIN}"
echo "Port TLS       : ${TLS}"
echo "Port none TLS  : ${NTLS}"
echo "Port gRPC      : ${TLS}"
echo "Alt Port TLS   : 2053, 2083, 2087, 2096, 8443"
echo "Alt Port NTLS  : 8080, 8880, 2052, 2082, 2086, 2095"
echo "id             : ${UUID}"
echo "alterId        : 0"
echo "Security       : auto"
echo "Network        : ws"
echo "Path           : /(multipath) • ubah suka-suka"
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
