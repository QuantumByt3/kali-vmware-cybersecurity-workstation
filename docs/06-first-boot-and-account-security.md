# First Boot and Account Security

This step powers on the Kali virtual machine for the first time and replaces
the publicly known default password.

Complete this step before installing additional tools or beginning lab work.

---

## 1. Power On Kali

Open:

```text
VMware Workstation Pro
```

Select the Kali virtual machine.

Choose:

```text
Power on this virtual machine
```

Wait for Kali Linux to reach the login screen.

The first boot may take longer than later boots.

### If the Mouse Works but the Cursor Is Invisible

An **invisible cursor** is different from a complete mouse-input failure.

This troubleshooting path applies when the pointer itself cannot be seen, but
mouse movement, hover behavior, or clicks still appear to work inside Kali.

Kali's official VMware build documentation states that its pre-built VMware
images are generated with the older **Workstation 8.x** virtual-machine
hardware compatibility profile for broad backward compatibility. On newer
VMware Workstation releases, that legacy profile can contribute to unexpected
guest behavior.

Broadcom employees have specifically recommended upgrading the VM's virtual
hardware for invisible-cursor reports, including a Windows 11 host running Kali
Linux in VMware Workstation 25H2.

Review:

[Kali inside VMware (Guest VM)](https://www.kali.org/docs/virtualization/install-vmware-guest-vm/)

[VMware Virtual Machine Hardware Versions](https://knowledge.broadcom.com/external/article/315655/virtual-machine-hardware-versions.html)

[VMware 25H2 — Kali Cursor Discussion](https://community.broadcom.com/vmware-cloud-foundation/discussion/vmware-25h2)

If the cursor is invisible:

1. Do not reinstall Kali.
2. Do not begin changing Kali cursor themes or guest packages.
3. Shut Kali down cleanly if possible.
4. Confirm that the VM is fully powered off, not suspended.
5. In VMware Workstation Pro, select:

   ```text
   VM
   -> Manage
   -> Change Hardware Compatibility
   ```

6. Confirm that Step 05 upgraded the VM from the legacy compatibility profile
   to the newest compatibility level supported by the installed VMware
   Workstation release.
7. If the compatibility level was not upgraded, complete the Step 05
   compatibility procedure, then power Kali on again.
8. Recheck whether the cursor is visible.

Return to:

[05 — Configure the Kali VMware Virtual Machine](05-configure-kali-vm.md)

if the hardware-compatibility procedure was skipped or not completed.

If the VM is already using the intended current compatibility level and the
cursor is still invisible, do not make several unrelated graphics changes at
once. Record the VMware Workstation version and VM hardware compatibility level,
then continue troubleshooting one change at a time using current Broadcom
guidance.

Broadcom has documented additional host-side cursor-rendering troubleshooting
for persistent cases, but those changes are not part of this repository's
normal baseline.

If the mouse does **not** move, click, or interact with the guest at all, treat
that as a separate input problem rather than applying this invisible-cursor
procedure automatically.

---

---

## 2. Sign In with the Initial Kali Credentials

The official pre-built Kali VMware image uses the initial credentials:

```text
Username: kali
Password: kali
```

These credentials are publicly documented and are intended only for initial
access to the pre-built image.

Sign in as:

```text
kali
```

---

## 3. Open a Terminal

After the Kali desktop loads, open a terminal.

You can use the terminal icon in the Kali panel or application menu.

You should see a prompt similar to:

```text
kali@kali:~$
```

The exact appearance may differ slightly between Kali releases.

---

## 4. Change the Default Password Immediately

In the Kali terminal, run:

```bash
passwd
```

When prompted for:

```text
Current password:
```

enter:

```text
kali
```

The terminal will not display characters while a password is being typed.

This is normal.

When prompted for:

```text
New password:
```

enter a new, unique password.

Enter the same new password again when prompted.

A successful change should end with a message similar to:

```text
passwd: password updated successfully
```

Do not place the new password in this repository, a script, a screenshot, or
a public note.

---

## 5. Confirm the Current User

Run:

```bash
whoami
```

Expected result:

```text
kali
```

Then run:

```bash
id
```

The output should identify the current account and its groups.

The exact numeric IDs and group list can vary.

---

## 6. Confirm sudo Access

Run:

```bash
sudo -v
```

Enter the new password when prompted.

If the command returns to the terminal without an error, the account can use
`sudo` for authorized administrative tasks.

Then run:

```bash
sudo whoami
```

Expected result:

```text
root
```

This does not convert the normal login account into the root account.

It confirms that `sudo` can temporarily perform an administrative command.

---

## 7. Confirm the Hostname

Run:

```bash
hostnamectl --static
```

The pre-built image may use:

```text
kali
```

as its hostname.

This repository does not require a custom hostname. If you choose to rename
the VM later, make that change deliberately after the baseline is stable and
record the new hostname in your private workstation notes.

Do not change it during this first-boot step.

---

## 8. Lock the Screen When Leaving the VM

Treat the Kali VM like any other workstation containing cybersecurity tools,
lab credentials, or evidence.

When stepping away from the computer, lock the Kali desktop rather than
leaving an active session unattended.

Do not disable the login password for convenience.

---

## 9. Do Not Enable Remote Services Yet

At this stage, do not manually enable services such as:

```text
SSH
RDP
VNC
FTP
web servers
database servers
```

Enable a remote service only when an authorized lab or workflow explicitly
requires it, and stop or disable it again when the task is complete.

Keeping unnecessary services stopped reduces accidental network exposure.

---

## 10. First-Boot Checklist

Before continuing, verify:

- [ ] Kali powered on successfully
- [ ] The cursor is visible, or the invisible-cursor compatibility procedure was completed
- [ ] The initial `kali` account logged in successfully
- [ ] The default `kali` password was replaced
- [ ] `whoami` reports `kali`
- [ ] `sudo -v` completes without an error
- [ ] `sudo whoami` reports `root`
- [ ] The current hostname was identified
- [ ] No unnecessary remote services were manually enabled

The first controlled boot and account-security checks are now complete.

Previous:

[05 — Configure the Kali VMware Virtual Machine](05-configure-kali-vm.md)

Continue to:

[07 — Update Kali Linux](07-update-kali.md)
