# Kali VMware Cybersecurity Workstation

A beginner-friendly, security-first guide for building a complete Kali Linux
cybersecurity workstation in VMware Workstation Pro on Windows 11.

This repository is designed for students, Cyber Club members, CTF
participants, blue-team learners, DFIR learners, web-security students, and
anyone who needs a repeatable Kali virtual machine for authorized
cybersecurity training.

No previous virtual-machine experience is required.

---

## What This Repository Builds

Following this repository from start to finish creates a Kali workstation that
is:

- Installed from Kali's official pre-built VMware image
- Verified before first use
- Right-sized for the Windows host
- Updated and security-reviewed
- Organized for labs, CTFs, development, and DFIR work
- Equipped with core cybersecurity tools
- Expandable through optional tool profiles
- Protected by a deliberate VMware snapshot strategy
- Tested with Windows and Kali validation scripts
- Designed to avoid committing secrets, VM disks, captures, or private lab data
- Reproducible for another student starting from a normal Windows 11 computer

The goal is not simply to install Kali.

The goal is to build an organized, recoverable, maintainable, and
well-documented cybersecurity workstation.

---

## Authorized Use Only

This repository is intended for:

- Systems you own
- Systems you are explicitly authorized to test
- CTF environments
- Cyber ranges
- Training platforms
- Classroom labs
- Defensive security work
- Digital-forensics training

Do not use these tools or workflows against systems, accounts, networks, or
data without authorization.

Review the repository security policy before publishing changes:

[Security and Sensitive-Data Policy](SECURITY.md)

---

## Repository Governance and Policies

This repository includes explicit project-governance, security, licensing, and
contribution documentation.

Before contributing, reviewing, redistributing, or reporting a security issue,
read the policy that applies to the task.

### License

Original repository content is distributed under the:

[MIT License](LICENSE)

The MIT License applies to original project content only.

Third-party products, tools, packages, trademarks, documentation, and other
external material remain subject to their own licenses and terms.

### Contributing

Contribution requirements, validation expectations, authorized-use
boundaries, dependency rules, and pull-request expectations are defined in:

[Contributing Guidelines](CONTRIBUTING.md)

### Code of Conduct

Project participation standards are defined in:

[Code of Conduct](CODE_OF_CONDUCT.md)

### Security

Repository vulnerabilities, accidental secret exposure, sensitive-data
handling, coordinated disclosure, and safe testing are covered by:

[Security Policy](SECURITY.md)

Sensitive repository security reports should follow the private reporting
process described there rather than being posted publicly.

### Third-Party Software and Trademarks

This project documents and interoperates with software from multiple vendors
and open-source projects.

Licensing, attribution, trademark, and non-affiliation information is in:

[Third-Party Notices](THIRD_PARTY_NOTICES.md)

This repository is an independent educational project. It is not an official
Kali Linux, OffSec, Broadcom, VMware, Microsoft, 7-Zip, PortSwigger, Caido, or
other third-party vendor project unless explicitly stated otherwise by the
respective organization.

### Change History

Project-level changes and release preparation are tracked in:

[Changelog](CHANGELOG.md)

---

## Continuous Validation

Repository quality is enforced both locally and through GitHub Actions.

The validation workflow is:

[`.github/workflows/validate.yml`](.github/workflows/validate.yml)

It runs on:

- Pushes to `main`
- Pull requests targeting `main`
- Manual workflow dispatch

The workflow uses read-only repository-content permissions and validates:

- PowerShell syntax
- PSScriptAnalyzer findings
- Bash syntax
- ShellCheck findings
- Sensitive-content patterns
- Forbidden artifacts
- LF line endings
- Internal Markdown links
- Documented repository paths
- `.gitignore` protections

The repository-wide safety validator is:

[`scripts/windows/Test-RepositorySafety.ps1`](scripts/windows/Test-RepositorySafety.ps1)

Run it locally from the repository root with:

```powershell
.\scripts\windows\Test-RepositorySafety.ps1
```

A clean repository should end with:

```text
RESULT: PASS
```

PowerShell static-analysis settings are defined in:

[`PSScriptAnalyzerSettings.psd1`](PSScriptAnalyzerSettings.psd1)

GitHub Actions dependencies are checked monthly through:

[`.github/dependabot.yml`](.github/dependabot.yml)

