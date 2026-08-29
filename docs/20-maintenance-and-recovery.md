# Maintenance and Recovery

This step establishes a simple maintenance and recovery routine for the Kali
VMware cybersecurity workstation.

The goal is to keep the VM current, recoverable, and predictable without
turning routine maintenance into a rebuild.

---

## 1. Use a Controlled Maintenance Cycle

For major changes:

1. Confirm the VM is healthy.
2. Save important work.
3. Take a snapshot.
4. Make one controlled change.
5. Re-run the relevant validator.
6. Keep or remove the snapshot based on the result.

Avoid changing several unrelated settings at the same time.

---

## 2. Snapshot Before Major Changes

Create a VMware snapshot before:

- Large Kali upgrades
- Kernel upgrades
- Major tool-profile changes
- Significant VMware configuration changes
- Experimental package installations
- Network-mode changes

A snapshot is a rollback point.

It is not a backup.

---

## 3. Use Clear Snapshot Names

Good examples:

```text
Clean Updated Baseline
Before Major Kali Upgrade
Before Tool Profile Change
Before VMware Network Change
Known Good CTF Baseline
```

Avoid vague names such as:

```text
snapshot1
test
new
backup
```

A useful name should explain why the snapshot exists.

---

## 4. Update Kali

Use:

```bash
bash scripts/kali/Update-Kali.sh
```

The helper checks the system, refreshes APT metadata, reports available
upgrades, and asks before performing a full upgrade.

It does not automatically reboot the VM.

---

## 5. Reboot When Required

After maintenance, check whether a reboot is required.

The final workstation validator reviews:

```text
/var/run/reboot-required
```

If needed:

```bash
sudo reboot
```

After startup, allow networking and the desktop to settle before validation.

---

## 6. Validate After Updates

Run:

```bash
bash scripts/kali/Test-KaliReadiness.sh
```

A healthy result ends with:

```text
Overall Result: KALI WORKSTATION READINESS VERIFIED
```

and:

```text
Exit code: 0
```

Review warnings or failures before making additional changes.

---

## 7. Re-run a Focused Profile When Needed

If an update changes or removes a tool, run only the relevant profile.

Core tools:

```bash
bash scripts/kali/Install-CoreTools.sh
```

CTF tools:

```bash
bash scripts/kali/profiles/Install-CTFTools.sh
```

Web tools:

```bash
bash scripts/kali/profiles/Install-WebTools.sh
```

Network and AD tools:

```bash
bash scripts/kali/profiles/Install-NetworkADTools.sh
```

Blue-Team and DFIR tools:

```bash
bash scripts/kali/profiles/Install-BlueTeamDFIRTools.sh
```

---

## 8. Development Environment Maintenance

Run:

```bash
bash scripts/kali/Configure-DevelopmentEnvironment.sh
```

when development tooling needs verification.

Use Python virtual environments for project dependencies:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

Use `pipx` for isolated Python applications.

Avoid routine use of:

```bash
sudo pip install
```

---

## 9. Validate Networking

Inside Kali:

```bash
bash scripts/kali/Test-KaliNetworkReadiness.sh
```

On Windows:

```powershell
.\scripts\windows\Test-VMwareNetworkReadiness.ps1
```

Both checks are read-only and intentionally avoid printing private network
values in their normal output.

---

## 10. Review the Security Baseline

Periodically run:

```bash
bash scripts/kali/Harden-Kali.sh
```

This audit-oriented helper reviews:

- User context
- Root password state
- SSH compatibility mode
- Common server services
- Listener state
- VMware environment

Review warnings before changing service configuration.

---

## 11. VMware Workstation Updates

When VMware Workstation is updated:

1. Shut down Kali cleanly.
2. Update VMware Workstation on Windows.
3. Confirm the Kali VM still opens.
4. Confirm VMware virtual adapters remain available.
5. Start Kali.
6. Run the Windows VMware network validator.
7. Run the Kali network validator.
8. Run the full Kali readiness validator.

Do not assume a VMware update requires rebuilding Kali.

---

