# Code of Conduct

## 1. Purpose

This repository supports safe, professional, beginner-friendly, and reproducible cybersecurity learning.

The project documents and automates the setup and maintenance of a Kali Linux virtual machine on VMware Workstation Pro using a Windows host.

Cybersecurity tools and techniques may have legitimate educational, defensive, administrative, research, and testing uses while also carrying misuse potential. Participation in this project therefore requires technical responsibility and professional judgment.

This Code of Conduct defines the behavioral standards for the repository community.

---

## 2. Scope

This Code of Conduct applies to project-related participation, including:

- Issues
- Pull requests
- Code review
- Repository discussions
- Commit discussions
- Documentation feedback
- Security-related coordination
- Project-linked educational activities
- Project-linked demonstrations

It also applies when someone is clearly representing the project in another project-related setting.

This document governs behavior.

Technical vulnerabilities are handled under [SECURITY.md](SECURITY.md).

Contribution procedures are defined in [CONTRIBUTING.md](CONTRIBUTING.md).

---

## 3. Expected Conduct

Participants are expected to:

- Communicate professionally.
- Treat others with respect.
- Focus criticism on ideas, code, documentation, or technical behavior.
- Support claims with evidence when practical.
- Correct mistakes when reliable evidence shows a claim is wrong.
- Avoid personal attacks and unnecessary hostility.
- Make room for beginners to ask reasonable questions.
- Protect private and sensitive information.
- Respect legal and authorization boundaries.
- Respect intellectual-property and licensing requirements.
- Follow repository security and contribution policies.

Technical disagreement is permitted.

Technical scrutiny is encouraged.

Personal hostility is not.

---

## 4. Beginner-Friendly Participation

This repository is intentionally structured so that people with limited experience can follow the workstation build from the beginning.

Participants should not ridicule someone for:

- Asking a basic question
- Misunderstanding terminology
- Needing a command explained
- Requesting clarification
- Making a correctable configuration mistake
- Being unfamiliar with Linux
- Being unfamiliar with PowerShell
- Being unfamiliar with VMware
- Being unfamiliar with Git or GitHub

Experienced contributors are encouraged to explain:

- What a command does
- Why a setting is recommended
- What could go wrong
- What a safe expected result looks like
- How to verify success

Beginner-friendly guidance must still remain technically accurate.

---

## 5. Technical Disagreement

Technical disagreement is a normal part of engineering and security work.

Acceptable disagreement includes:

- Challenging an implementation
- Questioning a dependency
- Requesting stronger validation
- Identifying a security weakness
- Rejecting unsupported claims
- Comparing alternative architectures
- Requesting reproducible evidence
- Requesting an official upstream source

When disagreeing, participants should:

1. Identify the specific technical point.
2. Provide evidence where practical.
3. Distinguish fact from opinion.
4. Avoid attacking the person presenting the idea.
5. Be willing to revise a position when better evidence is available.

Useful evidence may include:

- Reproducible command output
- Official vendor documentation
- Official project documentation
- Source code
- Release notes
- Test results
- Standards documentation
- Security advisories

---

## 6. Cybersecurity Authorization

This project supports authorized cybersecurity education and defensive practice.

Participants must not use project spaces to encourage unauthorized access, damage, disruption, surveillance, credential theft, persistence, or other harmful activity against systems they do not own or have explicit permission to test.

Appropriate contexts include:

- Personally owned systems
- Explicitly authorized lab environments
- CTF environments
- Cyber ranges
- Educational sandboxes
- Systems covered by a clear testing authorization
- Defensive administration
- Digital-forensics practice using lawfully obtained data

When authorization is unclear, discussion should remain within a controlled lab context rather than assuming permission.

---

## 7. Demonstrations and Examples

Security demonstrations should make the authorized context clear.

Examples should favor:

- Local virtual machines
- Intentionally vulnerable lab systems
- CTF targets
- Synthetic data
- Documentation-safe sample values
- Isolated training networks

Examples should not depend on:

- Real third-party credentials
- Real private network details
- Personal account data
- Real victim data
- Unrelated public systems
- Unapproved organizational infrastructure

A technically valid example may still be inappropriate for this repository if its presentation encourages misuse.

---

## 8. Privacy and Sensitive Information

Participants must protect sensitive information.

Do not knowingly publish:

- Passwords
- Authentication tokens
- API keys
- Private keys
- Recovery codes
- VPN credentials
- Private VPN profiles
- Personal addresses
- Private hostnames
- Real MAC addresses
- User-specific file-system paths
- Private organizational infrastructure details
- Private packet captures
- Memory dumps containing private or secret data
- Disk images containing private data
- Unsanitized screenshots containing private information

