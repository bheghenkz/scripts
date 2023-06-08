#!/bin/bash

sudo apt install jq -y

echo "[VMESS][Step 1/4] Downloading scripts..."

curl -sS DOMAIN/scripts/vmess/create.sh --output /usr/bin/vmess-create-account
curl -sS DOMAIN/scripts/vmess/renew.sh --output /usr/bin/vmess-renew-account
curl -sS DOMAIN/scripts/vmess/delete.sh --output /usr/bin/vmess-delete-account

echo "[VMESS][Step 2/4] Scripts has been successfully downloaded"

sleep 1

echo "[VMESS][Step 3/4] Applying permission..."

chmod +x /usr/bin/vmess-create-account
chmod +x /usr/bin/vmess-renew-account
chmod +x /usr/bin/vmess-delete-account

echo "[VMESS][Step 4/4] Permission has been successfully applied"
