# Kali Security Baseline

This step establishes a practical security baseline for the Kali virtual
machine without disabling normal CTF, lab, or blue-team functionality.

Kali is a security-testing workstation, not a production server. The goal is
to reduce unnecessary exposure while keeping the tools you need usable.

This initial baseline review is performed manually because the Kali repository
copy is obtained after this step. Once Step 00 Part B has been completed,
`scripts/kali/Harden-Kali.sh` provides a repeatable read-only audit for later
maintenance. That helper requires working `sudo` authorization for its
privileged read-only checks.

---

## 1. Use the Normal Kali Account

Sign in with the normal user account created for the VM.

Confirm the current user:

```bash
whoami
```

The expected result for the pre-built image is:

```text
kali
```

Do not use the root account as the normal desktop login.

Use `sudo` only when a command actually requires administrative privileges.

---

## 2. Confirm sudo Access

Run:

```bash
sudo -v
```

Then run:

```bash
sudo whoami
```

Expected result:

```text
root
```

This confirms that the normal account can perform authorized administrative
tasks without using a permanent root login.

---

## 3. Keep the Root Account Unused for Normal Work

Do not enable direct root login for routine use.

Do not configure automatic root login.

Do not enable root login over SSH.

Normal Kali tasks should be performed from the standard user account with
`sudo` used only when necessary.

---

## 4. Keep Kali's SSH Client in Strong Security Mode

Kali uses strong SSH client settings by default.

Do not enable Kali's SSH wide-compatibility mode unless an authorized lab
specifically requires older SSH algorithms or ciphers.

If you previously changed this setting, open:

```bash
kali-tweaks
```

Navigate to:

```text
Hardening
```

Use:

```text
Strong Security
```

for the normal workstation baseline.

Legacy compatibility can be enabled temporarily for a specific authorized
lab and returned to Strong Security afterward.

---

## 5. Review Listening Network Services

Run:

```bash
sudo ss -tulpen
```

This displays TCP and UDP sockets that are currently listening.

Do not assume every listening socket is malicious.

The purpose of this check is to understand what the VM is exposing.

Kali normally avoids enabling externally listening network services by
default.

---

## 6. Review Running Services

Run:

```bash
systemctl --type=service --state=running
```

Review the list.

Do not randomly stop services you do not recognize.

Later validation scripts in this repository will check common remote services
and identify items that need review.

---

## 7. Keep Remote Services Off Until Needed

Do not permanently enable services such as:

```text
ssh
apache2
nginx
vsftpd
smbd
```

unless you have a specific reason to use them.

A CTF or lab may require a temporary listener, web server, SSH server, or
other network service. Start only what the task requires and stop it when the
task is complete.

---

## 8. Keep VMware Networking on NAT by Default

For normal use, leave the VMware network adapter configured as:

```text
NAT
```

Use host-only networking for intentionally isolated local labs when
appropriate.

Use bridged networking only when the lab design specifically requires the Kali
VM to appear directly on the same network as the Windows host.

Do not switch to bridged networking simply because a lab connection is not
working.

---

## 9. Keep VMware Host Integration Restricted

For the baseline configuration, keep these disabled unless needed:

```text
Shared Folders
Drag and Drop
Copy and Paste
```

These features are convenient, but they also create additional paths between
the Windows host and Kali guest.

Enable them temporarily only when the workflow requires them.

---

## 10. Protect Credentials and Lab Files

Do not store passwords, API keys, private SSH keys, VPN profiles, or tokens in
public Git repositories.

Do not include credentials in screenshots.

Treat downloaded VPN configuration files as sensitive.

Keep CTF and lab credentials separate from public notes and reusable scripts.

---

## 11. Do Not Disable Security Controls for Convenience

Do not disable:

- Password authentication for the local desktop account
- Kali package-signature verification
- Windows Defender on the host
- Windows Firewall on the host
- VMware isolation controls

simply because a security tool or lab is inconvenient to configure.

When a lab requires an exception, make the smallest temporary change needed
and restore the normal baseline afterward.

---

## 12. Baseline Checklist

Before continuing, verify:

- [ ] Normal work is performed from the non-root Kali account
- [ ] `sudo` works when administrative access is required
- [ ] Direct root login is not used for routine work
- [ ] SSH client configuration uses Strong Security by default
- [ ] Listening network sockets have been reviewed
- [ ] Running services have been reviewed
- [ ] Unneeded remote services are not intentionally enabled
- [ ] VMware networking remains NAT by default
- [ ] Shared folders are disabled unless required
- [ ] Drag-and-drop is disabled unless required
- [ ] Copy-and-paste is disabled unless required
- [ ] Credentials and VPN profiles are treated as sensitive data

The Kali security baseline is now established.

Previous:

[08 — Create the Baseline Snapshot](08-create-baseline-snapshot.md)

Before Step 10 uses Kali-side repository scripts, return to Step 00 Part B and
obtain or verify the repository inside Kali:

[00 — Get the Repository Before Running Repository Scripts](00-get-the-repository.md)

Then continue to:

[10 — Directory Organization](10-directory-organization.md)
