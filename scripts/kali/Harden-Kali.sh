#!/usr/bin/env bash

# Kali Linux security-baseline audit.
# This script is read-only by default. It does not stop services, change
# firewall rules, modify SSH settings, or alter VMware configuration.

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

service_exists() {
    local service="$1"
    systemctl list-unit-files "${service}.service" --no-legend 2>/dev/null |
        grep -q "^${service}\.service"
}

check_service() {
    local service="$1"
    local label="$2"
    local active_state
    local enabled_state

    if ! service_exists "$service"; then
        write_result INFO "$label" "Service is not installed"
        return
    fi

    active_state="$(systemctl is-active "$service" 2>/dev/null || true)"
    enabled_state="$(systemctl is-enabled "$service" 2>/dev/null || true)"

    if [[ "$active_state" == "active" ]]; then
        write_result WARN "$label" "Service is currently active"
    else
        write_result PASS "$label" "Service is not active"
    fi

    case "$enabled_state" in
        enabled)
            write_result WARN "$label startup" "Service is enabled to start automatically"
            ;;
        disabled|masked)
            write_result PASS "$label startup" "Service is $enabled_state"
            ;;
        static|indirect|generated|alias|transient)
            write_result INFO "$label startup" "Service state is $enabled_state"
            ;;
        *)
            write_result INFO "$label startup" "Service startup state is ${enabled_state:-unknown}"
            ;;
    esac
}

finish() {
    printf '\n'
    printf '===============================================\n'
    printf ' Kali Security Baseline Summary\n'
    printf '===============================================\n'
    printf 'PASS : %s\n' "$PASS"
    printf 'WARN : %s\n' "$WARN"
    printf 'FAIL : %s\n' "$FAIL"
    printf 'INFO : %s\n' "$INFO"
    printf '\n'

    if (( FAIL > 0 )); then
        printf 'Overall Result: BASELINE NEEDS ATTENTION\n'
        exit 1
    fi

    if (( WARN > 0 )); then
        printf 'Overall Result: BASELINE READY WITH REVIEW ITEMS\n'
        printf 'Review warnings before treating the VM as the clean security baseline.\n'
        exit 0
    fi

    printf 'Overall Result: SECURITY BASELINE VERIFIED\n'
    exit 0
}

printf '\n'
printf '===============================================\n'
printf ' Kali Linux Security Baseline Audit\n'
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

# Confirm that routine work is not being performed as root.
if (( EUID == 0 )); then
    write_result WARN "User context" "Running as root; use the normal Kali account for routine work"
else
    write_result PASS "User context" "Running as non-root user: ${USER:-$(id -un)}"
fi

# Confirm sudo exists and administrative authorization is available.
if ! command -v sudo >/dev/null 2>&1; then
    write_result FAIL "sudo" "sudo is not installed"
    finish
fi

write_result PASS "sudo" "sudo is installed"

if ! sudo -v; then
    write_result FAIL "sudo authorization" "Administrative authorization failed"
    finish
fi

write_result PASS "sudo authorization" "Administrative authorization is available"

# Review sudo-group membership separately from successful sudo authorization.
if id -nG 2>/dev/null | tr ' ' '\n' | grep -qx 'sudo'; then
    write_result PASS "sudo group" "Current account belongs to the sudo group"
else
    write_result WARN "sudo group" "Current account was not detected in the sudo group"
fi

# Review root-account password state.
if command -v passwd >/dev/null 2>&1; then
    ROOT_STATUS="$(sudo passwd -S root 2>/dev/null | awk '{print $2}' || true)"

    case "$ROOT_STATUS" in
        L|LK)
            write_result PASS "Root account" "Root password is locked"
            ;;
        P)
            write_result WARN "Root account" "Root has a usable password; direct root login is not recommended"
            ;;
        NP)
            write_result FAIL "Root account" "Root account reports no password"
            ;;
        *)
            write_result INFO "Root account" "Root password state could not be determined"
            ;;
    esac
else
    write_result INFO "Root account" "passwd command is unavailable"
fi

# Verify that Kali SSH wide-compatibility mode is not enabled.
SSH_WIDE_COMPAT="/etc/ssh/ssh_config.d/kali-wide-compat.conf"

if [[ -e "$SSH_WIDE_COMPAT" ]]; then
    write_result WARN "SSH client hardening" "Wide Compatibility mode is enabled"
    write_result INFO "SSH client hardening" "Use kali-tweaks > Hardening > Strong Security for the normal baseline"
else
    write_result PASS "SSH client hardening" "Strong Security mode is in use"
fi

# Confirm the VM is running under VMware when systemd-detect-virt is available.
if command -v systemd-detect-virt >/dev/null 2>&1; then
    VIRT_TYPE="$(systemd-detect-virt 2>/dev/null || true)"

    if [[ "$VIRT_TYPE" == "vmware" ]]; then
        write_result PASS "Virtualization" "VMware virtual machine detected"
    elif [[ -n "$VIRT_TYPE" && "$VIRT_TYPE" != "none" ]]; then
        write_result WARN "Virtualization" "Detected virtualization platform: $VIRT_TYPE"
    else
        write_result WARN "Virtualization" "VMware virtualization was not detected"
    fi
else
    write_result INFO "Virtualization" "systemd-detect-virt is unavailable"
fi

# Audit common remotely accessible services.
printf '\n--- Remote Service Review ---\n'

check_service ssh "SSH server"
check_service apache2 "Apache web server"
check_service nginx "Nginx web server"
check_service vsftpd "FTP server"
check_service smbd "Samba server"

# Summarize listeners without printing local IP addresses or port details.
printf '\n--- Listening Socket Review ---\n'

if command -v ss >/dev/null 2>&1; then
    LISTENER_COUNT="$(
        sudo ss -H -lntu 2>/dev/null |
            awk '
                $5 !~ /^127\./ &&
                $5 !~ /^\[::1\]:/ &&
                $5 !~ /^::1:/ {
                    count++
                }
                END {
                    print count+0
                }
            '
    )"

    if (( LISTENER_COUNT == 0 )); then
        write_result PASS "Network listeners" "No non-loopback TCP/UDP listeners were detected"
    else
        write_result WARN "Network listeners" "$LISTENER_COUNT non-loopback TCP/UDP listener(s) require review"
        write_result INFO "Network listeners" "Run: sudo ss -tulpen"
    fi
else
    write_result WARN "Network listeners" "ss command is unavailable"
fi

# Confirm no reboot marker remains from package maintenance.
if [[ -f /var/run/reboot-required ]]; then
    write_result WARN "Pending reboot" "A reboot-required marker is present"
else
    write_result PASS "Pending reboot" "No reboot-required marker detected"
fi

printf '\n'
write_result INFO "VMware isolation" "Verify NAT, Shared Folders, Drag and Drop, and Copy/Paste manually in VMware settings"
write_result INFO "Review policy" "Warnings are review items because authorized labs may intentionally require temporary listeners or services"

finish
