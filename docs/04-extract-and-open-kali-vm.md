# Extract and Open the Kali VMware Virtual Machine

This step extracts the verified Kali VMware archive and opens the included
virtual-machine configuration in VMware Workstation Pro.

The repository uses Kali's official **pre-built VMware image**. You are not
creating a new Kali VM from scratch in this step.

---

## 1. Confirm the Previous Step Is Complete

Before extracting anything, confirm:

- VMware Workstation Pro is installed.
- The Kali VMware `.7z` archive came from the official Kali website.
- The archive's SHA-256 checksum matches Kali's published value.
- The archive has not been modified after verification.

If the checksum was not verified, return to:

[Download and Verify the Official Kali VMware Image](03-download-and-verify-kali.md)

Do not continue with an unverified archive.

---

## 2. Official Kali Import Guide

Kali maintains an official guide for importing the pre-built VMware image:

[Import a Pre-Made Kali VMware VM](https://www.kali.org/docs/virtualization/import-premade-vmware/)

Kali's current process is:

1. Extract the VMware archive.
2. Launch VMware Workstation.
3. Choose **Open a Virtual Machine**.
4. Browse to the extracted `.vmx` file.
5. Review the virtual-machine settings.
6. Power on the VM when the settings are correct.

This repository follows that same workflow.

---

## 3. Install 7-Zip If Needed

Kali distributes the pre-built VMware image as a `.7z` archive.

If 7-Zip is not already installed on Windows, use:

[Official 7-Zip Download Page](https://www.7-zip.org/download.html)

Install the normal 64-bit Windows release unless your Windows system requires a
different architecture.

On Windows 11, the 7-Zip commands may appear under:

```text
Show more options
```

Do not download 7-Zip from an unknown software-download site.

---

## 4. Locate the Verified Kali Archive

The downloaded archive normally follows this pattern:

```text
kali-linux-<version>-vmware-amd64.7z
```

For example:

```text
kali-linux-2026.2-vmware-amd64.7z
```

A common download location is:

```text
C:\Users\<your-username>\Downloads
```

The exact release number may be newer than the example shown here.

---

## 5. Create a Dedicated VM Storage Folder

Keep virtual machines outside the Git repository.

A simple Windows location is:

```text
C:\VMs
```

Create it in PowerShell if needed:

```powershell
New-Item -ItemType Directory -Path "C:\VMs" -Force
```

You can use another storage location if you prefer.

Choose a location with enough free disk space that is easy to identify later.

---

## 6. Extract the Archive with 7-Zip

In File Explorer:

1. Locate the verified Kali `.7z` archive.
2. Right-click the archive.
3. On Windows 11, choose **Show more options** if needed.
4. Choose the appropriate 7-Zip extraction option.
5. Extract the contents into your VM storage location.

For example:

```text
C:\VMs\
```

The extracted directory may have a name similar to:

```text
kali-linux-2026.2-vmware-amd64
```

or may contain a VMware `.vmwarevm` directory depending on the release layout.

Do not open the `.7z` archive directly in VMware.

---

## 7. Locate the `.vmx` File

Inside the extracted Kali VMware directory, locate the file ending in:

```text
.vmx
```

The `.vmx` file is VMware's virtual-machine configuration file.

The extracted directory will also contain the virtual disk and other VMware
supporting files.

Do not rename, edit, or move individual VMware files before opening the VM.

Keep the extracted VM directory together as one unit.

---

## 8. Open the Existing Kali VM

Launch:

```text
VMware Workstation Pro
```

From the main VMware Workstation window, choose:

```text
Open a Virtual Machine
```

Browse to the extracted Kali directory.

Select the included:

```text
.vmx
```

file and click:

```text
Open
```

VMware should add Kali to the virtual-machine library.

---

## 9. Do Not Use the New Virtual Machine Wizard

This repository does **not** use the New Virtual Machine Wizard for the
official pre-built Kali image.

If VMware displays:

```text
Welcome to the New Virtual Machine Wizard
```

and asks:

```text
What type of configuration do you want?
```

with:

```text
Typical (recommended)
Custom (advanced)
```

click:

```text
Cancel
```

Return to the VMware Workstation home screen and choose:

```text
Open a Virtual Machine
```

Then select Kali's extracted `.vmx` file.

The New Virtual Machine Wizard is used when manually building a VM, such as
when installing an operating system from an ISO. Kali's pre-built VMware image
already contains the VM configuration.

---

## 10. If VMware Asks Whether the VM Was Moved or Copied

VMware may ask whether the virtual machine was:

```text
Moved
```

or:

```text
Copied
```

For a newly downloaded and extracted copy of Kali, choose:

```text
I Copied It
```

when that prompt appears.

This allows VMware to generate identifiers appropriate for this copy of the
virtual machine.

If the prompt does not appear, continue normally.

---

## 11. Do Not Power On Kali Yet

After the `.vmx` file is opened, do not immediately select:

```text
Power on this virtual machine
```

First open:

```text
Edit virtual machine settings
```

or:

```text
VM Settings
```

depending on the VMware interface.

The next guide walks through the settings before first boot.

---

## 12. What the Settings Window Should Show

Under **Hardware**, you should see categories similar to:

```text
Memory
Processors
Hard Disk
Network Adapter
USB Controller
Sound Card
Display
```

Under **Options**, you may see categories such as:

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

The exact list can vary by VMware and Kali release.

Do not assume every default is ideal for your host computer.

The next guide explains the recommended settings for hosts with:

```text
8 GB RAM
16 GB RAM
32 GB or more RAM
```

and provides processor-allocation guidance as well.

---

## 13. Preserve the Included Virtual Disk

The Kali VMware image already includes its virtual disk.

Do not:

```text
Create a new virtual disk
```

and do not replace the included disk during this workflow.

The repository baseline uses the virtual disk supplied with Kali's official
pre-built image.

If more storage is needed later, expand it only after the workstation is
working and a known-good recovery point exists.

---

## 14. Keep the VM Out of Git

The extracted Kali VM must never be committed to this repository.

VMware files may contain:

- The complete Kali operating system
- Installed tools
- User data
- Credentials
- Browser data
- Shell history
- VPN information
- Lab artifacts
- Machine-specific configuration

Store the VM outside the Git repository, for example:

```text
C:\VMs\kali-linux-<version>-vmware-amd64\
```

The repository `.gitignore` blocks common VMware file types, but physical
separation is still the safer design.

---

## 15. If the `.vmx` File Is Missing

If you cannot find a `.vmx` file:

1. Confirm the `.7z` archive was fully extracted.
2. Confirm you downloaded the **VMware** pre-built image.
3. Look inside the extracted directories rather than the compressed archive.
4. Enable file extensions in Windows File Explorer if needed.
5. Compare your workflow with Kali's official guide.

Use:

[Import a Pre-Made Kali VMware VM](https://www.kali.org/docs/virtualization/import-premade-vmware/)

Do not create a replacement VM manually merely because the `.vmx` file was not
immediately visible.

---

## 16. If VMware Reports an Error Opening the VM

Check:

1. The archive passed checksum verification.
2. Extraction completed successfully.
3. The `.vmx` is being opened from the extracted directory.
4. The VM's supporting files remain together.
5. VMware Workstation Pro is installed correctly.
6. The Windows host has adequate free storage.

Kali's virtualization documentation is available here:

[Kali Virtualization Documentation](https://www.kali.org/docs/virtualization/)

Avoid changing several VMware settings at once while troubleshooting.

---

## 17. What Comes Next

Once Kali appears in the VMware library:

1. Leave the VM powered off.
2. Open the VM settings.
3. Review Memory.
4. Review Processors.
5. Confirm the existing virtual disk.
6. Confirm NAT networking for the normal baseline.
7. Review host/guest integration settings.
8. Review the remaining virtual hardware.
9. Save the configuration.
10. Power on Kali only after the configuration guide is complete.

Continue to:

[Configure the Kali VMware Virtual Machine](05-configure-kali-vm.md)

---

## 18. Extraction and Import Checklist

Before continuing, verify:

- [ ] The Kali archive passed SHA-256 verification
- [ ] 7-Zip came from the official 7-Zip website if it was required
- [ ] The `.7z` archive was fully extracted
- [ ] The VM is stored outside the Git repository
- [ ] The included `.vmx` file was located
- [ ] VMware Workstation Pro was launched
- [ ] **Open a Virtual Machine** was selected
- [ ] The extracted `.vmx` file was opened
- [ ] The **New Virtual Machine Wizard** was not used
- [ ] `I Copied It` was selected if VMware displayed that prompt
- [ ] The included virtual disk was preserved
- [ ] The VM has not been powered on yet
- [ ] The VMware settings window is ready for review

Previous:

[Download and Verify the Official Kali VMware Image](03-download-and-verify-kali.md)

Continue to:

[Configure the Kali VMware Virtual Machine](05-configure-kali-vm.md)
