# Install VMware Workstation Pro on Windows 11

This step installs VMware Workstation Pro on the Windows 11 host that will run
the Kali Linux virtual machine.

The repository uses VMware Workstation Pro because it provides snapshots,
virtual networking, configurable virtual hardware, and a straightforward way
to run Kali without replacing or dual-booting the Windows host.

---

## 1. Confirm the Windows Host Is Ready

Complete the host-readiness checks first:

[Windows 11 Host Readiness](01-windows-host-readiness.md)

At minimum, confirm:

- Windows 11 is current.
- Hardware virtualization is available.
- At least 8 GB of system RAM is available.
- Sufficient free storage is available.
- No pending reboot is preventing installation.

The repository considers:

- 8 GB host RAM workable with a reduced Kali allocation.
- 16 GB host RAM recommended for most users.
- 32 GB or more ideal for a larger cybersecurity lab.

---

## 2. Use the Official Broadcom Download

VMware Workstation Pro is distributed through Broadcom.

Use the official download page:

[Download VMware Workstation Pro](https://support.broadcom.com/group/ecx/productdownloads?subfamily=VMware%20Workstation%20Pro&freeDownloads=true)

If the download page asks you to sign in, use the:

[Broadcom Support Portal](https://support.broadcom.com/)

Broadcom states that free software downloads can be accessed with a free Basic
User account. A Site ID, corporate email address, and paid subscription are not
required for the free-software download workflow.

Broadcom may require completion of profile and trade-compliance information
before a download becomes available.

For Broadcom's current download guidance, see:

[Downloading Free Software from the Broadcom Support Portal](https://knowledge.broadcom.com/external/article/397417/downloading-free-software-from-the-broad.html)

For VMware Workstation licensing and download guidance, see:

[Download and License VMware Desktop Hypervisor](https://knowledge.broadcom.com/external/article/368667/download-and-license-vmware-desktop-hype.html)

---

## 3. VMware Workstation Pro Is Free

VMware Workstation Pro is available at no cost for personal, educational, and
commercial use.

A license key is not required for the current free version.

If the installer presents a license-key field, continue using the free-version
option instead of entering a key you do not have.

Do not download cracked, repackaged, or third-party copies of VMware.

---

## 4. Choose the Windows Download

On the VMware Workstation Pro download page:

1. Sign in if Broadcom requests authentication.
2. Select the newest supported VMware Workstation Pro release.
3. Select the Windows build.
4. Accept the required terms and conditions.
5. Complete any required compliance information.
6. Download the Windows installer.

The installer filename and version will change as VMware releases updates.

Do not require a specific historical version unless a course or lab explicitly
depends on one.

---

## 5. Verify the Downloaded Installer

Before launching the installer, verify its Windows digital signature.

Open PowerShell and identify the downloaded installer.

Example:

```powershell
Get-ChildItem "$HOME\Downloads" -Filter "VMware-workstation*.exe"
```

Then verify the signature.

Replace the example filename with the actual downloaded installer:

```powershell
Get-AuthenticodeSignature `
    "$HOME\Downloads\VMware-workstation-full-<version>.exe" |
    Format-List Status, StatusMessage, SignerCertificate
```

The important result is:

```text
Status : Valid
```

Do not continue if Windows reports an invalid or untrusted signature until the
download source and file integrity have been reviewed.

---

## 6. Start the Installer

Right-click the verified VMware Workstation Pro installer and select:

```text
Run as administrator
```

Approve the Windows User Account Control prompt if it appears.

The exact installer screens may change between VMware releases.

For a normal Windows 11 workstation, the default installation choices are
appropriate unless you have a specific organizational or compatibility
requirement.

---

## 7. Complete the Installation

Proceed through the VMware Workstation Pro installer.

General guidance:

- Keep the normal VMware Workstation Pro application components.
- Keep the standard networking components.
- Allow VMware to install the required virtual-network drivers.
- Do not remove NAT or host-only networking support.
- Do not enter a paid license key unless you actually have one.
- Restart Windows if the installer explicitly requires it.

The repository later uses:

```text
VMnet1
```

for the normal VMware host-only virtual network and:

```text
VMnet8
```

for the normal VMware NAT virtual network.

---

## 8. Launch VMware Workstation Pro

After installation, open:

```text
VMware Workstation Pro
```

The main VMware Workstation window should load without an installation error.

Do not create a Kali VM yet.

The next steps use Kali's official pre-built VMware image instead of manually
installing Kali from an ISO.

---

## 9. If You See the New Virtual Machine Wizard

The repository's primary workflow does not use the **New Virtual Machine
Wizard** for Kali.

If you see a screen asking:

```text
What type of configuration do you want?
```

with options such as:

```text
Typical (recommended)
Custom (advanced)
```

you are in the manual VM-creation workflow.

Cancel that wizard.

Later, after downloading and extracting Kali's official VMware image, choose:

```text
Open a Virtual Machine
```

and open Kali's included:

```text
.vmx
```

configuration file.

This avoids rebuilding a VM that Kali already provides in pre-configured form.

---

## 10. VMware Documentation

Broadcom maintains the current VMware Workstation Pro documentation here:

[VMware Workstation Pro Documentation](https://techdocs.broadcom.com/us/en/vmware-cis/desktop-hypervisors/workstation-pro/26H1.html)

Use Broadcom documentation when a VMware interface or option has changed since
this repository was written.

---

## 11. Validate the VMware Installation

From the repository root in PowerShell, run:

```powershell
.\scripts\windows\Test-VMwareInstallation.ps1
```

The validator is read-only and non-interactive. It does not install, update,
repair, launch, or modify VMware, and it does not create or change a virtual
machine.

It checks:

- `vmware.exe` in the normal Program Files locations and, when available, from
  the current command search path.
- VMware product and version information from the installed executable.
- The installed `vmware.exe` Authenticode signature.
- The `VMAuthdService` VMware Authorization Service.
- Windows network adapters whose interface description identifies VMware.
- Whether Windows reports an active hypervisor.

The result states are:

```text
Overall Result: VMWARE INSTALLATION VERIFIED
```

when no warnings or failures are recorded, or:

```text
Overall Result: VMWARE INSTALLED WITH REVIEW ITEMS
```

when one or more warnings are present but no blocking failure is recorded.

Both of those states return process exit code:

```text
0
```

If a blocking check fails, such as VMware not being found or the installed
VMware executable having a non-valid digital-signature status, the script ends
with:

```text
Overall Result: VMWARE INSTALLATION NEEDS ATTENTION
```

and returns process exit code:

```text
1
```

The script does not print an `Exit code:` line automatically. To inspect the
process exit code immediately afterward, run:

```powershell
$LASTEXITCODE
```

An authorization service that exists but is not currently running is reported
as informational rather than as a failure. A missing authorization service or
missing VMware virtual network adapters is reported as a warning.

Review any warning or failure before continuing.

---

## 12. What Comes Next

After VMware Workstation Pro is installed:

1. Download Kali's official pre-built VMware image.
2. Verify its SHA-256 checksum.
3. Extract the archive.
4. Open the included `.vmx` file in VMware.
5. Review the virtual hardware before the first boot.
6. Configure memory, processors, networking, and isolation settings.

Do not power on the Kali VM until the repository reaches the configuration
step.

---

## 13. Installation Checklist

Before continuing, verify:

- [ ] Windows 11 host readiness is complete
- [ ] VMware was downloaded from the official Broadcom portal
- [ ] The installer signature reports `Valid`
- [ ] VMware Workstation Pro installed successfully
- [ ] VMware launches without an installation error
- [ ] The normal VMware networking components were retained
- [ ] You understand that the repository uses a pre-built Kali VMware image
- [ ] You have not created a second unnecessary Kali VM with the New Virtual Machine Wizard
- [ ] `Test-VMwareInstallation.ps1` completes successfully

Previous:

[01 — Windows 11 Host Readiness](01-windows-host-readiness.md)

Continue to:

[03 — Download and Verify the Official Kali VMware Image](03-download-and-verify-kali.md)
