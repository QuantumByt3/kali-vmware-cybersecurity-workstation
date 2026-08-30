# Windows 11 Host Readiness

This step verifies that the Windows 11 computer is ready to run VMware
Workstation Pro and the Kali Linux virtual machine used by this repository.

The goal is not merely to confirm that Windows can launch VMware. The host must
also retain enough memory, CPU capacity, storage, and network functionality to
remain responsive while Kali is running.

---

## Before You Begin — Repository Required

This guide uses a Windows PowerShell validator contained in this repository.

Before continuing, obtain or verify the Windows repository copy by completing:

[00 — Get the Repository Before Running Repository Scripts](00-get-the-repository.md)

You do not need a GitHub account when cloning this public repository over HTTPS
or when using GitHub's **Download ZIP** option.

Before a command in this guide says:

```text
From the repository root in PowerShell
```

confirm that PowerShell is inside the local repository directory containing:

```text
README.md
docs
scripts
```

Do not continue with a repository-script command until the referenced script
exists locally.

---
## 1. What This Guide Checks

Before installing VMware Workstation Pro, verify:

- Windows 11 is installed and supported.
- Windows is fully updated.
- The computer has enough RAM for Windows and Kali.
- The computer has enough free storage for the VM and snapshots.
- Hardware virtualization is available.
- A restart is not currently required.
- The host has working Internet connectivity.

The repository includes a read-only Windows validator for many of these checks:

```powershell
.\scripts\windows\Test-HostReadiness.ps1
```

You will run that validator later in this guide.

---

## 2. Official Windows 11 Requirements

Microsoft publishes the current Windows 11 system requirements here:

