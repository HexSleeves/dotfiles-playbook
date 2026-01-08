#!/usr/bin/env bash
#
# Local Machine Bootstrap
# Full setup for macOS or Linux desktop
#
# Usage:
#   ./bootstrap-local.sh
#
# Or download and run:
#   curl -fsSL https://raw.githubusercontent.com/yourusername/dotfiles-playbook/main/bootstrap-local.sh | bash
#

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Dotfiles Local Setup${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    TAGS="--tags macos"
elif [[ -f /etc/os-release ]]; then
    . /etc/os-release
    if [[ "$ID" == "ubuntu" ]] || [[ "$ID" == "debian" ]]; then
        OS="linux"
        TAGS="--tags linux"
    elif [[ "$ID" == "fedora" ]] || [[ "$ID" == "rhel" ]]; then
        OS="linux"
        TAGS="--tags linux"
    fi
fi

echo -e "${BLUE}==>${NC} Detected OS: $OS"
echo ""

# Install Ansible
if ! command -v ansible &> /dev/null; then
    echo -e "${BLUE}==>${NC} Installing Ansible..."

    if [[ "$OS" == "macos" ]]; then
        # Install Homebrew if needed
        if ! command -v brew &> /dev/null; then
            echo -e "${BLUE}==>${NC} Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

            # Add to PATH for Apple Silicon
            if [[ $(uname -m) == "arm64" ]]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
            fi
        fi
        brew install ansible
    else
        # Linux
        sudo apt-get update
        sudo apt-get install -y ansible python3-pip git
    fi
else
    echo -e "${BLUE}==>${NC} Ansible already installed"
fi

# Install collections
echo -e "${BLUE}==>${NC} Installing Ansible collections..."
ansible-galaxy collection install community.general

# Setup playbook directory
PLAYBOOK_DIR="$HOME/.dotfiles-playbook"
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# If we're already in the playbook directory, use it
if [[ "$CURRENT_DIR" == *"dotfiles-playbook"* ]] && [[ -f "$CURRENT_DIR/site.yml" ]]; then
    PLAYBOOK_DIR="$CURRENT_DIR"
    echo -e "${BLUE}==>${NC} Using current directory as playbook"
else
    # Clone or update
    if [[ -d "$PLAYBOOK_DIR" ]]; then
        echo -e "${BLUE}==>${NC} Updating playbook..."
        cd "$PLAYBOOK_DIR" && git pull
    else
        echo -e "${BLUE}==>${NC} Cloning playbook..."
        git clone https://github.com/yourusername/dotfiles-playbook.git "$PLAYBOOK_DIR"
    fi
fi

# Run playbook
echo ""
echo -e "${YELLOW}Note: Some tasks may require sudo password${NC}"
echo ""
echo -e "${BLUE}==>${NC} Running playbook..."
cd "$PLAYBOOK_DIR"
ansible-playbook site.yml $TAGS

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  ✓ Setup complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Next steps:"
echo "  1. Reload your shell: source ~/.zshrc (or ~/.bashrc)"
echo "  2. Review installed tools and configurations"
echo "  3. Customize $PLAYBOOK_DIR/group_vars/ as needed"
echo ""