Continuous integration is a safety control, not a substitute for reviewing a
change before running or merging it.

---

## Who This Guide Is For

This guide assumes that you:

- Use Windows 11
- Have basic computer skills
- Can download files from a website
- Can copy and paste commands when instructed
- May have little or no Linux experience
- May have never used VMware or another hypervisor
- Want a linear setup process
- Want commands that can be validated instead of blindly trusted

Technical terms are introduced as they become necessary.

---

## Official Downloads and Documentation

Use official sources whenever software must be downloaded manually.

### VMware Workstation Pro

[Download VMware Workstation Pro](https://support.broadcom.com/group/ecx/productdownloads?subfamily=VMware%20Workstation%20Pro&freeDownloads=true)

[Broadcom Support Portal](https://support.broadcom.com/)

[VMware Workstation Pro Documentation](https://techdocs.broadcom.com/us/en/vmware-cis/desktop-hypervisors/workstation-pro/26H1.html)

### Kali Linux

[Get Kali](https://www.kali.org/get-kali/)

[Import a Pre-Made Kali VMware VM](https://www.kali.org/docs/virtualization/import-premade-vmware/)

[Kali Virtualization Documentation](https://www.kali.org/docs/virtualization/)

[Downloading Official Kali Linux Images](https://www.kali.org/docs/introduction/download-official-kali-linux-images/)

### Archive Extraction

[Official 7-Zip Download Page](https://www.7-zip.org/download.html)

Do not substitute unofficial repackaged downloads when the original vendor
provides the software directly.

---

## Windows Host Requirements

Microsoft's minimum Windows 11 requirements are not the same as this
repository's practical virtualization requirements.

For this workstation, use the following host guidance:

| Windows host RAM | Repository rating | Kali RAM | Kali vCPU starting point |
| --- | --- | ---: | ---: |
| 8 GB | Workable minimum | 2 GB | 2 |
| 16 GB | Recommended | 4 GB | 2 |
| 32 GB or more | Ideal | 8 GB | 4 |

A capable 16 GB host may increase Kali to 4 vCPUs when a workload benefits from
it and Windows remains responsive.

Do not assign all host RAM or all logical processors to Kali.

Windows, VMware, browsers, security software, VS Code, and background services
still require host resources.

Detailed sizing instructions are in:

[Windows 11 Host Readiness](docs/01-windows-host-readiness.md)

and:

[Configure the Kali VMware Virtual Machine](docs/05-configure-kali-vm.md)

---

## Storage Guidance

Plan for approximately:

```text
100 GB or more free host storage
```

before beginning.

More storage is useful when working with:

- VMware snapshots
- Additional target VMs
- Active Directory labs
- Packet captures
- Memory images
- Disk images
- CTF artifacts
- Course projects

Keep the actual Kali virtual machine outside this Git repository.

A simple location is:

```text
C:\VMs
```

The repository contains documentation and automation.

It does not contain the VM itself.

---

## Repository Workflow

The normal build sequence is:

```text
Windows 11
    |
    v
Get the Repository on Windows
    |
    v
Check Host Readiness
    |
    v
Install VMware Workstation Pro
    |
    v
Download and Verify Kali
    |
    v
Extract and Open the Pre-Built VM
    |
    v
Configure VMware Hardware and Isolation
    |
    v
First Boot and Account Security
    |
    v
Update Kali
    |
    v
Create a Known-Good Snapshot
    |
    v
Review the Kali Security Baseline
    |
    v
Get or Verify the Repository inside Kali
    |
    v
Create the Workspace Structure
    |
    v
Install Core and Optional Tool Profiles
    |
    v
Configure the Development Environment
    |
    v
Use Workspace Helpers
    |
    v
Understand VMware Networking
    |
    v
Maintain and Recover the Workstation
    |
    v
Run Final Validation
    |
    v
Workstation Ready
```

Follow the documentation in order for the first build.

---

# Build Guide

## Step 00 — Get the Repository

Before running any repository script, obtain and verify the repository files
in the operating system where that script will run.

[00 — Get the Repository Before Running Repository Scripts](docs/00-get-the-repository.md)

For the first part of the build, this means obtaining the Windows repository
copy before Step 1.

Later, before Step 10 uses Kali-side repository scripts, obtain or verify a
separate Kali repository copy as explained in Step 00.

---

## Phase 1 — Prepare Windows and VMware

### 1. Windows Host Readiness

Verify Windows 11, RAM, storage, virtualization, updates, and the host baseline.

[01 — Windows 11 Host Readiness](docs/01-windows-host-readiness.md)

### 2. Install VMware Workstation Pro

Download VMware from Broadcom, validate the installer, install Workstation Pro,
and verify the Windows-side VMware components.

[02 — Install VMware Workstation Pro](docs/02-install-vmware-workstation.md)

### 3. Download and Verify Kali

Download Kali's official pre-built VMware archive and compare its SHA-256 hash
against Kali's published value.

[03 — Download and Verify Kali](docs/03-download-and-verify-kali.md)

### 4. Extract and Open the Kali VM

Extract the `.7z` archive and open Kali's included `.vmx` file.

Do not use VMware's New Virtual Machine Wizard for the normal pre-built-image
workflow.

[04 — Extract and Open the Kali VM](docs/04-extract-and-open-kali-vm.md)

### 5. Configure the Kali VM

Review memory, processors, disk, NAT networking, shared folders, guest
isolation, snapshots, VMware Tools, VNC, and other VM options before first
boot.

Kali's official pre-built VMware images may open with an older virtual-hardware
compatibility profile such as `Workstation 8.x`. That label describes the VM's
virtual hardware compatibility, not the version of VMware Workstation installed
on Windows. With the VM fully powered off, Step 05 explains how to review and,
when appropriate, upgrade that compatibility level before first boot. If mouse
input works but the pointer is invisible, Step 06 provides the corresponding
first-boot troubleshooting path.

[05 — Configure the Kali VMware VM](docs/05-configure-kali-vm.md)

---

## Phase 2 — Secure and Update Kali

### 6. First Boot and Account Security

Boot the pre-built VM, change the public default credentials, verify the user
and sudo configuration, and establish the initial account baseline.

[06 — First Boot and Account Security](docs/06-first-boot-and-account-security.md)

### 7. Update Kali

Review the Kali rolling repository configuration and update the operating
system using the repository's controlled update workflow.

[07 — Update Kali](docs/07-update-kali.md)

### 8. Create the Baseline Snapshot

Create a known-good VMware recovery point after the initial operating-system
setup is complete.

[08 — Create the Baseline Snapshot](docs/08-create-baseline-snapshot.md)

### 9. Review the Kali Security Baseline

Audit the workstation's local security state without turning Kali into an
overly restrictive system that breaks normal CTF and training workflows.

[09 — Kali Security Baseline](docs/09-kali-security-baseline.md)

---

## Phase 3 — Organize the Workstation

### 10. Create the Directory Layout

Build a consistent directory structure for projects, labs, CTFs, scripts,
notes, evidence handling, and other cybersecurity work.

[10 — Directory Organization](docs/10-directory-organization.md)

---

## Phase 4 — Install Cybersecurity Tooling

### 11. Core Tools

Install and verify the common baseline tools used across multiple security
disciplines.

[11 — Core Tools](docs/11-core-tools.md)

### 12. CTF Tools

Add tools useful for authorized capture-the-flag environments and technical
training challenges.

[12 — CTF Tools](docs/12-ctf-tools.md)

### 13. Web Security Tools

Add tools used for authorized web-application testing and web-security labs.

[13 — Web Security Tools](docs/13-web-security-tools.md)

### 14. Browser and Proxy Workflow

Configure a practical browser/proxy workflow for tools such as Burp Suite and
other authorized web-testing environments.

[14 — Browser and Proxy Workflow](docs/14-browser-proxy-workflow.md)

### 15. Network and Active Directory Tools

Add networking and Active Directory tooling for authorized labs, ranges, and
training environments.

[15 — Network and Active Directory Tools](docs/15-network-ad-tools.md)

### 16. Blue Team and DFIR Tools

Add defensive-security, triage, forensic, and incident-response tooling.

[16 — Blue Team and DFIR Tools](docs/16-blue-team-dfir-tools.md)

---

## Phase 5 — Development and Workspace Automation

### 17. Development Environment

Configure Git, Python, shell tooling, compilation support, and related
developer utilities used throughout the workstation.

[17 — Development Environment](docs/17-development-environment.md)

### 18. Workspace Helpers

Create repeatable CTF and DFIR workspaces without manually rebuilding the same
directory structure for every exercise.

[18 — Workspace Helpers](docs/18-workspace-helpers.md)

---

## Phase 6 — Networking, Maintenance, and Recovery

### 19. VMware Networking

Understand NAT, host-only networking, bridged networking, and VMware LAN
segments before changing the network topology for a lab.

[19 — VMware Networking](docs/19-vmware-networking.md)

### 20. Maintenance and Recovery

Maintain Kali, use snapshots deliberately, troubleshoot failed changes, and
recover the workstation without immediately rebuilding it.

[20 — Maintenance and Recovery](docs/20-maintenance-and-recovery.md)

---

# Automation Included in the Repository

The scripts are intentionally divided between the Windows host and the Kali
guest.

Read a script before running it.

Run it from the environment for which it was written.

---

## Windows PowerShell Scripts

### Host Readiness

[View `Test-HostReadiness.ps1`](scripts/windows/Test-HostReadiness.ps1)

Checks Windows-side readiness before the VMware/Kali workflow begins.

Run from the repository root:

```powershell
.\scripts\windows\Test-HostReadiness.ps1
```

### VMware Installation

[View `Test-VMwareInstallation.ps1`](scripts/windows/Test-VMwareInstallation.ps1)

Validates the VMware Workstation installation and important Windows-side
components.

```powershell
.\scripts\windows\Test-VMwareInstallation.ps1
```

### Kali Download Hash

[View `Test-KaliDownloadHash.ps1`](scripts/windows/Test-KaliDownloadHash.ps1)

Verifies the downloaded Kali VMware archive against the SHA-256 checksum
published by Kali.

```powershell
.\scripts\windows\Test-KaliDownloadHash.ps1 `
    -ArchivePath "$HOME\Downloads\kali-linux-<version>-vmware-amd64.7z" `
    -ExpectedHash "<official-sha256>"
```

### VMware Network Readiness

[View `Test-VMwareNetworkReadiness.ps1`](scripts/windows/Test-VMwareNetworkReadiness.ps1)

Checks VMware's Windows networking components without publishing private
adapter addresses.

```powershell
.\scripts\windows\Test-VMwareNetworkReadiness.ps1
```

### Repository Safety

[View `Test-RepositorySafety.ps1`](scripts/windows/Test-RepositorySafety.ps1)

Audits the publishable repository tree for sensitive content, forbidden
artifacts, line-ending problems, broken internal links, missing documented
paths, README fresh-clone tree drift from Git-tracked files and directories,
unfinished content, and `.gitignore` regressions.

```powershell
.\scripts\windows\Test-RepositorySafety.ps1
```

The repository-safety validator is read-only and supports Windows PowerShell
5.1 or newer PowerShell releases.

It reports findings without printing detected secret values.

---

## Kali Baseline Scripts

### Update Kali

[View `Update-Kali.sh`](scripts/kali/Update-Kali.sh)

Provides a controlled Kali update workflow after the repository is available
inside Kali. Run it from the normal Kali account, not from a root shell or with
`sudo`; the helper requests `sudo` only for the administrative commands it
needs. It validates basic routing, DNS, and the Kali rolling repository before
refreshing package metadata and asking whether to perform the full upgrade.
Declining the full upgrade reports `UPDATE CANCELLED` and returns exit code `2`
so an incomplete maintenance run is not mistaken for a completed update.

```bash
bash scripts/kali/Update-Kali.sh
```

### Security Audit

[View `Harden-Kali.sh`](scripts/kali/Harden-Kali.sh)

Audits the Kali baseline and reports findings without silently applying broad
system-hardening changes. Run it from the normal Kali account. The audit uses
`sudo` authorization for read-only privileged checks such as the root-account
password state and listener review, but it does not stop services, change SSH
settings, alter firewall rules, or modify VMware configuration.

```bash
bash scripts/kali/Harden-Kali.sh
```

### Core Tools

[View `Install-CoreTools.sh`](scripts/kali/Install-CoreTools.sh)

Installs and verifies the core tool baseline.

```bash
bash scripts/kali/Install-CoreTools.sh
```

### Development Environment

[View `Configure-DevelopmentEnvironment.sh`](scripts/kali/Configure-DevelopmentEnvironment.sh)

Configures and verifies the development-tool baseline while preserving an
existing Git identity.

```bash
bash scripts/kali/Configure-DevelopmentEnvironment.sh
```

### Kali Network Readiness

[View `Test-KaliNetworkReadiness.sh`](scripts/kali/Test-KaliNetworkReadiness.sh)

Checks guest networking and VMware integration without printing private
network addresses.

```bash
bash scripts/kali/Test-KaliNetworkReadiness.sh
```

### Final Kali Readiness

[View `Test-KaliReadiness.sh`](scripts/kali/Test-KaliReadiness.sh)

Runs the final Kali-side workstation readiness checks.

```bash
bash scripts/kali/Test-KaliReadiness.sh
```

---

## Focused Kali Tool Profiles

The complete workstation build uses all four focused profiles in Steps 12
through 16. Each installer runs from the normal Kali account, uses `sudo` only
for package-management work, installs only missing required packages, and
returns a failure if required packages are declined or remain unavailable.

A user intentionally building a narrower workstation may choose not to install
every profile, but the final `Test-KaliReadiness.sh` validator treats the full
documented tool baseline as required and will report missing profile commands
as failures.

### CTF Profile

[View `Install-CTFTools.sh`](scripts/kali/profiles/Install-CTFTools.sh)

```bash
bash scripts/kali/profiles/Install-CTFTools.sh
```

### Web Security Profile

[View `Install-WebTools.sh`](scripts/kali/profiles/Install-WebTools.sh)

```bash
bash scripts/kali/profiles/Install-WebTools.sh
```

### Network and Active Directory Profile

[View `Install-NetworkADTools.sh`](scripts/kali/profiles/Install-NetworkADTools.sh)

```bash
bash scripts/kali/profiles/Install-NetworkADTools.sh
```

### Blue Team and DFIR Profile

[View `Install-BlueTeamDFIRTools.sh`](scripts/kali/profiles/Install-BlueTeamDFIRTools.sh)

```bash
bash scripts/kali/profiles/Install-BlueTeamDFIRTools.sh
```

---

## Workspace Scripts

### Initialize the Directory Layout

[View `Initialize-DirectoryLayout.sh`](scripts/kali/workspace/Initialize-DirectoryLayout.sh)

```bash
bash scripts/kali/workspace/Initialize-DirectoryLayout.sh
```

### Create a CTF Workspace

[View `New-CTFWorkspace.sh`](scripts/kali/workspace/New-CTFWorkspace.sh)

Creates a new structured CTF workspace without overwriting an existing one.

```bash
bash scripts/kali/workspace/New-CTFWorkspace.sh
```

### Create a DFIR Case Workspace

[View `New-DFIRCaseWorkspace.sh`](scripts/kali/workspace/New-DFIRCaseWorkspace.sh)

Creates a structured DFIR case workspace with separation for notes and case
artifacts.

```bash
bash scripts/kali/workspace/New-DFIRCaseWorkspace.sh
```

---

# VMware Baseline

The normal repository baseline is:

```text
VM type: Official Kali pre-built VMware image
Network: NAT
Shared Folders: Disabled
Drag and Drop: Disabled
Copy and Paste: Disabled
AutoProtect: Disabled
VNC: Disabled
Manual snapshots: Enabled as part of the workflow
```

For a 32 GB Windows host:

```text
Kali RAM: 8 GB
Kali vCPUs: 4
```

For a 16 GB Windows host:

```text
Kali RAM: 4 GB
Kali vCPUs: 2 initially
```

For an 8 GB Windows host:

```text
Kali RAM: 2 GB
Kali vCPUs: 2
```

See:

[Configure the Kali VMware Virtual Machine](docs/05-configure-kali-vm.md)

---

# VMware Networking Philosophy

The default workstation uses:

```text
NAT
```

NAT is appropriate for normal:

- Kali updates
- Package installation
- Web browsing
- CTF VPN connections
- Authorized training-platform access

Do not use bridged networking as the automatic default.

Intentionally vulnerable targets should use an isolated design such as
host-only networking or a VMware LAN segment when appropriate for the lab.

Network design is covered in:

[VMware Networking](docs/19-vmware-networking.md)

---

# Sensitive Data and Git Safety

Never commit:

- Kali VM disks
- VMware VM configuration containing private machine state
- VPN profiles
- Private keys
- Passwords
- API tokens
- Authentication cookies
- Packet captures containing private traffic
- Memory dumps
- Disk images
- Forensic evidence
- Private case data
- Raw screenshots containing sensitive information
- Machine-specific secrets

The repository `.gitignore` intentionally blocks common examples of these
artifacts.

That protection is a safety net, not permission to place sensitive material in
the repository directory.

Use local private storage for sensitive work.

Read:

[Security and Sensitive-Data Policy](SECURITY.md)

Before committing public changes, also run:

```powershell
.\scripts\windows\Test-RepositorySafety.ps1
```

---

# Kali Release Model

Kali is a rolling Linux distribution.

This means:

- Package versions change
- Tool names may change
- Dependencies may change
- A package available today may be renamed later
- VMware images receive new point-release filenames
- Documentation screenshots may change

The repository therefore focuses on reproducible **processes** rather than
requiring every future user to install the exact historical package versions
used during development.

When a release changes, prefer current official Kali documentation and verify
the new behavior before changing the repository.

---

# Repository Validation Baseline

The workstation used to validate this repository included:

```text
Host OS: Windows 11
Host RAM: 32 GB
Hypervisor: VMware Workstation Pro
VM type: Official Kali pre-built VMware image
Kali release baseline: 2026.2
Kali architecture: amd64
Kali network baseline: VMware NAT
Kali RAM allocation: 8 GB
Kali vCPU allocation: 4
```

The Kali 2026.2 VMware archive used during validation had the official SHA-256:

```text
c65145cef70166889e7283a230e88c832eaa8077e6e7cd37b47c0ccdc05685b0
```

That checksum applies to that specific validated archive only.

For a newer Kali release, use the checksum currently published on:

[Get Kali](https://www.kali.org/get-kali/)

---

# Validation Philosophy

This repository does not assume that a command succeeded merely because it was
executed.

The build and publication process uses:

- PowerShell parsing
- PSScriptAnalyzer
- Bash syntax checks
- ShellCheck
- Runtime validation
- Idempotency checks where appropriate
- Sensitive-data scans
- Forbidden-artifact scans
- Internal Markdown-link checks
- Documented-path checks
- Line-ending checks
- `.gitignore` regression checks
- Repository-wide readiness scripts
- GitHub Actions continuous integration

The objective is to make failures visible before the repository is published,
merged, released, or used as a teaching reference.

A local pass does not make every future environment identical.

A CI pass does not replace judgment.

Both controls are used together.

---

# Final Workstation Checks

After completing the build, the normal validation sequence includes:

### Windows

```powershell
.\scripts\windows\Test-HostReadiness.ps1
.\scripts\windows\Test-VMwareInstallation.ps1
.\scripts\windows\Test-VMwareNetworkReadiness.ps1
```

### Kali

```bash
bash scripts/kali/Harden-Kali.sh
bash scripts/kali/Test-KaliNetworkReadiness.sh
bash scripts/kali/Test-KaliReadiness.sh
```

### Repository

```powershell
.\scripts\windows\Test-RepositorySafety.ps1
```

Review warnings instead of automatically treating them as failures.

The readiness validators return exit code `0` for a verified state or a
review-item state and exit code `1` when blocking failures are present. The
maintenance updater uses exit code `2` specifically when the user cancels the
full upgrade.

Correct actual failures before calling the workstation or repository complete.

---

# Beginner Rules That Prevent Common Problems

1. Follow the documentation in order during the first build.
2. Download VMware and Kali only from official sources.
3. Verify the Kali archive before extracting it.
4. Open Kali's included `.vmx` instead of creating an unnecessary second VM.
5. Do not assign all host RAM or CPU resources to Kali.
6. Keep the Kali VM outside the Git repository.
7. Use NAT as the normal networking baseline.
8. Do not use bridged mode casually on school, work, or public networks.
9. Change Kali's public default password during first boot.
10. Create snapshots at deliberate known-good points.
11. Read scripts before running them.
12. Do not commit secrets, captures, evidence, or VM files.
13. Run only the tool profiles you actually need.
14. Test only systems and networks you are authorized to test.
15. Validate the finished workstation instead of assuming it works.
16. Run the repository-safety validator before publishing changes.
17. Review third-party licenses before introducing new dependencies.
18. Use the private security-reporting process for sensitive vulnerabilities.

---

# Troubleshooting Order

When something fails, avoid changing several settings at once.

Use this order:

```text
Read the error
    |
    v
Identify whether the problem is Windows, VMware, Kali, repository, or networking
    |
    v
Run the relevant repository validator
    |
    v
Review the matching documentation guide
    |
    v
Change one thing
    |
    v
Test again
    |
    v
Use a known-good snapshot if recovery is faster
```

For VMware-specific problems, begin with:

[Install VMware Workstation Pro](docs/02-install-vmware-workstation.md)

[Configure the Kali VMware Virtual Machine](docs/05-configure-kali-vm.md)

[VMware Networking](docs/19-vmware-networking.md)

[Maintenance and Recovery](docs/20-maintenance-and-recovery.md)

For repository-publication problems, begin with:

[Contributing Guidelines](CONTRIBUTING.md)

[Security Policy](SECURITY.md)

[`Test-RepositorySafety.ps1`](scripts/windows/Test-RepositorySafety.ps1)

---

# Repository Layout

The tree below represents the files and directories that are present in a fresh
Git clone of this repository.

```text
kali-vmware-cybersecurity-workstation/
|
|-- .github/
|   |-- ISSUE_TEMPLATE/
|   |   |-- bug_report.yml
|   |   |-- documentation_issue.yml
|   |   |-- feature_request.yml
|   |   `-- config.yml
|   |
|   |-- workflows/
|   |   `-- validate.yml
|   |
|   |-- dependabot.yml
|   `-- pull_request_template.md
|
|-- assets/
|   `-- sanitized-images/
|       `-- .gitkeep
|
|-- docs/
|   |-- 00-get-the-repository.md
|   |-- 01-windows-host-readiness.md
|   |-- 02-install-vmware-workstation.md
|   |-- 03-download-and-verify-kali.md
|   |-- 04-extract-and-open-kali-vm.md
|   |-- 05-configure-kali-vm.md
|   |-- 06-first-boot-and-account-security.md
|   |-- 07-update-kali.md
|   |-- 08-create-baseline-snapshot.md
|   |-- 09-kali-security-baseline.md
|   |-- 10-directory-organization.md
|   |-- 11-core-tools.md
|   |-- 12-ctf-tools.md
|   |-- 13-web-security-tools.md
|   |-- 14-browser-proxy-workflow.md
|   |-- 15-network-ad-tools.md
|   |-- 16-blue-team-dfir-tools.md
|   |-- 17-development-environment.md
|   |-- 18-workspace-helpers.md
|   |-- 19-vmware-networking.md
|   `-- 20-maintenance-and-recovery.md
|
|-- scripts/
|   |-- windows/
|   |   |-- Test-HostReadiness.ps1
|   |   |-- Test-KaliDownloadHash.ps1
|   |   |-- Test-RepositorySafety.ps1
|   |   |-- Test-VMwareInstallation.ps1
|   |   `-- Test-VMwareNetworkReadiness.ps1
|   |
|   `-- kali/
|       |-- Configure-DevelopmentEnvironment.sh
|       |-- Harden-Kali.sh
|       |-- Install-CoreTools.sh
|       |-- Test-KaliNetworkReadiness.sh
|       |-- Test-KaliReadiness.sh
|       |-- Update-Kali.sh
|       |
|       |-- profiles/
|       |   |-- Install-BlueTeamDFIRTools.sh
|       |   |-- Install-CTFTools.sh
|       |   |-- Install-NetworkADTools.sh
|       |   `-- Install-WebTools.sh
|       |
|       `-- workspace/
|           |-- Initialize-DirectoryLayout.sh
|           |-- New-CTFWorkspace.sh
|           `-- New-DFIRCaseWorkspace.sh
|
|-- .gitattributes
|-- .gitignore
|-- CHANGELOG.md
|-- CODE_OF_CONDUCT.md
|-- CONTRIBUTING.md
|-- LICENSE
|-- PSScriptAnalyzerSettings.psd1
|-- README.md
|-- SECURITY.md
`-- THIRD_PARTY_NOTICES.md
```

The repository may also use local-only working directories that are intentionally
excluded from Git. For example, `assets/raw-screenshots/` is reserved for
unsanitized screenshots that must never be published directly.

Because Git does not track empty directories, a directory that exists only on a
developer's local workstation is not part of the fresh-clone repository unless
it contains at least one tracked file.

---

# What This Repository Does Not Contain

This repository intentionally does not distribute:

- Kali virtual-machine disk files
- VMware snapshots
- Kali ISO files
- VPN configurations
- Course answer files
- Private CTF flags
- Credentials
- Real forensic evidence
- Packet captures from private networks
- Password lists copied from restricted sources
- Malware samples
- Private organization data
- Private keys
- Authentication tokens
- Unsanitized screenshots
- User-specific machine configuration
- Private lab addressing
- Memory or disk evidence containing private data

Users should obtain required operating-system images and third-party software
from their official sources.

---

# Contribution Workflow

Contributions should remain focused, reproducible, and safe.

Before opening a pull request:

1. Read [CONTRIBUTING.md](CONTRIBUTING.md).
2. Confirm the change is within project scope.
3. Confirm any cybersecurity activity was authorized.
4. Review new third-party dependencies and licenses.
5. Run the relevant Windows or Kali validation.
6. Run `Test-RepositorySafety.ps1`.
7. Confirm scripts parse and lint cleanly.
8. Confirm internal links resolve.
9. Confirm no secrets, private artifacts, or machine-specific values are present.
10. Review `git diff --check`.
11. Update documentation when behavior changes.
12. Update `THIRD_PARTY_NOTICES.md` when required.
13. Update `CHANGELOG.md` when the change is release-relevant.

Pull requests use:

[`.github/pull_request_template.md`](.github/pull_request_template.md)

Public issues use structured issue forms under:

[`.github/ISSUE_TEMPLATE/`](.github/ISSUE_TEMPLATE/)

Blank issues are intentionally disabled so reports contain enough information
to evaluate safely.

---

# Dependency and Supply-Chain Approach

This project attempts to minimize unnecessary dependency risk.

General rules:

- Prefer operating-system package repositories when appropriate.
- Prefer official upstream downloads and documentation.
- Verify downloaded artifacts when publishers provide checksums or signatures.
- Avoid committing third-party binaries.
- Avoid vendoring tools without a clear reason and compatible license.
- Keep optional security tool profiles separate from the required baseline.
- Document new dependencies and their purpose.
- Review licensing before adding or redistributing third-party material.
- Keep GitHub Actions dependencies visible and review update pull requests.

Dependabot checks the GitHub Actions ecosystem monthly through:

[`.github/dependabot.yml`](.github/dependabot.yml)

Automated dependency updates should still be reviewed before merging.

---

# Release and Change Management

Project changes are recorded in:

[CHANGELOG.md](CHANGELOG.md)

The repository uses a deliberate release process.

Before a versioned release, maintainers should confirm:

- Governance files are current.
- Repository validation passes.
- GitHub Actions validation passes.
- Security settings are reviewed.
- Third-party notices are current.
- Documentation renders correctly on GitHub.
- Public links are current.
- No secrets or forbidden artifacts are present.
- The release contents match the intended scope.

A release tag should represent a known repository state rather than an
unreviewed working tree.

---

# Recommended Learning Approach

For a first-time user:

1. Build the workstation once by following the guides in order.
2. Read each command before running it.
3. Confirm the expected result before moving forward.
4. Use the validation scripts to understand what a healthy system looks like.
5. Create snapshots before major experimental changes.
6. Add optional tool profiles only when a course, lab, or project needs them.
7. Keep notes about what you changed and why.
8. Keep sensitive work outside the public repository.
9. Treat warnings as information to review, not as automatic success.
10. Re-run validation after meaningful configuration changes.

The objective is not only to have Kali installed.

The objective is to understand the workstation well enough to maintain,
troubleshoot, validate, and safely use it.

---

# Start Here

Begin with:

[00 — Get the Repository Before Running Repository Scripts](docs/00-get-the-repository.md)

After the repository is available on the Windows host, continue to:

[01 — Windows 11 Host Readiness](docs/01-windows-host-readiness.md)

Then continue through the numbered guides in order.

Before Step 10, return to Step 00 Part B to obtain or verify the repository
inside Kali before running Kali-side repository scripts.

If the Windows host and VMware are already configured, still review the early
guides before skipping them so that your VM settings match the repository
baseline.

Before contributing changes to the repository itself, also read:

[CONTRIBUTING.md](CONTRIBUTING.md)

and:

[SECURITY.md](SECURITY.md)

---

# License

Original content in this repository is licensed under the:

[MIT License](LICENSE)

Third-party software and documentation referenced by this project remain
subject to their respective licenses and terms.

See:

[THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)