[Windows 11 System Requirements](https://support.microsoft.com/en-us/windows/experience/compatibility/windows-11-system-requirements)

Microsoft's Windows 11 minimum requirements include:

```text
Processor: 1 GHz or faster, 2 or more cores
RAM: 4 GB
Storage: 64 GB or greater
Firmware: UEFI, Secure Boot capable
TPM: TPM 2.0
Graphics: DirectX 12 compatible
```

Those are Windows 11 operating-system minimums.

They are **not** sufficient recommendations for this VMware + Kali
cybersecurity workstation.

---

## 3. Repository Host Requirements

For this repository, use the following practical host guidance:

| Windows host RAM | Repository rating | Kali RAM starting point |
| --- | --- | ---: |
| 8 GB | Workable minimum | 2 GB |
| 16 GB | Recommended | 4 GB |
| 32 GB or more | Ideal | 8 GB |

The Windows host must retain enough memory for:

- Windows itself
- VMware Workstation Pro
- The Kali VM
- Web browsers
- VS Code
- Security software
- Communication applications
- Background Windows services

Do not allocate all available RAM to Kali.

---

## 4. 8 GB Host

A Windows 11 computer with:

```text
8 GB RAM
```

can run this workstation, but it is the lower practical limit.

The recommended Kali starting allocation is:

```text
2 GB RAM
2 vCPUs
```

This configuration is suitable for:

- Command-line work
- Basic networking exercises
- Lightweight CTF challenges
- Nmap
- Git
- Python scripting
- Smaller web-security labs

Expect limitations when several memory-heavy applications run together.

Examples include:

```text
Firefox
Burp Suite
BloodHound
Metasploit
Multiple browser tabs
Several VMs
```

An 8 GB host should generally run only the primary Kali VM during active lab
work.

---

## 5. 16 GB Host

A Windows 11 computer with:

```text
16 GB RAM
```

is the recommended general-purpose baseline.

Start Kali with:

```text
4 GB RAM
2 vCPUs
```

A capable CPU may use:

```text
4 vCPUs
```

when a workload benefits from them.

This host size provides a practical balance between Kali and Windows for:

- CTF work
- Web-security testing
- Burp Suite or Caido
- Network analysis
- Active Directory labs
- Python development
- Blue-team exercises
- Basic DFIR workloads

---

## 6. 32 GB or More Host

A Windows 11 computer with:

```text
32 GB RAM
```

or more is ideal for this repository.

The recommended Kali baseline is:

```text
8 GB RAM
4 vCPUs
```

This leaves substantial resources available to Windows while supporting a
larger Kali workload.

A 32 GB host also provides more flexibility for:

- Additional target VMs
- Active Directory lab environments
- Memory-forensics analysis
- Multiple security applications
- Larger browser workloads
- Development tools
- Packet analysis

Do not automatically allocate more than 8 GB to Kali merely because the host
has additional memory.

Increase the VM only when a specific workload demonstrates a need.

---

## 7. Check the Installed Windows Version

Press:

```text
Windows Key + R
```

Type:

```text
winver
```

and press **Enter**.

Confirm the computer is running:

```text
Windows 11
```

The exact edition may be:

```text
Windows 11 Home
Windows 11 Pro
Windows 11 Education
Windows 11 Enterprise
```

VMware Workstation Pro can be used on normal supported Windows 11 editions.

Close the About Windows window after checking the version.

---

## 8. Check Windows Update

Open:

```text
Start
-> Settings
-> Windows Update
```

Select:

```text
Check for updates
```

Install normal Windows security, quality, and driver updates before installing
VMware.

Microsoft's Windows Update help is available here:

[Windows Update Help](https://support.microsoft.com/en-US/Windows/Deployment/Updates-Lifecycle/windows-update-faq)

If Windows requests a restart, restart the computer before continuing.

Do not begin the VMware installation while Windows is in the middle of a
pending update or restart cycle.

---

## 9. Check Installed RAM

Open Task Manager with:

```text
Ctrl + Shift + Esc
```

Select:

```text
Performance
```

Then select:

```text
Memory
```

Review the installed memory.

Classify the host as:

```text
8 GB      -> Workable minimum
16 GB     -> Recommended
32 GB+    -> Ideal
```

A system may report a value slightly below the marketed capacity.

For example, a 32 GB computer may display a usable value slightly below:

```text
32.0 GB
```

That does not necessarily indicate a problem.

---

## 10. Why Windows 11's 4 GB Minimum Is Not Enough Here

Microsoft lists:

```text
4 GB
```

as the Windows 11 operating-system minimum.

This repository intentionally requires more because the computer must run both:

```text
Windows 11
```

and:

```text
Kali Linux in VMware
```

at the same time.

A 4 GB Windows host does not provide a practical resource margin for this
workstation.

For this repository:

```text
8 GB = minimum workable host
16 GB = recommended host
32 GB+ = ideal host
```

---

## 11. Check Processor Information

In Task Manager:

```text
Performance
-> CPU
```

Review:

- Processor model
- Core count
- Logical processor count
- Virtualization status

The VM does not need every physical or logical processor.

The repository later starts with:

```text
2 vCPUs
```

for an 8 GB or typical 16 GB host and:

```text
4 vCPUs
```

for the 32 GB ideal baseline.

---

## 12. Check Hardware Virtualization

In:

```text
Task Manager
-> Performance
-> CPU
```

look for:

```text
Virtualization
```

The desired state is:

```text
Enabled
```

If virtualization is already enabled, do not change BIOS or UEFI settings.

Microsoft provides current virtualization guidance here:

[Enable Virtualization on Windows](https://support.microsoft.com/en-us/windows/experience/enable-virtualization-on-windows)

---

## 13. If Virtualization Is Disabled

If Task Manager reports:

```text
Virtualization: Disabled
```

do not install VMware yet.

Virtualization may need to be enabled in the computer's UEFI or BIOS.

Common firmware names include:

```text
Intel Virtualization Technology
Intel VT-x
Intel VMX
AMD-V
SVM
SVM Mode
```

The exact label depends on the computer manufacturer and processor.

Use Microsoft's virtualization guide:

[Enable Virtualization on Windows](https://support.microsoft.com/en-us/windows/experience/enable-virtualization-on-windows)

and the computer manufacturer's support documentation.

---

## 14. Enter UEFI from Windows If Needed

Microsoft documents the normal Windows 11 route as:

```text
Settings
-> System
-> Recovery
-> Advanced startup
-> Restart now
```

Then:

```text
Troubleshoot
-> Advanced options
-> UEFI Firmware Settings
-> Restart
```

Only use this process when virtualization is currently disabled.

Do not change unrelated UEFI settings.

Incorrect firmware changes can affect the computer's ability to boot or use
security features correctly.

---

## 15. Do Not Disable Secure Boot for This Setup

This repository does not require disabling Windows Secure Boot merely to run
the normal Kali VMware workstation.

Microsoft documents Secure Boot here:

[Windows 11 and Secure Boot](https://support.microsoft.com/en-us/windows/security/devicesecurity/windows-11-and-secure-boot)

Do not disable security controls without a specific, documented requirement.

If a future specialized lab requires a firmware change, understand the reason
and restore the normal security baseline afterward.

---

## 16. Check Available Storage

Open:

```text
File Explorer
-> This PC
```

Review the free space on the drive that will store the Kali VM.

This repository recommends having approximately:

```text
100 GB or more free
```

before beginning.

More is preferable if the system will also store:

- Multiple VMs
- Snapshots
- Active Directory labs
- DFIR images
- Packet captures
- Course files
- CTF files

The official Kali VMware image itself may present an approximately 80 GB
virtual disk, but that does not mean the host immediately consumes the full
virtual capacity.

VM disks and snapshots can grow over time.

---

## 17. Recommended VM Storage Location

Keep virtual machines outside the Git repository.

A simple host location is:

```text
C:\VMs
```

For example:

```text
C:\VMs\kali-linux-<version>-vmware-amd64\
```

Do not store the actual VM under:

```text
Cybersecurity\GitHub\kali-vmware-cybersecurity-workstation
```

The repository contains documentation and automation, not VM disks.

---

## 18. Check Internet Connectivity

The Windows host needs working Internet access for:

- VMware Workstation Pro download
- Kali image download
- Windows updates
- Kali package updates
- Tool installation
- GitHub access
- Authorized online training platforms

Confirm that a normal browser can reach:

[Microsoft](https://www.microsoft.com/)

and:

[Kali Linux](https://www.kali.org/)

Do not change DNS, firewall, VPN, or adapter settings merely because one
website is temporarily unavailable.

---

## 19. Check for a Pending Windows Restart

A restart may be required after:

- Windows Update
- Driver installation
- Firmware updates
- Security software updates
- Windows feature changes

Restart before installing VMware when Windows indicates that one is required.

The repository host-readiness script also checks common Windows restart
markers.

---

## 20. Close Unnecessary Applications

Before installing VMware, save work and close unnecessary applications.

Examples include:

- Games
- Large browser sessions
- Video editors
- Other virtualization products
- Unneeded installers

This is not a permanent requirement.

It simply reduces interference during initial VMware installation.

---

## 21. Windows Hypervisor Behavior

Modern Windows 11 systems may report an active Microsoft hypervisor.

This can occur because Windows security or virtualization features are using
the Windows hypervisor.

The repository's host validator is designed to recognize this condition.

Do not automatically disable Windows security features merely because VMware
detects a hypervisor.

The completed workstation used by this repository was validated successfully
with Windows reporting:

```text
HypervisorPresent: True
```

---

## 22. Do Not Disable Security Features Preemptively

Avoid disabling features such as:

- Secure Boot
- Windows Security
- Microsoft Defender
- Core isolation
- Memory integrity
- Firewall protections

unless a specific VMware compatibility problem has actually been identified
and a documented fix requires a change.

The goal is a cybersecurity workstation, so unnecessary weakening of the
Windows host would undermine the design.

---

## 23. Run the Repository Host Validator

From the repository root in PowerShell, run:

```powershell
.\scripts\windows\Test-HostReadiness.ps1
```

The script performs read-only checks for:

- Windows 11
- 64-bit architecture
- Installed memory
- Available storage on the Windows system drive (`$env:SystemDrive`)
- Hardware virtualization or active hypervisor state
- Common pending-restart conditions

It also prints an informational Windows Update reminder. The validator does not
determine whether Windows Update is fully current and does not test Internet
connectivity. Complete those checks manually in Sections 8 and 18.

The script itself does not prompt for input, request elevation, change BIOS
settings, change Windows features, or modify system configuration.

---

## 24. Understand the Validator Result

A host with no failures and no warnings ends with:

```text
Overall Result: READY
```

A host with warnings but no failures ends with:

```text
Overall Result: READY WITH REVIEW
```

Both results return process exit code:

```text
0
```

The script does not print an `Exit code:` line automatically. To inspect the
process exit code immediately after the script finishes, run:

```powershell
$LASTEXITCODE
```

If one or more blocking checks fail, the script ends with:

```text
Overall Result: NOT READY
```

and returns process exit code:

```text
1
```

Warnings should be reviewed before continuing.

A blocking failure should be corrected before VMware installation.

Informational messages do not represent failures.

---

## 25. Memory Guidance Used Later in VMware

The host memory classification directly controls the VM recommendation used in:

[Configure the Kali VMware Virtual Machine](05-configure-kali-vm.md)

Use:

```text
8 GB Windows host
-> 2 GB Kali
```

```text
16 GB Windows host
-> 4 GB Kali
```

```text
32 GB+ Windows host
-> 8 GB Kali
```

This keeps Windows and Kali from unnecessarily competing for memory.

---

## 26. CPU Guidance Used Later in VMware

The processor guidance also carries forward into the VMware configuration
step.

Use:

```text
8 GB host
-> 2 vCPUs
```

```text
16 GB host
-> 2 vCPUs initially
-> up to 4 when appropriate
```

```text
32 GB+ host
-> 4 vCPUs
```

Do not assign every logical processor to Kali.

Windows still requires CPU capacity while the VM is running.

---

## 27. Host Readiness Is Different from Kali VM Sizing

These two concepts are related but not identical.

Host readiness asks:

```text
Can this Windows computer safely support the workstation?
```

VM sizing asks:

```text
How much of the host should Kali receive?
```

A 32 GB host does not mean Kali should receive 32 GB.

A 16-core processor does not mean Kali should receive all 16 cores.

The VM should receive enough resources for its workload while preserving a
responsive Windows host.

---

## 28. If the Host Has Less Than 8 GB RAM

Do not use the normal repository workstation profile on a host with less than:

```text
8 GB RAM
```

Possible alternatives include:

- Upgrade the host memory
- Use a more capable computer
- Use a school-provided lab environment
- Use an authorized cloud or remote lab when available

Do not reduce both Windows and Kali below practical operating levels simply to
force the workstation onto inadequate hardware.

---

## 29. If Storage Is Limited

If the host does not have enough free space:

1. Remove unnecessary files.
2. Move large personal files to appropriate storage.
3. Use another internal drive if available.
4. Use a suitable external SSD if VMware performance is acceptable.
5. Avoid accumulating unnecessary snapshots.

Do not place the VM inside OneDrive or another synchronization directory unless
you understand the implications for large VMware files and synchronization.

---

## 30. Laptop Power Considerations

When performing:

- Kali updates
- VMware installation
- Large package installations
- VM snapshots
- Disk-intensive labs

connect the laptop to appropriate external power when practical.

Unexpected shutdown during a major update or snapshot operation can damage the
working state of the VM.

The battery does not need to remain at 100 percent for normal use.

Follow the laptop manufacturer's battery-health guidance.

---

## 31. Recommended Host Baseline Summary

A strong general-purpose host looks like:

```text
Windows 11
16 GB or more RAM
Modern 64-bit multi-core CPU
Hardware virtualization enabled
100 GB or more free storage
Current Windows updates
Working Internet connectivity
Normal Windows security controls enabled
```

The repository's ideal workstation baseline is:

```text
Windows 11
32 GB RAM
8 GB assigned to Kali
4 vCPUs assigned to Kali
VMware NAT networking
```

---

## 32. Host Readiness Checklist

Before installing VMware Workstation Pro, verify:

- [ ] Windows 11 is installed
- [ ] Windows Update is current
- [ ] No required Windows restart is pending
- [ ] The host has at least 8 GB RAM
- [ ] 16 GB RAM is available if possible
- [ ] 32 GB or more is recognized as the ideal baseline
- [ ] Hardware virtualization is enabled
- [ ] UEFI settings were not changed unnecessarily
- [ ] Secure Boot was not disabled unnecessarily
- [ ] The host has approximately 100 GB or more free storage
- [ ] Internet connectivity is working
- [ ] The VM will be stored outside the Git repository
- [ ] The Kali memory recommendation for this host is understood
- [ ] The Kali vCPU recommendation for this host is understood
- [ ] `Test-HostReadiness.ps1` completes without a blocking failure

The Windows host is now ready for VMware Workstation Pro.

Previous:

[00 — Get the Repository Before Running Repository Scripts](00-get-the-repository.md)

Continue to:

[02 — Install VMware Workstation Pro](02-install-vmware-workstation.md)
