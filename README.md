# Dotfiles Ansible Playbook

A powerful, idempotent Ansible playbook designed to bootstrap and configure your development environment across **macOS**, **Linux Desktop**, and **minimal Cloud VMs** (like exe.dev).

## 🎯 What it does

This playbook automates the installation and configuration of your entire developer toolchain:

- **macOS Workstation**: Complete setup including Homebrew packages, GUI applications (VS Code, iTerm2, etc.), and macOS system preferences (Dock, Finder).
- **Linux Desktop**: Personal environment setup with standard CLI tools, development runtimes, and desktop applications.
- **Cloud/Dev VMs**: A lightweight, minimal configuration focused on core CLI tools (git, tmux, zsh, starship) optimized for remote development.

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
   # Auto-detect tags based on OS
   ansible-playbook site.yml --ask-become-pass

   # OR run specific tags
   ansible-playbook site.yml --tags macos
   ansible-playbook site.yml --tags linux,desktop
   ansible-playbook site.yml --tags exedev,minimal
   ```

## 📂 Structure

- `bootstrap.sh`: The universal entry point.
- `site.yml`: Main playbook file.
- `inventory.yml`: Defines localhost and other environments.
- `tasks/`:
  - `common.yml`: Shared tools (git, zsh, starship).
  - `macos.yml`: Brew Casks, Mac-specific settings.
  - `linux.yml`: Apt/Dnf packages for desktop.
  - `exedev-minimal.yml`: Light setup for VMs.

## 📝 Configuration

You can customize the setup by modifying variables in `group_vars/`:

- `all.yml`: Git user/email, common packages.
- `macos.yml`: List of Homebrew packages and Casks.
- `exedev.yml`: Minimal package list.