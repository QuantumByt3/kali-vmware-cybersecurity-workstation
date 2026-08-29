# Update Kali Linux

This step updates Kali Linux before additional tools, hardening, or workstation
customization are applied.

Kali is a rolling-release distribution. Keep it current, but avoid major
updates immediately before an important CTF or lab if the system is already
working and tested.

---

## 1. Confirm the Network Adapter Has an Address

Open a Kali terminal.

Run:

```bash
ip -brief address
```

Look for an active network interface with an IPv4 address.

Then run:

```bash
ip route
```

You should normally see a default route.

If no active interface or default route is present, stop and troubleshoot the
VMware NAT connection before continuing.

---

## 2. Confirm DNS Resolution

Run:

```bash
getent hosts kali.org
```

A successful result should return one or more addresses for `kali.org`.

If no result is returned, stop and troubleshoot network or DNS connectivity
before continuing.

---

## 3. Confirm the Kali Repository Configuration

For Kali Linux 2026.2 and newer, run:

```bash
cat /etc/apt/sources.list.d/kali.sources
```

The standard Kali rolling repository should identify:

```text
URIs: http://http.kali.org/kali/
Suites: kali-rolling
Components: main contrib non-free non-free-firmware
```

The configuration should also reference:

```text
/usr/share/keyrings/kali-archive-keyring.gpg
```

Do not add random third-party repositories to fix missing packages.

If the Kali repository configuration is missing or substantially different,
stop before upgrading.

---

## 4. Refresh Package Information

Run:

```bash
sudo apt update
```

This downloads current package information from the configured Kali
repositories.

Read the output before continuing.

Do not ignore repository-signature, missing-key, or repository errors.

---

## 5. Upgrade Kali

After `sudo apt update` completes successfully, run:

```bash
sudo apt full-upgrade -y
```

Kali recommends `full-upgrade` for normal rolling-release updates because
dependency changes may require packages to be added or removed.

The upgrade may take several minutes.

Do not shut down the VM while packages are being installed or configured.

---

## 6. Check Whether a Reboot Is Required

Run:

```bash
if [ -f /var/run/reboot-required ]; then
    echo "REBOOT REQUIRED"
else
    echo "NO REBOOT REQUIRED"
fi
```

If the result is:

```text
REBOOT REQUIRED
```

run:

```bash
sudo reboot
```

Wait for Kali to restart and sign back in.

If the result is:

```text
NO REBOOT REQUIRED
```

continue without rebooting.

---

## 7. Confirm the Updated System

Open a terminal.

Run:

```bash
cat /etc/os-release
```

Then run:

```bash
uname -r
```

The exact Kali release and kernel numbers will change over time.

---

## 8. Update Timing for CTFs and Labs

A practical workflow is:

1. Update Kali before preparing for an event.
2. Confirm the tools you need still work.
3. Create a clean VMware snapshot.
4. Avoid unnecessary major updates during an active CTF or important lab.
5. Update again afterward when appropriate.

---

## 9. Update Checklist

Before continuing, verify:

- [ ] Kali has an active network interface
- [ ] A default route is present
- [ ] DNS resolution works
- [ ] The official Kali rolling repository is configured
- [ ] `sudo apt update` completed without repository errors
- [ ] `sudo apt full-upgrade -y` completed successfully
- [ ] Kali was rebooted if required
- [ ] Kali starts normally after the update
- [ ] Release and kernel information can be displayed

The next step will automate routine Kali update checks and maintenance.
