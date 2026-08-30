#!/usr/bin/env bash

# Installs and verifies the core tools used by this Kali workstation.
# The script installs only packages that are missing from the current system.
# It does not add third-party repositories or remove existing packages.

set -Eeuo pipefail

PASS=0
WARN=0
FAIL=0
INFO=0

PACKAGES=(
    git
    curl
    wget
    jq
    python3
    python3-venv
    pipx
    tmux
    tree
    unzip
    7zip
    build-essential
    nmap
    netcat-traditional
    socat
    tcpdump
    tshark
    wireshark
)

COMMANDS=(
    git
    curl
    wget
    jq
    python3
    pipx
    tmux
    tree
    unzip
    7z
    gcc
    make
    nmap
    nc
    socat
    tcpdump
    tshark
    wireshark
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
    printf ' Core Tool Setup Summary\n'
    printf '===============================================\n'
    printf 'PASS : %s\n' "$PASS"
    printf 'WARN : %s\n' "$WARN"
    printf 'FAIL : %s\n' "$FAIL"
    printf 'INFO : %s\n' "$INFO"
    printf '\n'

    if (( FAIL > 0 )); then
        printf 'Overall Result: CORE TOOL SETUP NEEDS ATTENTION\n'
        exit 1
    fi

    if (( WARN > 0 )); then
        printf 'Overall Result: CORE TOOLS READY WITH REVIEW ITEMS\n'
        exit 0
    fi

    printf 'Overall Result: CORE TOOLS VERIFIED\n'
    exit 0
}

printf '\n'
printf '===============================================\n'
printf ' Kali Core Tool Setup\n'
printf '===============================================\n'
printf '\n'

# Require Kali Linux.
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

# Do not run the workstation setup as root.
if (( EUID == 0 )); then
    write_result FAIL "User context" "Do not run this script as root or with sudo"
    finish
fi

write_result PASS "User context" "Running as user: ${USER:-$(id -un)}"

# Confirm sudo is available before package installation.
if ! command -v sudo >/dev/null 2>&1; then
    write_result FAIL "sudo" "sudo is not available"
    finish
fi

if ! sudo -v; then
    write_result FAIL "sudo" "Administrative authorization failed"
    finish
fi

write_result PASS "sudo" "Administrative authorization is available"

# Refresh package metadata so package availability is current.
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
            awk '/Candidate:/ {print $2; exit}'
    )"

    if [[ -z "$candidate" || "$candidate" == "(none)" ]]; then
        write_result FAIL "$package" "No install candidate is available from the configured repositories"
        continue
    fi

    write_result INFO "$package" "Missing; repository candidate: $candidate"
    MISSING_PACKAGES+=("$package")
done

if (( FAIL > 0 )); then
    write_result FAIL "Package availability" "One or more required packages are unavailable"
    finish
fi

if (( ${#MISSING_PACKAGES[@]} == 0 )); then
    write_result PASS "Package installation" "All core packages are already installed"
else
    printf '\nThe following core packages are missing:\n\n'

    printf '  %s\n' "${MISSING_PACKAGES[@]}"

    printf '\n'
    read -r -p "Install the missing packages now? [y/N]: " RESPONSE

    case "$RESPONSE" in
        y|Y|yes|YES|Yes)
            ;;
        *)
            write_result FAIL "Package installation" "Installation was cancelled; required core packages remain missing"
            finish
            ;;
    esac

    printf '\nInstalling missing core packages...\n\n'

    if sudo apt install -y "${MISSING_PACKAGES[@]}"; then
        write_result PASS "Package installation" "Missing core packages installed successfully"
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

# Verify Python virtual-environment support separately.
if python3 -m venv --help >/dev/null 2>&1; then
    write_result PASS "Python venv" "python3 virtual-environment support is available"
else
    write_result FAIL "Python venv" "python3 -m venv is unavailable"
fi

# Report Kali's standard metapackage baseline without forcing installation.
for metapackage in kali-linux-default kali-tools-top10; do
    if dpkg-query -W -f='${Status}\n' "$metapackage" 2>/dev/null |
        grep -q '^install ok installed$'; then
        write_result INFO "$metapackage" "Metapackage is installed"
    else
        write_result INFO "$metapackage" "Metapackage is not installed; this script does not require it"
    fi
done

write_result INFO "Repository policy" "No third-party APT repositories were added"
write_result INFO "Package policy" "Only missing packages from the configured Kali repositories were installed"

finish
