# Install and Verify Core Kali Tools

This step installs and verifies the small set of core tools used throughout
this repository.

The setup script installs only packages that are missing.

It does not add third-party repositories or remove existing packages.

---

## 1. Core Tool Setup Script

From the root of this repository inside Kali, run:

```bash
chmod +x scripts/kali/Install-CoreTools.sh
```

Then run:

```bash
./scripts/kali/Install-CoreTools.sh
```

Enter your Kali password if `sudo` prompts for it.

The script will first run:

```bash
sudo apt update
```

and then review the required packages.

---

## 2. What the Script Checks

The core package set includes:

```text
git
curl
wget
jq
python3
python3-venv
pipx
tmux
tree
unzip
7zip
build-essential
nmap
netcat-traditional
socat
tcpdump
tshark
wireshark
```

These packages provide the basic command-line, scripting, development,
networking, packet-analysis, and troubleshooting capabilities used by later
sections of this repository.

---

## 3. Existing Packages Are Preserved

If a required package is already installed, the script leaves it in place.

If a package is missing, the script checks whether an installation candidate
is available from the configured Kali repositories.

Only missing packages are offered for installation.

The script does not blindly reinstall the entire toolset every time it runs.

---

## 4. Installing Missing Packages

If one or more required packages are missing, the script displays them and
asks:

```text
Install the missing packages now? [y/N]:
```

To continue, type:

```text
y
```

and press **Enter**.

To cancel, press **Enter** or type:

```text
n
```

The script will not install the missing packages unless you approve the
installation.

---

## 5. Command Verification

After package review or installation, the script verifies that the expected
commands are available.

Examples include:

```text
git
python3
pipx
tmux
nmap
nc
socat
tcpdump
tshark
wireshark
```

It also verifies Python virtual-environment support with:

```bash
python3 -m venv --help
```

---

## 6. Kali Metapackages

The script reports whether these common Kali metapackages are present:

```text
kali-linux-default
kali-tools-top10
```

They are reported for awareness only.

The script does not force either metapackage to be installed.

Later sections will add focused tooling for CTF, web security, networking,
Active Directory, and blue-team or DFIR work.

---

## 7. Package Naming

Package names can change over time in a rolling distribution.

For the Kali baseline tested while building this repository:

```text
7z command -> 7zip package
nc command -> netcat-traditional package
```

The setup script still checks the currently configured Kali repositories
before attempting to install a missing package.

---

## 8. Successful Result

A successful run ends with:

```text
Overall Result: CORE TOOLS VERIFIED
```

and returns exit code:

```text
0
```

You can check the exit code immediately after the script finishes:

```bash
echo $?
```

---

## 9. Stop If the Script Fails

If the script reports:

```text
Overall Result: CORE TOOL SETUP NEEDS ATTENTION
```

do not continue to the next setup phase yet.

Review the failed package or command first.

Do not add random third-party repositories simply to make a missing package
install.

---

## 10. Core Tool Checklist

Before continuing, verify:

- [ ] `sudo apt update` completed successfully
- [ ] Required packages are installed
- [ ] Required commands are available
- [ ] Python virtual-environment support works
- [ ] No third-party APT repository was added by the script
- [ ] The script finished with `FAIL : 0`
- [ ] The script returned exit code `0`

The next phase adds focused cybersecurity tool profiles without installing
every Kali package available.
