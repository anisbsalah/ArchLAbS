#!/bin/bash

# Checking if is running in Repo Folder
if [[ "$(basename "$(pwd)" | tr '[:upper:]' '[:lower:]')" =~ ^scripts$ ]]; then
	echo "You are running this in ArchLAbS Folder."
	echo "Please use ./archlabs.sh instead!"
	exit
fi

# Installing git
echo "[*] Installing git..."
pacman -Sy --noconfirm --needed git glibc

echo "[*] Cloning the ArchLAbS Project..."
git clone https://github.com/anisbsalah/ArchLAbS.git

echo "[*] Executing ArchLAbS Script..."

cd "${HOME}/ArchLAbS" || exit 1

exec ./archlabs.sh
