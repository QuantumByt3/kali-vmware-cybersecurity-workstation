#!/usr/bin/env bash

# Creates the standard Kali cybersecurity workspace used by this repository.
# The script is safe to run more than once. It creates missing directories
# and leaves existing files and directories unchanged.

set -Eeuo pipefail

PASS=0
WARN=0
FAIL=0
INFO=0

BASE_DIR="${HOME}/Cybersecurity"

DIRECTORIES=(
    "CTFs"
    "Labs"
    "Projects"
    "Scripts"
    "Notes"
    "Captures"
    "Wordlists"
    "Tools"
    "Temp"
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
    printf ' Directory Layout Summary\n'
    printf '===============================================\n'
    printf 'PASS : %s\n' "$PASS"
    printf 'WARN : %s\n' "$WARN"
    printf 'FAIL : %s\n' "$FAIL"
    printf 'INFO : %s\n' "$INFO"
    printf '\n'

    if (( FAIL > 0 )); then
        printf 'Overall Result: DIRECTORY SETUP NEEDS ATTENTION\n'
        exit 1
    fi

    if (( WARN > 0 )); then
        printf 'Overall Result: DIRECTORY SETUP COMPLETE WITH REVIEW ITEMS\n'
        exit 0
    fi

    printf 'Overall Result: DIRECTORY LAYOUT VERIFIED\n'
    exit 0
}

printf '\n'
printf '===============================================\n'
printf ' Kali Cybersecurity Directory Setup\n'
printf '===============================================\n'
printf '\n'

# Require a normal user account so the workspace is created in the user's home.
if (( EUID == 0 )); then
    write_result FAIL "User context" "Do not run this script as root or with sudo"
    finish
fi

write_result PASS "User context" "Running as user: ${USER:-$(id -un)}"

# Confirm that the home directory is available and writable.
if [[ -z "${HOME:-}" || ! -d "$HOME" ]]; then
    write_result FAIL "Home directory" "A valid home directory could not be identified"
    finish
fi

if [[ ! -w "$HOME" ]]; then
    write_result FAIL "Home directory" "The current user cannot write to $HOME"
    finish
fi

write_result PASS "Home directory" "Home directory is available and writable"

# Create the main Cybersecurity workspace if it does not already exist.
if [[ -e "$BASE_DIR" && ! -d "$BASE_DIR" ]]; then
    write_result FAIL "Workspace" "$BASE_DIR exists but is not a directory"
    finish
fi

if [[ -d "$BASE_DIR" ]]; then
    write_result INFO "Workspace" "$BASE_DIR already exists"
else
    if mkdir -p "$BASE_DIR"; then
        write_result PASS "Workspace" "Created $BASE_DIR"
    else
        write_result FAIL "Workspace" "Unable to create $BASE_DIR"
        finish
    fi
fi

# Create each standard workspace directory.
for directory in "${DIRECTORIES[@]}"; do
    target="${BASE_DIR}/${directory}"

    if [[ -e "$target" && ! -d "$target" ]]; then
        write_result FAIL "$directory" "$target exists but is not a directory"
        continue
    fi

    if [[ -d "$target" ]]; then
        write_result INFO "$directory" "Directory already exists"
        continue
    fi

    if mkdir -p "$target"; then
        write_result PASS "$directory" "Directory created"
    else
        write_result FAIL "$directory" "Unable to create directory"
    fi
done

# Verify the expected directory layout after creation.
printf '\n--- Verification ---\n'

MISSING=0

for directory in "${DIRECTORIES[@]}"; do
    target="${BASE_DIR}/${directory}"

    if [[ -d "$target" ]]; then
        printf '[OK] %s\n' "$target"
    else
        printf '[MISSING] %s\n' "$target"
        ((MISSING+=1))
    fi
done

if (( MISSING > 0 )); then
    write_result FAIL "Verification" "$MISSING expected directories are missing"
else
    write_result PASS "Verification" "All expected directories are present"
fi

write_result INFO "Workspace path" "$BASE_DIR"
write_result INFO "Safety" "Existing files and directories were not deleted or overwritten"

finish
