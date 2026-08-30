#!/usr/bin/env bash

# Performs a read-only readiness check across the completed Kali VMware
# workstation. It validates the operating system, VMware guest state,
# workspace layout, tool profiles, development environment, networking,
# and common service exposure without printing private network details.

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
    printf ' Kali Workstation Readiness Summary\n'
    printf '===============================================\n'
    printf 'PASS : %s\n' "$PASS"
    printf 'WARN : %s\n' "$WARN"
    printf 'FAIL : %s\n' "$FAIL"
    printf 'INFO : %s\n' "$INFO"
    printf '\n'

    if (( FAIL > 0 )); then
        printf 'Overall Result: KALI WORKSTATION NEEDS ATTENTION\n'
        exit 1
    fi

    if (( WARN > 0 )); then
        printf 'Overall Result: KALI WORKSTATION READY WITH REVIEW ITEMS\n'
        exit 0
    fi

    printf 'Overall Result: KALI WORKSTATION READINESS VERIFIED\n'
    exit 0
}

check_command_group() {
    local group_name="$1"
    shift
    local commands=("$@")
    local missing=()
    local command_name

    for command_name in "${commands[@]}"; do
        if ! command -v "$command_name" >/dev/null 2>&1; then
            missing+=("$command_name")
        fi
    done

    if (( ${#missing[@]} == 0 )); then
        write_result PASS "$group_name" "All ${#commands[@]} required commands are available"
    else
        write_result FAIL "$group_name" "Missing commands: ${missing[*]}"
    fi
}

printf '\n'
printf '===============================================\n'
printf ' Kali VMware Workstation Readiness Check\n'
printf '===============================================\n'
printf '\n'

# Operating-system checks.
if [[ ! -r /etc/os-release ]]; then
    write_result FAIL "Operating system" "/etc/os-release could not be read"
    finish
fi

# shellcheck disable=SC1091
source /etc/os-release

if [[ "${ID:-}" == "kali" ]]; then
    write_result PASS "Operating system" "${PRETTY_NAME:-Kali Linux} detected"
else
    write_result FAIL "Operating system" "This validator is intended for Kali Linux"
    finish
fi

if (( EUID == 0 )); then
    write_result WARN "User context" "Running this read-only validator as root is unnecessary"
else
    write_result PASS "User context" "Running as a normal user"
fi

# VMware guest state.
if command -v systemd-detect-virt >/dev/null 2>&1; then
    VIRT_TYPE="$(systemd-detect-virt 2>/dev/null || true)"

    if [[ "$VIRT_TYPE" == "vmware" ]]; then
        write_result PASS "Virtualization" "VMware virtualization detected"
    else
        write_result WARN "Virtualization" "VMware was not detected as the current virtualization platform"
    fi
else
    write_result INFO "Virtualization" "systemd-detect-virt is unavailable"
fi

if command -v vmware-toolbox-cmd >/dev/null 2>&1; then
    write_result PASS "VMware Tools" "vmware-toolbox-cmd is available"
else
    write_result WARN "VMware Tools" "vmware-toolbox-cmd is unavailable"
fi

# Workspace layout.
WORKSPACE_ROOT="${HOME}/Cybersecurity"
WORKSPACE_DIRECTORIES=(
    CTFs
    Labs
    Projects
    Scripts
    Notes
    Captures
    Wordlists
    Tools
    Temp
)

if [[ -d "$WORKSPACE_ROOT" ]]; then
    write_result PASS "Workspace root" "$WORKSPACE_ROOT exists"
else
    write_result FAIL "Workspace root" "$WORKSPACE_ROOT does not exist"
fi

MISSING_DIRECTORIES=()

for directory in "${WORKSPACE_DIRECTORIES[@]}"; do
    if [[ ! -d "$WORKSPACE_ROOT/$directory" ]]; then
        MISSING_DIRECTORIES+=("$directory")
    fi
done

if (( ${#MISSING_DIRECTORIES[@]} == 0 )); then
    write_result PASS "Workspace layout" "All ${#WORKSPACE_DIRECTORIES[@]} standard directories are present"
else
    write_result FAIL "Workspace layout" "Missing directories: ${MISSING_DIRECTORIES[*]}"
fi

# Core workstation commands.
check_command_group "Core tools" \
    git curl wget jq python3 pipx tmux tree unzip 7z \
    gcc make cmake shellcheck nmap nc socat tcpdump tshark wireshark

# CTF profile.
check_command_group "CTF tools" \
    gobuster ffuf feroxbuster dirsearch hydra john hashcat sqlmap nikto \
    whatweb enum4linux smbclient netexec bloodhound-python responder \
    evil-winrm searchsploit msfconsole radare2 gdb checksec binwalk exiftool

# Web-security profile.
check_command_group "Web tools" \
    burpsuite caido firefox-esr chromium httpx-toolkit nuclei ffuf gobuster \
    feroxbuster dirsearch nikto whatweb sqlmap

# Network and Active Directory profile.
check_command_group "Network and AD tools" \
    ip ss ping traceroute dig whois nmap masscan arp-scan netdiscover \
    tcpdump tshark wireshark smbclient rpcclient netexec enum4linux \
    bloodhound-python responder evil-winrm ldapsearch certipy-ad \
    impacket-smbclient impacket-psexec

# Blue-team and DFIR profile.
check_command_group "Blue-team and DFIR tools" \
    wireshark tshark tcpdump yara strings exiftool binwalk foremost \
    bulk_extractor fls mmls icat fsstat hashdeep md5deep sha256sum \
    file xxd hexdump vol

# Python environment.
if python3 -m pip --version >/dev/null 2>&1; then
    write_result PASS "Python pip" "python3 -m pip is available"
else
    write_result FAIL "Python pip" "python3 -m pip is unavailable"
fi

if python3 -m venv --help >/dev/null 2>&1; then
    write_result PASS "Python venv" "Virtual-environment support is available"
else
    write_result FAIL "Python venv" "Virtual-environment support is unavailable"
fi

if pipx list --short 2>/dev/null |
    awk '$1 == "volatility3" {found=1} END {exit found ? 0 : 1}'; then
    write_result PASS "Volatility 3" "volatility3 is managed through pipx"
else
    write_result WARN "Volatility 3" "vol command exists or may exist, but volatility3 was not confirmed in pipx"
fi

# Git configuration without exposing identity values.
GIT_NAME="$(git config --global user.name 2>/dev/null || true)"
GIT_EMAIL="$(git config --global user.email 2>/dev/null || true)"
DEFAULT_BRANCH="$(git config --global init.defaultBranch 2>/dev/null || true)"

if [[ -n "$GIT_NAME" ]]; then
    write_result PASS "Git user.name" "A global Git name is configured"
else
    write_result WARN "Git user.name" "Global Git name is not configured"
fi

if [[ -n "$GIT_EMAIL" ]]; then
    write_result PASS "Git user.email" "A global Git email is configured"
else
    write_result WARN "Git user.email" "Global Git email is not configured"
fi

if [[ "$DEFAULT_BRANCH" == "main" ]]; then
    write_result PASS "Git default branch" "init.defaultBranch is set to main"
elif [[ -n "$DEFAULT_BRANCH" ]]; then
    write_result INFO "Git default branch" "A non-main default branch is configured and preserved"
else
    write_result WARN "Git default branch" "init.defaultBranch is not configured"
fi

# Interactive shell.
if [[ "${SHELL:-}" == */zsh ]]; then
    write_result PASS "Login shell" "Zsh is the configured shell"
elif [[ -n "${SHELL:-}" ]]; then
    write_result INFO "Login shell" "A non-Zsh login shell is configured"
else
    write_result INFO "Login shell" "Login shell could not be determined"
fi

# Read-only network readiness without printing addresses.
if command -v ip >/dev/null 2>&1; then
    ACTIVE_INTERFACE_COUNT="$(
        ip -brief link show up |
            awk '$1 != "lo" {count++} END {print count+0}'
    )"

    if [[ "$ACTIVE_INTERFACE_COUNT" =~ ^[0-9]+$ ]] && (( ACTIVE_INTERFACE_COUNT > 0 )); then
        write_result PASS "Network interface" "At least one active non-loopback interface is present"
    else
        write_result FAIL "Network interface" "No active non-loopback interface was detected"
    fi

    if ip -4 route show default | grep -q '^default'; then
        write_result PASS "Default route" "A default IPv4 route is present"
    else
        write_result WARN "Default route" "No default IPv4 route was detected"
    fi
else
    write_result FAIL "Network checks" "ip command is unavailable; interface and route checks could not be completed"
fi

if command -v getent >/dev/null 2>&1; then
    if getent hosts kali.org >/dev/null 2>&1; then
        write_result PASS "DNS resolution" "Hostname resolution is working"
    else
        write_result WARN "DNS resolution" "Hostname resolution failed"
    fi
else
    write_result FAIL "DNS resolution" "getent is unavailable; hostname resolution could not be evaluated"
fi

# Review common remote services without starting or stopping anything.
SERVICES=(
    ssh
    apache2
    nginx
    vsftpd
    smbd
)

ACTIVE_SERVICES=()

for service_name in "${SERVICES[@]}"; do
    if systemctl is-active --quiet "$service_name" 2>/dev/null; then
        ACTIVE_SERVICES+=("$service_name")
    fi
done

if (( ${#ACTIVE_SERVICES[@]} == 0 )); then
    write_result PASS "Common services" "No reviewed remote-access or server services are active"
else
    write_result WARN "Common services" "Review active services: ${ACTIVE_SERVICES[*]}"
fi

# Reboot marker.
if [[ -e /var/run/reboot-required ]]; then
    write_result WARN "Reboot state" "The system reports that a reboot is required"
else
    write_result PASS "Reboot state" "No reboot-required marker is present"
fi

write_result INFO "Privacy" "Private IP addresses, gateways, DNS servers, MAC addresses, and Git identity values were not printed"
write_result INFO "Safety" "This validator performs no scanning, exploitation, package installation, service changes, or network reconfiguration"
write_result INFO "Maintenance" "Re-run the relevant profile script if a future Kali update removes or changes a required tool"

finish
