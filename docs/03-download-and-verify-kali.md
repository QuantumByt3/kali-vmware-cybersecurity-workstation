# Download and Verify the Official Kali VMware Image

This step downloads Kali Linux from the official Kali website and verifies the
VMware archive before it is extracted or opened in VMware Workstation Pro.

The repository uses Kali's official **pre-built VMware image**. You do not need
to create a new virtual machine manually or install Kali from an ISO for this
workflow.

---

## 1. Use the Official Kali Download Page

Open:

[Get Kali](https://www.kali.org/get-kali/)

On the page, locate:

```text
Pre-built Virtual Machines
```

Then choose the:

```text
VMware
```

download for the standard 64-bit PC architecture.

Kali currently labels that architecture:

```text
amd64
```

Do not download the VirtualBox, Hyper-V, QEMU, ARM, WSL, or installer image for
this VMware Workstation workflow.

---

## 2. Official Kali VMware Documentation

Kali documents the pre-built VMware workflow here:

[Import a Pre-Made Kali VMware VM](https://www.kali.org/docs/virtualization/import-premade-vmware/)

Kali's broader virtualization documentation is available here:

[Kali Virtualization Documentation](https://www.kali.org/docs/virtualization/)

For information about obtaining official Kali images, see:

[Downloading Kali Linux](https://www.kali.org/docs/introduction/download-official-kali-linux-images/)

Use these official sources if filenames, screenshots, or release numbers have
changed since this repository was written.

---

## 3. Choose the Pre-Built VMware Image

On the **Get Kali** page, the VMware download is listed under the pre-built
virtual-machine section.

The filename normally follows this pattern:

```text
kali-linux-<version>-vmware-amd64.7z
```

For example:

```text
kali-linux-2026.2-vmware-amd64.7z
```

The version number changes as new Kali releases become available.

Always prefer the latest stable point-release VMware image unless a class,
competition, or lab specifically requires a different version.

---

## 4. Do Not Use the Weekly Image by Default

Kali may also provide weekly images.

Weekly images can contain newer changes, but the normal beginner workstation
baseline should use the current stable point release.

Use a weekly image only when you have a specific reason to do so.

For most users, choose the standard VMware point-release image shown on:

[Get Kali](https://www.kali.org/get-kali/)

---

## 5. Download the VMware Archive

Click the VMware download on the official Kali page.

Save the archive to a location such as:

```text
Downloads
```

Do not extract it yet.

A typical downloaded file looks like:

```text
kali-linux-<version>-vmware-amd64.7z
```

The `.7z` archive contains the pre-built VMware virtual machine.

---

## 6. Understand the SHA-256 Checksum

Kali publishes a SHA-256 checksum for its downloadable images.

The checksum allows you to confirm that the archive you downloaded matches the
file Kali intended to distribute.

A SHA-256 value is a long hexadecimal string such as:

```text
c65145cef70166889e7283a230e88c832eaa8077e6e7cd37b47c0ccdc05685b0
```

That value was the official VMware checksum for the Kali Linux **2026.2**
point-release image when this repository baseline was validated.

Do not assume that checksum applies to a newer Kali release.

For a newer release, copy the checksum currently displayed beside the VMware
download on:

[Get Kali](https://www.kali.org/get-kali/)

---

## 7. Verify the Archive with the Repository Script

From the repository root in PowerShell, run:

```powershell
.\scripts\windows\Test-KaliDownloadHash.ps1 `
    -ArchivePath "$HOME\Downloads\kali-linux-<version>-vmware-amd64.7z" `
    -ExpectedHash "<official-sha256-from-kali.org>"
```

Replace:

```text
<version>
```

with the version you downloaded.

Replace:

```text
<official-sha256-from-kali.org>
```

with the SHA-256 checksum shown on the official Kali download page for that
specific VMware archive.

The script verifies:

- The supplied path resolves to a local file.
- The file uses the `.7z` extension.
- The filename matches the expected `kali-linux-...-vmware-amd64.7z` pattern.
- The expected checksum is exactly 64 hexadecimal characters.
- The downloaded file's SHA-256 value matches the supplied official value.

The script is read-only and non-interactive. It does not require elevation,
extract the archive, download files, or change system configuration.

The `ExpectedHash` format is enforced by PowerShell parameter validation before
the script body runs. If the value is not exactly 64 hexadecimal characters,
PowerShell rejects the parameter instead of producing the normal verification
summary. Recopy the checksum from Kali's official download page and run the
command again.

---

## 8. Verify the Archive Manually

You can also calculate the SHA-256 checksum directly in PowerShell.

Example:

```powershell
Get-FileHash `
    "$HOME\Downloads\kali-linux-<version>-vmware-amd64.7z" `
    -Algorithm SHA256
```

PowerShell returns a value under:

```text
Hash
```

Compare it carefully with the SHA-256 value published by Kali.

The values must match exactly.

---

## 9. What a Successful Verification Means

A matching SHA-256 checksum confirms that the downloaded archive has the same
content as the file represented by the checksum published by Kali.

When the repository script succeeds, it ends with:

```text
Overall Result: KALI DOWNLOAD VERIFIED
The archive may now be extracted.
```

and returns process exit code:

```text
0
```

To inspect the exit code immediately after the script finishes, run:

```powershell
$LASTEXITCODE
```

If the archive path, archive type, filename pattern, hash calculation, or
SHA-256 comparison fails, the script ends with:

```text
Overall Result: VERIFICATION FAILED
Do not extract or open the Kali archive.
```

and returns process exit code:

```text
1
```

If the values match, continue to extraction.

If the values do not match:

1. Do not extract the archive.
2. Do not open it in VMware.
3. Delete the questionable download.
4. Return to the official Kali download page.
5. Download the VMware archive again.
6. Verify the new download.

Do not bypass a failed checksum merely because the filename looks correct.

---

## 10. Confirm the Download Source

The primary download source for this repository is:

[Official Kali Download Page](https://www.kali.org/get-kali/)

Do not obtain the Kali VM from:

- File-sharing sites
- Unofficial mirrors linked from unknown sources
- Random cloud-storage links
- Torrents that are not published by Kali
- Repacked virtual machines
- Preconfigured "hacking VM" downloads from third parties

Kali also provides official torrent links on its download page. If you use
one, verify the resulting file against Kali's published checksum just as you
would with a direct download.

---

## 11. Default Credentials for the Pre-Built VM

Kali's official pre-built virtual machines currently use the default login:

```text
Username: kali
Password: kali
```

These credentials are public and are intended only to make the first boot
possible.

The repository changes the password during the first-boot security step.

Do not reuse:

```text
kali
```

as the long-term password.

---

## 12. Do Not Create a New VM Yet

After downloading and verifying the archive, do not use VMware's:

```text
Create a New Virtual Machine
```

wizard.

The Kali archive already contains the VMware configuration required by the
pre-built VM.

The next guide will:

1. Install or use 7-Zip.
2. Extract the `.7z` archive.
3. Locate Kali's included `.vmx` file.
4. Use VMware's **Open a Virtual Machine** workflow.
5. Review the VM before powering it on.

---

## 13. 7-Zip

The official Kali documentation recommends extracting the VMware `.7z`
archive before opening the VM.

If 7-Zip is not already installed on Windows, obtain it from:

[Official 7-Zip Download Page](https://www.7-zip.org/download.html)

Do not use an unknown third-party download site for 7-Zip.

The extraction process is covered in the next guide.

---

## 14. Repository Validation Baseline

This repository was validated using the official Kali VMware pre-built image.

At the time of validation:

```text
Release: Kali Linux 2026.2
Architecture: amd64
Format: VMware pre-built virtual machine
Archive: kali-linux-2026.2-vmware-amd64.7z
SHA-256: c65145cef70166889e7283a230e88c832eaa8077e6e7cd37b47c0ccdc05685b0
```

A future user does not need to use this exact release.

The important process is:

```text
Official source
    ->
Current VMware image
    ->
Current official checksum
    ->
Local SHA-256 verification
```

---

## 15. Download and Verification Checklist

Before continuing, verify:

- [ ] The file came from the official Kali website
- [ ] The **Pre-built Virtual Machines** section was used
- [ ] The VMware `amd64` image was selected
- [ ] The archive filename follows the expected Kali VMware pattern
- [ ] The SHA-256 checksum was copied from the official Kali download page
- [ ] `Test-KaliDownloadHash.ps1` or `Get-FileHash` was used
- [ ] The local SHA-256 exactly matches the official checksum
- [ ] A failed checksum was not ignored
- [ ] The archive has not been opened as an unverified VM
- [ ] The public default credentials will be changed after first boot

Previous:

[02 — Install VMware Workstation Pro](02-install-vmware-workstation.md)

Continue to:

[04 — Extract and Open the Kali VMware Virtual Machine](04-extract-and-open-kali-vm.md)
