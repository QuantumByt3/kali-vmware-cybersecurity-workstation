# Focused Web Security Tool Profile

This step installs and verifies the web-security tools used throughout this
Kali workstation.

The profile is intentionally focused. It provides the tools needed for common
authorized web-application labs without forcing every web-security package
available in Kali.

---

## 1. Run the Web Tool Profile

From the root of this repository inside Kali, run:

```bash
chmod +x scripts/kali/profiles/Install-WebTools.sh
```

Then run:

```bash
./scripts/kali/profiles/Install-WebTools.sh
```

Enter your Kali password if `sudo` prompts for it.

The script refreshes package information and checks which required packages
are already installed.

---

## 2. Required Web-Security Tools

The focused profile verifies:

```text
Burp Suite
Caido
Firefox ESR
Chromium
ProjectDiscovery HTTPX
Nuclei
FFUF
Gobuster
Feroxbuster
Dirsearch
Nikto
WhatWeb
SQLMap
```

The script installs only packages that are missing.

---

## 3. Interception Proxies

The workstation includes:

```text
Burp Suite
Caido
```

Both can be used as interception proxies for authorized web-application
testing.

You do not need to run both at the same time.

Choose the proxy that best fits the lab or workflow you are performing.

---

## 4. OWASP ZAP

OWASP ZAP is treated as an optional additional proxy.

The profile checks whether:

```text
zaproxy
```

is available from the configured Kali repositories.

It does not force ZAP onto every beginner workstation because Burp Suite and
Caido already provide the primary interception-proxy workflow for this build.

If you specifically want ZAP, install it with:

```bash
sudo apt install zaproxy
```

Do not add a third-party repository to install it.

---

## 5. Browsers

The focused profile verifies:

```text
firefox-esr
chromium
```

Firefox ESR will be the primary lab browser used by this repository.

Chromium is retained as a useful secondary browser for compatibility testing
and troubleshooting.

Do not use a browser profile containing personal accounts, saved passwords, or
personal browsing data for interception-proxy labs.

---

## 6. ProjectDiscovery HTTPX

Kali provides the ProjectDiscovery HTTPX tool with the command:

```text
httpx-toolkit
```

Use:

```bash
httpx-toolkit
```

for the web-reconnaissance tool used in security workflows.

Do not assume that:

```bash
httpx
```

is the same program.

On Kali, `/usr/bin/httpx` may belong to the separate `python3-httpx` package.

The profile intentionally checks `httpx-toolkit` by name to avoid this
confusion.

---

## 7. Web Discovery and Enumeration

The profile verifies:

```text
ffuf
gobuster
feroxbuster
dirsearch
nikto
whatweb
```

These tools support tasks such as:

- Content discovery
- Directory and file enumeration
- Technology identification
- Basic web-server assessment
- Authorized application reconnaissance

Use them only within the scope of the lab or system you are authorized to
test.

---

## 8. Nuclei

The profile verifies:

```text
nuclei
```

Nuclei is a template-driven scanner.

Before using Nuclei against a target, confirm that automated scanning is
permitted by the lab, platform, or testing authorization.

Do not assume that permission to browse a site automatically includes
permission for automated scanning.

---

## 9. SQLMap

The profile verifies:

```text
sqlmap
```

SQLMap can automate database-injection testing.

Use it only when the application and testing scope explicitly permit this type
of activity.

Do not use automated exploitation against systems outside your authorization.

---

## 10. Browser Proxy Configuration

Browser proxy configuration is intentionally performed manually.

A later step will configure a dedicated lab browser profile and proxy helper.

This keeps:

- Personal browsing separate from lab traffic
- Proxy certificates limited to the lab browser
- Proxy settings easy to enable and disable
- Beginner troubleshooting more predictable

Do not import interception-proxy certificates into the Windows host's global
trusted certificate store for this workstation build.

---

## 11. Successful Result

A successful profile run ends with:

```text
Overall Result: WEB TOOL PROFILE VERIFIED
```

Check the exit code immediately afterward:

```bash
echo $?
```

Expected result:

```text
0
```

---

## 12. Web Tool Checklist

Before continuing, verify:

- [ ] Burp Suite is available
- [ ] Caido is available
- [ ] Firefox ESR is available
- [ ] Chromium is available
- [ ] `httpx-toolkit` is available
- [ ] Nuclei is available
- [ ] FFUF is available
- [ ] Gobuster is available
- [ ] Feroxbuster is available
- [ ] Dirsearch is available
- [ ] Nikto is available
- [ ] WhatWeb is available
- [ ] SQLMap is available
- [ ] The profile completed with `FAIL : 0`
- [ ] The profile returned exit code `0`

The next step will configure the dedicated browser and interception-proxy
workflow for authorized web-security labs.
