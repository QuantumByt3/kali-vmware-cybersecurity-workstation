#!/usr/bin/env bash

# Performs a read-only networking readiness check for a Kali Linux guest
# running in VMware Workstation. The script reports connectivity state without
# printing private IP addresses, gateways, DNS server addresses, or MAC
# addresses.

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
    printf '\n'
    printf '===============================================\n'
    printf ' Kali Network Readiness Summary\n'
    printf '===============================================\n'
    printf 'PASS : %s\n' "$PASS"
    printf 'WARN : %s\n' "$WARN"
    printf 'FAIL : %s\n' "$FAIL"
    printf 'INFO : %s\n' "$INFO"
    printf '\n'

    if (( FAIL > 0 )); then
        printf 'Overall Result: NETWORK READINESS NEEDS ATTENTION\n'
        exit 1
    fi

    if (( WARN > 0 )); then
        printf 'Overall Result: NETWORK READY WITH REVIEW ITEMS\n'
        exit 0
    fi

    printf 'Overall Result: NETWORK READINESS VERIFIED\n'
    exit 0
}

printf '\n'
printf '===============================================\n'
printf ' Kali VMware Network Readiness Check\n'
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

# Confirm the script is not running as root.
if (( EUID == 0 )); then
    write_result WARN "User context" "Running as root is unnecessary for this read-only check"
else
    write_result PASS "User context" "Running as a normal user"
fi

# Verify required local commands.
REQUIRED_COMMANDS=(
    ip
    getent
)

for command_name in "${REQUIRED_COMMANDS[@]}"; do
    if command -v "$command_name" >/dev/null 2>&1; then
        write_result PASS "$command_name" "Required command is available"
    else
        write_result FAIL "$command_name" "Required command is unavailable"
    fi
done

if (( FAIL > 0 )); then
    finish
fi

# Detect the virtualization platform without exposing machine-specific data.
if command -v systemd-detect-virt >/dev/null 2>&1; then
    VIRT_TYPE="$(systemd-detect-virt 2>/dev/null || true)"

    if [[ "$VIRT_TYPE" == "vmware" ]]; then
        write_result PASS "Virtualization" "VMware virtualization detected"
    elif [[ -n "$VIRT_TYPE" && "$VIRT_TYPE" != "none" ]]; then
        write_result WARN "Virtualization" "Detected virtualization platform: $VIRT_TYPE"
    else
        write_result WARN "Virtualization" "VMware virtualization was not detected"
    fi
else
    write_result INFO "Virtualization" "systemd-detect-virt is unavailable"
fi

# Count active non-loopback interfaces without printing their addresses.
mapfile -t ACTIVE_INTERFACES < <(
    ip -brief link show up |
        awk '$1 != "lo" {print $1}'
)

