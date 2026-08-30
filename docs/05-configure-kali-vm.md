# Configure the Kali VMware Virtual Machine

This step reviews the virtual hardware and VMware options for Kali before the
first boot.

The repository uses Kali's official pre-built VMware image. The goal here is
not to rebuild the VM. The goal is to right-size the existing VM for the
Windows 11 host, preserve the included virtual disk, use a safe networking
baseline, and disable unnecessary host/guest integration.

---

## 1. Open the Kali VM Settings

In VMware Workstation Pro:

1. Select the imported Kali virtual machine.
2. Make sure the VM is powered off.
3. Select **Edit virtual machine settings** or **VM Settings**.
4. Start on the **Hardware** tab.

The hardware list should contain items similar to:

```text
Memory
Processors
Hard Disk
Network Adapter
USB Controller
Sound Card
Display
```

The exact labels can vary slightly by VMware release.

Do not power on Kali until this guide is complete.

---

## 2. Official References

Kali documents its VMware configuration here:

[Import a Pre-Made Kali VMware VM](https://www.kali.org/docs/virtualization/import-premade-vmware/)

Kali also documents how its VMware images are built here:

[Kali inside VMware](https://www.kali.org/docs/virtualization/install-vmware-guest-vm/)

For VMware-specific performance guidance, see:

[Improving Virtual Machine Performance for VMware](https://www.kali.org/docs/virtualization/improving-vm-performance-vmware/)

Broadcom documents VMware Workstation virtual-machine hardware settings here:

[Create Virtual Machines in VMware Workstation](https://knowledge.broadcom.com/external/article/315434/create-virtual-machines-in-vmware-workst.html)

These official references are useful if VMware changes a label or screen after
this repository is published.

---

## 3. Review and Upgrade Virtual Hardware Compatibility

Before changing memory, CPU, networking, or integration settings, review the
VM's **virtual hardware compatibility** while the VM is fully powered off.

Kali's official VMware build documentation states that its pre-built VMware
images are intentionally generated with:

```text
Workstation 8.x
```

hardware compatibility so that the same image can run for a wider range of
VMware users.

This label describes the VM's **virtual hardware compatibility level**. It does
**not** mean that VMware Workstation 8 is installed on the Windows host.

Kali also states that newer VMware Workstation releases may offer to upgrade
the VM from that older profile, removing limitations associated with the
legacy compatibility level.

Broadcom's current virtual-hardware table maps common Workstation releases as
follows:

| VMware Workstation release | Virtual hardware version |
| --- | ---: |
| Workstation 8.x | 8 |
| Workstation Pro 17.x | 20 |
| Workstation Pro 17.6 | 21 |
| Workstation Pro 25H2 / 26H1 | 22 |

Review the current Broadcom mapping before relying on a historical version
number:

[VMware Virtual Machine Hardware Versions](https://knowledge.broadcom.com/external/article/315655/virtual-machine-hardware-versions.html)

### Repository Compatibility Baseline

This repository prioritizes a current Windows 11 + supported VMware Workstation
environment over preserving compatibility with very old VMware releases.

When using a current supported Workstation release, upgrade the Kali VM from
the legacy Workstation 8.x profile to the **newest compatibility level offered
by the Workstation version installed on the host**.

Do not choose a compatibility level newer than the installed VMware Workstation
release supports.

If you intentionally need to move this VM back to an older VMware product,
review Broadcom's compatibility table before upgrading because a VM using a
newer virtual hardware version may not power on in an older VMware release.

### Change the Hardware Compatibility

Keep the verified Kali `.7z` archive until the VM has completed its first
successful boot and the repository reaches the known-good snapshot stage. That
archive provides a clean re-extraction path if the initial VM configuration
must be rebuilt.

With the Kali VM fully powered off:

1. Select the Kali VM in VMware Workstation Pro.
2. Open:

   ```text
   VM
   -> Manage
   -> Change Hardware Compatibility
   ```

3. In the **Change Hardware Compatibility Wizard**, select **Next**.
4. Choose the newest Workstation compatibility level supported by the
   Workstation release installed on the Windows host.
5. Select **Next**.
6. If VMware asks whether to clone or alter the VM, choose:

   ```text
   Alter this virtual machine
   ```

   for this fresh, verified Kali image.

7. Review the proposed compatibility change.
8. Select **Finish**.
9. Close the wizard when the conversion completes.
10. Reopen the VM settings or summary and confirm that the VM is no longer
    using the legacy Workstation 8.x compatibility profile.

The exact wording of the compatibility label can vary between Workstation
releases. Follow the newest compatibility level actually offered by the
installed application.

Broadcom documents the Workstation workflow under:

[Virtual Machine Hardware Versions](https://knowledge.broadcom.com/external/article/315655/virtual-machine-hardware-versions.html)

### Why This Repository Performs the Upgrade

A lower virtual hardware version can limit newer virtual-machine functionality
or contribute to unexpected guest behavior on a newer VMware product.
Broadcom specifically lists unexpected guest-operating-system behavior and
unavailable VM operations among symptoms associated with older hardware
versions.

For this Kali workstation, modernizing the compatibility profile before the
first controlled boot also gives us a clean troubleshooting baseline for
display and pointer problems.

If the mouse later moves or clicks correctly but the pointer itself is
invisible inside Kali, Step 06 treats that as an **invisible-cursor symptom**
rather than a total mouse-input failure and directs you to verify this hardware
compatibility change first.

Do not change unrelated `.vmx` values manually as part of this procedure.

---

## 4. Recommended Resource Profiles

Do not move every VMware slider as high as possible.

Windows still needs memory and CPU resources while Kali is running. Giving the
VM too many resources can make both the Windows host and the Kali guest feel
slower.

Use the following values as practical starting points for one Kali VM.

| Windows host RAM | Kali RAM | Virtual CPU starting point | Use case |
| --- | ---: | ---: | --- |
| 8 GB | 2 GB | 2 vCPUs | Workable minimum for lighter labs |
| 16 GB | 4 GB | 2-4 vCPUs | Recommended general-purpose baseline |
| 32 GB or more | 8 GB | 4 vCPUs | Ideal baseline for this workstation |

These are repository recommendations, not hard limits.

A user may adjust them later based on:

- The physical CPU in the Windows host
- How many other VMs are running
- Browser and proxy usage
- Active Directory labs
- Memory-forensics workloads
- Password-cracking workloads
- Other Windows applications running at the same time

Start conservatively and increase resources only when there is a demonstrated
need.

---

## 5. Memory

In the **Hardware** list, select:

```text
Memory
```

VMware displays a memory slider and a numeric field measured in MB.

Use the numeric field when you want an exact value.

### Host with 8 GB RAM

Set Kali to:

```text
2048 MB
```

which is:

```text
2 GB
```

This is a workable minimum for a graphical Kali VM.

Expect to be more selective about running multiple heavy applications at the
same time.

For example, Firefox, Burp Suite, BloodHound, Metasploit, and several terminal
sessions together may feel constrained on a 2 GB guest.

Do not give a Windows 11 host with only 8 GB of total RAM most of its memory.

### Host with 16 GB RAM

Set Kali to:

```text
4096 MB
```

which is:

```text
4 GB
```

This is the recommended starting point for most students.

It provides enough room for common Kali workflows while leaving substantial
memory available to Windows.

### Host with 32 GB or More RAM

Set Kali to:

```text
8192 MB
```

which is:

```text
8 GB
```

This is the repository's ideal general-purpose baseline.

A configuration showing:

```text
Memory: 8 GB
```

is appropriate for a 32 GB host running one primary Kali workstation VM.

Do not increase beyond 8 GB merely because more RAM is available.

Increase it only when a specific workload demonstrates a need.

---

## 6. Why More RAM Is Not Always Better

VMware must obtain the guest's memory from the Windows host.

If too much RAM is assigned to Kali, Windows may have to:

- Compress memory
- Page memory to disk
- Reduce caching
- Compete with the guest for available RAM

That can make the entire computer slower.

Kali's own VMware performance guidance notes that host and guest performance
can degrade when available physical memory becomes constrained.

A responsive 4 GB Kali VM on a 16 GB host is better than an oversized VM that
starves Windows.

---

## 7. Processors

In the **Hardware** list, select:

```text
Processors
```

VMware may present two related values:

```text
Number of processors
Number of cores per processor
```

The total number of virtual CPUs is:

```text
processors x cores per processor = total vCPUs
```

For example:

```text
1 processor x 4 cores = 4 vCPUs
```

For this repository, keep the topology simple unless a lab specifically
requires something else.

---

## 8. Processor Recommendations

Use these starting points.

### 8 GB Host

Use:

```text
Number of processors: 1
Number of cores per processor: 2
Total: 2 vCPUs
```

### 16 GB Host

Start with:

```text
Number of processors: 1
Number of cores per processor: 2
Total: 2 vCPUs
```

For heavier workloads on a capable host, increase to:

```text
Number of processors: 1
Number of cores per processor: 4
Total: 4 vCPUs
```

### 32 GB or More Host

Use:

```text
Number of processors: 1
Number of cores per processor: 4
Total: 4 vCPUs
```

A VMware summary showing:

```text
Processors: 4
```

is appropriate for the 32 GB workstation baseline when those four vCPUs are
configured intentionally.

---

## 9. Why We Do Not Allocate Every CPU Thread

Windows, VMware, antivirus software, browsers, communication applications, and
other host processes still need CPU time.

Allocating every available logical processor to Kali does not guarantee better
performance.

It can increase contention between the Windows host and guest.

Leave CPU capacity available to the host.

If Kali performs well at 2 or 4 vCPUs, there is no reason to increase the
allocation.

---

## 10. Kali's Official CPU Example

Kali's manual VMware build documentation currently demonstrates:

```text
2 processors
2 cores per processor
4 total cores
```

That is a valid four-vCPU configuration.

This repository uses a simpler one-processor topology for the beginner
baseline:

```text
1 processor
4 cores per processor
4 total vCPUs
```

Both arrangements provide four total virtual CPUs.

The important beginner concept is to understand the total vCPU count and avoid
oversizing the VM.

---

## 11. Processor Virtualization Options

VMware may show advanced processor options such as:

```text
Virtualize Intel VT-x/EPT or AMD-V/RVI
Virtualize CPU performance counters
Virtualize IOMMU
```

Leave these advanced options at their existing defaults unless a specific lab
requires nested virtualization or another advanced feature.

Do not enable nested virtualization simply because Kali is a cybersecurity
workstation.

Some Windows hypervisor configurations can also conflict with virtualized CPU
performance counters.

Change these settings only for a documented requirement.

---

## 12. Hard Disk

Select the existing:

```text
Hard Disk
```

The official pre-built Kali VM already contains its virtual disk.

A current pre-built image may show a virtual disk of approximately:

```text
80 GB
```

The exact size can change between Kali releases.

Keep the existing disk.

Do not:

```text
Remove
```

the supplied disk.

Do not create a replacement disk merely because VMware allows you to add one.

---

## 13. Disk Space on the Windows Host

The virtual disk can grow as Kali stores more data.

The Windows host therefore needs enough free physical storage for:

- The Kali virtual disk
- VMware snapshots
- Kali package upgrades
- Browser data
- Tools
- CTF files
- Lab files
- Temporary files

The host-readiness guide recommends substantial free storage before beginning.

Review:

[Windows Host Readiness](01-windows-host-readiness.md)

Snapshots can consume significant additional disk space, so do not treat the
displayed virtual-disk size as the maximum host storage the VM may use over
time.

---

## 14. Network Adapter

Select:

```text
Network Adapter
```

For the normal workstation baseline, choose:

```text
NAT
```

Kali's VMware documentation also uses NAT as the default configuration.

NAT gives Kali practical Internet connectivity through the Windows host without
placing the guest directly onto the physical network as a normal bridged peer.

Use NAT for:

- Kali updates
- Package installation
- Web browsing
- Authorized training platforms
- CTF VPN connections
- Normal workstation use

---

## 15. Do Not Use Bridged Networking by Default

Do not select:

```text
Bridged
```

just because it appears to provide direct network access.

Bridged mode places the VM more directly onto the surrounding physical network.

That is not appropriate as the default for:

- Public Wi-Fi
- School networks
- Workplace networks
- Intentionally vulnerable lab targets

Use bridged mode only when a specific authorized lab requires it and you
understand the network scope.

The repository covers networking modes in detail here:

[VMware Networking Modes](19-vmware-networking.md)

---

## 16. Host-Only and LAN Segments

Later, intentionally vulnerable local targets may use:

```text
Host-only
```

or a VMware:

```text
LAN Segment
```

depending on the lab design.

Do not switch the primary Kali workstation away from NAT during initial setup.

First establish a known-good working baseline.

---

## 17. USB Controller

The pre-built VM may show:

```text
USB Controller: Present
```

Leave the USB controller at its default setting.

USB passthrough is useful when an authorized lab requires a physical USB
device.

Remember that attaching a USB device to Kali may disconnect it from Windows
while the guest controls it.

Do not automatically pass through personal storage devices or security tokens
to the VM.

---

## 18. Sound Card

The pre-built VM may show:

```text
Sound Card: Auto detect
```

Leave this setting at its default unless you have a specific reason to remove
or troubleshoot audio.

Sound is not required for most cybersecurity exercises, but leaving the
pre-built setting alone avoids unnecessary configuration changes.

---

## 19. Display

The pre-built VM may show:

```text
Display: Auto detect
```

Keep the normal display settings initially.

Kali's VMware documentation notes that 3D acceleration can improve graphical
performance in some configurations.

However, if you later experience graphical corruption, unusual full-screen
behavior, or display instability, 3D acceleration is one setting that may be
reviewed during troubleshooting.

Do not change several display settings at the same time.

Establish the baseline first.

---

## 20. Open the Options Tab

After reviewing the **Hardware** tab, select:

```text
Options
```

You may see items similar to:

```text
General
Power
Shared Folders
Snapshots
AutoProtect
Guest Isolation
Encryption
VMware Tools
VNC Connections
Metadata
Advanced
```

The exact options vary by VMware version.

---

## 21. General

Under:

```text
General
```

VMware may display information such as:

```text
Virtual machine name
Guest operating system
Version
Working directory
```

The official pre-built Kali image may identify the guest as a Debian 64-bit
system.

That is expected because Kali is Debian-based.

Do not change the guest operating-system type merely because the displayed
Debian version looks older than the current Kali release.

This setting is VMware guest metadata; it is not the Kali release number.

---

## 22. Virtual Machine Name

You may leave Kali's supplied name in place.

A versioned name such as:

```text
kali-linux-2026.2-vmware-amd64
```

is useful because it identifies the original point-release image.

Renaming the library entry is optional.

Do not rename or move the underlying virtual-disk files casually after the VM
has been added to VMware.

---

## 23. Working Directory

Confirm the working directory points to the VM storage location you selected.

For example:

```text
C:\VMs\kali-linux-<version>-vmware-amd64\
```

The VM should remain outside this Git repository.

Do not place the VM under:

```text
Cybersecurity\GitHub\kali-vmware-cybersecurity-workstation
```

The repository contains setup automation and documentation, not the virtual
machine itself.

---

## 24. Shared Folders

Select:

```text
Shared Folders
```

For the security-first baseline, set:

```text
Disabled
```

Shared folders create an additional path between the Windows host and Kali.

They can be convenient, but convenience is not required for the initial
baseline.

Keep them disabled until you have a specific file-transfer requirement.

---

## 25. Guest Isolation

Select:

```text
Guest Isolation
```

For the security-first baseline, disable:

```text
Enable drag and drop
Enable copy and paste
```

The exact checkboxes may vary by VMware version.

Disabling these features reduces casual data movement between Windows and Kali.

This is especially useful when Kali is working with:

- Suspicious files
- CTF artifacts
- Web payloads
- Forensic evidence copies
- Untrusted downloads

You can temporarily enable an integration feature later if a legitimate lab
requires it.

Return it to the baseline afterward.

---

## 26. Snapshots

VMware snapshots are an important part of this workstation.

Do not create the main baseline snapshot yet.

The repository first:

1. Boots Kali.
2. Changes the default password.
3. Updates the operating system.
4. Verifies the initial security state.

Then it creates the clean baseline snapshot.

The snapshot workflow is documented here:

[Create the Baseline Snapshot](08-create-baseline-snapshot.md)

---

## 27. AutoProtect

If VMware provides:

```text
AutoProtect
```

keep it:

```text
Disabled
```

for this repository baseline.

We use intentional manual snapshots at known-good points rather than automatic
snapshot accumulation.

Manual snapshots are easier for a beginner to understand and document.

---

## 28. Encryption

The pre-built VM may show:

```text
Not encrypted
```

VM encryption is not required for this repository baseline.

Do not enable encryption casually because it can affect VM management and
recovery workflows.

If you later store sensitive information, evaluate protection at the host,
storage, VM, and data levels according to the actual requirement.

---

## 29. VMware Tools

The official pre-built Kali VMware image includes guest tooling.

Under VMware Tools options, the VM may show time synchronization enabled.

Keeping accurate time is important for:

- Logs
- Git commits
- CTF records
- Packet analysis
- DFIR timelines
- Authentication

Leave normal VMware Tools time synchronization enabled for the baseline unless
a specialized lab requires independent guest time behavior.

The workstation later verifies VMware Tools from Kali with:

```bash
vmware-toolbox-cmd -v
```

---

## 30. VNC Connections

If the options include:

```text
VNC Connections
```

keep VNC:

```text
Disabled
```

unless you have a specific, authorized requirement for remote console access.

The beginner workstation does not need to expose a VNC service.

---

## 31. Auto Login

If VMware shows an auto-login option, do not enable it for the workstation
baseline.

Kali should require the configured user password for normal login.

The public `kali/kali` default credentials are changed during first boot.

---

## 32. Advanced Options

After completing the deliberate virtual-hardware compatibility review earlier
in this guide, leave other advanced VM options at their supplied defaults
unless this repository or a specific authorized lab instructs you to change
one.

Avoid changing firmware, virtualization-engine, or isolation flags simply
because they are available.

A stable known-good configuration is more valuable than maximizing the number
of customized settings.

---

## 33. Recommended Baseline Summary

For a typical 32 GB Windows 11 host, the repository baseline is:

```text
Hardware Compatibility: Newest level supported by the installed Workstation release
Memory: 8 GB
vCPUs: 4
Hard Disk: Existing Kali virtual disk
Network Adapter: NAT
USB Controller: Default / Present
Sound Card: Default / Auto detect
Display: Default / Auto detect
Shared Folders: Disabled
Drag and Drop: Disabled
Copy and Paste: Disabled
AutoProtect: Disabled
VMware Tools Time Sync: Enabled
VNC: Disabled
```

For a 16 GB host, reduce Kali memory to:

```text
4 GB
```

and start with:

```text
2 vCPUs
```

For an 8 GB host, reduce Kali memory to:

```text
2 GB
```

and use:

```text
2 vCPUs
```

---

## 34. Resource Reference Table

Use this quick reference before clicking **OK**.

| Setting | 8 GB host | 16 GB host | 32 GB+ host |
| --- | --- | --- | --- |
| Hardware compatibility | Newest supported by installed Workstation | Newest supported by installed Workstation | Newest supported by installed Workstation |
| Kali RAM | 2 GB | 4 GB | 8 GB |
| Processors | 1 | 1 | 1 |
| Cores per processor | 2 | 2 initially | 4 |
| Total vCPUs | 2 | 2 initially | 4 |
| Network | NAT | NAT | NAT |
| Shared folders | Disabled | Disabled | Disabled |
| Drag and drop | Disabled | Disabled | Disabled |
| Copy and paste | Disabled | Disabled | Disabled |
| AutoProtect | Disabled | Disabled | Disabled |
| VNC | Disabled | Disabled | Disabled |

For a capable 16 GB host, four total vCPUs are reasonable when a workload
benefits from them and Windows still has enough CPU capacity.

---

## 35. Save the VMware Configuration

After reviewing the settings, click:

```text
OK
```

or the equivalent button in your VMware version.

Do not start changing unrelated VMware application preferences.

The virtual-machine configuration is now ready for the first boot.

---

## 36. If VMware Refuses a Setting Change

Some virtual-hardware changes require the VM to be fully powered off.

A suspended VM is not the same as a powered-off VM.

If an option is unavailable:

1. Cancel the settings window.
2. Confirm the VM is not running.
3. Confirm the VM is not suspended.
4. Power it off completely if necessary.
5. Reopen **VM Settings**.

Do not edit the `.vmx` file manually to bypass a disabled GUI option unless a
documented troubleshooting procedure specifically requires it.

---

## 37. Do Not Chase the Screenshot Exactly

VMware and Kali releases change.

Your screen may not have the exact same:

- Version number
- Virtual-disk size
- Working-directory name
- VMware compatibility label
- Display options
- USB-controller options

Follow the intent of the baseline rather than trying to reproduce every
historical screenshot pixel-for-pixel.

The most important settings are:

```text
Current supported virtual-hardware compatibility
Right-sized memory
Right-sized vCPU count
Existing Kali disk preserved
NAT networking
Unnecessary integration disabled
```

---

## 38. Configuration Checklist

Before first boot, verify:

- [ ] The Kali VM is powered off while hardware settings are changed
- [ ] `Workstation 8.x` is understood as a legacy VM compatibility profile, not the installed VMware application version
- [ ] Virtual hardware compatibility was reviewed and upgraded to the newest level supported by the installed Workstation release
- [ ] Memory matches the host-resource recommendation
- [ ] The host retains enough RAM for Windows
- [ ] The virtual CPU allocation is understood
- [ ] The VM does not receive every available host CPU thread
- [ ] The existing Kali virtual disk is preserved
- [ ] The network adapter is set to NAT
- [ ] Bridged networking is not the default
- [ ] Shared Folders are disabled
- [ ] Drag and drop are disabled
- [ ] Copy and paste are disabled
- [ ] AutoProtect is disabled
- [ ] VMware Tools settings remain available
- [ ] VNC is disabled
- [ ] Advanced options remain at known-good defaults
- [ ] The VM is stored outside the Git repository
- [ ] The settings have been saved

The Kali virtual machine is now ready for its first controlled boot.

Previous:

[04 — Extract and Open the Kali VMware Virtual Machine](04-extract-and-open-kali-vm.md)

Continue to:

[06 — First Boot and Account Security](06-first-boot-and-account-security.md)
