# VMware Networking Modes

This step explains the VMware Workstation networking modes used by the Kali
workstation and how to choose an appropriate network for normal use, CTF labs,
and isolated practice environments.

The safest choice depends on what the VM needs to communicate with.

---

## 1. Networking Goals

A Kali VM may need one of several different network behaviors:

- Internet access for updates and package installation
- Access to an authorized lab target
- Isolation from the physical LAN
- Communication only with other lab VMs
- Temporary access to the Windows host

Do not choose a network mode only because it "works."

Choose the mode that provides the minimum connectivity required for the task.

---

## 2. VMware NAT

VMware NAT is the recommended default for this workstation.

In a typical VMware Workstation installation, NAT uses:

```text
VMnet8
```

The guest receives a private virtual-network address and VMware translates
outbound traffic through the Windows host.

Use NAT for:

- Kali updates
- Package installation
- General web access
- Authorized CTF platforms
- Browser-based labs
- VPN-based training environments

For this repository, NAT is the normal everyday baseline.

---

## 3. What NAT Does Not Mean

NAT does not automatically mean "fully isolated."

Depending on the host network, routing, firewall rules, and VMware
configuration, a NAT-connected guest may still be able to reach systems on the
same physical LAN.

Therefore, do not place intentionally vulnerable target VMs on NAT merely
because NAT uses private addressing.

Use a more isolated lab network when vulnerable targets should not communicate
with the surrounding home, school, or public network.

---

## 4. VMware Host-Only Networking

A typical VMware Workstation installation provides host-only networking on:

```text
VMnet1
```

Host-only networking normally allows:

```text
Windows host <-> VMware guest
VMware guest <-> other guests on the same host-only network
```

while preventing normal direct access to the external physical network.

Host-only networking is useful for:

- Local security labs
- Kali-to-target VM exercises
- Testing services between VMs
- Deliberately vulnerable practice machines
- Labs that do not require Internet access

The Windows host remains part of the virtual network.

---

## 5. Host-Only Is Not the Same as Air-Gapped

A host-only network is isolated from normal external routing, but the Windows
host can still communicate with the guests.

That means the host itself becomes part of the lab boundary.

Do not treat host-only networking as equivalent to a physically disconnected
environment.

For deliberately vulnerable systems, keep the Windows host patched and avoid
unnecessary shared folders, clipboard integration, or exposed services.

---

## 6. VMware Bridged Networking

Bridged networking places the VM onto the physical network as a peer device.

The VM may receive an address from the same DHCP infrastructure used by the
Windows host and other devices on that network.

Bridged mode may be useful in specialized authorized scenarios, but it is not
the default recommended mode for this workstation.

Avoid bridged networking when:

- Using public Wi-Fi
- Using school or workplace networks without authorization
- Running intentionally vulnerable target VMs
- A lab does not explicitly require Layer 2 access to the physical network

Bridged mode increases the VM's exposure to the surrounding network and the
surrounding network's exposure to the VM.

---

## 7. VMware LAN Segments

VMware Workstation can also create LAN segments for VM-to-VM communication.

A LAN segment is useful when lab VMs should communicate with each other but
should not have normal connectivity to:

- The Windows host
- The Internet
- The physical LAN

Unlike the common NAT and host-only networks, a LAN segment does not normally
provide VMware DHCP or a host-side virtual adapter.

Guest addressing may therefore need to be configured manually or provided by
a lab-specific DHCP service.

LAN segments are a strong option for deliberately vulnerable multi-VM labs.

---

## 8. Recommended Baseline

For the Kali workstation itself, use:

```text
NAT
```

for normal operation unless a specific authorized lab requires something
different.

For an isolated local lab containing Kali and vulnerable targets, prefer:

```text
Host-only
```

or:

```text
LAN Segment
```

depending on whether the Windows host needs to participate in the lab network.

Use bridged networking only when the lab design specifically requires it and
the physical network owner has authorized that activity.

---

## 9. Typical Use Cases

### Normal Kali Workstation

Recommended:

```text
NAT
```

Provides convenient Internet access for updates and common training
platforms.

### Kali Plus a Vulnerable Target VM

Recommended:

```text
Host-only
```

when the Windows host may need to communicate with the lab.

### Fully Internal Multi-VM Practice Lab

Recommended:

```text
LAN Segment
```

when only the lab VMs need to communicate with each other.

### Authorized Physical-Network Assessment

Possible:

```text
Bridged
```

but only when that network access is explicitly required and authorized.

---

## 10. Check the Current Kali Interface

Inside Kali, run:

```bash
ip -brief address
```

Then review routes:

```bash
ip route
```

These commands show the current interface state and routing information.

Do not publish screenshots or command output containing private lab addresses
without reviewing and sanitizing them first.

