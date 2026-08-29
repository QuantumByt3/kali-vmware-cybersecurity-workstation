#!/usr/bin/env bash

# Creates a clean, repeatable workspace for an authorized CTF, lab, or
# competition exercise under ~/Cybersecurity/CTFs. The helper performs no
# scanning, exploitation, or network activity.

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
    printf ' CTF Workspace Summary\n'
    printf '===============================================\n'
    printf 'PASS : %s\n' "$PASS"
    printf 'WARN : %s\n' "$WARN"
    printf 'FAIL : %s\n' "$FAIL"
    printf 'INFO : %s\n' "$INFO"
    printf '\n'

    if (( FAIL > 0 )); then
        printf 'Overall Result: CTF WORKSPACE NEEDS ATTENTION\n'
        exit 1
    fi

    if (( WARN > 0 )); then
        printf 'Overall Result: CTF WORKSPACE READY WITH REVIEW ITEMS\n'
        exit 0
    fi

    printf 'Overall Result: CTF WORKSPACE READY\n'
    exit 0
}

printf '\n'
printf '===============================================\n'
printf ' New Authorized CTF Workspace\n'
printf '===============================================\n'
printf '\n'

if (( EUID == 0 )); then
    write_result FAIL "User context" "Do not run this helper as root or with sudo"
    finish
fi

WORKSPACE_ROOT="${HOME}/Cybersecurity/CTFs"

if [[ ! -d "$WORKSPACE_ROOT" ]]; then
    write_result FAIL "Workspace root" "$WORKSPACE_ROOT does not exist"
    write_result INFO "Prerequisite" "Run Initialize-DirectoryLayout.sh first"
    finish
fi

RAW_NAME="${1:-}"

if [[ -z "$RAW_NAME" ]]; then
    read -r -p "CTF or lab name: " RAW_NAME
fi

if [[ -z "$RAW_NAME" ]]; then
    write_result FAIL "Workspace name" "A CTF or lab name is required"
    finish
fi

if [[ "$RAW_NAME" == "." || "$RAW_NAME" == ".." ]]; then
    write_result FAIL "Workspace name" "Reserved directory names are not allowed"
    finish
fi

SAFE_NAME="$(
    printf '%s' "$RAW_NAME" |
        tr '[:upper:]' '[:lower:]' |
        sed -E 's/[^a-z0-9._-]+/-/g; s/^-+//; s/-+$//'
)"

if [[ -z "$SAFE_NAME" ]]; then
    write_result FAIL "Workspace name" "The supplied name did not contain usable characters"
    finish
fi

if [[ "$SAFE_NAME" == "." || "$SAFE_NAME" == ".." ]]; then
    write_result FAIL "Workspace name" "Sanitized name is not safe"
    finish
fi

TARGET="${WORKSPACE_ROOT}/${SAFE_NAME}"

write_result PASS "Workspace root" "$WORKSPACE_ROOT is available"

if [[ "$SAFE_NAME" != "$RAW_NAME" ]]; then
    write_result INFO "Workspace name" "Using sanitized directory name: $SAFE_NAME"
else
    write_result PASS "Workspace name" "Using directory name: $SAFE_NAME"
fi

if [[ -e "$TARGET" ]]; then
    write_result WARN "Workspace creation" "$TARGET already exists; no files were overwritten"
    write_result INFO "Existing workspace" "Use the existing directory or choose a different name"
    finish
fi

DIRECTORIES=(
    Notes
    Scans
    Web
    Files
    Screenshots
    Scripts
    Findings
)

if mkdir -p "$TARGET"; then
    write_result PASS "Workspace creation" "Created $TARGET"
else
    write_result FAIL "Workspace creation" "Could not create $TARGET"
    finish
fi

for directory in "${DIRECTORIES[@]}"; do
    if mkdir -p "$TARGET/$directory"; then
        write_result PASS "$directory" "Created $TARGET/$directory"
    else
        write_result FAIL "$directory" "Could not create $TARGET/$directory"
    fi
done

README_PATH="$TARGET/README.md"

cat > "$README_PATH" <<EOF
# ${RAW_NAME}

Authorized CTF, lab, or competition workspace.

## Scope

Document the systems, challenge targets, or lab environment that you are
authorized to test before beginning technical work.

## Notes

- Keep credentials, VPN profiles, private keys, and tokens out of public repos.
- Treat screenshots, scan results, and downloaded challenge files as sensitive
  until they have been reviewed and sanitized.
- Do not use this workspace as evidence that a target is authorized.
- Follow the rules and scope provided by the lab, CTF, course, or organization.

## Workspace

- \`Notes/\` - command notes, observations, and methodology
- \`Scans/\` - authorized scan output
- \`Web/\` - web-testing notes and artifacts
- \`Files/\` - challenge files and working copies
- \`Screenshots/\` - screenshots requiring review before publication
- \`Scripts/\` - challenge-specific helper scripts
- \`Findings/\` - validated findings and final notes
EOF

if [[ -f "$README_PATH" ]]; then
    write_result PASS "README" "Created workspace README"
else
    write_result FAIL "README" "Workspace README was not created"
fi

if (( FAIL > 0 )); then
    finish
fi

printf '\nWorkspace created:\n\n'
printf '  %s\n\n' "$TARGET"

printf 'Directory structure:\n\n'
find "$TARGET" -maxdepth 1 -mindepth 1 -printf '  %f\n' |
    sort

printf '\n'

write_result INFO "Authorized use" "Use this workspace only for systems and challenges you are authorized to test"
write_result INFO "Public repository safety" "Review and sanitize artifacts before committing them publicly"
write_result INFO "Next step" "Record the authorized scope in the workspace README before testing"

finish
