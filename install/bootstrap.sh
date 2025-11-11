#!/bin/bash

# Bootstrap script for setting up a fresh Mac with minimal prerequisites
# This script installs just enough to clone the dotfiles repo and run the main installer

echo "═══════════════════════════════════════════"
echo "  Dotfiles Bootstrap Script"
echo "═══════════════════════════════════════════"
echo ""
echo "This script will install the minimum prerequisites needed"
echo "to clone and run the dotfiles installation."
echo ""

# Check if running on macOS
if [[ ! "$OSTYPE" == "darwin"* ]]; then
    echo "❌ This script is designed for macOS only."
    exit 1
fi

echo "→ Checking prerequisites..."
echo ""

# Check for Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
    echo "→ Xcode Command Line Tools not found. Installing..."
    xcode-select --install
    
    echo ""
    echo "⚠️  Please complete the Xcode Command Line Tools installation"
    echo "   in the dialog that appeared, then run this script again."
    echo ""
    exit 0
else
    echo "✓ Xcode Command Line Tools already installed"
fi

# Check for Homebrew
if ! command -v brew &>/dev/null; then
    echo ""
    echo "→ Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon
    if [[ $(uname -m) == "arm64" ]]; then
        echo ""
        echo "→ Adding Homebrew to PATH for Apple Silicon..."
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    
    echo "✓ Homebrew installed successfully"
else
    echo "✓ Homebrew already installed"
fi

# Check for git (should be available via Xcode CLI Tools)
if ! command -v git &>/dev/null; then
    echo "❌ Git is not available. This is unexpected after installing Xcode CLI Tools."
    exit 1
else
    echo "✓ Git is available"
fi

# Install mise (version manager for neovim, node, ruby, etc.)
if ! command -v mise &>/dev/null; then
    echo ""
    echo "→ Installing mise (version manager)..."
    brew install mise
    echo "✓ mise installed successfully"
else
    echo "✓ mise already installed"
fi

# Check for 1Password CLI (optional but recommended for API key management)
if ! command -v op &>/dev/null; then
    echo ""
    echo "⚠️  1Password CLI not found (optional)"
    echo "   If you want to use the 'claude' command wrapper, install 1Password CLI:"
    echo "   brew install 1password-cli"
else
    echo "✓ 1Password CLI available"
fi

echo ""
echo "═══════════════════════════════════════════"
echo "  Prerequisites Check Complete!"
echo "═══════════════════════════════════════════"
echo ""

# Check if dotfiles repo already exists
DOTFILES_DIR="$HOME/Developer/dotfiles"

if [ -d "$DOTFILES_DIR" ]; then
    echo "✓ Dotfiles directory already exists at: $DOTFILES_DIR"
    echo ""
    echo "Next step: Run the main installer"
    echo "  cd $DOTFILES_DIR"
    echo "  sh install/install.sh"
else
    echo "Next steps:"
    echo ""
    echo "1. Create the Developer directory if needed:"
    echo "   mkdir -p ~/Developer"
    echo ""
    echo "2. Clone the dotfiles repository:"
    echo "   cd ~/Developer"
    echo "   git clone <your-dotfiles-repo-url> dotfiles"
    echo ""
    echo "3. Run the main installer:"
    echo "   cd dotfiles"
    echo "   sh install/install.sh"
fi

echo ""
echo "═══════════════════════════════════════════"

