#!/bin/bash

echo "[SSH][Step 1/4] Downloading scripts..."

curl -sS https://raw.githubusercontent.com/bheghenkz/scripts/main/ssh/create.sh --output /usr/bin/ssh-create-account
curl -sS https://raw.githubusercontent.com/bheghenkz/scripts/main/ssh/renew.sh --output /usr/bin/ssh-renew-account
curl -sS https://raw.githubusercontent.com/bheghenkz/scripts/main/ssh/password.sh --output /usr/bin/ssh-password-account
curl -sS https://raw.githubusercontent.com/bheghenkz/scripts/main/ssh/delete.sh --output /usr/bin/ssh-delete-account

echo "[SSH][Step 2/4] Scripts has been successfully downloaded"

sleep 1

echo "[SSH][Step 3/4] Applying permission..."

chmod +x /usr/bin/ssh-create-account
chmod +x /usr/bin/ssh-renew-account
chmod +x /usr/bin/ssh-password-account
chmod +x /usr/bin/ssh-delete-account

echo "[SSH][Step 4/4] Permission has been successfully applied"
