#!/usr/bin/env bash

# Kali Linux workstation update helper.
# This script updates an existing Kali installation using the official
# kali-rolling repository configuration.
#
# It does not add repositories, remove repositories, or reboot automatically.

set -Eeuo pipefail

PASS=0
WARN=0
FAIL=0
INFO=0

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
    local exit_code="$1"
    local result_override="${2:-}"

    printf '\n'
    printf '===============================================\n'
    printf ' Kali Update Summary\n'
    printf '===============================================\n'
    printf 'PASS : %s\n' "$PASS"
    printf 'WARN : %s\n' "$WARN"
    printf 'FAIL : %s\n' "$FAIL"
    printf 'INFO : %s\n' "$INFO"
    printf '\n'

    if [[ -n "$result_override" ]]; then
        printf 'Overall Result: %s\n' "$result_override"
    elif (( exit_code != 0 )); then
        printf 'Overall Result: UPDATE NEEDS ATTENTION\n'
    elif (( WARN > 0 )); then
        printf 'Overall Result: UPDATE COMPLETE WITH REVIEW ITEMS\n'
    else
        printf 'Overall Result: UPDATE COMPLETE\n'
    fi

    exit "$exit_code"
}

printf '\n'
printf '===============================================\n'
printf ' Kali Linux Workstation Update\n'
printf '===============================================\n'
printf '\n'

# Confirm that this is Kali Linux.
if [[ ! -r /etc/os-release ]]; then
    write_result FAIL "Operating system" "/etc/os-release could not be read"
    finish 1
fi

# shellcheck disable=SC1091
source /etc/os-release

if [[ "${ID:-}" == "kali" ]]; then
    write_result PASS "Operating system" "${PRETTY_NAME:-Kali Linux} detected"
else
    write_result FAIL "Operating system" "This script is intended for Kali Linux"
    finish 1
fi

# Require a normal user account with sudo rather than a root login.
if (( EUID == 0 )); then
    write_result FAIL "User context" "Do not run this script as root or with sudo"
    finish 1
fi

write_result PASS "User context" "Running as user: ${USER:-$(id -un)}"

if ! command -v sudo >/dev/null 2>&1; then
    write_result FAIL "sudo" "sudo is not available"
    finish 1
fi

if ! sudo -v; then
    write_result FAIL "sudo" "Administrative authorization failed"
    finish 1
fi

write_result PASS "sudo" "Administrative authorization is available"

# Confirm basic network routing.
if ip route show default | grep -q '^default'; then
    write_result PASS "Network route" "A default route is present"
else
    write_result FAIL "Network route" "No default route was detected"
    finish 1
fi

# Confirm DNS resolution.
if getent hosts kali.org >/dev/null 2>&1; then
    write_result PASS "DNS" "kali.org resolves successfully"
else
    write_result FAIL "DNS" "kali.org could not be resolved"
    finish 1
fi

# Validate the official Kali rolling repository.
MODERN_SOURCE="/etc/apt/sources.list.d/kali.sources"
LEGACY_SOURCE="/etc/apt/sources.list"

if [[ -f "$MODERN_SOURCE" ]]; then
    if grep -Eq '^[[:space:]]*Suites:[[:space:]]+kali-rolling([[:space:]]|$)' "$MODERN_SOURCE" &&
       grep -Eq '^[[:space:]]*URIs:[[:space:]]+https?://http\.kali\.org/kali/?([[:space:]]|$)' "$MODERN_SOURCE"; then
        write_result PASS "APT repository" "Official kali-rolling repository detected in kali.sources"
    else
        write_result FAIL "APT repository" "kali.sources does not match the expected kali-rolling configuration"
        finish 1
    fi
elif [[ -f "$LEGACY_SOURCE" ]] &&
     grep -Eq '^[[:space:]]*deb[[:space:]]+https?://http\.kali\.org/kali[[:space:]]+kali-rolling([[:space:]]|$)' "$LEGACY_SOURCE"; then
    write_result WARN "APT repository" "Legacy kali-rolling sources.list detected; current Kali releases use kali.sources"
else
    write_result FAIL "APT repository" "The official kali-rolling repository configuration was not detected"
    finish 1
fi

# Refresh package metadata.
printf '\nRefreshing package information...\n\n'

if sudo apt update; then
    write_result PASS "APT update" "Package information refreshed successfully"
else
    write_result FAIL "APT update" "apt update failed"
    finish 1
fi

# Report the number of available package upgrades.
UPGRADE_COUNT="$(
    apt list --upgradable 2>/dev/null |
        tail -n +2 |
        wc -l |
        tr -d '[:space:]'
)"

write_result INFO "Available upgrades" "${UPGRADE_COUNT:-0} package(s) reported as upgradable"

printf '\n'
printf 'The next command performs a Kali full-upgrade.\n'
printf 'Packages may be installed, upgraded, or removed to satisfy dependencies.\n'
printf '\n'

read -r -p "Continue with sudo apt full-upgrade -y? [y/N]: " RESPONSE

case "$RESPONSE" in
    y|Y|yes|YES|Yes)
        ;;
    *)
        write_result WARN "Full upgrade" "Upgrade was cancelled; the full system upgrade was not performed"
        finish 2 "UPDATE CANCELLED"
        ;;
esac

printf '\nRunning full system upgrade...\n\n'

if sudo apt full-upgrade -y; then
    write_result PASS "Full upgrade" "Kali full-upgrade completed successfully"
else
    write_result FAIL "Full upgrade" "Kali full-upgrade failed"
    finish 1
fi

# Check for a common reboot-required marker.
if [[ -f /var/run/reboot-required ]]; then
    write_result WARN "Reboot" "A reboot is required; run: sudo reboot"
else
    write_result INFO "Reboot" "No reboot-required marker was detected"
fi

# Display final release and kernel information.
write_result INFO "Release" "${PRETTY_NAME:-Kali Linux}"
write_result INFO "Kernel" "$(uname -r)"

finish 0
