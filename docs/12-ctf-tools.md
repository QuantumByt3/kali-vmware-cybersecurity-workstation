# Focused CTF Tool Profile

This step installs and verifies a focused set of tools for Capture the Flag
competitions and authorized hands-on labs.

The profile is intentionally smaller than Kali's broad metapackages.

---

## 1. Run the CTF Tool Profile

From the root of this repository inside Kali, run:

```bash
bash scripts/kali/profiles/Install-CTFTools.sh
```

Enter your Kali password if `sudo` prompts for it.

The script refreshes package information and checks which CTF packages are
already installed.

---

## 2. What the Profile Covers

The profile provides tools commonly useful for:

- Web enumeration
- Content discovery
- Password auditing
- Hash analysis
- SMB and Active Directory labs
- Exploit research
- Metasploit labs
- Binary inspection
- Reverse engineering
- File and metadata analysis

The goal is to provide a useful starting toolkit without installing every
package available in Kali.

---

## 3. Web and Content Discovery

The profile verifies tools including:

```text
gobuster
ffuf
feroxbuster
dirsearch
nikto
whatweb
sqlmap
```

These tools support authorized web enumeration, content discovery, and
application-security labs.

---

## 4. Password and Hash Tools

The profile verifies:

```text
hydra
john
hashcat
```

Use password-auditing tools only against credentials, hashes, and systems you
are authorized to test.

---

## 5. SMB and Active Directory Tools

The profile verifies tools including:

```text
smbclient
rpcclient
netexec
impacket-smbclient
impacket-psexec
bloodhound-python
responder
evil-winrm
```

This repository uses:

```text
netexec
```

for the focused SMB and Active Directory workflow.

It does not require the older:

```text
crackmapexec
```

command.

---

## 6. Exploitation and Research Tools

The profile verifies:

```text
searchsploit
msfconsole
```

These tools are intended for authorized labs, CTFs, and systems for which you
have explicit testing permission.

---

## 7. Reverse Engineering and File Analysis

The profile verifies:

```text
radare2
gdb
checksec
strings
binwalk
exiftool
```

These tools provide a practical starting point for binary inspection,
challenge analysis, metadata review, and introductory reverse engineering.

---

## 8. Installing Missing Packages

If required packages are missing, the script lists them and asks:

```text
Install the missing CTF packages now? [y/N]:
```

Type:

```text
y
```

and press **Enter** to install them from the configured Kali repositories.

The script does not add third-party APT repositories.

---

## 9. Kali Metapackages

The script reports broad Kali metapackages for awareness but does not force
them to be installed.

Examples include:

```text
kali-tools-web
kali-tools-passwords
kali-tools-exploitation
kali-tools-information-gathering
kali-tools-vulnerability
kali-tools-forensics
kali-tools-reverse-engineering
```

This keeps the workstation focused and avoids installing large overlapping
collections only for completeness.

---

## 10. Successful Result

A successful run ends with:

```text
Overall Result: CTF TOOL PROFILE VERIFIED
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

## 11. CTF Tool Checklist

Before continuing, verify:

- [ ] The script completed with `FAIL : 0`
- [ ] Missing packages were installed successfully
- [ ] Required commands were found after installation
- [ ] No third-party APT repository was added
- [ ] NetExec is available for the focused SMB/AD workflow
- [ ] The script returns exit code `0`
- [ ] Running the script a second time does not reinstall existing packages

The next phase will establish a focused web-security workflow and browser
tooling for authorized application-security labs.
