# Security Policy

## 1. Purpose

The Kali VMware Cybersecurity Workstation repository is designed for
cybersecurity education, authorized labs, CTFs, defensive security work,
digital-forensics training, and systems that you own or have explicit
permission to test.

The repository contains documentation and automation that configure or
validate a Windows 11 host, VMware Workstation Pro, and a Kali Linux virtual
machine.

Because the project interacts with security tooling, virtualization, network
configuration, and system state, security reports should be handled carefully.

---

## 2. Authorized Use

The tools, scripts, and techniques documented here must not be used against
systems, networks, accounts, services, or data without authorization.

Acceptable use includes:

- Systems you own
- Systems you are explicitly authorized to test
- Classroom labs
- Cyber ranges
- CTF environments
- Authorized training platforms
- Defensive-security analysis
- Incident-response training
- Digital-forensics exercises

A security report should not include evidence obtained through unauthorized
access.

---

## 3. Supported Versions

This repository is documentation and automation rather than a packaged
application with multiple maintained release branches.

The supported project version is:

```text
main
```

after the repository is published.

If tagged releases are created later, the most recent supported release will
normally be the current release unless the repository explicitly states
otherwise.

Historical commits, abandoned branches, forks, and old snapshots are not
actively supported.

---

## 4. What Qualifies as a Repository Security Issue

Examples of security issues that should be reported privately include:

- A script unexpectedly exposes credentials or secrets
- A script prints private network details that should remain private
- A script can overwrite sensitive user data without appropriate safeguards
- Unsafe privilege handling
- Command injection
- Path traversal
- Unsafe temporary-file handling
- Insecure file permissions created by repository automation
- A workflow grants broader GitHub permissions than it requires
- A workflow exposes secrets to untrusted pull requests
- A repository file contains a real credential, token, or private key
- A repository file unintentionally contains private personal or lab data
- A published example would cause users to weaken important security controls
- A validation routine gives a dangerous false sense of security
- A contribution bypasses repository safety checks in a meaningful way

If disclosure would create additional risk, report it privately.

---

## 5. What Is Normally a Bug Report Instead

The following issues generally do not require private security reporting:

- Typographical errors
- Broken internal links
- Broken public documentation links
- Outdated screenshots
- Package-name changes
- Version mismatches
- Non-sensitive installation failures
- Cosmetic formatting problems
- A tool no longer being available from a package repository
- A script producing an ordinary non-sensitive error
- Documentation that could be explained more clearly

These may be reported through the normal issue process once the public
repository is available.

Do not include sensitive information in a normal bug report.

---

## 6. Preferred Security Reporting Method

For a published public repository, the preferred reporting method is GitHub
Private Vulnerability Reporting when the repository displays:

```text
Report a vulnerability
```

under its security interface.

GitHub documents that workflow here:

