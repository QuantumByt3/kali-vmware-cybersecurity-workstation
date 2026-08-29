#!/usr/bin/env bash

# Installs and verifies a focused blue-team and DFIR tool profile for this
# Kali workstation. Kali APT is used for packaged tools. Volatility 3 is
# installed in an isolated pipx environment because it is not currently
# available as a Kali APT package.

set -Eeuo pipefail

PASS=0
WARN=0
FAIL=0
INFO=0

APT_PACKAGES=(
    wireshark
    tshark
    tcpdump
    yara
    binutils-x86-64-linux-gnu
    libimage-exiftool-perl
    binwalk
    foremost
    bulk-extractor
    sleuthkit
    hashdeep
    file
    xxd
    bsdextrautils
)

COMMANDS=(
    wireshark
    tshark
    tcpdump
    yara
    strings
    exiftool
    binwalk
    foremost
    bulk_extractor
    fls
    mmls
    icat
    fsstat
    hashdeep
    md5deep
    sha256sum
    file
    xxd
    hexdump
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
    printf ' Blue-Team and DFIR Tool Profile Summary\n'
    printf '===============================================\n'
    printf 'PASS : %s\n' "$PASS"
    printf 'WARN : %s\n' "$WARN"
    printf 'FAIL : %s\n' "$FAIL"
    printf 'INFO : %s\n' "$INFO"
    printf '\n'

    if (( FAIL > 0 )); then
        printf 'Overall Result: BLUE-TEAM/DFIR PROFILE NEEDS ATTENTION\n'
        exit 1
    fi

    if (( WARN > 0 )); then
        printf 'Overall Result: BLUE-TEAM/DFIR TOOLS READY WITH REVIEW ITEMS\n'
        exit 0
    fi

    printf 'Overall Result: BLUE-TEAM/DFIR TOOL PROFILE VERIFIED\n'
    exit 0
}

printf '\n'
printf '===============================================\n'
printf ' Kali Blue-Team and DFIR Tool Profile Setup\n'
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

# Confirm sudo and pipx.
if ! command -v sudo >/dev/null 2>&1; then
    write_result FAIL "sudo" "sudo is not available"
    finish
fi

if ! sudo -v; then
    write_result FAIL "sudo" "Administrative authorization failed"
    finish
fi

write_result PASS "sudo" "Administrative authorization is available"

if command -v pipx >/dev/null 2>&1; then
    write_result PASS "pipx" "pipx is available"
else
    write_result FAIL "pipx" "pipx is required for the isolated Volatility 3 installation"
    finish
fi

# Refresh APT package metadata.
printf '\nRefreshing package information...\n\n'

if sudo apt update; then
    write_result PASS "APT update" "Package information refreshed successfully"
else
    write_result FAIL "APT update" "apt update failed"
    finish
fi

printf '\n--- APT Package Review ---\n'

MISSING_PACKAGES=()

for package in "${APT_PACKAGES[@]}"; do
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
        write_result FAIL "$package" "No install candidate is available from the configured Kali repositories"
        continue
    fi

    write_result INFO "$package" "Missing; repository candidate: $candidate"
    MISSING_PACKAGES+=("$package")
done

if (( FAIL > 0 )); then
    write_result FAIL "Package availability" "One or more required blue-team/DFIR packages are unavailable"
    finish
fi

if (( ${#MISSING_PACKAGES[@]} == 0 )); then
    write_result PASS "APT package installation" "All focused APT packages are already installed"
else
    printf '\nThe following blue-team/DFIR packages are missing:\n\n'
    printf '  %s\n' "${MISSING_PACKAGES[@]}"
    printf '\n'

    read -r -p "Install the missing APT packages now? [y/N]: " RESPONSE

    case "$RESPONSE" in
        y|Y|yes|YES|Yes)
            ;;
        *)
            write_result WARN "APT package installation" "Installation was cancelled by the user"
            finish
            ;;
    esac

    printf '\nInstalling missing blue-team/DFIR packages...\n\n'

    if sudo apt install -y "${MISSING_PACKAGES[@]}"; then
        write_result PASS "APT package installation" "Missing APT packages installed successfully"
    else
        write_result FAIL "APT package installation" "apt install failed"
        finish
    fi
fi

printf '\n--- Volatility 3 Review ---\n'

VOLATILITY_PIPX_INSTALLED=false

if pipx list --short 2>/dev/null |
    awk '$1 == "volatility3" {found=1} END {exit found ? 0 : 1}'; then
    VOLATILITY_PIPX_INSTALLED=true
    write_result PASS "Volatility 3" "volatility3 is installed and managed by pipx"
fi

if [[ "$VOLATILITY_PIPX_INSTALLED" == "false" ]]; then
    write_result INFO "Volatility 3" "volatility3 is not currently managed by pipx"
    printf '\n'
    read -r -p "Install Volatility 3 from PyPI using pipx? [y/N]: " VOL_RESPONSE

    case "$VOL_RESPONSE" in
        y|Y|yes|YES|Yes)
            printf '\nInstalling Volatility 3 in an isolated pipx environment...\n\n'

            if pipx install volatility3; then
                write_result PASS "Volatility 3 installation" "volatility3 installed successfully with pipx"
            else
                write_result FAIL "Volatility 3 installation" "pipx installation failed"
                finish
            fi
            ;;
        *)
            write_result WARN "Volatility 3 installation" "Volatility 3 installation was cancelled by the user"
            ;;
    esac
fi

printf '\n--- Command Verification ---\n'

for command_name in "${COMMANDS[@]}"; do
    if command_path="$(command -v "$command_name" 2>/dev/null)"; then
        write_result PASS "$command_name" "Available at $command_path"
    else
        write_result FAIL "$command_name" "Command was not found after package verification"
    fi
done

if command_path="$(command -v vol 2>/dev/null)"; then
    write_result PASS "vol" "Volatility 3 command is available at $command_path"
else
    write_result WARN "vol" "Volatility 3 command is not available"
fi

write_result INFO "Evidence handling" "Work on copies of evidence and preserve original hashes when performing forensic analysis"
write_result INFO "Capture safety" "Packet captures and forensic images may contain sensitive data and should not be committed publicly"
write_result INFO "Repository policy" "APT tools came from configured Kali repositories; Volatility 3 uses an isolated pipx environment"
write_result INFO "Authorized use" "Use these tools only with evidence, systems, and networks you are authorized to examine"

finish
