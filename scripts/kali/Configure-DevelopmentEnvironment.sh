#!/usr/bin/env bash

# Configures and verifies the focused development environment used by this
# Kali workstation. The script installs only missing development packages,
# preserves existing Git identity settings, and sets the default Git branch
# to main only when that setting is currently unset.

set -Eeuo pipefail

PASS=0
WARN=0
FAIL=0
INFO=0

PACKAGES=(
    python3
    python3-pip
    python3-venv
    pipx
    git
    zsh
    tmux
    nano
    vim
    build-essential
    cmake
    shellcheck
)

COMMANDS=(
    python3
    pipx
    git
    zsh
    tmux
    nano
    vim
    gcc
    make
    cmake
    shellcheck
    curl
    wget
    jq
    tree
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
    printf ' Development Environment Summary\n'
    printf '===============================================\n'
    printf 'PASS : %s\n' "$PASS"
    printf 'WARN : %s\n' "$WARN"
    printf 'FAIL : %s\n' "$FAIL"
    printf 'INFO : %s\n' "$INFO"
    printf '\n'

    if (( FAIL > 0 )); then
        printf 'Overall Result: DEVELOPMENT ENVIRONMENT NEEDS ATTENTION\n'
        exit 1
    fi

    if (( WARN > 0 )); then
        printf 'Overall Result: DEVELOPMENT ENVIRONMENT READY WITH REVIEW ITEMS\n'
        exit 0
    fi

    printf 'Overall Result: DEVELOPMENT ENVIRONMENT VERIFIED\n'
    exit 0
}

printf '\n'
printf '===============================================\n'
printf ' Kali Development Environment Setup\n'
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
    write_result FAIL "Package availability" "One or more required development packages are unavailable"
    finish
fi

if (( ${#MISSING_PACKAGES[@]} == 0 )); then
    write_result PASS "Package installation" "All focused development packages are already installed"
else
    printf '\nThe following development packages are missing:\n\n'
    printf '  %s\n' "${MISSING_PACKAGES[@]}"
    printf '\n'

    read -r -p "Install the missing development packages now? [y/N]: " RESPONSE

    case "$RESPONSE" in
        y|Y|yes|YES|Yes)
            ;;
        *)
            write_result WARN "Package installation" "Installation was cancelled by the user"
            finish
            ;;
    esac

    printf '\nInstalling missing development packages...\n\n'

    if sudo apt install -y "${MISSING_PACKAGES[@]}"; then
        write_result PASS "Package installation" "Missing development packages installed successfully"
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

# Verify Python tooling without modifying the system Python environment.
if python3 -m pip --version >/dev/null 2>&1; then
    write_result PASS "Python pip" "python3 -m pip is available"
else
    write_result FAIL "Python pip" "python3 -m pip is unavailable"
fi

if python3 -m venv --help >/dev/null 2>&1; then
    write_result PASS "Python venv" "Python virtual-environment support is available"
else
    write_result FAIL "Python venv" "python3 -m venv is unavailable"
fi

write_result INFO "Python policy" "Use venv or pipx for third-party Python tools; avoid sudo pip install"

# Preserve existing Git identity.
GIT_NAME="$(git config --global user.name 2>/dev/null || true)"
GIT_EMAIL="$(git config --global user.email 2>/dev/null || true)"

if [[ -n "$GIT_NAME" ]]; then
    write_result PASS "Git user.name" "Existing global Git name is preserved"
else
    write_result WARN "Git user.name" "Global Git name is not configured"
fi

if [[ -n "$GIT_EMAIL" ]]; then
    write_result PASS "Git user.email" "Existing global Git email is preserved"
else
    write_result WARN "Git user.email" "Global Git email is not configured"
fi

# Set the default branch only when it is currently unset.
DEFAULT_BRANCH="$(git config --global init.defaultBranch 2>/dev/null || true)"

if [[ -z "$DEFAULT_BRANCH" ]]; then
    git config --global init.defaultBranch main
    write_result PASS "Git default branch" "Configured init.defaultBranch as main"
elif [[ "$DEFAULT_BRANCH" == "main" ]]; then
    write_result PASS "Git default branch" "init.defaultBranch is already set to main"
else
    write_result INFO "Git default branch" "Existing init.defaultBranch is preserved as: $DEFAULT_BRANCH"
fi

# Report the user's configured login shell.
CURRENT_SHELL="${SHELL:-}"

if [[ "$CURRENT_SHELL" == */zsh ]]; then
    write_result PASS "Login shell" "Zsh is the current shell"
elif [[ -n "$CURRENT_SHELL" ]]; then
    write_result INFO "Login shell" "Current shell is $CURRENT_SHELL; this script does not change it"
else
    write_result INFO "Login shell" "Current shell could not be determined"
fi

write_result INFO "Editor policy" "Nano and Vim are included; Neovim and VS Code are not required inside Kali"
write_result INFO "VS Code workflow" "This repository can be edited from VS Code on the Windows host"
write_result INFO "Repository policy" "No third-party APT repositories were added and existing Git identity values were not overwritten"

finish