[Privately Reporting a Security Vulnerability](https://docs.github.com/en/code-security/how-tos/report-and-fix-vulnerabilities/report-privately)

Private vulnerability reporting allows a reporter to send vulnerability
details directly to repository maintainers without publishing those details in
a normal issue.

---

## 7. If Private Vulnerability Reporting Is Not Available

If the repository does not display a private vulnerability reporting option:

1. Do not publish vulnerability details in a public issue.
2. Do not post credentials, exploit details, private data, or proof-of-concept
   material publicly.
3. Open a public issue only to request a preferred private security contact.
4. Keep that issue free of sensitive technical details.

GitHub recommends establishing a private communication channel before
disclosing vulnerability details publicly.

See:

[Coordinated Disclosure of Security Vulnerabilities](https://docs.github.com/en/code-security/concepts/vulnerability-reporting-and-management/coordinated-disclosure)

---

## 8. Information to Include in a Private Report

When reporting a vulnerability privately, include enough information to allow
the issue to be reproduced and assessed.

Useful information includes:

- A concise title
- Affected file or script
- Affected repository version or commit
- Operating-system version
- VMware version when relevant
- Kali version when relevant
- Exact reproduction steps
- Expected behavior
- Actual behavior
- Security impact
- Whether elevated privileges are required
- Whether user interaction is required
- Whether the issue exposes secrets or private information
- Suggested remediation if known

Keep examples sanitized.

---

## 9. Information Not to Include Publicly

Do not publish the following in public issues, discussions, pull requests, or
screenshots:

- Passwords
- API keys
- Access tokens
- Session cookies
- SSH private keys
- VPN credentials
- Private certificates
- Recovery codes
- Personal information
- Private email addresses
- Real private network details
- Private hostnames
- Account identifiers
- Packet captures containing sensitive traffic
- Memory dumps
- Disk images
- Forensic evidence
- Real CTF flags that must remain private
- Proprietary lab credentials
- Screenshots containing any of the above

Sanitize evidence before sharing it.

---

## 10. Accidental Secret Exposure

If a real secret is accidentally committed or pushed, treat the secret as
compromised.

Examples include:

- Password
- API token
- Personal access token
- SSH private key
- Cloud credential
- VPN credential
- Signing key
- Authentication cookie

The first response should be to:

1. Revoke or rotate the exposed credential.
2. Confirm that the replacement credential is not present in the repository.
3. Assess whether the credential was used after exposure.
4. Determine whether Git history cleanup is necessary.
5. Review repository safeguards to prevent recurrence.

Deleting the visible file does not make an exposed secret trustworthy again.

---

## 11. Removing Sensitive Data from Git History

GitHub documents procedures for removing sensitive data from repository
history:

[Removing Sensitive Data from a Repository](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository)

History rewriting can be disruptive and can affect:

- Commit hashes
- Forks
- Pull requests
- Collaborator clones
- Signed commits
- Branch protections

Rotate or revoke a leaked secret before deciding whether a history rewrite is
also necessary.

---

## 12. Secret Scanning

After publication, repository security settings should enable appropriate
GitHub secret-protection features where available.

GitHub secret scanning can identify supported credential patterns exposed in
repository content.

GitHub documents the feature here:

[Secret Scanning](https://docs.github.com/en/code-security/concepts/secret-security/secret-scanning)

A secret-scanning alert should be investigated promptly.

If a valid secret was exposed, rotate or revoke it.

---

## 13. Push Protection

Where available, GitHub push protection should be enabled to help prevent
supported secrets from being pushed into the repository.

Push protection is a preventive control.

It does not replace:

- Reviewing staged changes
- `.gitignore`
- Repository safety scans
- Contributor awareness
- Credential rotation after exposure

The repository should continue using multiple layers of secret protection.

---

## 14. Repository Security Advisories

GitHub Repository Security Advisories may be used by maintainers to discuss,
fix, and eventually disclose repository vulnerabilities.

GitHub documents that process here:

[Repository Security Advisories](https://docs.github.com/en/code-security/concepts/vulnerability-reporting-and-management/repository-security-advisories)

A draft advisory may be used to coordinate remediation privately before public
disclosure.

---

## 15. Coordinated Disclosure

Reporters are asked to allow a reasonable opportunity to:

- Reproduce the issue
- Assess impact
- Develop a fix
- Test the fix
- Update documentation
- Publish an advisory when appropriate

Do not intentionally publish sensitive vulnerability details while private
remediation is actively underway unless there is a compelling safety or legal
reason.

The project does not require reporters to surrender independent legal rights.

---

## 16. Response Expectations

Security reports will be reviewed on a best-effort basis.

This project does not guarantee:

- A specific response time
- A specific remediation time
- Continuous monitoring
- 24-hour support
- Commercial support
- Emergency-response coverage

The absence of a guaranteed service level does not reduce the importance of a
valid security report.

---

## 17. No Bug Bounty Program

This repository does not operate a bug bounty program unless a future project
notice explicitly states otherwise.

Do not assume that reporting a vulnerability creates an entitlement to:

- Payment
- Reward
- Employment
- Contract work
- Reimbursement
- Merchandise
- Public recognition

Good-faith reporters may be credited when appropriate and when they agree to
be identified.

---

## 18. Third-Party Vulnerabilities

This repository references many third-party products and projects.

Examples include:

- Kali Linux
- VMware Workstation Pro
- Microsoft Windows
- 7-Zip
- Burp Suite
- Caido
- Kali packages
- Python packages
- Cybersecurity tools

A vulnerability in third-party software should normally be reported to that
software's publisher or maintainer.

This repository is not the security-response team for those products.

Review:

[Third-Party Notices](THIRD_PARTY_NOTICES.md)

for ownership and licensing boundaries.

---

## 19. When a Third-Party Vulnerability Affects This Repository

A third-party issue may still justify a repository report when this project:

- Recommends a vulnerable configuration
- Pins an unsafe dependency
- Provides an unsafe installation method
- Fails to warn about a known material risk
- Introduces an insecure integration
- Encourages users to disable protections unnecessarily

In that case, report the repository-specific impact.

Do not submit confidential vendor vulnerability information that you are not
authorized to disclose.

---

## 20. Safe Security Testing

Security testing of this repository should avoid harming third parties.

Use:

- Local test repositories
- Disposable virtual machines
- Isolated lab networks
- Synthetic credentials
- Mock data
- Test fixtures
- Authorized services

Do not test a hypothesis by targeting unrelated public infrastructure.

---

## 21. VMware and Network Safety

Networking changes can affect systems outside the Kali VM.

The repository uses VMware NAT as its normal baseline.

Use caution when testing changes involving:

- Bridged networking
- Host-only networking
- LAN segments
- Port forwarding
- Local services
- Firewall changes
- Routing
- Packet capture

Do not use school, work, public, or third-party networks as experimental attack
ranges without authorization.

---

## 22. Privilege and Administrative Access

Some setup operations may require:

```text
Administrator
```

on Windows or:

```text
sudo
```

on Kali.

A contribution should request elevated privileges only when necessary.

Scripts should not hide privilege use from the user.

Avoid broad system changes when a narrower change is sufficient.

---

## 23. Destructive Behavior

Repository automation should not silently:

- Delete unrelated user files
- Format disks
- Remove network configuration
- Disable security software
- Disable firewalls
- Disable Secure Boot
- Disable operating-system protections
- Rewrite unrelated Git history
- Destroy VM snapshots
- Overwrite an existing workspace without warning

A destructive action requires a clear, documented reason and appropriate user
control.

---

## 24. File and Path Safety

Scripts that create directories or files should:

- Validate paths where practical
- Avoid accidental overwrite
- Quote path variables
- Avoid unsafe wildcard expansion
- Use predictable workspace locations
- Keep generated private artifacts out of Git

Workspace helpers should remain idempotent or explicitly protect existing
content when practical.

---

## 25. Network Privacy

Public repository output should avoid exposing real network details.

Validation scripts should not unnecessarily print:

- Private IPv4 addresses
- Gateways
- DNS server addresses
- MAC addresses
- Internal hostnames
- VPN endpoints

A security validator should report whether a condition is healthy without
publishing sensitive network inventory when that detail is unnecessary.

---

## 26. VMware Files and Virtual Disks

Never commit virtual-machine state to this repository.

This includes:

```text
.vmdk
.vmx
.vmxf
.vmsd
.vmsn
.vmem
.vmss
.nvram
```

VM files can contain:

- Credentials
- Browser history
- SSH material
- VPN data
- Lab artifacts
- Shell history
- Private network information
- Personal files

Keep virtual machines outside the repository.

---

## 27. Captures, Memory, and Forensic Evidence

Do not commit:

```text
.pcap
.pcapng
.cap
.evtx
.dmp
.dump
.raw
.mem
```

or comparable evidence artifacts unless the repository explicitly establishes
a safe synthetic fixture process.

Real evidence may contain highly sensitive information.

Use local case storage instead.

---

## 28. Raw Screenshots

Raw screenshots should remain local.

The repository ignores:

```text
assets/raw-screenshots/
```

Only publish sanitized images that have been reviewed for:

- Credentials
- Email addresses
- Usernames
- Private paths
- Hostnames
- IP addresses
- MAC addresses
- Browser data
- Account information
- Notifications
- Personal information

Sanitized public images belong in:

```text
assets/sanitized-images/
```

---

## 29. Repository Validation

The project uses layered validation before publication.

Checks include:

- PowerShell parsing
- Bash syntax
- ShellCheck
- Internal Markdown-link validation
- External-link validation
- Script-path validation
- Sensitive-data scanning
- Forbidden-artifact scanning
- Line-ending validation
- Git staged-content review
- `git diff --cached --check`

Passing automated checks does not prove the absence of every vulnerability.

Human review remains necessary.

---

## 30. CI Security

GitHub Actions workflows should use the minimum permissions necessary.

Where practical:

- Use read-only repository permissions
- Avoid exposing secrets to pull requests
- Pin or deliberately version third-party actions
- Avoid executing untrusted pull-request content with elevated permissions
- Keep validation workflows non-destructive
- Treat workflow changes as security-sensitive

A pull request that changes CI permissions deserves additional review.

---

## 31. Contribution Security

Contributors should review:

[Contributing Guidelines](CONTRIBUTING.md)

before submitting changes.

Security-relevant contributions should explain:

- What security behavior changes
- Why the change is necessary
- What was tested
- Whether privileges change
- Whether networking changes
- Whether new dependencies are introduced
- Whether the change can expose private information

---

## 32. Community Conduct

Security discussions are also subject to:

[Code of Conduct](CODE_OF_CONDUCT.md)

Good-faith disagreement about severity or remediation is acceptable.

Harassment, retaliation, threats, or publishing another person's private
information are not.

---

## 33. Disclosure Credit

When a vulnerability is fixed and publicly disclosed, the project may credit a
reporter if:

- The report was made in good faith
- Attribution is appropriate
- The reporter agrees to be identified

A reporter may request to remain anonymous.

---

## 34. CVE Assignment

This repository does not promise that every security issue will receive a CVE.

If a vulnerability is appropriate for public advisory publication, GitHub's
repository security advisory process may support requesting a CVE when
applicable.

Whether a CVE is appropriate depends on the nature and impact of the issue.

---

## 35. Legal and Regulatory Matters

This security policy describes project reporting and handling practices.

It is not legal advice and does not replace:

- Applicable law
- Contractual obligations
- School or employer policies
- Platform terms
- Export restrictions
- Third-party license terms
- Law-enforcement requirements

Reporters and contributors remain responsible for acting within their legal
authority.

---

## 36. Good-Faith Research

This project welcomes good-faith security review of the repository itself.

Good-faith review should:

- Stay within authorized scope
- Minimize harm
- Protect user privacy
- Avoid accessing unrelated third-party systems
- Avoid unnecessary data collection
- Report sensitive findings privately
- Allow reasonable remediation time

This policy does not authorize testing against infrastructure that the
repository owner does not control.

---

## 37. Security Policy Changes

This policy may evolve as the repository gains:

- Releases
- Contributors
- CI workflows
- Additional dependencies
- GitHub security features
- New automation

Material changes should be committed to the repository so that the policy
history remains reviewable.

---

## 38. Security Reporting Summary

For a potential repository vulnerability:

```text
Sensitive issue?
    |
    v
Do not open a detailed public issue
    |
    v
Use GitHub "Report a vulnerability" when available
    |
    v
Provide sanitized reproduction details
    |
    v
Coordinate remediation privately
    |
    v
Disclose publicly only when appropriate
```

For an ordinary non-sensitive bug:

```text
Use the normal issue process
```

For a third-party product vulnerability:

```text
Report it to the applicable upstream publisher or maintainer
```

For an accidentally exposed credential:

```text
Revoke or rotate it immediately
```

---

## 39. Related Project Policies

Review:

[Contributing Guidelines](CONTRIBUTING.md)

[Code of Conduct](CODE_OF_CONDUCT.md)

[Third-Party Notices](THIRD_PARTY_NOTICES.md)

[MIT License](LICENSE)

before contributing to or redistributing this project.
