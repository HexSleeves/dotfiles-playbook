#!/usr/bin/env bash
#
# exe.dev VM Quick Bootstrap
# Minimal setup optimized for exe.dev virtual machines
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/yourusername/dotfiles-playbook/main/bootstrap-exedev.sh | bash
#

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  exe.dev VM Quick Setup${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Install Ansible
if ! command -v ansible &> /dev/null; then
    echo -e "${BLUE}==>${NC} Installing Ansible..."
    sudo apt-get update -qq
    sudo apt-get install -y ansible python3-pip git curl
else
    echo -e "${BLUE}==>${NC} Ansible already installed"
fi

# Install required collections
echo -e "${BLUE}==>${NC} Installing Ansible collections..."
ansible-galaxy collection install community.general

# Clone playbook
PLAYBOOK_DIR="$HOME/.dotfiles-playbook"
PLAYBOOK_REPO="https://github.com/HexSleeves/dotfiles-playbook.git"

if [[ -d "$PLAYBOOK_DIR" ]]; then
    echo -e "${BLUE}==>${NC} Updating playbook..."
    cd "$PLAYBOOK_DIR" && git pull
else
    echo -e "${BLUE}==>${NC} Cloning playbook..."
    git clone "$PLAYBOOK_REPO" "$PLAYBOOK_DIR"
fi

# Run minimal setup
echo -e "${BLUE}==>${NC} Running minimal setup..."
cd "$PLAYBOOK_DIR"
ansible-playbook site.yml --ask-become-pass -e "os_linux_machine_profile=vm"

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  ✓ Setup complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Reload your shell: source ~/.bashrc"
echo ""
