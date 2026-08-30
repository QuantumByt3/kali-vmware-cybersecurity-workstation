# Focused Blue-Team and DFIR Tool Profile

This step installs and verifies the defensive-security and digital-forensics
tools used throughout this Kali workstation.

The profile is designed for packet analysis, file inspection, evidence triage,
memory forensics, and authorized blue-team or incident-response training.

---

## 1. Run the Blue-Team and DFIR Profile

From the root of this repository inside Kali, run:

```bash
bash scripts/kali/profiles/Install-BlueTeamDFIRTools.sh
```

Run the script from the normal Kali account. Do not prefix the command with
`sudo` and do not run it from a root shell. The profile requests `sudo` only
for APT package-management operations; the isolated Volatility 3 installation
runs as the normal user through `pipx`.

Enter your Kali password if `sudo` prompts for it.

The script checks the existing workstation first and installs only missing
components.

---

## 2. Network and Packet Analysis

The profile verifies:

```text
wireshark
tshark
tcpdump
```

These tools support packet capture and traffic analysis.

Packet captures may contain sensitive information such as:

- IP addresses
- Hostnames
- Credentials
- Cookies
- Session data
- DNS queries
- Application content

Treat packet captures as potentially sensitive evidence.

Do not commit packet captures to a public Git repository.

---

## 3. File Identification and Metadata

The profile verifies:

```text
file
exiftool
strings
binwalk
xxd
hexdump
```

These tools provide a practical starting point for:

- File-type identification
- Metadata inspection
- Embedded-content discovery
- Binary and hexadecimal inspection
- Initial artifact triage

---

## 4. Hashing and Integrity

The profile verifies:

```text
sha256sum
hashdeep
md5deep
```

For forensic work, calculate and record cryptographic hashes before modifying
or analyzing evidence whenever practical.

Prefer SHA-256 for modern integrity verification.

Example:

```bash
sha256sum evidence.img
```

Do not rely on MD5 alone for modern integrity verification.

---

## 5. File Carving

The profile verifies:

```text
foremost
```

Foremost can recover files from disk images or other data sources by examining
file signatures.

Perform carving against a working copy of evidence rather than the only
available original.

---

## 6. Bulk Data Extraction

The profile verifies:

```text
bulk_extractor
```

Bulk Extractor can identify features such as:

- Email addresses
- URLs
- Domain names
- Other structured artifacts

The resulting output may contain sensitive information.

Store extracted results in an appropriate case or lab workspace.

---

## 7. Filesystem Forensics

The profile verifies tools from The Sleuth Kit, including:

```text
fls
mmls
icat
fsstat
```

These tools support tasks such as:

- Partition review
- Filesystem inspection
- Directory listing
- File extraction
- Filesystem metadata review

Use forensic tools against authorized evidence and training images only.

---

## 8. YARA

The profile installs and verifies:

```text
yara
```

YARA uses rules to identify files or data that match defined patterns.

Use trusted rules and understand what a rule is designed to detect before
using its results as evidence of malicious activity.

A YARA match is an investigative lead, not automatic proof that a file is
malicious.

---

## 9. Volatility 3

Volatility 3 is used for memory-forensics analysis.

At the time this workstation profile was tested, Volatility 3 was not
available as a package from the configured Kali rolling APT repository.

The profile therefore installs:

```text
volatility3
```

using:

```text
pipx
```

This keeps the Python application inside an isolated environment instead of
installing it directly into Kali's system Python.

The primary command is:

```text
vol
```

The installed command should normally be available through:

```text
~/.local/bin/vol
```

---

## 10. Installing Volatility 3

If Volatility 3 is not already managed by pipx, the script asks:

```text
Install Volatility 3 from PyPI using pipx? [y/N]:
```

Type:

```text
y
```

and press **Enter** to install it.

If required APT packages are missing and you decline their installation, the
profile reports `Overall Result: BLUE-TEAM/DFIR PROFILE NEEDS ATTENTION` and
returns exit code `1`.

The script does not use:

```bash
sudo pip install
```

and does not modify Kali's system Python environment.

Volatility 3 and its `vol` command are required by the complete blue-team/DFIR
profile. If you decline the Volatility 3 installation when it is missing, or
if `vol` is still unavailable after installation review, the script reports a
failure and returns exit code `1`. Do not continue until the profile completes
successfully.

---

## 11. Evidence Handling

For real or simulated forensic work:

1. Preserve the original evidence when possible.
2. Record the original hash.
3. Perform analysis on a working copy.
4. Document important commands and observations.
5. Keep evidence and case information out of public repositories.
6. Recalculate hashes when integrity verification is required.

This repository is a workstation setup guide and is not a replacement for an
organization's forensic procedures or legal evidence-handling requirements.

---

## 12. Workspace Use

The standard workstation layout includes:

```text
~/Cybersecurity/Captures
```

for packet captures and temporary traffic-analysis files.

For larger forensic exercises, create a clearly named lab or project folder
under:

```text
~/Cybersecurity/Labs
```

or:

```text
~/Cybersecurity/Projects
```

Do not store sensitive real-world evidence in a public Git repository.

---

## 13. Successful Result

A successful profile run ends with:

```text
Overall Result: BLUE-TEAM/DFIR TOOL PROFILE VERIFIED
```

Check the exit code with:

```bash
echo $?
```

Expected result:

```text
0
```

---

## 14. Blue-Team and DFIR Checklist

Before continuing, verify:

- [ ] Wireshark is available
- [ ] TShark is available
- [ ] TCPDump is available
- [ ] YARA is available
- [ ] File and metadata inspection tools are available
- [ ] Foremost is available
- [ ] Bulk Extractor is available
- [ ] Sleuth Kit commands are available
- [ ] Hashing tools are available
- [ ] Volatility 3 is managed through pipx
- [ ] The `vol` command is available
- [ ] The profile completed with `FAIL : 0`
- [ ] The profile returned exit code `0`
- [ ] Running the profile again does not reinstall existing components

The focused blue-team and DFIR tool profile is now verified.

Previous:

[15 — Network and Active Directory Tools](15-network-ad-tools.md)

Continue to:

[17 — Development Environment](17-development-environment.md)
