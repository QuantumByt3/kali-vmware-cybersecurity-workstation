# Get the Repository Before Running Repository Scripts

This guide explains how to obtain the repository files before running any
repository script.

The most important concept is:

```text
The Windows host and the Kali virtual machine are separate operating systems.
Each operating system needs access to the repository files before it can run
the scripts intended for that operating system.
```

You do not pair VMware or Kali with GitHub.

---

## 1. Why This Guide Exists

Later guides use commands such as:

```powershell
.\scripts\windows\Test-HostReadiness.ps1
```

and:

```bash
bash scripts/kali/Install-CoreTools.sh
```

Those commands work only when the repository exists locally in the operating
system where the command is being run.

A path such as:

```text
scripts/kali/workspace/Initialize-DirectoryLayout.sh
```

is a file path inside this repository.

It is not a download command.

Typing that path by itself does not download anything from GitHub.

---

## 2. Windows and Kali Are Separate Environments

This workstation uses two operating systems:

```text
Windows 11 host
    |
    +-- Windows repository copy
    |      `-- scripts/windows/
    |
    `-- VMware Workstation Pro
           |
           `-- Kali Linux VM
                  |
                  `-- Kali repository copy
                         `-- scripts/kali/
```

Windows PowerShell scripts run on Windows.

Kali Bash scripts run inside Kali.

The Kali virtual machine itself is downloaded separately from Kali Linux and
must remain outside this Git repository.

---

## 3. No GitHub Account or Pairing Is Required

This repository is public.

A person following the guide does not need to:

- Create a GitHub account
- Configure an SSH key
- Fork the repository
- Pair VMware with GitHub
- Pair Kali with GitHub
- Enable VMware Shared Folders

Public repository files can be obtained with an HTTPS Git clone or GitHub's
**Download ZIP** option.

GitHub authentication is needed only for actions such as pushing changes to a
repository for which the user has write access.

---

## 4. Official Repository

Use the public repository:

[Kali VMware Cybersecurity Workstation](https://github.com/QuantumByt3/kali-vmware-cybersecurity-workstation)

The HTTPS clone address is:

```text
https://github.com/QuantumByt3/kali-vmware-cybersecurity-workstation.git
```

For a beginner, HTTPS cloning is simpler than SSH because no SSH key is
required to clone a public repository.

---

## Part A - Windows Repository Copy

The Windows copy provides the Windows-side validation scripts used during the
early build.

Use either the Git method or the ZIP method.

---

### 5. Windows Method A - Clone with Git

Open PowerShell.

Check whether Git is installed:

```powershell
git --version
```

If Git reports a version, continue.

If Git is not installed and you want to use this method, obtain Git for Windows
from its official source:

[Git for Windows](https://git-scm.com/download/win)

After Git is installed, open a new PowerShell window.

Choose a normal repository location outside the VMware VM directory.

Example:

```powershell
New-Item -ItemType Directory -Path "C:\GitHub" -Force
Set-Location "C:\GitHub"
```

Clone the repository:

```powershell
git clone https://github.com/QuantumByt3/kali-vmware-cybersecurity-workstation.git
```

Enter the repository:

```powershell
Set-Location ".\kali-vmware-cybersecurity-workstation"
```

Do not clone the repository inside:

```text
C:\VMs
```

or inside the extracted Kali VMware directory.

The Git repository and the virtual machine serve different purposes.

---

### 6. Verify the Windows Git Copy

From the repository root, run:

```powershell
Test-Path ".\README.md"
Test-Path ".\docs"
Test-Path ".\scripts\windows"
Test-Path ".\scripts\kali"
```

All four commands should return:

```text
True
```

Then run:

```powershell
git remote get-url origin
```

The result should identify:

```text
https://github.com/QuantumByt3/kali-vmware-cybersecurity-workstation.git
```

or another valid remote URL for this same repository.

---

### 7. Windows Method B - Download ZIP

Git is not required merely to read or use the repository.

To use the ZIP method:

1. Open the repository in a web browser.
2. Select **Code**.
3. Select **Download ZIP**.
4. Save the ZIP outside the VMware VM directory.
5. Extract the ZIP.
6. Open PowerShell in the extracted repository directory.

The extracted directory may be named:

```text
kali-vmware-cybersecurity-workstation-main
```

Verify it with:

```powershell
Test-Path ".\README.md"
Test-Path ".\docs"
Test-Path ".\scripts\windows"
Test-Path ".\scripts\kali"
```

All four commands should return:

```text
True
```

A ZIP copy does not contain Git history.

A ZIP copy cannot be updated with:

```text
git pull
```

Download and extract a newer ZIP when a newer repository copy is needed.

---

### 8. What "Repository Root" Means on Windows

The repository root is the directory containing files and directories such as:

```text
README.md
docs
scripts
SECURITY.md
LICENSE
```

When a guide says:

```text
From the repository root in PowerShell
```

PowerShell must currently be inside that directory.

Confirm the current directory with:

```powershell
Get-Location
```

A relative command such as:

```powershell
.\scripts\windows\Test-HostReadiness.ps1
```

starts from the current PowerShell directory.

If PowerShell is in the wrong directory, the command may report that the file
does not exist even though the script is present in the repository.

---

## Part B - Kali Repository Copy

The Kali copy becomes necessary when the numbered build begins using scripts
under:

```text
scripts/kali/
```

The normal sequence is:

```text
Windows setup
    |
    v
