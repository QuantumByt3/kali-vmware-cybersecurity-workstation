#!/usr/bin/env bash

# Installs and verifies a focused CTF tool profile for this Kali workstation.
# The script installs only missing packages from the configured Kali
# repositories. It does not add third-party repositories or remove packages.

set -Eeuo pipefail

PASS=0
WARN=0
FAIL=0
INFO=0

PACKAGES=(
    gobuster
    ffuf
    feroxbuster
    dirsearch
    hydra
    john
    hashcat
    sqlmap
    nikto
    whatweb
    enum4linux
    smbclient
    netexec
    python3-impacket
    bloodhound.py
    responder
    evil-winrm
    exploitdb
    metasploit-framework
    radare2
    gdb
    checksec
    binutils-x86-64-linux-gnu
    binwalk
    libimage-exiftool-perl
)

COMMANDS=(
    gobuster
    ffuf
    feroxbuster
    dirsearch
    hydra
    john
    hashcat
    sqlmap
    nikto
    whatweb
    enum4linux
    smbclient
    rpcclient
    netexec
    impacket-smbclient
    impacket-psexec
    bloodhound-python
    responder
    evil-winrm
    searchsploit
    msfconsole
    radare2
    gdb
    checksec
    strings
    binwalk
    exiftool
)

write_result() {
    local status="$1"
    local check="$2"
    local message="$3"

    case "$status" in
        PASS) ((PASS+=1)) ;;
        WARN) ((WARN+=1)) ;;
        FAIL) ((FAIL+=1)) ;;
        INFO) ((INFO+=1)) ;;
    esac

    printf '[%s] %s - %s\n' "$status" "$check" "$message"
}

finish() {
    printf '\n'
    printf '===============================================\n'
    printf ' CTF Tool Profile Summary\n'
    printf '===============================================\n'
    printf 'PASS : %s\n' "$PASS"
    printf 'WARN : %s\n' "$WARN"
    printf 'FAIL : %s\n' "$FAIL"
    printf 'INFO : %s\n' "$INFO"
    printf '\n'

    if (( FAIL > 0 )); then
        printf 'Overall Result: CTF TOOL PROFILE NEEDS ATTENTION\n'
        exit 1
    fi

    if (( WARN > 0 )); then
        printf 'Overall Result: CTF TOOLS READY WITH REVIEW ITEMS\n'
        exit 0
    fi

    printf 'Overall Result: CTF TOOL PROFILE VERIFIED\n'
    exit 0
}

printf '\n'
printf '===============================================\n'
printf ' Kali CTF Tool Profile Setup\n'
printf '===============================================\n'
printf '\n'

# Confirm Kali Linux.
if [[ ! -r /etc/os-release ]]; then
    write_result FAIL "Operating system" "/etc/os-release could not be read"
    finish
fi

# shellcheck disable=SC1091
source /etc/os-release

if [[ "${ID:-}" == "kali" ]]; then
    write_result PASS "Operating system" "${PRETTY_NAME:-Kali Linux} detected"
else
    write_result FAIL "Operating system" "This script is intended for Kali Linux"
    finish
fi

# Require a normal user account.
if (( EUID == 0 )); then
    write_result FAIL "User context" "Do not run this script as root or with sudo"
    finish
fi

write_result PASS "User context" "Running as user: ${USER:-$(id -un)}"

# Confirm sudo before package work.
if ! command -v sudo >/dev/null 2>&1; then
    write_result FAIL "sudo" "sudo is not available"
    finish
fi

if ! sudo -v; then
    write_result FAIL "sudo" "Administrative authorization failed"
    finish
fi

write_result PASS "sudo" "Administrative authorization is available"

# Refresh package metadata.
printf '\nRefreshing package information...\n\n'

if sudo apt update; then
    write_result PASS "APT update" "Package information refreshed successfully"
else
    write_result FAIL "APT update" "apt update failed"
    finish
fi

printf '\n--- Package Review ---\n'

MISSING_PACKAGES=()

for package in "${PACKAGES[@]}"; do
    if dpkg-query -W -f='${Status}\n' "$package" 2>/dev/null |
        grep -q '^install ok installed$'; then
        write_result PASS "$package" "Package is already installed"
        continue
    fi

    candidate="$(
    apt-cache policy "$package" 2>/dev/null |
        awk '/Candidate:/ {candidate=$2} END {print candidate}'
)"

    if [[ -z "$candidate" || "$candidate" == "(none)" ]]; then
        write_result FAIL "$package" "No install candidate is available from the configured repositories"
        continue
    fi

    write_result INFO "$package" "Missing; repository candidate: $candidate"
    MISSING_PACKAGES+=("$package")
done

if (( FAIL > 0 )); then
    write_result FAIL "Package availability" "One or more required CTF packages are unavailable"
    finish
fi

if (( ${#MISSING_PACKAGES[@]} == 0 )); then
    write_result PASS "Package installation" "All focused CTF packages are already installed"
else
    printf '\nThe following focused CTF packages are missing:\n\n'
    printf '  %s\n' "${MISSING_PACKAGES[@]}"
    printf '\n'

    read -r -p "Install the missing CTF packages now? [y/N]: " RESPONSE

    case "$RESPONSE" in
        y|Y|yes|YES|Yes)
            ;;
        *)
            write_result FAIL "Package installation" "Installation was cancelled; required CTF packages remain missing"
            finish
            ;;
    esac

    printf '\nInstalling missing CTF packages...\n\n'

    if sudo apt install -y "${MISSING_PACKAGES[@]}"; then
        write_result PASS "Package installation" "Missing CTF packages installed successfully"
    else
        write_result FAIL "Package installation" "apt install failed"
        finish
    fi
fi

printf '\n--- Command Verification ---\n'

for command_name in "${COMMANDS[@]}"; do
    if command_path="$(command -v "$command_name" 2>/dev/null)"; then
        write_result PASS "$command_name" "Available at $command_path"
    else
        write_result FAIL "$command_name" "Command was not found after package verification"
    fi
done

# NetExec is the maintained command used by this profile.
if command -v netexec >/dev/null 2>&1; then
    write_result INFO "SMB/AD workflow" "NetExec is available; CrackMapExec is not required by this profile"
fi

# Report broad Kali metapackages without forcing them onto the workstation.
for metapackage in \
    kali-tools-web \
    kali-tools-passwords \
    kali-tools-exploitation \
    kali-tools-information-gathering \
    kali-tools-vulnerability \
    kali-tools-forensics \
    kali-tools-reverse-engineering
do
    if dpkg-query -W -f='${Status}\n' "$metapackage" 2>/dev/null |
        grep -q '^install ok installed$'; then
        write_result INFO "$metapackage" "Metapackage is installed"
    else
        write_result INFO "$metapackage" "Metapackage is not required by this focused profile"
    fi
done

write_result INFO "Repository policy" "No third-party APT repositories were added"
write_result INFO "Profile policy" "Focused tools are installed individually instead of forcing large Kali metapackages"
write_result INFO "Authorized use" "Use these tools only in systems, labs, and CTFs you are authorized to test"

finish
