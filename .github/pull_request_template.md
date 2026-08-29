# Pull Request

## Summary

Describe the change clearly and concisely.

Explain:

- What changed
- Why the change is needed
- Which files or workflows are affected

---

## Type of Change

Select all that apply:

- [ ] Documentation
- [ ] Bug fix
- [ ] Validation improvement
- [ ] Windows PowerShell change
- [ ] Kali Bash change
- [ ] Tool-profile change
- [ ] Workspace-helper change
- [ ] VMware configuration change
- [ ] Networking change
- [ ] Security-policy change
- [ ] GitHub workflow or repository metadata
- [ ] Dependency or third-party integration change
- [ ] Other

---

## Affected Area

Identify the affected repository area.

Examples:

```text
docs/05-configure-kali-vm.md
scripts/kali/Test-KaliReadiness.sh
scripts/windows/Test-VMwareInstallation.ps1
.github/workflows/validate.yml
```

---

## Problem Being Solved

Describe the specific problem, limitation, incompatibility, or maintenance issue
this pull request addresses.

Avoid broad changes that do not have a clear purpose.

---

## Implementation

Explain how the change works.

For scripts, include relevant implementation details such as:

- Inputs
- Outputs
- Exit-code behavior
- Privilege requirements
- File-system changes
- Network behavior
- External dependencies
- Idempotency or overwrite protections

For documentation, explain:

- What workflow changed
- Why the existing guidance was insufficient
- Which official sources support the update

---

## Testing Performed

Describe the testing completed for this change.

Select all that apply:

- [ ] PowerShell parser
- [ ] `bash -n`
- [ ] ShellCheck
- [ ] Runtime validation
- [ ] Idempotency test
- [ ] Internal Markdown-link validation
- [ ] External-link validation
- [ ] Documented-path validation
- [ ] Sensitive-data scan
- [ ] Forbidden-artifact scan
- [ ] Line-ending validation
- [ ] `git diff --check`
- [ ] Manual documentation review
- [ ] VMware runtime test
- [ ] Kali runtime test
- [ ] Windows runtime test
- [ ] Not applicable

Provide important results below:

```text
Paste sanitized validation results here.
```

---

## Environment

Provide only the environment information needed to reproduce or evaluate the
change.

### Windows Host

```text
Windows version:
Architecture:
Host RAM:
```

### VMware

```text
VMware Workstation Pro version:
```

### Kali

```text
Kali version:
Architecture:
```

Do not include:

- Windows usernames
- Private paths
- Hostnames
- Private IP addresses
- MAC addresses
- VPN endpoints
- Credentials

---

## Security Impact

Does this pull request change security behavior?

- [ ] No security behavior changes
- [ ] Yes, security behavior changes

If yes, explain:

- What security control changes
- Whether privileges change
- Whether host/guest isolation changes
- Whether network exposure changes
- Whether new secrets or credentials are involved
- Whether new third-party software is introduced
- Whether the change affects CI permissions

Security-sensitive changes require additional review.

---

## Networking Impact

Does this pull request change networking behavior?

- [ ] No networking changes
- [ ] Yes, networking changes

If yes, identify the affected mode or behavior:

- [ ] NAT
- [ ] Host-only
- [ ] Bridged
- [ ] LAN segment
- [ ] Port forwarding
- [ ] Local listener
- [ ] Firewall
- [ ] DNS
- [ ] Routing
- [ ] Other

Explain the scope and authorization assumptions.

---

## Privilege Impact

Does this change require elevated privileges?

- [ ] No
- [ ] Windows Administrator
- [ ] Kali `sudo`
- [ ] Other

Explain why elevated privileges are necessary when applicable.

---

## Dependency Impact

Does this pull request add or change a third-party dependency?

- [ ] No
- [ ] Yes

If yes, provide:

```text
Name:
Official source:
License:
Required or optional:
Reason:
```

Confirm that:

- [ ] The dependency comes from an official or trusted upstream source.
- [ ] The applicable license was reviewed.
- [ ] `THIRD_PARTY_NOTICES.md` was updated when required.

---

## Documentation Impact

Does this change require documentation updates?

- [ ] No
- [ ] Yes
- [ ] Documentation-only pull request

If yes, confirm:

- [ ] Relevant guides were updated.
- [ ] README navigation remains accurate.
- [ ] Internal links resolve.
- [ ] Official external links are used where practical.
- [ ] Version-specific information is labeled clearly.

---

## Backward Compatibility

Does this change alter an existing workflow or baseline?

- [ ] No
- [ ] Yes

If yes, explain:

- What changes for existing users
- Whether migration is needed
- Whether an old command or path stops working
- Whether the change affects a validated baseline

---

## Data and Privacy Review

Confirm all of the following:

- [ ] No passwords are included.
- [ ] No API keys or access tokens are included.
- [ ] No private keys are included.
- [ ] No VPN profiles or credentials are included.
- [ ] No private IP addresses are included unless they are clearly synthetic documentation values.
- [ ] No MAC addresses from a real environment are included.
- [ ] No user-specific Windows paths are included.
- [ ] No private hostnames are included.
- [ ] No packet captures containing private traffic are included.
- [ ] No memory dumps, disk images, or real forensic evidence are included.
- [ ] No unsanitized screenshots are included.

---

## Virtual Machine Artifact Review

Confirm that this pull request does not add:

- [ ] VMware virtual disks
- [ ] VMware memory state
- [ ] VMware snapshots
- [ ] ISO images
- [ ] VHD/VHDX images
- [ ] QCOW/QCOW2 images
- [ ] VDI images

If a checked item is intentionally included, stop and explain why before the
pull request is merged.

---

## Authorized-Use Confirmation

Confirm:

- [ ] Any cybersecurity testing described or performed for this change was limited to systems or environments I own or was explicitly authorized to test.
- [ ] This contribution does not instruct users to target third-party systems without authorization.
- [ ] This contribution is consistent with the repository Security Policy and Code of Conduct.

---

## Contributor Rights and Licensing

Confirm:

- [ ] I have the right to submit this contribution.
- [ ] I understand that accepted contributions are distributed under the repository's MIT License.
- [ ] I did not copy third-party material into the repository without an appropriate license, permission, or valid basis for reuse.
- [ ] Required attribution and third-party notices have been preserved or added.

Review:

[Contributing Guidelines](../CONTRIBUTING.md)

[Security Policy](../SECURITY.md)

[Code of Conduct](../CODE_OF_CONDUCT.md)

[Third-Party Notices](../THIRD_PARTY_NOTICES.md)

[MIT License](../LICENSE)

---

## Final Checklist

Before requesting review, confirm:

- [ ] The pull request is focused on one logical change.
- [ ] The repository still follows the beginner-friendly workflow.
- [ ] Relevant validation passes.
- [ ] `git diff --check` reports no whitespace errors.
- [ ] LF line endings are preserved.
- [ ] No sensitive or private data is present.
- [ ] No forbidden artifacts are present.
- [ ] Required documentation is updated.
- [ ] New dependencies are justified and documented.
- [ ] Security and networking implications are explained.
- [ ] The pull request is ready for maintainer review.
