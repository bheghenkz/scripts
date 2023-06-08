#!/bin/bash

echo "[TROJAN][Step 1/4] Downloading scripts..."

curl -sS DOMAIN/scripts/trojan/create.sh --output /usr/bin/trojan-create-account
curl -sS DOMAIN/scripts/trojan/renew.sh --output /usr/bin/trojan-renew-account
curl -sS DOMAIN/scripts/trojan/delete.sh --output /usr/bin/trojan-delete-account

echo "[TROJAN][Step 2/4] Scripts has been successfully downloaded"

sleep 1

echo "[TROJAN][Step 3/4] Applying permission..."

chmod +x /usr/bin/trojan-create-account
chmod +x /usr/bin/trojan-renew-account
chmod +x /usr/bin/trojan-delete-account

echo "[TROJAN][Step 4/4] Permission has been successfully applied"