---

## 11. Test Basic Connectivity

Test whether Kali has a default route:

```bash
ip route | grep default
```

Test DNS resolution:

```bash
getent hosts kali.org
```

When Internet access is expected, test HTTPS connectivity with:

```bash
curl -I https://www.kali.org/
```

A failed Internet test does not automatically mean VMware is broken.

Check the selected network mode, guest interface state, host connectivity,
DNS, VPN state, and firewall configuration before changing VMware settings.

---

## 12. Change a VM Network Mode

Shut down the Kali VM before making major virtual-hardware changes.

In VMware Workstation:

1. Select the VM.
2. Open **VM Settings**.
3. Select **Network Adapter**.
4. Choose the required network mode.
5. Confirm the change.
6. Start the VM.
7. Recheck the interface and route inside Kali.

Do not switch networking modes during a lab unless you understand how the
change affects scope and connectivity.

---

## 13. NAT and VPN-Based Labs

Many authorized platforms provide a VPN connection from Kali to a training
environment.

A common safe layout is:

```text
Kali VM
   |
VMware NAT
   |
Windows host
   |
Internet
   |
Authorized training VPN
```

The exact VPN route behavior depends on the training platform and VPN
configuration.

Always follow the platform's connection instructions and scope rules.

Do not assume that connecting to a training VPN authorizes testing anything
outside the assigned lab network.

---

## 14. Vulnerable Target VMs

Intentionally vulnerable systems require additional care.

Do not expose them unnecessarily to:

- Home networks
- School networks
- Workplace networks
- Public Wi-Fi
- The open Internet

Before powering on a deliberately vulnerable target, verify its virtual
network adapter configuration.

For most local practice labs, use host-only networking or a LAN segment.

---

## 15. Multiple Network Adapters

A VM can have more than one virtual network adapter.

Multiple adapters can accidentally create paths between networks that were
intended to remain separated.

For example, a target with both:

```text
NAT
```

and:

```text
Host-only
```

may no longer be meaningfully isolated from external connectivity.

Use only the adapters required by the lab design.

Remove or disconnect unnecessary adapters.

---

## 16. Shared Services and Host Exposure

Network isolation is only one part of VM isolation.

Also review:

- VMware shared folders
- Clipboard sharing
- Drag and drop
- Guest services
- Listening network services
- Host firewall rules
- Port forwarding
- USB passthrough

The workstation security baseline keeps unnecessary integration disabled by
default.

---

## 17. VMware Virtual Network Editor

VMware Workstation provides a Virtual Network Editor on supported
installations.

It can be used to review or configure virtual networks such as:

```text
VMnet1
VMnet8
```

Depending on the VMware installation and Windows permissions, administrative
rights may be required for some changes.

Do not modify virtual-network subnets, DHCP settings, or NAT behavior merely
to make a lab work.

First understand what the lab requires and preserve a known-good baseline.

---

## 18. Troubleshooting Order

If Kali loses expected connectivity, check in this order:

1. Confirm the VMware network adapter is connected.
2. Confirm the correct VMware network mode is selected.
3. Run `ip -brief address`.
4. Run `ip route`.
5. Check for a default route when Internet access is expected.
6. Test DNS with `getent hosts kali.org`.
7. Confirm the Windows host itself has connectivity.
8. Review VPN state.
9. Review host and guest firewall rules.
10. Review VMware virtual-network configuration.

Avoid changing several networking settings at once.

Make one controlled change, test it, and document the result.

---

## 19. Repository Safety

Do not place private network details in this public repository.

Sanitize material containing:

- Private IP addresses
- MAC addresses
- Internal hostnames
- VPN-assigned addresses
- Gateway addresses
- DNS server addresses
- Organization-specific network names
- Screenshots of private network configuration

Use generic examples in public documentation.

---

## 20. Networking Checklist

Before using Kali for a lab, verify:

- [ ] The required VMware network mode is understood
- [ ] NAT is used for the normal workstation baseline
- [ ] Vulnerable targets are not unnecessarily connected to NAT or bridged networks
- [ ] Host-only is used when the host needs access to an isolated lab
- [ ] LAN segments are considered for VM-only isolated labs
- [ ] Bridged mode is used only when specifically required and authorized
- [ ] Unnecessary virtual network adapters are disconnected
- [ ] Kali has the expected interface configuration
- [ ] Kali has only the routes required for the task
- [ ] VPN scope is understood before testing
- [ ] Private network information is sanitized before publication

The VMware networking baseline and lab-isolation guidance are now documented.

Previous:

[18 — Workspace Helpers](18-workspace-helpers.md)

Continue to:

[20 — Maintenance and Recovery](20-maintenance-and-recovery.md)
