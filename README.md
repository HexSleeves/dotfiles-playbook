# Dotfiles Ansible Playbook

A comprehensive Ansible playbook for setting up dotfiles across multiple platforms:
- **macOS** (work environment with full tooling)
- **Linux Desktop** (personal environment with desktop applications)
- **exe.dev VMs** (minimal subset for quick development environments)

## 🚀 Quick Start (Bootstrap Scripts)

The easiest way to get started is using our bootstrap scripts. They automatically install Ansible and run the appropriate playbook for your system.

### exe.dev VMs (Minimal Setup)

One command to set up a new exe.dev VM:

```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/dotfiles-playbook/main/bootstrap-exedev.sh | bash
```

This installs essential CLI tools, development basics, and shell enhancements optimized for VMs.

### Local Machine (Full Setup)

For your macOS or Linux desktop:

```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/dotfiles-playbook/main/bootstrap-local.sh | bash
```

This performs the full installation with all development tools, GUI apps (macOS), and desktop applications (Linux).

### Universal Bootstrap (Advanced)

For more control, use the universal bootstrap script:

```bash
# Full setup (auto-detects platform)
curl -fsSL https://raw.githubusercontent.com/yourusername/dotfiles-playbook/main/bootstrap.sh | bash

# Minimal setup (for any VM)
curl -fsSL https://raw.githubusercontent.com/yourusername/dotfiles-playbook/main/bootstrap.sh | bash -s -- --minimal

# Custom repository
curl -fsSL https://raw.githubusercontent.com/yourusername/dotfiles-playbook/main/bootstrap.sh | bash -s -- --repo https://github.com/custom/repo.git
```

### What the Bootstrap Scripts Do

1. **Detect your OS** (macOS, Debian/Ubuntu, Fedora/RHEL)
2. **Install Ansible** and required dependencies
3. **Install Ansible Galaxy collections** (community.general)
4. **Clone the playbook** to `~/.dotfiles-playbook`
5. **Run the appropriate playbook** for your platform
6. **Configure your environment** with all the tools and settings

### 📝 Before You Run

**Important:** The bootstrap scripts reference `https://github.com/yourusername/dotfiles-playbook.git`. You need to:

1. **Fork/clone this repository** to your own GitHub account
2. **Update the repository URLs** in the bootstrap scripts:
   - `bootstrap.sh` → Update `PLAYBOOK_REPO` variable
   - `bootstrap-local.sh` → Update the git clone URL
   - `bootstrap-exedev.sh` → Update the git clone URL
3. **Update your dotfiles repo** in `site.yml`:
   - Change `dotfiles_repo` variable to your actual dotfiles repository

Or use the `--repo` flag with the universal bootstrap script to specify your repository URL.

---

## 📖 Manual Installation

If you prefer to install manually or need more control, follow these steps:

## Prerequisites

### All Platforms
- Python 3.x installed
- Ansible installed (`pip install ansible` or `brew install ansible`)

### For Remote Hosts
- SSH access configured
- User with sudo privileges

## Installation

### 1. Install Ansible

**macOS:**
```bash
brew install ansible
```

**Linux (Debian/Ubuntu):**
```bash
sudo apt update
sudo apt install ansible python3-pip
pip3 install ansible
```

**Linux (Fedora/RHEL):**
```bash
sudo dnf install ansible python3-pip
pip3 install ansible
```

### 2. Install Required Ansible Collections

```bash
ansible-galaxy collection install community.general
```

### 3. Clone This Repository

```bash
git clone <your-repo-url> ~/dotfiles-playbook
cd ~/dotfiles-playbook
```

## Configuration

### 1. Update Inventory File

Edit `inventory.yml` to add your hosts:

```yaml
all:
  children:
    macos:
      hosts:
        localhost:
          ansible_connection: local
          environment_type: work

    linux:
      hosts:
        my-linux-desktop:
          ansible_host: 192.168.1.100
          ansible_user: myuser
          environment_type: personal

    exedev:
      hosts:
        my-vm:
          ansible_host: my-vm.myuser.exe.dev
          ansible_user: ubuntu
          environment_type: vm
```

### 2. Update Variables

Edit `group_vars/all.yml` to set your Git configuration:

```yaml
git_user_name: "Your Name"
git_user_email: "your.email@example.com"
```

### 3. Set Your Dotfiles Repository

Edit `site.yml` and update the `dotfiles_repo` variable:

```yaml
vars:
  dotfiles_repo: "https://github.com/yourusername/dotfiles.git"
```

## Usage

### Run on Local Machine (macOS)

```bash
ansible-playbook site.yml --tags macos
```

### Run on Local Machine (Linux)

```bash
ansible-playbook site.yml --tags linux
```

### Run on exe.dev VM

```bash
# First, make sure you can SSH to your VM
ssh ubuntu@my-vm.myuser.exe.dev

# Then run the playbook
ansible-playbook site.yml --limit exedev
```

### Run on Specific Host

```bash
ansible-playbook site.yml --limit hostname
```

### Run Specific Tasks with Tags

```bash
# Common tasks only
ansible-playbook site.yml --tags common

# macOS only
ansible-playbook site.yml --tags macos

# Linux desktop only
ansible-playbook site.yml --tags linux,desktop

# exe.dev minimal only
ansible-playbook site.yml --tags exedev,minimal
```

### Dry Run (Check Mode)

```bash
ansible-playbook site.yml --check
```

### Syntax Check

```bash
ansible-playbook site.yml --syntax-check
```

## What Gets Installed

### macOS (Work Environment)