If sensitive material is accidentally published, follow the response guidance in [SECURITY.md](SECURITY.md).

Do not pressure another participant to reveal private environment details when sanitized information is sufficient.

---

## 9. Vulnerability Information

Do not publicly disclose repository security vulnerabilities when private reporting is appropriate.

Examples may include:

- Exposed credentials
- Unsafe CI privilege behavior
- A validation bypass that could publish sensitive artifacts
- A security-relevant automation defect
- A repository configuration weakness that materially affects contributors

Use the private reporting process described in [SECURITY.md](SECURITY.md).

Normal documentation mistakes and ordinary functional bugs may be reported through public issue templates.

---

## 10. Intellectual Property and Licensing

Contributors must respect intellectual-property rights.

Do not submit material that you do not have the right to contribute.

This includes:

- Proprietary source code
- Restricted course materials
- Unauthorized copies of commercial software
- Vendor binaries without redistribution permission
- Copyrighted material that cannot lawfully be redistributed
- Third-party documentation copied beyond an appropriate permitted use
- Licensed material whose terms conflict with repository distribution

When using third-party software or documentation:

- Prefer linking to the official source.
- Preserve required attribution.
- Identify relevant licensing when a dependency is introduced.
- Update `THIRD_PARTY_NOTICES.md` when appropriate.
- Do not imply that third-party software is covered by this repository's MIT License.

See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for project notices.

---

## 11. Trademarks and Affiliation

Product names may be used descriptively when needed to explain compatibility or workflow.

Do not falsely imply that this repository is:

- An official Kali Linux project
- An OffSec project
- A Broadcom project
- A VMware project
- A Microsoft project
- Endorsed by a third-party vendor unless that endorsement actually exists

Trademark use must remain descriptive and accurate.

---

## 12. Academic and Professional Integrity

Participants should represent their work accurately.

Do not:

- Claim another person's work as your own.
- Falsify validation results.
- Fabricate command output.
- Misrepresent authorization.
- Hide material security behavior from reviewers.
- Present untested instructions as verified.
- Conceal copied material or incompatible licensing.

When a contribution is based on another source, identify that source when appropriate.

When a result has not been validated, describe it accurately rather than claiming it passed testing.

---

## 13. Responsible Automation

Automation deserves additional care because unsafe actions can become easy to repeat.

Contributors should clearly document:

- Required privileges
- Files changed
- Packages installed
- Network changes
- Services affected
- Firewall behavior
- External downloads
- Expected output
- Failure conditions
- Exit-code behavior
- Repeated-run behavior

Automation should avoid destructive behavior unless the behavior is explicitly required, narrowly scoped, clearly explained, and safe for the intended environment.

---

## 14. Network Safety

Network-related contributions should preserve a safe baseline.

Changes involving:

- NAT
- Host-only networking
- Bridged networking
- Port forwarding
- Firewall rules
- Local listeners
- DNS
- Routing
- Shared folders
- Host/guest integration

should explain the resulting trust boundary.

Contributors should not normalize unnecessary exposure of intentionally vulnerable lab systems to unrelated networks.

---

## 15. Constructive Review

Review should improve both the contribution and the repository.

Reviewers should:

- Be specific.
- Explain blocking concerns.
- Separate required changes from optional suggestions.
- Cite evidence for technical objections.
- Avoid belittling language.
- Recognize when a concern has been addressed.
- Keep review focused on repository quality.

Contributors should:

- Respond professionally.
- Ask for clarification when needed.
- Explain intentional design choices.
- Update documentation when behavior changes.
- Avoid treating technical review as a personal attack.

---

## 16. Unacceptable Behavior

Unacceptable behavior includes:

- Harassment
- Threats
- Personal attacks
- Discriminatory abuse
- Deliberate intimidation
- Repeated disruptive behavior
- Sexual harassment
- Doxxing
- Publishing another person's private information
- Impersonation
- Spam
- Deliberate misinformation
- Knowingly fabricated technical evidence
- Encouraging unauthorized system access
- Encouraging destructive activity against unauthorized targets
- Publishing secrets or credentials
- Circumventing repository safeguards for malicious purposes
- Retaliation against a person who raises a good-faith concern

This list is not exhaustive.

Maintainers may act on behavior that clearly undermines a safe and productive project environment even when the exact behavior is not listed above.

---

## 17. Good-Faith Mistakes

