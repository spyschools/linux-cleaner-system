# Clean Linux System

A Bash script that cleans up logs, package caches, developer caches, browser data, temporary files, and shell history on Kali Linux (and other Debian-based distributions).

**Author:** Spy Schools / Fariz Azhari
**GitHub:** [github.com/spyschools](https://github.com/spyschools)

---

## ⚠️ Warning

This script **permanently deletes data**. Read this section before running it.

- Deletes **browser profiles** for Chrome, Firefox, and Chromium, including bookmarks, saved passwords, extensions, and history.
- Deletes **all `node_modules` folders** and **all `package-lock.json` files** under your home directory.
- Deletes the entire `~/.cache` folder, Trash, `/tmp`, and `/var/tmp`.
- Deletes APT package lists and APT/dpkg lock files. Removing locks while `apt` or `dpkg` is running can corrupt your package database.
- Deletes `~/.bash_history`.
- Removes `__pycache__` folders **system-wide**.

Back up anything important first. Use at your own risk.

---

## What It Does

The script runs 32 steps in order:

| Steps | Action |
|-------|--------|
| 1-2 | Vacuum systemd journal logs (older than 5 days, max size 1G) |
| 3 | Check for running `apt` processes |
| 4-9 | Remove APT cache files and APT/dpkg lock files |
| 10-11 | Remove APT package lists and reconfigure pending dpkg packages |
| 12-14 | Clean Go module cache and build cache |
| 15-17 | Remove `node_modules`, `package-lock.json`, and npm cache |
| 18-20 | Remove `__pycache__` folders and purge pip cache |
| 21-23 | Remove Chrome, Firefox, and Chromium data |
| 24-26 | Empty Trash, `~/.cache`, and thumbnails |
| 27-29 | Clear `/tmp`, `/var/tmp`, and old compressed/rotated logs |
| 30 | `apt autoremove --purge`, `autoclean`, and `clean` |
| 31-32 | Remove bash history file and clear current session history |

---

## Requirements

- Kali Linux or another Debian-based distribution
- Bash
- A user with `sudo` privileges

Optional tools (steps are skipped or may show a harmless error if missing): `go`, `npm`, `pip3`.

---

## Installation

```bash
git clone https://github.com/spyschools/linux-cleaner-system.git
cd linux-cleaner-system
chmod +x clean-linux-system.sh
```

## Usage

```bash
sudo ./clean-linux-system.sh
```

The script asks for confirmation before it starts, and again if it detects running `apt`/`dpkg` processes.

To make the history-clearing step (step 32) affect your **current terminal**, run the script with `source`:

```bash
source clean-linux-system.sh
```

Or run this manually after the script finishes:

```bash
history -c && history -w
```

---

## Notes

- The script does **not** use `set -e`, so a failed step will not stop the remaining steps.
- Because APT package lists are deleted (step 10), `apt install` will not find packages until you run `sudo apt update` yourself. The script does not run it for you.
- Close other applications before running. Clearing `/tmp` can disrupt running programs.
- The script uses `$HOME`, so it cleans the home directory of the user who runs it.

---

## Disclaimer

This script is provided "as is", without warranty of any kind. The author is not responsible for any data loss or system damage. Review the script and understand each command before running it.

---

## License

Released under the MIT License. Feel free to use, modify, and share, and please keep the author credit.

---

## Author

**Spy Schools / Fariz Azhari**
[github.com/spyschools](https://github.com/spyschools)
