#!/usr/bin/env bash

set -euo pipefail

echo "================================="
echo " Arch Linux Maintenance Script"
echo "================================="

# Check internet connectivity
echo
echo "[1/8] Checking internet connection..."
ping -c 1 archlinux.org >/dev/null

# Refresh keyrings
echo
echo "[2/8] Updating Arch keyrings..."
sudo pacman -Sy --needed archlinux-keyring

# Full system upgrade
echo
echo "[3/8] Updating system..."
sudo pacman -Syu

# Update AUR packages if yay or paru exists
echo
echo "[4/8] Checking AUR helper..."

if command -v yay >/dev/null 2>&1; then
    echo "Updating AUR packages with yay..."
    yay -Sua --noconfirm
elif command -v paru >/dev/null 2>&1; then
    echo "Updating AUR packages with paru..."
    paru -Sua --noconfirm
else
    echo "No AUR helper found."
fi

# Remove orphaned packages
echo
echo "[5/8] Removing orphaned packages..."

orphans="$(pacman -Qdtq || true)"

if [[ -n "$orphans" ]]; then
    sudo pacman -Rns $orphans
else
    echo "No orphaned packages found."
fi

# Clean package cache
echo
echo "[6/8] Cleaning package cache..."
sudo pacman -Sc --noconfirm

# Clean old journal logs
echo
echo "[7/8] Cleaning old journal logs..."
sudo journalctl --vacuum-time=30d

# Verify installed packages
echo
echo "[8/8] Verifying package integrity..."
pacman -Qk

echo
echo "================================="
echo " System Status"
echo "================================="

echo
echo "Disk usage:"
df -h /

echo
echo "Failed services:"
systemctl --failed || true

echo
echo "Recent system errors:"
journalctl -p 3 -xb --no-pager || true

echo
echo "Maintenance complete."