Not every mistake is misconduct.

A contributor may:

- Misunderstand a command
- Link to an outdated source
- Miss a documentation edge case
- Introduce an accidental bug
- Misread tool output
- Make an incorrect technical assumption

When a mistake appears to be made in good faith, the preferred response is to identify it, explain it, and provide an opportunity to correct it.

Repeated refusal to correct harmful behavior after clear guidance may become a conduct issue.

---

## 18. Maintainer Responsibilities

Project maintainers are responsible for applying this Code of Conduct reasonably and consistently.

Maintainers may:

- Request a change in tone or behavior.
- Ask a participant to stop a disruptive interaction.
- Edit or remove inappropriate repository content where GitHub permissions allow.
- Lock conversations.
- Close issues or pull requests.
- Decline contributions.
- Restrict repository participation.
- Report serious platform abuse to GitHub.
- Escalate security-sensitive material through the repository security process.

Moderation decisions should consider:

- Severity
- Intent
- Impact
- Repetition
- Prior warnings
- Willingness to correct behavior
- Risk to other participants
- Risk to repository users

A contribution may also be declined for technical reasons without constituting a conduct sanction.

---

## 19. Enforcement

Maintainers should use proportionate enforcement.

Possible responses include:

### Correction

For minor or accidental problems, a maintainer may explain the concern and request a correction.

### Warning

For inappropriate or repeated behavior, a maintainer may issue a clear warning and identify the expected change.

### Participation Restriction

For serious or continuing violations, maintainers may restrict participation, close interactions, or block further contribution where platform controls permit.

### Removal

Content may be removed when it:

- Exposes private information
- Contains abusive material
- Encourages unauthorized harm
- Violates applicable platform rules
- Creates a material security risk
- Contains unlawfully redistributed material

### Platform Reporting

Serious abuse may be reported to GitHub through GitHub's reporting mechanisms.

---

## 20. Reporting Conduct Concerns

For behavior occurring on GitHub, participants may use GitHub's built-in reporting tools when available.

See:

[Reporting abuse or spam](https://docs.github.com/en/communities/maintaining-your-safety-on-github/reporting-abuse-or-spam)

Participants should not create public repository issues containing sensitive personal details solely to report a conduct concern.

For conduct that also involves a repository security vulnerability or exposed secret, follow [SECURITY.md](SECURITY.md).

---

## 21. GitHub Platform Standards

Participation in this repository is also subject to GitHub's platform rules.

See:

[GitHub Community Guidelines](https://docs.github.com/en/site-policy/github-terms/github-community-guidelines)

This repository may establish project-specific expectations in addition to GitHub's baseline community rules.

Nothing in this document limits GitHub's ability to enforce its own policies.

---

## 22. Security Reports and Conduct Reports

A security report concerns a technical vulnerability, exposed secret, unsafe workflow, or similar repository security issue.

A conduct report concerns behavior.

Some incidents may involve both.

Examples:

- Publishing another person's token may be both a security and conduct issue.
- Harassing a contributor is primarily a conduct issue.
- A CI privilege weakness is primarily a security issue.
- A documentation typo is neither and belongs in the normal issue process.

Use the reporting path appropriate to the problem.

---

## 23. Good-Faith Reporting

Participants should not retaliate against someone for making a good-faith security, conduct, licensing, privacy, or technical-quality report.

A report may ultimately be found incorrect without becoming misconduct.

Deliberately false reports intended to harass or disrupt others are not protected by this principle.

---

## 24. Changes to This Code

Maintainers may update this Code of Conduct as the repository changes.

Material changes should remain reviewable through normal repository history.

Participants are responsible for following the version that applies to current project participation.

---

## 25. Related Repository Policies

This Code of Conduct should be read together with:

- [README.md](README.md)
- [CONTRIBUTING.md](CONTRIBUTING.md)
- [SECURITY.md](SECURITY.md)
- [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)
- [LICENSE](LICENSE)

If a behavioral issue also raises a repository security concern, the Security Policy controls the vulnerability-reporting process.

If a contribution issue concerns contribution mechanics, the Contributing Guidelines control the submission process.

---

## 26. Summary

Participate professionally.

Challenge technical ideas without attacking people.

Support beginners without sacrificing accuracy.

Protect private information.

Respect licensing and intellectual-property rights.

Keep cybersecurity work within authorized environments.

Report repository vulnerabilities through the security process.

Use GitHub's reporting mechanisms for platform abuse when appropriate.

The goal is a repository community where people can learn, verify, contribute, and improve the project safely.
