#!/usr/bin/env bash

# Creates a structured workspace for an authorized DFIR lab, exercise, or case
# under ~/Cybersecurity/Projects/DFIR-Cases. The helper creates directories
# and documentation templates only; it does not acquire, copy, mount, hash,
# modify, or analyze evidence.

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
    printf ' DFIR Case Workspace Summary\n'
    printf '===============================================\n'
    printf 'PASS : %s\n' "$PASS"
    printf 'WARN : %s\n' "$WARN"
    printf 'FAIL : %s\n' "$FAIL"
    printf 'INFO : %s\n' "$INFO"
    printf '\n'

    if (( FAIL > 0 )); then
        printf 'Overall Result: DFIR CASE WORKSPACE NEEDS ATTENTION\n'
        exit 1
    fi

    if (( WARN > 0 )); then
        printf 'Overall Result: DFIR CASE WORKSPACE READY WITH REVIEW ITEMS\n'
        exit 0
    fi

    printf 'Overall Result: DFIR CASE WORKSPACE READY\n'
    exit 0
}

printf '\n'
printf '===============================================\n'
printf ' New Authorized DFIR Case Workspace\n'
printf '===============================================\n'
printf '\n'

if (( EUID == 0 )); then
    write_result FAIL "User context" "Do not run this helper as root or with sudo"
    finish
fi

PROJECTS_ROOT="${HOME}/Cybersecurity/Projects"
WORKSPACE_ROOT="${PROJECTS_ROOT}/DFIR-Cases"

if [[ ! -d "$PROJECTS_ROOT" ]]; then
    write_result FAIL "Projects root" "$PROJECTS_ROOT does not exist"
    write_result INFO "Prerequisite" "Run Initialize-DirectoryLayout.sh first"
    finish
fi

if [[ ! -d "$WORKSPACE_ROOT" ]]; then
    if mkdir -p "$WORKSPACE_ROOT"; then
        write_result PASS "DFIR root" "Created $WORKSPACE_ROOT"
    else
        write_result FAIL "DFIR root" "Could not create $WORKSPACE_ROOT"
        finish
    fi
else
    write_result PASS "DFIR root" "$WORKSPACE_ROOT is available"
fi

RAW_NAME="${1:-}"

if [[ -z "$RAW_NAME" ]]; then
    read -r -p "DFIR case or lab name: " RAW_NAME
fi

if [[ -z "$RAW_NAME" ]]; then
    write_result FAIL "Case name" "A DFIR case or lab name is required"
    finish
fi

if [[ "$RAW_NAME" == "." || "$RAW_NAME" == ".." ]]; then
    write_result FAIL "Case name" "Reserved directory names are not allowed"
    finish
fi

SAFE_NAME="$(
    printf '%s' "$RAW_NAME" |
        tr '[:upper:]' '[:lower:]' |
        sed -E 's/[^a-z0-9._-]+/-/g; s/^-+//; s/-+$//'
)"

if [[ -z "$SAFE_NAME" ]]; then
    write_result FAIL "Case name" "The supplied name did not contain usable characters"
    finish
fi

if [[ "$SAFE_NAME" == "." || "$SAFE_NAME" == ".." ]]; then
    write_result FAIL "Case name" "Sanitized name is not safe"
    finish
fi

TARGET="${WORKSPACE_ROOT}/${SAFE_NAME}"

if [[ "$SAFE_NAME" != "$RAW_NAME" ]]; then
    write_result INFO "Case name" "Using sanitized directory name: $SAFE_NAME"
else
    write_result PASS "Case name" "Using directory name: $SAFE_NAME"
fi

if [[ -e "$TARGET" ]]; then
    write_result WARN "Workspace creation" "$TARGET already exists; no files were overwritten"
    write_result INFO "Existing workspace" "Use the existing directory or choose a different name"
    finish
fi

DIRECTORIES=(
    Evidence-Original
    Evidence-Working
    Hashes
    Notes
    Exports
    Screenshots
    Timeline
    Reports
    Scripts
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
NOTES_PATH="$TARGET/Notes/case-notes.md"
HASH_PATH="$TARGET/Hashes/sha256.txt"

cat > "$README_PATH" <<EOF
# ${RAW_NAME}

Authorized DFIR lab, exercise, or case workspace.

## Scope and Authorization

Document the authorized evidence sources, systems, case boundaries, and any
handling requirements before beginning analysis.

## Evidence Handling

- Preserve original evidence whenever possible.
- Calculate and record hashes before analysis when appropriate.
- Perform analysis on working copies rather than the only original.
- Do not place credentials, personal data, or sensitive case material in a
  public repository.
- Follow organizational, legal, academic, or competition handling rules.

## Workspace

- \`Evidence-Original/\` - preserved source evidence; avoid modifying contents
- \`Evidence-Working/\` - analysis copies and derived working material
- \`Hashes/\` - recorded integrity hashes
- \`Notes/\` - case notes, commands, observations, and methodology
- \`Exports/\` - tool exports and extracted artifacts
- \`Screenshots/\` - screenshots requiring review before publication
- \`Timeline/\` - timeline data and event reconstruction
- \`Reports/\` - findings, summaries, and final reports
- \`Scripts/\` - case-specific helper scripts
EOF

cat > "$NOTES_PATH" <<EOF
# Case Notes - ${RAW_NAME}

## Authorization and Scope

Record the authorized scope here before analysis.

## Evidence Inventory

Document evidence identifiers, source descriptions, and acquisition details.

## Analysis Log

Record significant commands, tools, timestamps, observations, and findings.

## Findings

Document validated findings separately from assumptions or investigative leads.
EOF

: > "$HASH_PATH"

if [[ -f "$README_PATH" ]]; then
    write_result PASS "README" "Created case workspace README"
else
    write_result FAIL "README" "Workspace README was not created"
fi

if [[ -f "$NOTES_PATH" ]]; then
    write_result PASS "Case notes" "Created case-notes.md template"
else
    write_result FAIL "Case notes" "Case notes template was not created"
fi

if [[ -f "$HASH_PATH" ]]; then
    write_result PASS "Hash log" "Created empty SHA-256 hash log"
else
    write_result FAIL "Hash log" "SHA-256 hash log was not created"
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

write_result INFO "Evidence safety" "This helper did not acquire, copy, mount, hash, or modify evidence"
write_result INFO "Original evidence" "Keep Evidence-Original preserved and use working copies for analysis"
write_result INFO "Public repository safety" "Review and sanitize all case artifacts before publication"
write_result INFO "Next step" "Document authorization and evidence inventory before beginning analysis"

finish