## 12. Snapshot Recovery

If a recent change breaks the VM, a known-good snapshot may provide a fast
rollback.

Before reverting:

1. Preserve files that must survive the rollback.
2. Confirm the intended snapshot.
3. Understand that reverting changes VM state.
4. Revert only when the snapshot is known-good.
5. Run the readiness validator after recovery.

---

## 13. Snapshot Limitations

Snapshots are not long-term backups.

Large or stale snapshot chains can:

- Consume significant disk space
- Reduce performance
- Complicate recovery
- Make VM state harder to understand

Keep snapshots purposeful and remove obsolete ones when they no longer provide
useful rollback value.

---

## 14. Back Up Important Work Separately

Important notes, scripts, reports, and repository content should not exist only
inside the VM.

Do not use a public Git repository as a backup location for:

- Credentials
- Private keys
- VPN profiles
- Packet captures
- Disk images
- Memory dumps
- Sensitive evidence
- Unsanitized screenshots

---

## 15. Clean Temporary Work

The workstation includes:

```text
~/Cybersecurity/Temp
```

for disposable working material.

Periodically review:

```text
~/Cybersecurity/Captures
```

and project-specific export directories as well.

Do not delete evidence or course material solely because it is old. Follow any
applicable retention requirements.

---

## 16. Troubleshooting Order

When the workstation stops behaving as expected:

1. Identify the exact symptom.
2. Run `Test-KaliReadiness.sh`.
3. Run the focused validator for the affected area.
4. Review the most recent change.
5. Verify package or service state.
6. Make one controlled correction.
7. Re-test.
8. Use snapshot rollback only when appropriate.

Avoid random configuration changes.

---

## 17. Network Troubleshooting

Start with:

```bash
bash scripts/kali/Test-KaliNetworkReadiness.sh
```

Then check Windows:

```powershell
.\scripts\windows\Test-VMwareNetworkReadiness.ps1
```

If needed, manually review:

```bash
ip -brief address
ip route
getent hosts kali.org
```

Do not modify VMware subnets or adapters until the problem has been narrowed
down.

---

## 18. Tool Troubleshooting

If one tool disappears after an update:

1. Confirm the command is missing.
2. Identify which profile owns the tool.
3. Re-run that profile.
4. Review APT or pipx output.
5. Re-run `Test-KaliReadiness.sh`.

Do not reinstall every profile to repair one missing command unless the
evidence supports doing so.

---

## 19. Volatility 3 Maintenance

Volatility 3 is managed through:

```text
pipx
```

Review its environment with:

```bash
pipx list
```

The repository does not silently upgrade pipx-managed applications during
routine validation.

---

## 20. Recovery Decision Guide

Use a focused repair when:

- Kali still boots
- Only one package or configuration is affected
- The cause is understood

Consider snapshot rollback when:

- A recent known change caused the issue
- A known-good snapshot exists
- Required files have been preserved

Consider rebuilding when:

- The VM is broadly corrupted
- Trust in the VM state has been lost
- Recovery is less reliable than starting clean
- A verified source image is available
- Important work is backed up elsewhere

---

## 21. Maintenance Checklist

Before maintenance:

- [ ] Save important work
- [ ] Confirm adequate disk space
- [ ] Confirm the VM is currently healthy
- [ ] Create a snapshot before major changes

After maintenance:

- [ ] Reboot if required
- [ ] Confirm VMware networking
- [ ] Confirm Kali networking
- [ ] Run `Test-KaliReadiness.sh`
- [ ] Review warnings or failures
- [ ] Record meaningful changes
- [ ] Remove obsolete snapshots when appropriate

---

## 22. Recovery Checklist

If something breaks:

- [ ] Identify the exact symptom
- [ ] Run the full readiness validator
- [ ] Run the focused validator
- [ ] Review the most recent change
- [ ] Avoid unrelated changes
- [ ] Repair one layer at a time
- [ ] Re-test after each correction
- [ ] Preserve important files before rollback or rebuild

The next phase performs repository-wide validation before the first public
commit and push.