**Homebrew Packages:**
- Modern CLI tools: `bat`, `eza`, `fd`, `ripgrep`, `fzf`, `delta`, `jq`, `yq`, `gh`, `lazygit`
- Development tools: `node`, `python`, `go`, `rust`, `docker`, `kubectl`, `helm`, `terraform`
- Databases: `postgresql`, `redis`, `sqlite`
- Utilities: `neovim`, `tmux`, `zsh`, `starship`, `direnv`

**GUI Applications (Casks):**
- `visual-studio-code`, `iterm2`, `docker`, `postman`, `slack`, `notion`, `rectangle`, `stats`

**System Preferences:**
- Dock autohide enabled
- Show all file extensions
- Show path bar in Finder

### Linux Desktop (Personal Environment)

**Packages:**
- Modern CLI tools: `bat`, `fd-find`, `ripgrep`, `fzf`, `jq`
- Development tools: Full build toolchain, Git, Node.js, Python, Go
- Desktop applications: Firefox, Chromium, VLC, GIMP, Terminator
- System utilities: `htop`, `iotop`, `ncdu`, `tree`

**Snap Packages:**
- VS Code, Postman, Slack (if Snap is available)

**Additional Tools:**
- Rust toolchain via rustup
- Node.js via nvm
- Starship prompt
- fzf fuzzy finder

### exe.dev VMs (Minimal Setup)

**Essential Packages:**
- Core tools: `git`, `curl`, `wget`, `vim`, `tmux`, `htop`
- Modern CLI: `ripgrep`, `fzf`, `jq`, `bat`
- Development: `build-essential`, `python3`, `nodejs`
- Shell: `zsh`, `starship` (minimal config)

**Features:**
- Lightweight Starship prompt configuration
- Bash aliases for modern tools
- Essential Git configuration
- fzf key bindings

## File Structure

```
dotfiles-playbook/
├── ansible.cfg                 # Ansible configuration
├── inventory.yml               # Host inventory
├── site.yml                    # Main playbook
├── bootstrap.sh                # Universal bootstrap script
├── bootstrap-local.sh          # Local machine bootstrap
├── bootstrap-exedev.sh         # exe.dev VM bootstrap
├── group_vars/
│   ├── all.yml                 # Common variables
│   ├── macos.yml               # macOS-specific variables
│   ├── linux.yml               # Linux-specific variables
│   └── exedev.yml              # exe.dev VM variables
├── tasks/
│   ├── common.yml              # Common tasks for all platforms
│   ├── macos.yml               # macOS-specific tasks
│   ├── linux.yml               # Linux desktop tasks
│   └── exedev-minimal.yml      # Minimal setup for exe.dev VMs
└── README.md                   # This file
```

## Customization

### Adding More Homebrew Packages (macOS)

Edit `group_vars/macos.yml`:

```yaml
homebrew_packages:
  - your-package-name
```

### Adding More APT Packages (Linux)

Edit `group_vars/linux.yml`:

```yaml
apt_packages:
  - your-package-name
```

### Adding More Tools to exe.dev VMs

Edit `group_vars/exedev.yml`:

```yaml
minimal_packages:
  - your-minimal-tool
```

### Linking Additional Dotfiles

Edit the appropriate task file and add:

```yaml
- name: Link dotfiles (your-file)
  ansible.builtin.file:
    src: "{{ dotfiles_dest }}/.your-file"
    dest: "{{ ansible_env.HOME }}/.your-file"
    state: link
    force: yes
  when: dotfiles_dir.stat.exists
  ignore_errors: yes
```

## Troubleshooting

### Homebrew Installation Fails (macOS)

If Homebrew installation hangs, manually install it first:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Permission Denied Errors

Make sure your user has sudo privileges. You may need to run with `--ask-become-pass`:

```bash
ansible-playbook site.yml --ask-become-pass
```

### SSH Connection Issues (Remote Hosts)

Test SSH connection first:

```bash
ssh user@hostname
```

Make sure your SSH key is added to the remote host's `~/.ssh/authorized_keys`.

### exe.dev VM Connection

Make sure you can SSH to your exe.dev VM:

```bash
ssh ubuntu@your-vm.your-username.exe.dev
```

If you need to set up SSH keys, copy your public key:

```bash
ssh-copy-id ubuntu@your-vm.your-username.exe.dev
```

## Platform-Specific Notes

### macOS
- Requires Xcode Command Line Tools: `xcode-select --install`
- Some Homebrew casks may require manual approval in System Preferences
- macOS defaults changes may require logout/login to take effect

### Linux
- Different distributions use different package managers (APT vs DNF)
- Some packages may have different names across distributions
- Desktop environment tools are tailored for GNOME/Ubuntu

### exe.dev VMs
- Minimal setup is optimized for Ubuntu-based VMs
- Focuses on CLI tools and development essentials
- No GUI applications installed
- Lightweight configuration for quick provisioning

## Advanced Usage

### Running Against Multiple Hosts

```bash
ansible-playbook site.yml --limit 'macos:linux'
```

### Verbose Output

```bash
ansible-playbook site.yml -v    # verbose
ansible-playbook site.yml -vv   # more verbose
ansible-playbook site.yml -vvv  # very verbose
```

### Running Specific Tasks

```bash
ansible-playbook site.yml --start-at-task="Install Homebrew packages"
```

## Contributing

Feel free to customize this playbook for your needs. Common customizations:

1. Add your favorite tools to the package lists
2. Create additional task files for specific software
3. Add more macOS defaults settings
4. Create role-based organization for complex setups

## License

MIT License - feel free to use and modify as needed.

## Resources

- [Ansible Documentation](https://docs.ansible.com/)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- [exe.dev Documentation](https://exe.dev/docs)
- [Homebrew](https://brew.sh/)
- [Starship Prompt](https://starship.rs/)
