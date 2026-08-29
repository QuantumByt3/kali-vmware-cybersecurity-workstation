# Third-Party Notices

This file identifies important third-party software, trademarks, services, and
documentation referenced by the Kali Linux VMware Cybersecurity Workstation
project.

The repository's MIT License applies only to original project content for
which the repository owner has the right to grant that license.

It does not replace, supersede, or relicense third-party software, trademarks,
documentation, services, or other intellectual property.

---

## 1. No Third-Party Software Is Redistributed

This repository is designed to provide:

- Documentation
- Setup guidance
- Validation scripts
- Installation helpers
- Workspace automation
- Configuration recommendations

It does not intentionally redistribute the third-party applications,
operating-system images, virtual-machine disks, commercial tools, or package
archives referenced by the project.

Users obtain those components from their original publishers or package
repositories and remain responsible for complying with the applicable terms.

---

## 2. Kali Linux™

KALI LINUX™ is a trademark of OffSec.

This project references Kali Linux for compatibility, installation, and
educational purposes.

The project is not affiliated with, sponsored by, endorsed by, or maintained
by OffSec or the Kali Linux project.

The repository does not redistribute the Kali Linux VMware image.

Users should obtain Kali Linux from the official Kali website:

[Get Kali](https://www.kali.org/get-kali/)

Kali's trademark policy is available here:

[Kali Linux Trademark Policy](https://www.kali.org/docs/policy/trademark/)

Kali documentation is available here:

[Kali Linux Documentation](https://www.kali.org/docs/)

Kali Linux contains software from many upstream projects, and those components
remain subject to their respective licenses.

This repository's MIT License does not relicense Kali Linux or its included
packages.

---

## 3. VMware® Workstation Pro

VMware is a registered trademark or trademark of VMware and/or its applicable
corporate owner or subsidiaries in the United States and other jurisdictions.

VMware is now part of Broadcom.

This project references VMware Workstation Pro as the virtualization platform
used by the documented workstation build.

The project is not affiliated with, sponsored by, endorsed by, or maintained
by Broadcom or VMware.

The repository does not redistribute VMware Workstation Pro installers,
VMware binaries, VMware virtual-machine disks, or proprietary VMware
documentation.

Users should obtain VMware Workstation Pro through Broadcom's official
channels:

[VMware Workstation Pro Downloads](https://support.broadcom.com/group/ecx/productdownloads?subfamily=VMware%20Workstation%20Pro&freeDownloads=true)

[Broadcom Support Portal](https://support.broadcom.com/)

[VMware Workstation Pro Documentation](https://techdocs.broadcom.com/us/en/vmware-cis/desktop-hypervisors/workstation-pro/26H1.html)

VMware software remains subject to the license terms and other conditions
provided by Broadcom or the applicable VMware contracting entity.

The repository's MIT License does not grant rights to VMware software,
branding, documentation, or other VMware intellectual property.

---

## 4. Microsoft Windows

Microsoft, Windows, Windows 11, PowerShell, and other Microsoft product names
may be trademarks or registered trademarks of Microsoft Corporation in the
United States and other jurisdictions.

This project documents a Windows 11 host and uses PowerShell for host-side
validation.

The project is not affiliated with, sponsored by, endorsed by, or maintained
by Microsoft.

The repository does not redistribute Windows, Windows installation media, or
Microsoft proprietary software.

Windows remains subject to Microsoft's applicable license terms.

Official Windows information is available from:

[Microsoft](https://www.microsoft.com/)

[Windows Documentation](https://learn.microsoft.com/windows/)

The repository's MIT License does not relicense Microsoft software or
documentation.

---

## 5. 7-Zip

7-Zip is developed by Igor Pavlov and is distributed under its own applicable
licenses.

The official 7-Zip license information identifies the GNU Lesser General
Public License as the primary license for most 7-Zip code and identifies
additional license terms for certain components.

This repository does not redistribute 7-Zip binaries or source code.

7-Zip is referenced only as an archive-extraction tool for the Kali VMware
image.

Users should obtain 7-Zip from:

[Official 7-Zip Download Page](https://www.7-zip.org/download.html)

Official license information is available here:

[7-Zip License](https://www.7-zip.org/license.txt)

The repository's MIT License does not replace the licenses that apply to
7-Zip.

---

## 6. Burp Suite

Burp Suite is developed and licensed by PortSwigger Ltd.

This project may reference Burp Suite Community Edition for authorized
web-security training and proxy workflows.

The project is not affiliated with, sponsored by, endorsed by, or maintained
by PortSwigger Ltd.

The repository does not redistribute Burp Suite.

Users are responsible for accepting and complying with the terms that apply to
the edition they use.

Official legal information is available here:

[PortSwigger Legal Information](https://portswigger.net/legal)

[Burp Suite Terms and Conditions](https://portswigger.net/burp/eula)

The repository's MIT License does not relicense Burp Suite.

---

## 7. Caido

Caido software and services are provided by Caido Labs Inc.

This project may reference Caido as an optional web-security proxy for
authorized testing and training.

The project is not affiliated with, sponsored by, endorsed by, or maintained
by Caido Labs Inc.

The repository does not redistribute Caido software.

Users are responsible for the terms applicable to the Caido software or
service they use.

Official legal information is available here:

[Caido Legal Documents](https://www.caido.io/legal/)

The repository's MIT License does not relicense Caido software, services, or
documentation.

---

## 8. Kali Package Repository Software

The repository contains scripts that may request packages from Kali's official
APT repositories.

Examples include cybersecurity tools, development utilities, networking
utilities, forensic tools, and command-line applications.

Those scripts do not transfer ownership of or relicense the installed
packages.

Each package remains subject to its own:

- Copyright
- License
- Upstream project terms
- Distribution requirements

Users can inspect Debian/Kali package copyright information after installation.

A common local location is:

```text
/usr/share/doc/<package>/copyright
```

Package metadata can also be inspected with standard Debian package tools.

---

## 9. Python and pipx Packages

Some workflows may install Python applications through:

```text
pipx
```

or other Python packaging mechanisms.

Those applications remain governed by their individual upstream licenses.

Installing a package through a repository script does not make that package
part of this project's MIT-licensed source code.

Before redistributing, modifying, or incorporating third-party Python code,
review the applicable package license.

---

## 10. Git and Development Tools

This repository references development tools such as Git, Python, Bash,
ShellCheck, and related utilities.

These are independent third-party projects.

They remain subject to their respective licenses and trademark policies.

The fact that this repository documents, invokes, or validates a tool does not
transfer ownership of that tool or alter its license.

---

## 11. Cybersecurity Tools

The optional tool profiles reference numerous independent cybersecurity
projects.

Examples may include tools used for:

- Network analysis
- CTF exercises
- Web-security testing
- Active Directory labs
- Blue-team analysis
- Digital forensics
- Development

Each tool remains the property of its respective copyright holders and is
subject to its own license.

The scripts in this repository are installation and validation helpers only.

Do not assume that this project's MIT License applies to a tool merely because
a repository script installs or invokes it.

---

## 12. Third-Party Documentation

This repository links to external documentation rather than intentionally
copying substantial third-party documentation into the project.

External documentation remains subject to the copyright, terms, and policies
of its publisher.

A link does not imply:

- Ownership
- Endorsement
- Sponsorship
- Partnership
- Warranty

Links are provided to help users locate authoritative technical information.

---

## 13. Screenshots and Images

Only sanitized images that the project has the right to publish should be
added to:

```text
assets/sanitized-images/
```

Do not add third-party screenshots, logos, artwork, or interface images unless
their use is permitted by the applicable copyright, trademark, license, or
other legal terms.

Do not assume that publicly visible material is automatically free to
redistribute.

---

## 14. Trademarks

All trademarks, service marks, product names, company names, and logos
referenced by this project remain the property of their respective owners.

Use of a third-party name in this repository is intended to identify the
actual product, service, platform, or project being discussed.

Unless explicitly stated otherwise, such use does not imply affiliation,
endorsement, sponsorship, certification, partnership, or authorization by the
trademark owner.

---

## 15. Repository Naming

The repository name references Kali and VMware to describe the technologies
used by the documented workstation.

That naming is descriptive.

The repository is an independent educational project and is not an official
Kali Linux, OffSec, VMware, or Broadcom repository.

Users should rely on the official publisher sites for authoritative product
information and software downloads.

---

## 16. No License Expansion

Nothing in this file should be interpreted as granting rights beyond those
actually provided by an applicable license, trademark policy, contract, or
other authorization.

If a third-party license imposes requirements that differ from this
repository's MIT License, the third-party license controls for that
third-party material.

---

## 17. No Warranty for Third-Party Components

Third-party software and services are provided by their respective publishers
under their own terms.

This project does not provide warranties, support commitments, or guarantees
on behalf of third-party publishers.

A tool being documented or supported by a repository script does not mean the
project guarantees:

- Availability
- Compatibility
- Security
- Fitness for a particular purpose
- Continued licensing terms
- Continued free availability
- Continued package naming

Always review current upstream information when those matters are important.

---

## 18. Changes in Ownership, Licensing, or Terms

Software ownership, product names, licenses, download procedures, and terms of
service can change.

This file reflects the project's understanding at the time it was written.

Contributors who update a third-party integration should verify:

1. The current official publisher
2. The current official download source
3. The applicable license or terms
4. Relevant trademark guidance
5. Whether the repository redistributes any third-party material

Update this file when a change materially affects the repository's notices.

---

## 19. Adding a New Third-Party Dependency

Before adding a new dependency, contributors should document:

- Product or project name
- Official publisher or maintainer
- Official source
- Purpose in this repository
- Applicable license
- Whether files are redistributed
- Any required attribution
- Any relevant trademark or usage restrictions

Review:

[Contributing Guidelines](CONTRIBUTING.md)

before proposing the dependency.

---

## 20. Project License

Original project content is licensed under the:

[MIT License](LICENSE)

subject to the limitations described in this file.

The MIT License does not grant ownership of, or additional rights to,
third-party intellectual property referenced by the project.

---

## 21. Questions About Third-Party Rights

When there is uncertainty about whether third-party material may be copied,
modified, or redistributed, do not assume permission.

Consult the current upstream license or terms and obtain appropriate
permission when required.

For significant legal uncertainty, seek qualified legal advice before
redistributing the material.
