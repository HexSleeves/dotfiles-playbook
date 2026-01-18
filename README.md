# Dotfiles Ansible Playbook

A powerful, idempotent Ansible playbook designed to bootstrap and configure your development environment across **macOS**, **Linux Desktop**, and **minimal Cloud VMs** (like exe.dev).

## 🎯 What it does

This playbook automates the installation and configuration of your entire developer toolchain:

- **Bootstraps the system**: OS packages and safe baseline configuration.
- **Installs core developer tooling**: `mise`, `bun`, and supporting utilities.
- **Applies dotfiles via chezmoi**: Ansible installs and drives `chezmoi` (dotfile logic should live in your chezmoi repo).

## 🚀 One-Line Installation

We provide a universal bootstrap script that detects your operating system and applies the appropriate configuration.

### Standard Setup (macOS & Linux Desktop)

This will install Ansible, clone this repo, and run the full desktop playbook.

```bash
curl -fsSL https://raw.githubusercontent.com/HexSleeves/dotfiles-playbook/main/bootstrap.sh | bash
```

### Minimal Setup (Cloud VMs / exe.dev)

For a lightweight setup (skips GUI apps and heavy tools), use the `--minimal` flag:

```bash
curl -fsSL https://raw.githubusercontent.com/HexSleeves/dotfiles-playbook/main/bootstrap.sh | bash -s -- --minimal
```

### Custom Repository

If you have forked this repository, you can point the bootstrapper to your fork:

```bash
curl -fsSL https://raw.githubusercontent.com/HexSleeves/dotfiles-playbook/main/bootstrap.sh | bash -s -- --repo https://github.com/YOUR_USERNAME/dotfiles-playbook.git
```

## 🛠 Manual Installation

If you prefer to run things yourself:

1. **Install Ansible**:
   - macOS: `brew install ansible`
   - Ubuntu/Debian: `sudo apt update && sudo apt install ansible`
   - Fedora: `sudo dnf install ansible`

2. **Clone the repo**:

   ```bash
   git clone https://github.com/HexSleeves/dotfiles-playbook.git ~/.dotfiles-playbook
   cd ~/.dotfiles-playbook
   ```

3. **Install dependencies**:

   ```bash
   ansible-galaxy collection install community.general
   ```

4. **Run the playbook**:

   ```bash
   # Full setup (bootstrap + tooling + dotfiles if `chezmoi_repo` is configured)
   ansible-playbook site.yml --ask-become-pass

   # Selective runs
   ansible-playbook playbooks/bootstrap.yml --ask-become-pass
   ansible-playbook playbooks/tooling.yml
   ansible-playbook playbooks/dotfiles.yml

   # VM/minimal profile
   ansible-playbook site.yml --ask-become-pass -e os_linux_machine_profile=vm
   ```

## 📂 Structure

- `bootstrap.sh`: The universal entry point.
- `site.yml`: Back-compat entrypoint (imports `playbooks/site.yml`).
- `playbooks/`: Composable entrypoints (`bootstrap.yml`, `tooling.yml`, `dotfiles.yml`).
- `roles/`: Reusable modules (OS, tooling, chezmoi).
- `inventories/home/`: Default inventory + per-machine overrides.

## 📝 Configuration

You can customize the setup by modifying variables in `inventories/home/`:

- `inventories/home/group_vars/all.yml`: shared defaults (set `git_user_name`, `git_user_email`, `chezmoi_repo`).
- `inventories/home/host_vars/*.yml`: per-machine overrides (recommended).