VMware installation
    |
    v
Kali download and import
    |
    v
Kali first boot
    |
    v
Kali update
    |
    v
Baseline snapshot
    |
    v
Kali security review
    |
    v
Obtain or verify the repository inside Kali
    |
    v
Create the Kali workspace
    |
    v
Install and validate Kali tooling
```

---

### 9. Keep the Kali Repository Copy Separate

The security-first VMware baseline keeps Shared Folders disabled.

You do not need to enable Shared Folders just to make repository scripts
available inside Kali.

Instead, obtain a separate public repository copy inside Kali.

The recommended location is:

```text
~/kali-vmware-cybersecurity-workstation
```

This location is intentionally separate from:

```text
~/Cybersecurity
```

because Step 10 creates the `~/Cybersecurity` workspace.

---

### 10. Kali Method A - Clone with Git

Open a Kali terminal.

Check whether Git is installed:

```bash
git --version
```

If Git reports a version, continue.

If Git is missing, install it from the configured Kali repositories:

```bash
sudo apt update
sudo apt install -y git
```

Return to the Kali home directory:

```bash
cd ~
```

Clone the public repository:

```bash
git clone https://github.com/QuantumByt3/kali-vmware-cybersecurity-workstation.git
```

No GitHub username, password, SSH key, or personal access token is required for
this public HTTPS clone.

Enter the repository:

```bash
cd ~/kali-vmware-cybersecurity-workstation
```

Confirm the current directory:

```bash
pwd
```

The result should end with:

```text
/kali-vmware-cybersecurity-workstation
```

---

### 11. Verify the Kali Git Copy

From the Kali repository root, run:

```bash
test -f README.md && echo "README: PASS"
test -d docs && echo "docs: PASS"
test -d scripts/windows && echo "Windows scripts: PASS"
test -d scripts/kali && echo "Kali scripts: PASS"
```

Expected result:

```text
README: PASS
docs: PASS
Windows scripts: PASS
Kali scripts: PASS
```

Then run:

```bash
git remote get-url origin
```

The result should identify this repository.

The normal public HTTPS remote is:

```text
https://github.com/QuantumByt3/kali-vmware-cybersecurity-workstation.git
```

---

### 12. Kali Method B - Download ZIP

If Git is not desired, use GitHub's ZIP download.

Inside Kali:

1. Open Firefox.
2. Open the public repository.
3. Select **Code**.
4. Select **Download ZIP**.
5. Save the archive.
6. Extract it.
7. Open a terminal in the extracted repository directory.

The directory may be named:

```text
kali-vmware-cybersecurity-workstation-main
```

Verify the extracted copy:

```bash
test -f README.md && echo "README: PASS"
test -d docs && echo "docs: PASS"
test -d scripts/windows && echo "Windows scripts: PASS"
test -d scripts/kali && echo "Kali scripts: PASS"
```

Expected result:

```text
README: PASS
docs: PASS
Windows scripts: PASS
Kali scripts: PASS
```

A ZIP copy cannot be updated with `git pull`.

Download a newer ZIP when a newer repository copy is needed.

---

### 13. What "Repository Root" Means Inside Kali

For the recommended Git clone, the repository root is:

```text
~/kali-vmware-cybersecurity-workstation
```

Before running a Kali repository script, enter that directory:

```bash
cd ~/kali-vmware-cybersecurity-workstation
```

Then verify the requested script exists.

Example:

```bash
test -f scripts/kali/workspace/Initialize-DirectoryLayout.sh && echo "Script found: PASS"
```

Expected result:

```text
Script found: PASS
```

Only after the file is confirmed should the script be executed.

---

### 14. The Step 10 Example

Step 10 uses:

```text
scripts/kali/workspace/Initialize-DirectoryLayout.sh
```

That text identifies the location of the script inside the local Kali
repository copy.

It does not download anything.

It does not pair Kali with GitHub.

From the Kali repository root, run:

```bash
bash scripts/kali/workspace/Initialize-DirectoryLayout.sh
```

That script creates the standard workspace under:

```text
~/Cybersecurity
```

If Bash reports:

```text
No such file or directory
```

do not change VMware settings.

First check:

```bash
pwd
```

Then check:

```bash
test -f scripts/kali/workspace/Initialize-DirectoryLayout.sh && echo "Script found: PASS"
```

If the script is not found, verify that the repository was downloaded or
cloned correctly and that the terminal is in the repository root.

---

### 15. Standard Kali Script Execution

Beginner-facing instructions in this repository use:

```bash
bash path/to/script.sh
```

Using `bash` explicitly avoids requiring the executable permission bit merely
to follow the guide.

You may inspect a script before running it.

Example:

```bash
less scripts/kali/Update-Kali.sh
```

Press:

```text
q
```

to exit `less`.

Reading a script before running it is encouraged.

---

### 16. Keep Windows and Kali Scripts in the Correct Operating System

Run files under:

```text
scripts/windows/
```

from Windows PowerShell.

Run files under:

```text
scripts/kali/
```

from a Kali terminal.

Do not try to run Windows PowerShell validators as ordinary Kali Bash scripts.

Do not try to run Kali Bash scripts as ordinary Windows PowerShell scripts.

The directory names indicate which operating system is intended to run the
script.

---

### 17. Updating a Git Repository Copy

If a Git clone has no local changes, update it from the repository root with:

```powershell
git pull --ff-only
```

on Windows, or:

```bash
git pull --ff-only
```

inside Kali.

The command:

```text
--ff-only
```

prevents Git from silently creating a merge commit during a routine update.

If Git reports local modifications or another conflict, do not discard work
blindly.

Review the local changes first.

ZIP users should download and extract a fresh ZIP instead.

---

### 18. The Repository Is Not the Virtual Machine

This repository contains:

- Documentation
- PowerShell scripts
- Bash scripts
- Validation logic
- Workspace helpers
- GitHub project files

It does not contain the Kali virtual machine itself.

The Kali VM remains in the Windows VM storage location selected during the
VMware setup.

For example:

```text
C:\VMs\kali-linux-<version>-vmware-amd64\
```

Do not move the VM into the Git repository.

Do not move the Git repository into the VM's VMware file directory.

---

### 19. Keep Sensitive Work Outside the Public Repository

Do not place these items in either public repository copy:

- Passwords
- API tokens
- Authentication cookies
- SSH private keys
- VPN profiles
- Private CTF material
- Packet captures containing private traffic
- Memory dumps
- Disk images
- Real forensic evidence
- VMware virtual disks
- Private lab addressing
- Unsanitized screenshots

Review:

[Security and Sensitive-Data Policy](../SECURITY.md)

before publishing repository changes.

---

### 20. Fresh-User Checklist

Before running any repository script, confirm:

- [ ] You know whether the command belongs to Windows or Kali
- [ ] The repository exists locally in that operating system
- [ ] You are inside the repository root
- [ ] `README.md` is present
- [ ] `docs/` is present
- [ ] `scripts/windows/` is present
- [ ] `scripts/kali/` is present
- [ ] The specific script named by the guide exists locally
- [ ] The repository is not the Kali virtual machine itself
- [ ] Windows and Kali may use separate repository copies
- [ ] VMware Shared Folders are not required
- [ ] A public HTTPS clone does not require GitHub authentication
- [ ] Sensitive lab data will remain outside the public repository

---

### 21. Continue the Build

After obtaining and verifying the Windows repository copy, continue to:

[Windows 11 Host Readiness](01-windows-host-readiness.md)

Later, after completing the Kali security-baseline review and before Step 10
uses its first Kali repository workspace script, return to Part B of this guide
and obtain or verify the Kali repository copy.

The governing rule for the remainder of the project is:

```text
If a guide tells you to run a repository script, first confirm that the
repository exists locally in the operating system where that script must run.
```
