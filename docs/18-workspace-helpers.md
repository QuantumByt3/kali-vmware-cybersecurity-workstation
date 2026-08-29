# CTF and DFIR Workspace Helpers

This step documents the reusable workspace helpers included with the Kali
workstation.

These helpers create consistent directory structures and starter
documentation for authorized cybersecurity exercises. They do not scan
networks, exploit systems, acquire evidence, or perform forensic analysis.

---

## 1. Included Helpers

The repository includes:

```text
scripts/kali/workspace/Initialize-DirectoryLayout.sh
scripts/kali/workspace/New-CTFWorkspace.sh
scripts/kali/workspace/New-DFIRCaseWorkspace.sh
```

Use them in this order:

1. Initialize the main workstation directories.
2. Create a CTF workspace for an authorized challenge or lab.
3. Create a DFIR workspace for an authorized forensic exercise.

---

## 2. Initialize the Main Directory Layout

Run:

```bash
chmod +x scripts/kali/workspace/Initialize-DirectoryLayout.sh
./scripts/kali/workspace/Initialize-DirectoryLayout.sh
```

The helper creates:

```text
~/Cybersecurity/
├── CTFs/
├── Labs/
├── Projects/
├── Scripts/
├── Notes/
├── Captures/
├── Wordlists/
├── Tools/
└── Temp/
```

Running the helper again is safe. Existing directories are preserved.

---

## 3. Create a CTF Workspace

Run:

```bash
chmod +x scripts/kali/workspace/New-CTFWorkspace.sh
./scripts/kali/workspace/New-CTFWorkspace.sh "Example CTF"
```

The supplied name is converted into a filesystem-safe directory name.

For example:

```text
Example CTF
```

becomes:

```text
example-ctf
```

The workspace is created under:

```text
~/Cybersecurity/CTFs/example-ctf
```

---

## 4. CTF Workspace Structure

A new CTF workspace contains:

```text
example-ctf/
├── Files/
├── Findings/
├── Notes/
├── README.md
├── Scans/
├── Screenshots/
├── Scripts/
└── Web/
```

Use:

- `Notes/` for commands, observations, and methodology.
- `Scans/` for authorized scan and enumeration output.
- `Web/` for web-application notes and reviewed artifacts.
- `Files/` for challenge files and working copies.
- `Screenshots/` for screenshots requiring review.
- `Scripts/` for challenge-specific helper scripts.
- `Findings/` for validated findings and final notes.

---

## 5. CTF Safety

CTF artifacts may expose:

- IP addresses
- Hostnames
- Usernames
- Credentials
- Tokens
- Session data
- Internal paths
- Network information

Review and sanitize artifacts before publication.

Do not publish private keys, VPN profiles, credentials, or authentication
tokens.

The workspace itself does not establish authorization. Follow the scope and
rules supplied by the lab, CTF, course, or competition.

---

## 6. CTF Overwrite Protection

If a requested workspace already exists, the helper does not overwrite it.

A repeat run reports:

```text
Overall Result: CTF WORKSPACE READY WITH REVIEW ITEMS
```

and returns exit code:

```text
0
```

Existing notes and challenge artifacts remain untouched.

---

## 7. Create a DFIR Case Workspace

Run:

```bash
chmod +x scripts/kali/workspace/New-DFIRCaseWorkspace.sh
./scripts/kali/workspace/New-DFIRCaseWorkspace.sh "Example DFIR Lab"
```

The name is converted into a filesystem-safe directory name.

The workspace is created under:

```text
~/Cybersecurity/Projects/DFIR-Cases/example-dfir-lab
```

---

## 8. DFIR Workspace Structure

A new DFIR workspace contains:

```text
example-dfir-lab/
├── Evidence-Original/
├── Evidence-Working/
├── Exports/
├── Hashes/
│   └── sha256.txt
├── Notes/
│   └── case-notes.md
├── README.md
├── Reports/
├── Screenshots/
├── Scripts/
└── Timeline/
```

