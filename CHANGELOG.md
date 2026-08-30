# Changelog

All notable changes to the Kali VMware Cybersecurity Workstation project will
be documented in this file.

This project uses a simple release-history format inspired by common
open-source changelog practices.

The first versioned release is `v1.0.0`. New work should be recorded under
**Unreleased** until the next release.

---

## [Unreleased]

No changes have been recorded after `v1.0.0`.

---

## [1.0.0] - 2026-08-30

### Added

- Complete beginner-oriented workflow for building a Kali Linux cybersecurity
  workstation in VMware Workstation Pro on a Windows 11 host.
- Twenty-one sequential guides covering repository acquisition, Windows host
  readiness, VMware installation, Kali download and verification, VM import and
  configuration, first boot, updating, snapshots, hardening, tools, workspace
  organization, networking, maintenance, and recovery.
- Windows PowerShell validators for host readiness, VMware installation, Kali
  archive hash verification, VMware networking, and repository publication
  safety.
- Thirteen Kali Bash scripts for updating, hardening, core tools, focused tool
  profiles, development setup, network/readiness validation, directory
  initialization, and CTF/DFIR workspace creation.
- Focused CTF, web-security, Network/Active Directory, and Blue-Team/DFIR tool
  profiles.
- CTF and DFIR workspace generators with existing-workspace protection.
- README fresh-clone repository layout documentation.
- Repository safety validation for forbidden artifacts, sensitive-content
  patterns, unfinished markers, line endings, internal Markdown links,
  documented repository paths, README tree drift, and `.gitignore` protections.
- GitHub issue forms for bugs, documentation issues, and feature requests.
- Pull-request guidance, contribution guidelines, security policy, Code of
  Conduct, third-party notices, MIT licensing, and Dependabot configuration.
- GitHub Actions validation for PowerShell syntax, PSScriptAnalyzer, Bash
  syntax, ShellCheck, and repository safety checks.
- Private vulnerability-reporting guidance integrated with GitHub's native
  Private Vulnerability Reporting workflow.

### Changed

- Aligned the README fresh-clone tree with the exact Git-tracked repository
  structure.
- Added consistent previous/next navigation and corrected sequencing across the
  full documentation set.
- Expanded VMware compatibility, virtual-hardware, first-boot, and
  invisible-pointer troubleshooting guidance.
- Aligned documentation with actual script privilege requirements, result
  states, exit codes, idempotency, and failure behavior.
- Reduced the pull-request template while preserving validation, privacy,
  licensing, dependency, compatibility, security, and authorized-use review.
- Changed Dependabot GitHub Actions checks from monthly to weekly.
- Pinned `actions/checkout` v7 to a reviewed full commit SHA.
- Hardened the `main` ruleset so pull requests and `Repository Validation` are
  required, the branch must be current with `main`, normal merge commits are the
  only permitted merge method, deletion and non-fast-forward updates are
  blocked, and no bypass actors are configured.
- Disabled the repository Wiki so tracked Markdown under `docs/` remains the
  single documentation source.
- Added focused GitHub repository topics for discoverability.
- Removed the duplicate custom private-vulnerability issue link after
  confirming GitHub's native private-reporting control is available.

### Fixed

- Corrected required-package cancellation behavior so incomplete required-tool
  installations return failure instead of reporting success.
- Updated `Update-Kali.sh` to reject root execution and return a distinct exit
  code for an intentionally cancelled full upgrade.
- Validated sudo authorization before privileged hardening checks.
- Made a missing `vol` command a blocking Blue-Team/DFIR profile failure.
- Prevented `Test-KaliReadiness.sh` from terminating abruptly when `ip` or
  `getent` is unavailable.
- Fixed an `Install-CoreTools.sh` `pipefail`/SIGPIPE edge case that could return
  exit code 141 during package-candidate detection.
- Lowered `Test-RepositorySafety.ps1` to the verified Windows PowerShell 5.1
  baseline.
- Added README fresh-clone tree comparison against Git-tracked files and
  directories.
- Corrected documentation-link examples and stale pre-publication language.
- Generalized the Windows pending-restart warning so it remains accurate after
  VMware is installed.

### Security

- Established explicit authorized-use boundaries for cybersecurity testing.
- Added publication restrictions for credentials, private keys, VPN material,
  private network details, packet captures, memory dumps, forensic evidence,
  VM state, and unsanitized screenshots.
- Added `.gitignore` guardrails for sensitive data and large/private lab
  artifacts.
- Added repository-level sensitive-content and forbidden-artifact validation.
- Documented accidental-secret response, credential rotation, and Git-history
  cleanup considerations.
- Documented GitHub secret scanning and push protection as layered controls.
- Restricted GitHub Actions permissions to read-only repository contents.
- Pinned the third-party checkout action to an immutable commit SHA.
- Confirmed GitHub Private Vulnerability Reporting is available.
- Protected `main` with required pull requests and required repository
  validation.

### Validation

The `v1.0.0` baseline was validated through both local/runtime testing and
GitHub CI.

- Fresh public HTTPS clone completed successfully without account-specific SSH
  configuration.
- Fresh clone resolved to the expected `main` commit and contained exactly 57
  tracked files.
- Repository safety validation passed with zero forbidden artifacts, sensitive
  findings, unfinished markers, CRLF/lone-CR files, broken internal links,
  missing documented paths, README layout findings, or `.gitignore` failures.
- All Windows PowerShell scripts parsed successfully under Windows PowerShell
  5.1 and PowerShell 7.
- `PSScriptAnalyzer` completed with zero findings.
- All 13 Kali Bash scripts passed `bash -n`.
- All 13 Kali Bash scripts passed ShellCheck.
- Windows runtime validation confirmed host readiness behavior, VMware
  installation detection, VMware network readiness, and both successful and
  failing Kali archive hash-verification paths.
- Kali runtime validation confirmed network readiness, workstation readiness,
  security-baseline checks, update behavior, directory initialization,
  workspace helpers, focused tool profiles, controlled cancellation paths,
  missing-command handling, sudo-authorization failure handling, and the
  corrected core-tools package-candidate path.
- Pull-request and post-merge GitHub Actions validation passed for the release
  preparation changes.

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

5. Confirm the README, documentation, scripts, security policy, and third-party
   notices still match the release.
6. Run the repository validation workflow.
7. Review the staged Git diff.
8. Create the release commit.
9. Create an annotated or GitHub release tag when appropriate.

---

## Versioning

The project uses semantic-style version numbers for public releases:

```text
MAJOR.MINOR.PATCH
```

Examples:

```text
1.0.0
1.1.0
1.1.1
```

A version number communicates the scale of the project change rather than the
version of Kali Linux or VMware Workstation Pro.

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

## Release Baseline

`v1.0.0` establishes the first supported tagged baseline for this repository.

Future work belongs under **Unreleased** until it is intentionally moved into a
new versioned section. Historical release entries should remain intact so users
can understand compatibility, security, and workflow changes across versions.
