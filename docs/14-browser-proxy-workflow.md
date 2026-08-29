# Browser and Interception Proxy Workflow

This step creates a dedicated Firefox lab profile and configures a simple
workflow for Burp Suite and Caido.

Use this browser profile only for authorized cybersecurity labs and testing.

---

## 1. Create a Dedicated Firefox Lab Profile

Open a Kali terminal and run:

```bash
firefox-esr -P
```

Firefox Profile Manager should open.

Select:

```text
Create Profile
```

Name the profile:

```text
CyberLab
```

Finish creating the profile and launch Firefox with `CyberLab`.

Do not sign in to a personal Firefox account in this profile.

---

## 2. Keep Lab Browsing Separate

Use `CyberLab` for:

- Burp Suite
- Caido
- Authorized web labs
- CTF web challenges
- Local training applications

Do not use this profile for personal email, banking, social media, or other
sensitive personal browsing.

---

## 3. Verify the Proxy Listener

Start the proxy you intend to use.

For Burp Suite:

```bash
burpsuite
```

For Caido:

```bash
caido
```

A common local listener is:

```text
127.0.0.1:8080
```

The exact port can differ.

Verify the listener address and port inside Burp or Caido before configuring
Firefox.

Do not run both applications on the same listener port at the same time.

---

## 4. Configure Firefox

Inside the `CyberLab` Firefox profile, open:

```text
Settings
```

Search for:

```text
Network Settings
```

Select:

```text
Settings...
```

Choose:

```text
Manual proxy configuration
```

Enter the address and port used by your proxy.

Example:

```text
HTTP Proxy: 127.0.0.1
Port: 8080
```

Use the same proxy for HTTPS when the Firefox option is available.

Save the settings.

---

## 5. Test the Connection

With Burp or Caido running, browse to an authorized lab or harmless test page.

Confirm the request appears inside the proxy.

If the page does not load:

1. Confirm the proxy is running.
2. Confirm the Firefox proxy address.
3. Confirm the Firefox proxy port.
4. Confirm the proxy listener uses the same address and port.
5. Check whether an intercepted request is waiting for you to forward it.

Do not disable unrelated security controls to fix a proxy problem.

---

## 6. HTTPS Certificate Trust

HTTPS interception requires Firefox to trust the certificate authority used by
the selected proxy.

Import proxy CA certificates only into the dedicated `CyberLab` profile.

Do not add lab proxy certificates to the Windows host's global trusted
certificate store.

---

## 7. Burp Suite Certificate

Start Burp Suite and make sure its proxy listener is active.

Using the proxied `CyberLab` profile, browse to:

```text
http://burp
```

Download Burp's CA certificate.

In Firefox, open:

```text
Settings
> Privacy & Security
> Certificates
> View Certificates
> Authorities
```

Import the Burp CA certificate and trust it for identifying websites when
required for the lab workflow.

---

## 8. Caido Certificate

Start Caido and make sure its proxy listener is active.

Use Caido's certificate download or installation workflow for the installed
version.

Import the Caido CA certificate into:

```text
CyberLab
```

through Firefox's:

```text
Settings
> Privacy & Security
> Certificates
> View Certificates
> Authorities
```

Keep the certificate limited to the lab browser profile.

---

## 9. Optional Proxy-Switching Extension

A proxy-switching extension such as FoxyProxy can make switching proxy settings
more convenient.

It is optional.

A beginner can complete this repository using Firefox's built-in manual proxy
settings.

If you install an extension, obtain it from the official Firefox add-ons
source and review the permissions it requests.

---

## 10. Turn the Proxy Off After the Lab

When finished, return to:

```text
Settings
> Network Settings
> Settings...
```

Select:

```text
No proxy
```

or restore the normal setting that was used before the lab.

Close Burp Suite or Caido when it is no longer needed.

---

## 11. Browser and Proxy Checklist

Before continuing, verify:

- [ ] The `CyberLab` Firefox profile exists
- [ ] The lab profile contains no personal accounts
- [ ] Burp Suite starts successfully
- [ ] Caido starts successfully
- [ ] Firefox can use the selected local proxy
- [ ] Test traffic appears inside the selected proxy
- [ ] Only one application uses a specific listener port at a time
- [ ] HTTPS interception works after importing the required proxy CA
- [ ] Proxy certificates remain limited to the lab browser profile
- [ ] Personal browsing remains outside the proxied profile

The next phase will inventory networking and Active Directory tools used for
authorized labs and CTF environments.
