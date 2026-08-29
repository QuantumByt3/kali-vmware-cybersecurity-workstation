# Create a Clean Baseline Snapshot

This step creates a VMware snapshot after Kali has been verified, updated, and
confirmed to boot normally.

The snapshot gives you a safe rollback point before hardening, tool
installation, and customization begin.

---

## 1. Shut Down Kali Cleanly

Inside the Kali terminal, run:

```bash
sudo poweroff
```

Wait until VMware shows that the virtual machine is powered off.

Do not create the baseline snapshot while Kali is still shutting down.

---

## 2. Open Snapshot Manager

In VMware Workstation Pro, select the Kali virtual machine.

Open:

```text
VM
> Snapshot
> Snapshot Manager
```

The exact menu wording may vary slightly by VMware Workstation release.

---

## 3. Create the Baseline Snapshot

Select:

```text
Take Snapshot
```

Use this snapshot name:

```text
Clean Updated Baseline
```

For the description, use:

```text
Kali imported, default password changed, networking verified, and system fully updated before hardening and tool customization.
```

Create the snapshot.

Wait for VMware to finish before continuing.

---

## 4. Confirm the Snapshot Exists

In Snapshot Manager, verify that:

```text
Clean Updated Baseline
```

appears in the snapshot tree.

Do not delete this snapshot during the initial workstation build.

---

## 5. Understand What the Snapshot Is For

Use this snapshot if a later configuration change causes problems.

Examples include:

- A hardening change breaks required functionality
- A package installation causes a dependency problem
- A tool configuration becomes unusable
- A service or firewall change prevents lab access
- A later experiment damages the VM

A snapshot is not a replacement for backups.

It is a short-term rollback point for the virtual machine.

---

## 6. Do Not Store Important Work Only Inside Snapshots

CTF notes, scripts, reports, evidence, and project files should still be
managed carefully.

Do not depend on VMware snapshots as the only copy of important data.

Later sections will establish a consistent directory structure for work files.

---

## 7. Power Kali Back On

After the snapshot has been created, power the Kali VM back on.

Sign in normally.

Open a terminal and run:

```bash
whoami
```

Then run:

```bash
uname -r
```

Confirm Kali still starts normally.

---

## 8. Snapshot Checklist

Before continuing, verify:

- [ ] Kali was shut down cleanly
- [ ] Snapshot Manager opened successfully
- [ ] `Clean Updated Baseline` was created
- [ ] The snapshot appears in the snapshot tree
- [ ] Kali powers back on normally
- [ ] The normal user account can sign in
- [ ] The terminal opens successfully

The next step will establish the Kali workstation security baseline.
