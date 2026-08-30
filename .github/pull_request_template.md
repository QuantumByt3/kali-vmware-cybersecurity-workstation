# Pull Request

## Summary

<!-- What changed, why is it needed, and what user problem does it solve? -->

## Change Type

Select all that apply:

- [ ] Documentation
- [ ] Bug fix
- [ ] Validation or CI improvement
- [ ] Windows PowerShell change
- [ ] Kali Bash change
- [ ] Tool-profile or workspace-helper change
- [ ] VMware or networking change
- [ ] Security, governance, or repository-metadata change
- [ ] Dependency or third-party integration change
- [ ] Other

## Scope

Affected files or workflows:

```text
List the repository-relative paths that matter most.
```

Related issue, if any:

```text
Fixes #...
```

## Implementation

Explain the important implementation details.

For script changes, include relevant behavior such as inputs, outputs, exit codes,
privilege requirements, file-system effects, networking, dependencies, and
idempotency.

For documentation changes, identify the workflow that changed and the official
upstream source when the correction depends on current third-party behavior.

## Validation

Select the checks that apply:

- [ ] PowerShell parser
- [ ] PSScriptAnalyzer
- [ ] `bash -n`
- [ ] ShellCheck
- [ ] Runtime validation
- [ ] Idempotency or controlled failure-path test
- [ ] Repository safety validation
- [ ] Internal-link or documented-path validation
- [ ] `git diff --check`
- [ ] Windows runtime test
- [ ] Kali runtime test
- [ ] VMware runtime test
- [ ] Manual documentation review
- [ ] Not applicable

Important sanitized results:

```text
Paste only the results needed to support the change.
```

## Impact Review

### Security, Privilege, and Networking

State whether the change affects any of the following:

```text
Security behavior:
Windows Administrator requirements:
Kali sudo requirements:
VMware host/guest isolation:
Network mode, routing, DNS, firewall, listeners, or port forwarding:
CI permissions or secrets:
```

If none apply, write `None` where appropriate.

### Dependencies

- [ ] No third-party dependency was added or changed.
- [ ] A dependency was added or changed and the details are documented below.

When applicable:

```text
Name:
Official source:
License:
Required or optional:
Reason:
```

If a dependency changed, confirm:

- [ ] The source is official or otherwise trusted.
- [ ] The applicable license was reviewed.
- [ ] `THIRD_PARTY_NOTICES.md` was updated when required.

## Documentation and Compatibility

- [ ] Relevant guides were updated, or documentation is not affected.
- [ ] README navigation and repository-layout claims remain accurate, when affected.
- [ ] Internal links resolve.
- [ ] Version-specific information is labeled clearly.
- [ ] Existing users are not silently broken, or migration guidance is provided.

Backward-compatibility notes:

```text
Describe any changed command, path, prerequisite, result state, or workflow.
```

## Privacy, Artifact, and Authorized-Use Review

Confirm all applicable statements:

- [ ] No passwords, API keys, access tokens, private keys, or credentials are included.
- [ ] No private IP addresses, MAC addresses, hostnames, VPN details, or user-specific paths are included.
- [ ] No private packet captures, memory dumps, disk images, forensic evidence, malware samples, or unsanitized screenshots are included.
- [ ] No VMware virtual disks, snapshots, memory-state files, ISO images, VHD/VHDX, QCOW/QCOW2, or VDI images are included.
- [ ] Any cybersecurity testing described or performed was limited to systems or environments the contributor owns or was explicitly authorized to test.
- [ ] Sensitive vulnerability information, if any, was handled according to the repository Security Policy.

## Contributor Rights and Licensing

- [ ] I have the right to submit this contribution.
- [ ] I understand that accepted contributions are distributed under the repository's MIT License.
- [ ] I did not copy third-party material without an appropriate license, permission, or valid basis for reuse.
- [ ] Required attribution and third-party notices have been preserved or added.

## Final Checklist

- [ ] The pull request is focused on one logical change.
- [ ] The repository remains beginner-friendly and reproducible.
- [ ] Relevant validation passes.
- [ ] `git diff --check` reports no whitespace errors.
- [ ] LF line endings are preserved.
- [ ] No sensitive or forbidden artifacts are present.
- [ ] New dependencies are justified and documented.
- [ ] Security, privilege, networking, and compatibility impacts are explained.
- [ ] The pull request is ready for maintainer review.

## Repository Policies

- [Contributing Guidelines](https://github.com/QuantumByt3/kali-vmware-cybersecurity-workstation/blob/main/CONTRIBUTING.md)
- [Security Policy](https://github.com/QuantumByt3/kali-vmware-cybersecurity-workstation/security/policy)
- [Code of Conduct](https://github.com/QuantumByt3/kali-vmware-cybersecurity-workstation/blob/main/CODE_OF_CONDUCT.md)
- [Third-Party Notices](https://github.com/QuantumByt3/kali-vmware-cybersecurity-workstation/blob/main/THIRD_PARTY_NOTICES.md)
- [MIT License](https://github.com/QuantumByt3/kali-vmware-cybersecurity-workstation/blob/main/LICENSE)