The helper creates structure and documentation only.

It does not acquire, copy, mount, hash, modify, or analyze evidence.

---

## 9. Evidence Directories

Use:

```text
Evidence-Original/
```

for preserved source evidence when appropriate for the exercise.

Use:

```text
Evidence-Working/
```

for analysis copies and derived working material.

Perform analysis on working copies rather than the only available original
whenever practical.

For formal investigations, follow the applicable organizational, legal, and
chain-of-custody procedures.

---

## 10. Hash Records

The helper creates:

```text
Hashes/sha256.txt
```

as an empty log for SHA-256 integrity records.

A typical hashing command is:

```bash
sha256sum Evidence-Working/example.img
```

The workspace helper does not automatically hash files.

Record hashes according to the requirements of the lab, course, competition,
or organization.

---

## 11. DFIR Notes and Analysis Material

The helper creates:

```text
Notes/case-notes.md
```

with sections for:

```text
Authorization and Scope
Evidence Inventory
Analysis Log
Findings
```

Record significant commands, tools, timestamps, observations, and decisions.

Keep investigative leads separate from validated findings.

Use:

- `Exports/` for tool exports and extracted artifacts.
- `Timeline/` for timeline data and reconstruction.
- `Reports/` for findings, summaries, and reports.
- `Screenshots/` for reviewed case screenshots.
- `Scripts/` for case-specific analysis helpers.

---

## 12. DFIR Publication Safety

Before publishing DFIR material, check for:

- Personal information
- Usernames
- Hostnames
- File paths
- IP addresses
- Credentials
- Tokens
- Case identifiers
- Unrelated desktop content

Before publishing scripts, remove hard-coded case data and secrets.

Real evidence and sensitive case material should not be stored in a public Git
repository.

---

## 13. DFIR Overwrite Protection

If a requested DFIR workspace already exists, the helper does not overwrite
it.

A repeat run reports:

```text
Overall Result: DFIR CASE WORKSPACE READY WITH REVIEW ITEMS
```

and returns exit code:

```text
0
```

Existing evidence folders, notes, and templates remain untouched.

---

## 14. Repository Safety

The public repository should contain the helper scripts and documentation, not
private challenge data or real case evidence.

The repository `.gitignore` blocks many common sensitive artifact types, but
`.gitignore` is not a substitute for manual review.

Before committing, verify that you are not publishing:

- Credentials
- Private keys
- VPN profiles
- Tokens
- Packet captures
- Memory dumps
- Disk images
- VM disks
- Real-world evidence
- Private lab information
- Unsanitized screenshots

---

## 15. Successful Results

A successful new CTF workspace ends with:

```text
Overall Result: CTF WORKSPACE READY
```

A successful new DFIR workspace ends with:

```text
Overall Result: DFIR CASE WORKSPACE READY
```

Check either exit code with:

```bash
echo $?
```

Expected:

```text
0
```

---

## 16. Workspace Helper Checklist

Before continuing, verify:

- [ ] The main `~/Cybersecurity` directory layout exists
- [ ] `New-CTFWorkspace.sh` creates the expected CTF structure
- [ ] CTF names are sanitized into safe directory names
- [ ] Existing CTF workspaces are not overwritten
- [ ] `New-DFIRCaseWorkspace.sh` creates the expected DFIR structure
- [ ] DFIR names are sanitized into safe directory names
- [ ] The DFIR README is created
- [ ] The DFIR case-notes template is created
- [ ] The empty SHA-256 log is created
- [ ] Existing DFIR workspaces are not overwritten
- [ ] Neither helper performs network activity
- [ ] Neither helper automatically acquires or modifies evidence
- [ ] Sensitive artifacts are reviewed before publication

The next phase covers VMware networking modes and how to choose the safest
network configuration for normal workstation use, CTF labs, and isolated
practice environments.
