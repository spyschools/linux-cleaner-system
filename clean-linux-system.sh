#!/bin/bash
# ==============================================================
#  Script Name : Clean Linux System
#  File Name   : clean-linux-system.sh
#  Author      : Spy Schools / Fariz Azhari
#  Description : Cleans logs, package caches, dev caches, browser
#                data, temp files, and shell history on Kali Linux.
#  Usage       : chmod +x clean-linux-system.sh && ./clean-linux-system.sh
# ==============================================================

# No "set -e" so one failed step does not stop the others
USER_HOME="${HOME}"
step() { echo -e "\n[$1] $2"; }

echo "=============================================="
echo "  Clean Linux System"
echo "  Author: Spy Schools / Fariz Azhari"
echo "=============================================="
echo "WARNING: This script deletes browser profiles (bookmarks, passwords,"
echo "history), node_modules, package-lock.json, caches, /tmp, and terminal history."
read -rp "Continue? (y/N): " answer
[[ "$answer" =~ ^[Yy]$ ]] || { echo "Cancelled."; exit 0; }

sudo -v || exit 1

step 1 "Remove journal logs older than 5 days"
sudo journalctl --vacuum-time=5d

step 2 "Limit journal size to 1G"
sudo journalctl --vacuum-size=1G

step 3 "Check running apt processes"
ps aux | grep '[a]pt'
if pgrep -f "apt|apt-get|dpkg" >/dev/null 2>&1; then
    echo "!! apt/dpkg processes are still running. Removing locks now may corrupt packages."
    read -rp "Continue anyway? (y/N): " proceed
    [[ "$proceed" =~ ^[Yy]$ ]] || exit 1
fi

step 4 "Remove pkgcache.bin"
sudo rm -f /var/cache/apt/pkgcache.bin

step 5 "Remove srcpkgcache.bin"
sudo rm -f /var/cache/apt/srcpkgcache.bin

step 6 "Remove apt lists lock"
sudo rm -f /var/lib/apt/lists/lock

step 7 "Remove apt archives lock"
sudo rm -f /var/cache/apt/archives/lock

step 8 "Remove dpkg lock-frontend"
sudo rm -f /var/lib/dpkg/lock-frontend

step 9 "Remove dpkg lock"
sudo rm -f /var/lib/dpkg/lock

step 10 "Remove apt package lists"
sudo rm -rf /var/lib/apt/lists/*

step 11 "Reconfigure pending dpkg packages"
sudo dpkg --configure -a

step 12 "Clean Go module cache"
if command -v go >/dev/null 2>&1; then
    sudo go clean -modcache
else
    echo "Go is not installed, skipped."
fi

step 13 "Remove Go pkg/mod"
sudo rm -rf "$USER_HOME/go/pkg/mod"

step 14 "Remove Go build cache"
sudo rm -rf "$USER_HOME/.cache/go-build"

step 15 "Remove all node_modules folders in home"
find "$USER_HOME" -type d -name node_modules -prune -exec sudo rm -rf {} + 2>/dev/null

step 16 "Remove all package-lock.json files in home"
find "$USER_HOME" -type f -name package-lock.json -exec sudo rm -f {} + 2>/dev/null

step 17 "Remove npm cache"
sudo rm -rf "$USER_HOME/.npm"

step 18 "Remove __pycache__ in home"
find "$USER_HOME" -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null

step 19 "Remove __pycache__ system-wide"
sudo find / -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null

step 20 "Purge pip cache"
pip3 cache purge

step 21 "Remove Google Chrome data"
sudo rm -rf "$USER_HOME/.cache/google-chrome/" "$USER_HOME/.config/google-chrome/"

step 22 "Remove Firefox data"
sudo rm -rf "$USER_HOME/.cache/mozilla/firefox/" "$USER_HOME/.mozilla/firefox/"

step 23 "Remove Chromium data"
sudo rm -rf "$USER_HOME/.cache/chromium/" "$USER_HOME/.config/chromium/"

step 24 "Empty Trash"
sudo rm -rf "$USER_HOME/.local/share/Trash/"*

step 25 "Remove all of ~/.cache"
sudo rm -rf "$USER_HOME/.cache/"*

step 26 "Remove thumbnails"
sudo rm -rf "$USER_HOME/.cache/thumbnails/"*

step 27 "Remove /tmp contents"
sudo rm -rf /tmp/*

step 28 "Remove /var/tmp contents"
sudo rm -rf /var/tmp/*

step 29 "Remove old logs (.gz and .old)"
sudo rm -f /var/log/*.gz /var/log/*.old

step 30 "Clean apt packages"
sudo apt autoremove --purge -y
sudo apt autoclean
sudo apt clean

step 31 "Remove bash history file"
rm -f "$USER_HOME/.bash_history"

step 32 "Clear current session history"
history -c && history -w

echo -e "\nDone. System cleanup completed."
