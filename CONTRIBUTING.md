# Contributing to Kali VMware Cybersecurity Workstation

Thank you for considering a contribution to this repository.

This project is intended to provide a beginner-friendly, reproducible, and
security-conscious Kali Linux workstation build for authorized cybersecurity
education, CTFs, labs, defensive security, and digital-forensics training.

Contributions should preserve that purpose.

---

## 1. Contribution Principles

A contribution should improve at least one of the following:

- Accuracy
- Security
- Reproducibility
- Beginner usability
- Documentation quality
- Validation coverage
- Maintainability
- Compatibility with supported Windows, VMware, or Kali releases

Avoid unnecessary complexity.

A change should solve a clear problem rather than simply add more tools,
settings, or automation.

---

## 2. Authorized and Ethical Use

Do not submit content that encourages or enables unauthorized access to
systems, networks, accounts, or data.

Acceptable contributions include:

- Authorized lab setup
- CTF tooling
- Defensive-security workflows
- Security validation
- Network analysis
- Web-security training
- Digital-forensics workflows
- Incident-response tooling
- Reproducible development-environment improvements

Contributions must not include:

- Instructions targeting real systems without authorization
- Stolen credentials
- Real victim data
- Private organization data
- Malware intended for deployment
- Destructive payloads
- Credential-theft material
- Persistence intended for unauthorized systems
- Evasion instructions designed to facilitate abuse

When a security technique has legitimate educational value, document the
authorized scope clearly.

---

## 3. Never Commit Sensitive Data

Do not submit:

- Passwords
- API keys
- Access tokens
- Private keys
- VPN profiles
- Authentication cookies
- Personal email addresses
- Private IP addressing from a real environment
- MAC addresses from a real environment
- Private hostnames
- User-specific Windows profile paths
- Packet captures containing private traffic
- Memory dumps
- Disk images
- Forensic evidence
- CTF flags that should remain private
- Screenshots containing sensitive or identifying information

Use placeholders in public documentation.

Examples:

```text
<your-username>
<hostname>
<official-sha256>
<version>
```

Review:

[Security and Sensitive-Data Policy](SECURITY.md)

before opening a pull request.

---

## 4. Do Not Commit Virtual Machines or Large Lab Artifacts

Do not submit VMware or disk artifacts such as:

```text
.vmdk
.vmx
.vmxf
.vmsd
.vmsn
.vmem
.vmss
.nvram
.iso
.img
.vhd
.vhdx
.qcow
.qcow2
.vdi
```

Do not submit packet captures, forensic images, evidence collections, VPN
profiles, or compressed tool archives.

The repository is intended to contain documentation, configuration guidance,
and reproducible automation rather than user-specific lab state.

---

## 5. Use Official Sources

When a contribution adds a manual download or installation step, prefer the
software vendor's official source.

Examples include:

- Broadcom for VMware Workstation Pro
- Kali Linux for Kali images and documentation
- Microsoft for Windows documentation
- 7-Zip for 7-Zip downloads

Avoid linking to unofficial software mirrors when the original publisher
provides the required file or documentation directly.

Use descriptive Markdown links instead of bare URLs when the URL is meant to
be clicked by a reader.

Literal URLs used inside commands or configuration examples may remain raw.

---

## 6. Keep the Beginner Workflow Linear

This repository is designed for users who may have no prior virtualization or
Linux experience.

Documentation should:

- Explain why a step is required
- Use clear headings
- Provide exact commands
- Explain expected results
- Include safety boundaries where relevant
- Link to the next related guide
- Avoid assuming advanced background knowledge

Do not require the reader to infer missing setup steps.

---

## 7. Preserve Repository Structure

Primary documentation belongs in:

```text
docs/
```

Windows-host PowerShell scripts belong in:

```text
scripts/windows/
```

General Kali scripts belong in:

```text
scripts/kali/
```

Optional Kali tool profiles belong in:

```text
scripts/kali/profiles/
```

Workspace helpers belong in:

```text
scripts/kali/workspace/
```

Sanitized public images may be placed in:

```text
assets/sanitized-images/
```

Do not place public content in ignored private directories.

---

## 8. PowerShell Requirements

PowerShell contributions should:

- Parse successfully with the PowerShell parser
- Avoid unnecessary administrative changes
- Prefer read-only validation when practical
- Report failures clearly
- Use meaningful exit codes when appropriate
- Avoid printing secrets or private network details
- Be safe to inspect before execution

Before submitting a PowerShell change, verify that it parses successfully.

---

## 9. Bash Requirements

Bash contributions should:

- Pass `bash -n`
- Pass ShellCheck
- Use safe quoting
- Avoid unnecessary privilege escalation
- Avoid silently overwriting user data
- Avoid printing secrets or private environment details
- Handle expected failure conditions clearly

