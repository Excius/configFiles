#!/bin/bash

DISCORD_URL="https://discord.com/api/download/stable?platform=linux&format=deb"
SYSTEM_FILE="/usr/share/applications/discord.desktop"

TMP_DIR="/tmp/discord.deb"

echo "Downloading latest Discord package"
wget -O "$TMP_DIR" "$DISCORD_URL"

if [ $? -ne 0 ]; then
  echo "Failed to download Discord package"
  exit 1
fi

echo "Installing Discord"
sudo dpkg -i "$TMP_DIR"

sudo apt-get install -f -y

rm "$TMP_DIR"

echo "Discord installed successfully"

echo "Patching Exec= line in $SYSTEM_FILE"
sudo sed -i 's|^Exec=.*|Exec=sh -c "/usr/share/discord/Discord > /dev/null 2>\&1"|' "$SYSTEM_FILE"

echo "✅ Discord desktop entry patched successfully!"
