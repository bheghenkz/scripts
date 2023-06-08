#!/bin/bash

echo "[VLESS][Step 1/4] Downloading scripts..."

curl -sS DOMAIN/scripts/vless/create.sh --output /usr/bin/vless-create-account
curl -sS DOMAIN/scripts/vless/renew.sh --output /usr/bin/vless-renew-account
curl -sS DOMAIN/scripts/vless/delete.sh --output /usr/bin/vless-delete-account

echo "[VLESS][Step 2/4] Scripts has been successfully downloaded"

sleep 1

echo "[VLESS][Step 3/4] Applying permission..."

chmod +x /usr/bin/vless-create-account
chmod +x /usr/bin/vless-renew-account
chmod +x /usr/bin/vless-delete-account

echo "[VLESS][Step 4/4] Permission has been successfully applied"
