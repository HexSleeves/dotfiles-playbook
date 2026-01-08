#!/usr/bin/env bash
#
# Dotfiles Bootstrap Script
# Automatically installs Ansible and runs the dotfiles playbook
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/yourusername/dotfiles-playbook/main/bootstrap.sh | bash
#
# Or for exe.dev VMs (minimal setup):
#   curl -fsSL https://raw.githubusercontent.com/yourusername/dotfiles-playbook/main/bootstrap.sh | bash -s -- --minimal
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PLAYBOOK_REPO="https://github.com/HexSleeves/dotfiles-playbook.git"
PLAYBOOK_DIR="$HOME/.dotfiles-playbook"
MINIMAL_SETUP=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --minimal)
            MINIMAL_SETUP=true
            shift
            ;;
        --repo)
            PLAYBOOK_REPO="$2"
            shift 2
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# Helper functions
print_step() {
    echo -e "${BLUE}==>${NC} ${GREEN}$1${NC}"
}

print_warning() {
    echo -e "${YELLOW}WARNING:${NC} $1"
}

print_error() {
    echo -e "${RED}ERROR:${NC} $1"
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ -f /etc/os-release ]]; then
        . /etc/os-release
        if [[ "$ID" == "ubuntu" ]] || [[ "$ID" == "debian" ]]; then
            echo "debian"
        elif [[ "$ID" == "fedora" ]] || [[ "$ID" == "rhel" ]] || [[ "$ID" == "centos" ]]; then
            echo "redhat"
        else
            echo "unknown"
        fi
    else
        echo "unknown"
    fi
}

# Install Ansible
install_ansible() {
    local os_type=$(detect_os)

    print_step "Detected OS: $os_type"

    case $os_type in
        macos)
            print_step "Installing Ansible via Homebrew..."
            if ! command -v brew &> /dev/null; then
                print_step "Installing Homebrew first..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

                # Add Homebrew to PATH for Apple Silicon
                if [[ $(uname -m) == "arm64" ]]; then
                    eval "$(/opt/homebrew/bin/brew shellenv)"
                fi
            fi
            brew install ansible
            ;;

        debian)
            print_step "Installing Ansible via APT..."
            sudo apt-get update
            sudo apt-get install -y software-properties-common
            sudo apt-get install -y ansible python3-pip
            ;;

        redhat)
            print_step "Installing Ansible via DNF..."
            sudo dnf install -y ansible python3-pip
            ;;

        *)
            print_error "Unsupported operating system"
            print_warning "Please install Ansible manually: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html"
            exit 1
            ;;
    esac
}

# Install Ansible Galaxy collections
install_collections() {
    print_step "Installing required Ansible Galaxy collections..."
    ansible-galaxy collection install community.general
}

# Clone or update playbook repository
setup_playbook() {
    if [[ -d "$PLAYBOOK_DIR" ]]; then
        print_step "Updating existing playbook repository..."
        cd "$PLAYBOOK_DIR"
        git pull
    else
        print_step "Cloning playbook repository..."
        git clone "$PLAYBOOK_REPO" "$PLAYBOOK_DIR"
        cd "$PLAYBOOK_DIR"
    fi
}

# Run the playbook
run_playbook() {
    local os_type
    os_type=$(detect_os)

    print_step "Running playbook..."

    local tags=""
    if [[ "$MINIMAL_SETUP" == true ]]; then
        print_step "Running minimal setup for VM environment..."
        tags="--tags exedev,minimal"
    else
        case $os_type in
            macos)
                tags="--tags macos"
                ;;
            debian|redhat)
                tags="--tags linux"
                ;;
        esac
    fi

    # Run the playbook
    cd "$PLAYBOOK_DIR"
    ansible-playbook site.yml "$tags" --ask-become-pass
}

# Main execution
main() {
    echo -e "${GREEN}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Dotfiles Bootstrap Script"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${NC}"

    # Check if Ansible is already installed
    if command -v ansible &> /dev/null; then
        print_step "Ansible is already installed ($(ansible --version | head -n1))"
    else
        install_ansible
    fi

    # Install required collections
    install_collections

    # Setup playbook
    setup_playbook

    # Run playbook
    run_playbook

    echo -e "${GREEN}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  ✓ Setup complete!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Reload your shell: source ~/.bashrc (or ~/.zshrc)"
    echo "  2. Update your dotfiles repository URL in ~/.dotfiles-playbook/site.yml"
    echo "  3. Re-run the playbook to sync your dotfiles: cd ~/.dotfiles-playbook && ansible-playbook site.yml"
    echo ""
}

# Run main function
main
