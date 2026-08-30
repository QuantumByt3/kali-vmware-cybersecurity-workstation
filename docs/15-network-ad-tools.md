# Focused Networking and Active Directory Tool Profile

This step installs and verifies the networking and Active Directory tools used
throughout this Kali workstation.

The profile is designed for authorized labs, CTFs, coursework, and defensive
training.

---

## 1. Run the Networking and AD Tool Profile

From the root of this repository inside Kali, run:

```bash
bash scripts/kali/profiles/Install-NetworkADTools.sh
```

Run the script from the normal Kali account. Do not prefix the command with
`sudo` and do not run it from a root shell. The profile requests `sudo` only
for package-management operations.

Enter your Kali password if `sudo` prompts for it.

The script refreshes package information and installs only packages that are
missing.

If required networking or Active Directory packages are missing and you
decline the installation prompt, the profile remains incomplete. The script
reports `Overall Result: NETWORK/AD TOOL PROFILE NEEDS ATTENTION` and returns
exit code `1`.

---

## 2. Core Networking Tools

The profile verifies tools including:

```text
ip
ss
ping
traceroute
dig
whois
nmap
masscan
arp-scan
netdiscover
tcpdump
tshark
wireshark
```

These tools support network configuration, connectivity checks, discovery,
packet capture, and traffic analysis.

---

## 3. DNS Tooling

On the Kali baseline used for this repository, the:

```text
dig
```

command is provided by:

```text
bind9-dnsutils
```

The older `dnsutils` package name is not required by this setup.

---

## 4. SMB and Windows Network Tools

The profile verifies:

```text
smbclient
rpcclient
netexec
enum4linux
```

These tools are commonly used in authorized Windows, SMB, and Active
Directory labs.

---

## 5. Active Directory Tools

The profile verifies:

```text
bloodhound-python
responder
evil-winrm
ldapsearch
certipy-ad
impacket-smbclient
impacket-psexec
```

The related Kali packages include:

```text
bloodhound.py
responder
evil-winrm
ldap-utils
certipy-ad
python3-impacket
```

Do not assume that a command name and its package name are always identical.

---

## 6. Service Behavior

Installing these tools does not mean their related services should run
continuously.

The setup script does not start:

```text
SSH
Samba
Responder
web servers
other remote services
```

Start a service or listener only when an authorized lab requires it.

Stop it when the task is complete.

---

## 7. VMware Network Mode

Keep the Kali VM on:

```text
NAT
```

for the normal workstation baseline.

Use host-only networking when you intentionally build an isolated local lab.

Use bridged networking only when a specific authorized lab requires the VM to
appear directly on the same network as the Windows host.

Do not change network mode simply because a lab connection fails.

---

## 8. Discovery and Scanning Scope

Tools such as:

```text
nmap
masscan
arp-scan
netdiscover
```

can generate active network traffic.

Use them only on:

- Networks you own
- Authorized lab networks
- CTF environments
- Training platforms that permit the activity
- Systems included in an approved testing scope

Do not scan unrelated devices on school, work, public, or residential
networks without authorization.

---

## 9. Packet Capture

Use:

```text
tcpdump
tshark
wireshark
```

for packet capture and traffic analysis.

Packet captures can contain:

- IP addresses
- Hostnames
- Credentials
- Session data
- Cookies
- DNS queries
- Application contents

Treat capture files as potentially sensitive.

Do not commit `.pcap`, `.pcapng`, or similar captures to a public repository.

---

## 10. Successful Result

A successful run ends with:

```text
Overall Result: NETWORK/AD TOOL PROFILE VERIFIED
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

## 11. Networking and AD Checklist

Before continuing, verify:

- [ ] Core network commands are available
- [ ] `dig` is available through `bind9-dnsutils`
- [ ] Nmap is available
- [ ] Packet-capture tools are available
- [ ] SMB client tools are available
- [ ] NetExec is available
- [ ] BloodHound Python collection tooling is available
- [ ] LDAP tooling is available
- [ ] Certipy is available
- [ ] Common Impacket SMB commands are available
- [ ] The script did not start network services
- [ ] The script completed with `FAIL : 0`
- [ ] The script returned exit code `0`

The focused networking and Active Directory tool profile is now verified.

Previous:

[14 — Browser and Proxy Workflow](14-browser-proxy-workflow.md)

Continue to:

[16 — Blue-Team and DFIR Tools](16-blue-team-dfir-tools.md)
