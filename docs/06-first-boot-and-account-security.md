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

A later workstation-setup step can customize the hostname if desired.

Do not change it yet.

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

A later section will enable services only when they are actually needed.

Keeping unnecessary services stopped reduces accidental network exposure.

---

## 10. First-Boot Checklist

Before continuing, verify:

- [ ] Kali powered on successfully
- [ ] The initial `kali` account logged in successfully
- [ ] The default `kali` password was replaced
- [ ] `whoami` reports `kali`
- [ ] `sudo -v` completes without an error
- [ ] `sudo whoami` reports `root`
- [ ] The current hostname was identified
- [ ] No unnecessary remote services were manually enabled

The next step will update Kali Linux and establish the initial software
baseline.
