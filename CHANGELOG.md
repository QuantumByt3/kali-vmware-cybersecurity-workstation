# Changelog

All notable changes to the Kali VMware Cybersecurity Workstation project will
be documented in this file.

This project follows a simple release-history format inspired by common
open-source changelog practices.

The repository is public and continues development toward its first versioned release.

---

## [Unreleased]

### Added

- Beginner-friendly Windows 11 host-readiness guidance
- VMware Workstation Pro installation and validation workflow
- Official Kali VMware image download and SHA-256 verification workflow
- Kali VMware extraction and import guidance
- VMware virtual-hardware sizing guidance for 8 GB, 16 GB, and 32 GB+ hosts
- VMware NAT networking baseline
- Shared-folder and guest-isolation guidance
- First-boot account-security workflow
- Kali update workflow
- Baseline VMware snapshot guidance
- Kali security-baseline auditing
- Organized cybersecurity workspace layout
- Core cybersecurity-tool installation
- CTF tool profile
- Web-security tool profile
- Network and Active Directory tool profile
- Blue-team and DFIR tool profile
- Browser and proxy workflow guidance
- Python, Git, Bash, ShellCheck, and development-environment setup
- CTF workspace helper
- DFIR case workspace helper
- VMware networking documentation
- Maintenance and recovery guidance
- Windows host-readiness validator
- VMware installation validator
- Kali archive hash validator
- VMware network-readiness validator
- Kali update helper
- Kali security-audit helper
- Kali core-tools installer
- Kali development-environment configurator
- Kali network-readiness validator
- Kali workstation-readiness validator
- Focused Kali tool-profile installers
- Workspace initialization helper
- CTF workspace generator
- DFIR case-workspace generator
- Repository security policy
- MIT License
- Contribution guidelines
- Code of Conduct
- Third-party notices
- Git ignore protections for private and sensitive artifacts
- Git attributes for consistent line endings
- Sanitized-image publication directory
- Internal Markdown navigation
- Official external documentation links
- Repository publication-safety validation process

### Security

- Added explicit authorized-use boundaries
- Added sensitive-data publication restrictions
- Added VM, capture, VPN, key, and forensic-artifact exclusions
- Added staged-content secret scanning
- Added private vulnerability-reporting guidance
- Added accidental secret exposure and credential-rotation guidance
- Added GitHub secret-scanning and push-protection guidance
- Added CI least-privilege requirements
- Added privacy-conscious network-validation requirements

### Validation

- PowerShell scripts parse successfully
- Bash scripts pass `bash -n`
- Bash scripts pass ShellCheck
- Repository text files use LF line endings
- Internal Markdown links resolve
- Documented repository paths resolve
- Official external links were reviewed during documentation audits
- Sensitive-data scans return no findings
- Forbidden-artifact scans return no findings
- Unfinished-content scans return no findings
- Staged whitespace validation passes
- Staged repository contents were reviewed before the initial commit

---

## Release Process

When creating a release:

1. Move relevant entries from **Unreleased** into a versioned section.
2. Use an ISO-formatted release date:

```text
YYYY-MM-DD
```

3. Keep the newest release directly below **Unreleased**.
4. Group changes under meaningful headings such as:

```text
Added
Changed
Fixed
Security
Removed
Deprecated
```

5. Confirm the README, documentation, scripts, security policy, and
   third-party notices still match the release.
6. Run the repository validation workflow.
7. Review the staged Git diff.
8. Create the release commit.
9. Create an annotated or GitHub release tag when appropriate.

---

## Versioning

The project may use semantic-style version numbers for public releases:

```text
MAJOR.MINOR.PATCH
```

Examples:

```text
1.0.0
1.1.0
1.1.1
```

A version number should communicate the scale of the project change rather
than the version of Kali Linux or VMware Workstation Pro.

Kali and VMware versions are compatibility references, not project-version
numbers.

---

## Compatibility Notes

Kali Linux is a rolling distribution.

VMware Workstation Pro, Windows 11, third-party packages, and external
documentation may change independently of this repository.

A release entry should identify material compatibility changes when they
affect:

- Windows host requirements
- VMware configuration
- Kali image selection
- Package names
- Installation scripts
- Tool profiles
- Network behavior
- Security controls
- Validation behavior

Do not silently remove compatibility information from the changelog when it is
important for reproducing an older project release.

---

## Security Fixes

Security-relevant fixes should be documented without unnecessarily exposing
sensitive exploit details before coordinated disclosure is complete.

When appropriate, a release entry may reference a GitHub Security Advisory
after the advisory becomes public.

For private vulnerability reporting, review:

[Security Policy](SECURITY.md)

---

## Third-Party Changes

When a release materially changes a third-party dependency, download source,
license, ownership reference, or trademark notice, review:

[Third-Party Notices](THIRD_PARTY_NOTICES.md)

and update that file when necessary.

---

## Contribution Changes

Changes to contributor requirements should be reflected in:

[Contributing Guidelines](CONTRIBUTING.md)

and, when applicable:

[Code of Conduct](CODE_OF_CONDUCT.md)

---

## License Changes

The current project license is:

[MIT License](LICENSE)

A future license change should not be treated as an ordinary documentation
edit.

License changes require deliberate review because previously distributed
versions remain subject to the license terms under which they were released.

---

## First Versioned Release

The repository is already public. The first versioned release should be created
only after the current public-development baseline is ready to freeze.

Before creating that release:

- Complete the governance and publication-readiness audit
- Confirm `main` is synchronized and protected by the intended ruleset
- Confirm the README, guides, scripts, policies, and third-party notices agree
  with the release baseline
- Run the repository safety validation and required GitHub Actions workflow
- Re-run material Windows, VMware, or Kali runtime checks when a release change
  affects those behaviors
- Move the relevant entries from **Unreleased** into the new versioned section
- Review the final release diff for private data, forbidden artifacts, and
  unintended compatibility changes
- Create the release tag and GitHub release only after the release commit and CI
  are verified

Until a versioned release is created, current public development remains under:

```text
[Unreleased]
```