Run:

```bash
bash -n path/to/script.sh
```

and:

```bash
shellcheck path/to/script.sh
```

before submitting the change.

---

## 10. Line Endings

The repository uses LF line endings for Markdown, Bash, PowerShell, and most
other text files.

The repository `.gitattributes` file defines the expected behavior.

Do not introduce CRLF line endings into Bash scripts.

---

## 11. Documentation Links

Internal Markdown links must resolve correctly.

When linking between files in `docs/`, use relative Markdown links.

Example:

```markdown
[VMware Networking](docs/19-vmware-networking.md)
```

From the root README, include the `docs/` path.

Example:

```markdown
[VMware Networking](docs/19-vmware-networking.md)
```

External links should prefer stable official documentation.

---

## 12. Version-Specific Information

Kali is a rolling distribution, and VMware releases change over time.

When documenting a specific release:

- State the release clearly
- Avoid presenting an old version as permanently current
- Prefer process-based instructions where practical
- Link to official current documentation
- Verify checksums against the current publisher source

Do not replace a working compatibility baseline solely to chase the newest
version number.

---

## 13. Testing Expectations

Before opening a pull request, run the validation relevant to your change.

At minimum, contributors should verify:

- Internal Markdown links
- Script path references
- PowerShell parser results
- Bash syntax
- ShellCheck
- Sensitive-data scans
- Forbidden-artifact scans
- Line endings
- `git diff --check`

If a contribution changes an installation or runtime script, test it in an
authorized disposable or recoverable environment when practical.

Document what was tested.

---

## 14. Pull Request Scope

Keep pull requests focused.

A pull request should normally address one logical change, such as:

- Fixing one documentation workflow
- Updating one compatibility issue
- Adding one validation improvement
- Correcting one tool profile
- Improving one security control

Large unrelated changes are harder to review and validate.

---

## 15. Pull Request Description

A pull request should explain:

1. What changed
2. Why the change is needed
3. What files are affected
4. How the change was tested
5. Whether it changes security behavior
6. Whether it changes networking behavior
7. Whether it introduces a new external dependency

Include screenshots only when they are sanitized and genuinely useful for
review.

---

## 16. New Dependencies

Do not add a new third-party dependency without a clear reason.

When proposing one, document:

- What it does
- Why existing tools are insufficient
- How it is installed
- Its official source
- Its license
- Its security implications
- Whether it is required or optional

Prefer built-in operating-system capabilities and established package
repositories when they are sufficient.

---

## 17. Third-Party Licensing

Do not copy third-party source code, documentation, screenshots, logos, or other
copyrighted material into this repository unless the applicable license or
permission allows it.

When referencing third-party software, use links and original documentation
where practical instead of redistributing the software itself.

Third-party products remain subject to their own licenses and terms.

---

## 18. Reporting Security Problems

Do not open a public issue that exposes:

- A real secret
- A valid credential
- A private key
- A token
- Sensitive personal data
- A private network detail that should not be public
- A vulnerability that would create unnecessary risk if immediately disclosed

Follow:

[Security and Sensitive-Data Policy](SECURITY.md)

for security-reporting guidance.

---

## 19. Commit Quality

Use concise commit messages that describe the change.

Examples:

```text
Fix Kali hash verification guidance
Improve VMware NAT validation
Add DFIR workspace checks
Update Windows host readiness documentation
```

Avoid messages such as:

```text
update
changes
fix stuff
test
```

---

## 20. Contribution Licensing

This repository is licensed under the MIT License.

By submitting a contribution, you represent that you have the right to submit
the material and agree that your contribution may be distributed under the
repository's MIT License.

Do not submit material that you do not have permission to license under those
terms.

Review:

[MIT License](LICENSE)

before contributing.

---

## 21. Code of Conduct

Participation in this project is also governed by the repository's Code of
Conduct.

Review:

[Code of Conduct](CODE_OF_CONDUCT.md)

before participating in project discussions or reviews.

---

## 22. Before You Submit

Confirm:

- [ ] The contribution supports authorized cybersecurity use
- [ ] No secrets or private data are included
- [ ] No VM disks, captures, evidence, or VPN profiles are included
- [ ] New external links use official sources where practical
- [ ] Internal links resolve
- [ ] Relevant scripts parse or lint successfully
- [ ] Bash scripts pass ShellCheck
- [ ] Line endings follow `.gitattributes`
- [ ] `git diff --check` reports no whitespace errors
- [ ] New dependencies are documented
- [ ] Third-party licensing has been considered
- [ ] The change has been tested where practical
- [ ] The pull request explains what changed and why

Thank you for helping keep this repository accurate, safe, reproducible, and
useful for cybersecurity learners.