if (( ${#ACTIVE_INTERFACES[@]} == 0 )); then
    write_result FAIL "Active interface" "No active non-loopback network interface was found"
elif (( ${#ACTIVE_INTERFACES[@]} == 1 )); then
    write_result PASS "Active interface" "One active non-loopback interface is present: ${ACTIVE_INTERFACES[0]}"
else
    write_result WARN "Active interfaces" "Multiple active non-loopback interfaces are present: ${#ACTIVE_INTERFACES[@]}"
fi

# Review IPv4 assignment without printing the address.
IPV4_INTERFACE_COUNT="$(
    ip -o -4 address show scope global |
        awk '{print $2}' |
        sort -u |
        wc -l |
        tr -d ' '
)"

if [[ "$IPV4_INTERFACE_COUNT" =~ ^[0-9]+$ ]] && (( IPV4_INTERFACE_COUNT > 0 )); then
    write_result PASS "IPv4 configuration" "At least one global IPv4 address is assigned"
else
    write_result WARN "IPv4 configuration" "No global IPv4 address was detected"
fi

# Review default route without printing the gateway.
DEFAULT_ROUTE="$(ip -4 route show default | head -n 1 || true)"

if [[ -n "$DEFAULT_ROUTE" ]]; then
    DEFAULT_INTERFACE="$(
        awk '
            {
                for (i = 1; i <= NF; i++) {
                    if ($i == "dev" && (i + 1) <= NF) {
                        print $(i + 1)
                        exit
                    }
                }
            }
        ' <<< "$DEFAULT_ROUTE"
    )"

    if [[ -n "$DEFAULT_INTERFACE" ]]; then
        write_result PASS "Default route" "Default IPv4 route exists through interface: $DEFAULT_INTERFACE"
    else
        write_result PASS "Default route" "A default IPv4 route exists"
    fi
else
    write_result WARN "Default route" "No default IPv4 route was found"
fi

# Perform a local route-table lookup only. This does not send traffic.
if ip -4 route get 1.1.1.1 >/dev/null 2>&1; then
    write_result PASS "Route selection" "The local routing table can select an external route"
else
    write_result WARN "Route selection" "No route could be selected for an external destination"
fi

# Perform DNS resolution without printing returned addresses.
if getent hosts kali.org >/dev/null 2>&1; then
    write_result PASS "DNS resolution" "Hostname resolution is working"
else
    write_result WARN "DNS resolution" "Hostname resolution failed"
fi

# Review NetworkManager when available.
if command -v nmcli >/dev/null 2>&1; then
    ACTIVE_NM_COUNT="$(
        nmcli -t -f DEVICE,STATE device status 2>/dev/null |
            awk -F: '$1 != "lo" && $2 == "connected" {count++} END {print count+0}'
    )"

    if [[ "$ACTIVE_NM_COUNT" =~ ^[0-9]+$ ]] && (( ACTIVE_NM_COUNT > 0 )); then
        write_result PASS "NetworkManager" "At least one non-loopback device is connected"
    else
        write_result WARN "NetworkManager" "No connected non-loopback device was reported"
    fi
else
    write_result INFO "NetworkManager" "nmcli is unavailable"
fi

# Verify VMware Tools when available.
if command -v vmware-toolbox-cmd >/dev/null 2>&1; then
    VMWARE_TOOLS_VERSION="$(vmware-toolbox-cmd -v 2>/dev/null || true)"

    if [[ -n "$VMWARE_TOOLS_VERSION" ]]; then
        write_result PASS "VMware Tools" "vmware-toolbox-cmd is available"
        write_result INFO "VMware Tools version" "$VMWARE_TOOLS_VERSION"
    else
        write_result WARN "VMware Tools" "vmware-toolbox-cmd exists but did not report a version"
    fi
else
    write_result WARN "VMware Tools" "vmware-toolbox-cmd is unavailable"
fi

# Report whether multiple default routes exist.
DEFAULT_ROUTE_COUNT="$(
    ip -4 route show default |
        wc -l |
        tr -d ' '
)"

if [[ "$DEFAULT_ROUTE_COUNT" =~ ^[0-9]+$ ]] && (( DEFAULT_ROUTE_COUNT > 1 )); then
    write_result WARN "Route complexity" "Multiple IPv4 default routes are configured"
elif [[ "$DEFAULT_ROUTE_COUNT" == "1" ]]; then
    write_result PASS "Route complexity" "A single IPv4 default route is configured"
else
    write_result INFO "Route complexity" "No IPv4 default route is configured"
fi

write_result INFO "Network mode" "Guest-only checks cannot prove NAT, host-only, bridged, or LAN-segment mode by themselves"
write_result INFO "Privacy" "Private IP addresses, gateways, DNS servers, and MAC addresses were intentionally not printed"
write_result INFO "Scope" "This script performs no host discovery, port scanning, exploitation, or configuration changes"
write_result INFO "Baseline" "Use VMware NAT for normal workstation operation unless an authorized lab requires another mode"

finish
