# Development Environment

This step configures and verifies the development tooling used by the Kali
workstation.

The goal is to provide a reliable environment for scripting, Git-based
projects, CTF work, automation, and repository validation without replacing
Kali's system Python or overwriting an existing Git identity.

---

## 1. Run the Development Environment Script

From the root of this repository inside Kali, run:

```bash
chmod +x scripts/kali/Configure-DevelopmentEnvironment.sh
```

Then run:

```bash
./scripts/kali/Configure-DevelopmentEnvironment.sh
```

Enter your Kali password if `sudo` prompts for it.

The script checks the workstation first and installs only missing packages.

---

## 2. Included Development Tools

The profile verifies these packages and commands:

```text
python3
python3-pip
python3-venv
pipx
git
zsh
tmux
nano
vim
build-essential
cmake
shellcheck
```

It also verifies commonly used utilities already included in the broader
workstation build:

```text
curl
wget
jq
tree
```

---

## 3. Python

Kali uses Python extensively, so the system Python environment should be kept
clean.

The workstation verifies:

```bash
python3 --version
python3 -m pip --version
python3 -m venv --help
pipx --version
```

For project-specific Python dependencies, prefer a virtual environment.

Example:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

Install project dependencies only after the environment is active.

To leave the environment:

```bash
deactivate
```

---

## 4. pipx

Use `pipx` for standalone Python applications that should remain isolated from
Kali's system Python.

For example, this workstation installs Volatility 3 through `pipx` when it is
not available from the configured Kali APT repositories.

List pipx-managed applications with:

```bash
pipx list
```

Avoid:

```bash
sudo pip install <package>
```

for normal workstation setup.

---

## 5. Git Identity

The configuration script preserves an existing global Git identity.

Review it with:

```bash
git config --global user.name
git config --global user.email
```

The script does not replace either value when they already exist.

If a beginner has not configured an identity yet, Git may require one before
the first commit.

Example format:

```bash
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"
```

Use the identity appropriate for the Git hosting account or organization.

---

## 6. Default Git Branch

When `init.defaultBranch` is not already configured, the workstation sets it
to:

```text
main
```

Verify with:

```bash
git config --global init.defaultBranch
```

Expected output:

```text
main
```

If a user already has a different value configured, the script preserves it.

---

## 7. Zsh and Bash

Kali commonly uses Zsh as the interactive shell.

Check the current shell with:

```bash
echo "$SHELL"
```

Check Zsh with:

```bash
zsh --version
```

Check Bash with:

```bash
bash --version
```

The setup script does not forcibly change the user's login shell.

Bash remains important because the automation scripts in this repository use:

```text
#!/usr/bin/env bash
```

---

## 8. tmux

`tmux` provides persistent terminal sessions and multiple panes inside one
terminal.

Verify it with:

```bash
tmux -V
```

Start a session with:

```bash
tmux
```

Detach from the session with:

```text
Ctrl+B
D
```

List sessions with:

```bash
tmux ls
```

Reconnect with:

```bash
tmux attach
```

---

## 9. Terminal Editors

The focused workstation keeps both:

```text
nano
vim
```

These are sufficient for local terminal editing.

Neovim is not required by this repository.

VS Code is also not required inside the Kali VM. A user may keep VS Code on
the Windows host and use the repository there while running and validating
Kali-specific scripts inside the VM.

---

## 10. Build Tools

The profile includes:

```text
gcc
make
cmake
```

These support source builds and development exercises when a project requires
them.

Check them with:

```bash
gcc --version
make --version
cmake --version
```

Do not compile or execute untrusted source code merely because a project
includes build instructions.

---

## 11. ShellCheck

The profile installs:

```text
shellcheck
```

ShellCheck performs static analysis on shell scripts and can identify common
Bash mistakes before runtime.

Check one script with:

```bash
shellcheck scripts/kali/Update-Kali.sh
```

Later repository validation will use ShellCheck across the applicable Bash
scripts.

A clean ShellCheck result is useful, but it does not replace runtime testing.

---

## 12. Safe Development Practices

For this workstation:

- Use `venv` for Python project dependencies.
- Use `pipx` for isolated Python applications.
- Avoid modifying Kali's system Python with `sudo pip`.
- Preserve existing Git identity settings.
- Keep credentials and tokens out of source files.
- Do not commit private keys or VPN profiles.
- Review scripts before executing them.
- Use ShellCheck and syntax checks before publishing Bash scripts.
- Test security tooling only in authorized environments.

---

## 13. Successful Result

A successful configuration run ends with:

```text
Overall Result: DEVELOPMENT ENVIRONMENT VERIFIED
```

Check the exit code with:

```bash
echo $?
```

Expected result:

```text
0
```

Running the script a second time should recognize the existing configuration
and avoid reinstalling packages unnecessarily.

---

## 14. Development Environment Checklist

Before continuing, verify:

- [ ] Python 3 is available
- [ ] `python3 -m pip` is available
- [ ] Python virtual environments are supported
- [ ] pipx is available
- [ ] Git is available
- [ ] Existing Git identity values are preserved
- [ ] New Git repositories default to `main`
- [ ] Zsh is available
- [ ] Bash is available
- [ ] tmux is available
- [ ] Nano is available
- [ ] Vim is available
- [ ] GCC and Make are available
- [ ] CMake is available
- [ ] ShellCheck is available
- [ ] The script completed with `FAIL : 0`
- [ ] The script returned exit code `0`
- [ ] A second run completes without reinstalling existing packages

The next phase will build reusable workspace helpers for CTF and forensic
projects.
