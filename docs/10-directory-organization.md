# Kali Workstation Directory Organization

This step creates a simple directory structure for cybersecurity work.

The goal is to keep CTFs, labs, scripts, notes, captures, and projects
organized without creating unnecessary clutter.

---

## 1. Main Workspace

The primary workspace for this repository is:

```text
~/Cybersecurity
```

Inside it, the workstation will use these folders:

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

---

## 2. What Each Folder Is For

### CTFs

Use:

```text
~/Cybersecurity/CTFs
```

for Capture the Flag events and challenges.

Create a separate folder for each event or platform.

Example:

```text
~/Cybersecurity/CTFs/Example-CTF
```

---

### Labs

Use:

```text
~/Cybersecurity/Labs
```

for authorized training environments and coursework.

Examples include:

- Hack The Box
- TryHackMe
- Local practice VMs
- Cybersecurity course labs
- Club exercises

---

### Projects

Use:

```text
~/Cybersecurity/Projects
```

for longer-term cybersecurity projects, code, and research.

Git repositories may also be stored here when appropriate.

---

### Scripts

Use:

```text
~/Cybersecurity/Scripts
```

for reusable Bash, Python, and other scripts that are not already managed
inside a dedicated Git repository.

Do not store passwords, tokens, or private keys inside scripts.

---

### Notes

Use:

```text
~/Cybersecurity/Notes
```

for technical notes, command references, and lab observations.

Do not place sensitive credentials in notes that may later be published.

---

### Captures

Use:

```text
~/Cybersecurity/Captures
```

for packet captures and temporary network-analysis files.

Packet captures may contain sensitive information.

Do not automatically publish this folder to GitHub.

---

### Wordlists

Use:

```text
~/Cybersecurity/Wordlists
```

for additional wordlists that you intentionally download or create.

Kali already includes system wordlists in locations such as:

```text
/usr/share/wordlists
```

Do not duplicate large system wordlists unnecessarily.

---

### Tools

Use:

```text
~/Cybersecurity/Tools
```

for third-party tools that are not installed through Kali's package manager.

Prefer official repositories and trusted sources.

Do not install random tools simply because they appear in a walkthrough.

---

### Temp

Use:

```text
~/Cybersecurity/Temp
```

for disposable files created during labs or troubleshooting.

Important work should not remain only in this directory.

---

## 3. Keep the Home Directory Clean

Avoid placing every tool, capture, script, and CTF directly in:

```text
~
```

A predictable workspace makes it easier to:

- Find previous work
- Back up important files
- Separate temporary data from projects
- Avoid accidentally publishing sensitive artifacts
- Reuse scripts across labs

---

## 4. Automated Setup

This repository provides:

```text
scripts/kali/workspace/Initialize-DirectoryLayout.sh
```

The script creates the standard workspace automatically.

It creates only missing directories and leaves existing files and directories
unchanged.

Before running it, complete Step 00 Part B and confirm that the terminal is
inside the Kali repository root.

From the repository root inside Kali, run:

```bash
bash scripts/kali/workspace/Initialize-DirectoryLayout.sh
```

Do not run this script with `sudo`.

The workspace belongs to the normal Kali user, and the script intentionally
refuses to run as root.

A successful run ends with:

```text
Overall Result: DIRECTORY LAYOUT VERIFIED
```

and returns exit code:

```text
0
```

If the script reports:

```text
Overall Result: DIRECTORY SETUP NEEDS ATTENTION
```

stop and review the reported failure before continuing.

---

## 5. Directory Checklist

Before continuing, verify:

- [ ] `~/Cybersecurity` exists
- [ ] `CTFs` exists
- [ ] `Labs` exists
- [ ] `Projects` exists
- [ ] `Scripts` exists
- [ ] `Notes` exists
- [ ] `Captures` exists
- [ ] `Wordlists` exists
- [ ] `Tools` exists
- [ ] `Temp` exists

The standard Kali workspace directory layout is now verified.

Previous:

[09 — Kali Security Baseline](09-kali-security-baseline.md)

Continue to:

[11 — Install and Verify Core Kali Tools](11-core-tools.md)
