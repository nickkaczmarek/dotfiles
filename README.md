# Dotfiles

Personal dotfiles for macOS setup with shell configurations, git settings, and development tools.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Neovim Setup (Automatic)](#neovim-setup-automatic)
- [Directory Structure](#directory-structure)
- [What Gets Installed](#what-gets-installed)
- [Selective Installation](#selective-installation)
- [Manual Installation Steps](#manual-installation-steps)
- [Troubleshooting](#troubleshooting)
- [Uninstalling](#uninstalling)

## Prerequisites

Before installing these dotfiles, you need:

1. **macOS** - This setup is designed for macOS
2. **Xcode Command Line Tools** - Required for git and other build tools
3. **Homebrew** - Package manager for macOS
4. **mise** - Version manager for tools (neovim, node, ruby, etc.)
5. **Developer directory** - The repo should be cloned to `~/Developer/dotfiles`

### Optional but Recommended

- **1Password CLI** (`op`) - Required if you want to use the `claude` command wrapper for automatic API key loading

### Fresh Machine Setup

If you're setting up a brand new Mac, run the bootstrap script first:

```bash
curl -o bootstrap.sh https://raw.githubusercontent.com/YOUR_USERNAME/dotfiles/main/install/bootstrap.sh
bash bootstrap.sh
```

This will install:
- ✅ Xcode Command Line Tools
- ✅ Homebrew
- ✅ mise (version manager)
- ⚠️  Warns about 1Password CLI (optional)

## Quick Start

### New Machine (First Time)

1. Create the Developer directory:
```bash
mkdir -p ~/Developer
cd ~/Developer
```

2. Clone this repository:
```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git
cd dotfiles
```

3. Run the installation script:
```bash
bash install/install.sh
```

4. Follow the interactive menu to choose what to install

5. Install version-locked tools with mise:
```bash
mise install
```
This installs: neovim 0.11.5, node 20, ruby 3.4.0, and usage (latest)

6. Restart your terminal:
```bash
exec zsh
```

7. Verify everything is working:
```bash
shell-doctor
```

### Existing Setup (Updating)

If you already have the dotfiles installed and want to update:

```bash
cd ~/Developer/dotfiles
git pull
bash install/install.sh
```

## Neovim Setup (Automatic)

The Neovim configuration includes **fully automatic plugin management**. On a fresh machine, when you first launch `nvim`:

### What Happens Automatically

1. **Packer plugin manager** auto-installs (if not present)
2. **All plugins** auto-install via PackerSync
3. **LSP servers** auto-install via Mason (`lua_ls`, `rust_analyzer`, `ts_ls`)
4. **Treesitter grammars** compile automatically (requires `node` from mise)

### First Launch Experience

```bash
nvim
```

**Expected behavior:**
- First launch takes 30-60 seconds (plugins installing)
- You may see informational messages about installations
- Some minor errors are normal during initial setup
- **Close and reopen nvim** after the first launch completes

**No manual steps required!** Everything installs itself.

### How It Works

The auto-bootstrap is embedded in `config/nvim/lua/kerams/packer.lua`:
- Checks if Packer exists on startup
- If missing, clones Packer from GitHub
- Automatically runs `PackerSync` to install all plugins
- LSPs and Treesitter grammars install on subsequent startup

This makes the Neovim setup **completely reproducible** on fresh machines without any manual intervention.

## Directory Structure

```
dotfiles/
├── config/              # All configuration files
│   ├── git/            # Git configuration and hooks
│   ├── shell/          # Zsh configuration, aliases, functions
│   ├── vim/            # Vim configuration
│   └── nvim/           # Neovim configuration
├── scripts/            # Executable scripts and utilities
│   ├── git/           # Git-related scripts
│   ├── shell/         # Shell functions
│   └── utils/         # General utilities
├── install/            # Installation scripts
│   ├── bootstrap.sh   # Prerequisites installer
│   ├── install.sh     # Main installer
│   └── lib/           
│       ├── helpers.sh # Shared helper functions
│       └── manifest.sh # Single source of truth for all symlinks
├── brew/              # Homebrew configuration
│   └── Brewfile       # Homebrew packages list
└── README.md
```

### Key Files

- **`install/lib/manifest.sh`** - Defines all config files that should be symlinked. This is the single source of truth used by both the installer and `shell-doctor`
- **`scripts/utils/shell-doctor`** - Diagnostic tool to verify your setup
- **`config/shell/.zshenv`** - Sets up PATH to include all script directories
- **`config/shell/.mise.toml`** - Version-locked tools managed by mise (neovim, node, etc.)
- **`brew/Brewfile`** - System utilities and GUI apps managed by Homebrew

### Adding New Configs or Scripts

The dotfiles use a **single source of truth** approach for easy maintenance:

- **New config file**: 
  1. Add file to appropriate `config/` subdirectory
  2. Add one line to `install/lib/manifest.sh`
  3. Done! Both installer and `shell-doctor` will automatically handle it

- **New script**: Add to appropriate `scripts/` subdirectory (automatically in PATH)
- **New shell function**: Add to `scripts/shell/` (one function per file, auto-loaded)
- **New Homebrew package**: Add to `brew/Brewfile`

The manifest file (`install/lib/manifest.sh`) is the single place where all symlinks are defined. This ensures the installer and diagnostic tool stay in sync automatically.

## Version Management Strategy

This dotfiles setup uses a **hybrid approach** for managing tools:

### mise (Version-Locked Tools)

Tools managed by `mise` are **pinned to specific versions** to avoid breaking changes:
- **neovim 0.11.5** - Locked to ensure plugin compatibility
- **node 20** - Required for nvim-treesitter to compile grammars
- **ruby 3.4.0** - Locked to specific version
- **usage** - Latest version (flexible tool)

Configuration: `config/shell/.mise.toml` (symlinked to `~/.config/mise/config.toml`)

**Why mise?**
- ✅ Version pinning prevents surprise breakage
- ✅ Reproducible across machines  
- ✅ No auto-updates without explicit action
- ✅ Per-project overrides available
- ✅ Essential for nvim-treesitter (needs node to compile)

### Homebrew (System Tools & Apps)

Tools managed by `Homebrew` are system utilities and apps that update safely:
- CLI utilities (git, fzf, tree, jq, etc.)
- Libraries (tree-sitter)
- GUI applications (casks)
- Development tools (swiftlint, gh, etc.)

Configuration: `brew/Brewfile`

**Why Homebrew?**
- ✅ Best for macOS system integration
- ✅ GUI apps and casks
- ✅ Tools with stable APIs

## What Gets Installed

### Configuration Files

The installer creates symlinks from your home directory to this repo:

| Config File | Location | Purpose |
|-------------|----------|---------|
| `.zshrc` | `config/shell/zshrc` | Main zsh configuration |
| `.zshenv` | `config/shell/zshenv` | Environment variables and PATH |
| `.p10k.zsh` | `config/shell/.p10k.zsh` | Powerlevel10k theme config |
| `.gitconfig` | `config/git/gitconfig` | Main git configuration |
| `.gitconfig-*` | `config/git/` | Work/personal git configs |
| `.gitpairs` | `config/git/gitpairs` | Pair programming git config |
| `.gitmessage` | `config/git/.gitmessage` | Git commit message template |
| `.gvimrc` | `config/vim/gvimrc` | Vim configuration |
| `~/.config/nvim` | `config/nvim/` | Neovim configuration |
| `.macos` | `config/shell/.macos` | macOS system defaults |
| `~/Brewfile` | `brew/Brewfile` | Homebrew packages |

### Scripts in PATH

All scripts in `scripts/` subdirectories are automatically added to your PATH:

**Git Scripts** (`scripts/git/`):
- `git-ui.zsh` - Open git repo in Fork.app
- `fuzzy-checkout` - Fuzzy find and checkout git branches
- `fetch-and-merge-origin-main` - Fetch and merge from origin/main
- `list-authors` - List git commit authors
- `pull-push` - Pull and push in one command
- `reset-to-server` - Reset local branch to match remote

**Shell Functions** (`scripts/shell/`):
- `anka-connect` - Connect to Anka VM
- `arduino-compile` / `arduino-upload` - Arduino development tools
- `check-if-vpn` - Check VPN connection status
- `delete-derived-data` - Clean Xcode derived data
- `delete-gps` - Delete iOS GPS simulator data
- `delete-simulator-cookies` - Clear simulator cookies
- `diskspace` - Show disk usage
- `load-anthropic-key` - Load Anthropic API key from 1Password (on-demand)
- `makeSmallVideo` - Compress video files
- `rotate-video` / `rotate-video-180` - Rotate videos
- `search_code` - Search codebase
- `youtube-dl-aria2` - Download videos with aria2

**Utility Scripts** (`scripts/utils/`):
- `bbpaste` - BBEdit clipboard utility
- `bman` - View man pages in BBEdit
- `check-arm-and-install-rosetta2` - Install Rosetta 2 if needed
- `clean-simulator` - Clean iOS simulator
- `claude` - Claude Code wrapper (auto-loads API key from 1Password)
- `shell-doctor` - Diagnostic tool to verify dotfiles setup
- `spinner` - Display loading spinner
- `install-bbedit-lsp.sh` - Install language servers for BBEdit

### Homebrew Packages

The Brewfile installs numerous development tools and applications:

**Command Line Tools**:
- `asdf` - Version manager
- `aria2` - Download utility
- `bat` - Better cat with syntax highlighting
- `exa` - Modern ls replacement
- `fzf` - Fuzzy finder
- `gh` - GitHub CLI
- `git-delta` - Better git diffs
- `jq` - JSON processor
- `swiftlint` - Swift linter
- `tree` - Directory tree viewer
- `wget` - File downloader
- And more...

**Cask Applications**:
- `xcodes` - Xcode version manager
- `visual-studio-code` - Code editor
- `keycastr` - Keystroke visualizer

**Fonts**:
- `font-meslo-lg-nerd-font` - Nerd Font for terminal

**Mac App Store**:
- BBEdit, DaisyDisk, Keynote, and more (see `brew/Brewfile` for full list)

## Selective Installation

The installer provides a simple interactive menu:

```bash
bash install/install.sh
```

Options:
1. **Full installation** - Everything (configs + brew + macos)
2. **Configs only** - All configuration files and symlinks
3. **Brew only** - Just Homebrew packages
4. **macOS defaults only** - Just apply system preferences  
5. **Verify installation** - Check if everything is properly configured
6. **Exit**

The simplified menu gives you control over the two main installation categories (configs vs packages) without overwhelming granularity.

## Manual Installation Steps

Some applications need to be installed manually as they're not available via Homebrew or the Mac App Store:

### Applications to Install Manually

- 1Password / 1Password for Safari
- Acorn
- AirBuddy
- Amphetamine
- Bartender 4
- Battery Buddy
- Cardhop
- Discord
- Drafts
- DuckDuckGo Privacy for Safari
- Fantastical
- Firefox
- Itsycal
- Keyboard Maestro
- Kite
- krisp
- MarsEdit
- Micro.blog
- NetNewsWire
- Notchmeister
- Nova
- Proxyman
- QLMarkdown
- Rectangle
- Retrobatch
- Rocket
- SF Symbols
- Slack
- Snk
- Soulver 2 / Soulver 3
- SoundSource
- Tweetbot
- Unexpectedly
- VLC
- WWT Timex
- xScope

### Post-Installation Configuration

After running the installer:

1. **Powerlevel10k** - Run `p10k configure` to customize your prompt
2. **Git** - Update git configs with your name and email
3. **Fork.app** - Set up `EDITOR_GIT` path in `.zshenv` if you use a different git GUI
4. **iTerm2** - Import your iTerm2 profile if you have one
5. **BBEdit** - Run `install-bbedit-lsp.sh` for LSP support (if needed)
6. **SSH Keys** - Set up your SSH keys for git authentication

## Troubleshooting

### Symlinks Not Working

If symlinks fail, you might have existing files:

```bash
# Backup existing files
mv ~/.zshrc ~/.zshrc.backup
mv ~/.gitconfig ~/.gitconfig.backup

# Re-run installer
bash install/install.sh
```

The installer automatically backs up existing files with timestamps.

### Shell Not Loading Configs

If your shell isn't loading the new configs:

```bash
# Restart shell
exec zsh

# Or close and reopen your terminal
```

### Neovim Errors or Missing Plugins

#### Quick Fixes (Try These First)

If you see errors about missing colorschemes, plugins, or treesitter:

```bash
# 1. Ensure mise tools are installed (neovim 0.11.5, node 20)
mise install

# 2. Verify neovim and node are available
which nvim   # Should show: ~/.local/share/mise/installs/neovim/...
which node   # Should show: ~/.local/share/mise/installs/node/...

# 3. Restart shell to pick up mise shims
exec zsh

# 4. Launch nvim (auto-bootstrap will run if needed)
nvim
```

If auto-bootstrap doesn't run or errors persist, try the manual steps below.

#### Manual Plugin Installation

If auto-bootstrap fails or you want to manually trigger it:

```bash
# Open nvim and run PackerSync
nvim
:PackerSync

# Wait for all plugins to install, then restart nvim
:qa
nvim
```

#### Complete Neovim Reset (Nuclear Option)

If Neovim is completely broken or won't start:

```bash
# 1. Back up current state (optional)
mv ~/.local/share/nvim ~/.local/share/nvim.backup
mv ~/.cache/nvim ~/.cache/nvim.backup

# 2. Remove all Neovim data and cache
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim

# 3. Restart shell
exec zsh

# 4. Launch nvim (auto-bootstrap will start fresh)
nvim

# Auto-bootstrap will:
# - Install Packer
# - Install all plugins
# - Install LSPs and Treesitter grammars
# 
# This may take 30-60 seconds on first launch.
# Close and reopen nvim after it completes.
```

#### Common Error Messages and Fixes

| Error | Cause | Fix |
|-------|-------|-----|
| `"tree-sitter generate" errors` | Node not found | Run `mise install` to install node 20 |
| `"colorscheme 'rose-pine' not found"` | Plugins not installed | Run `:PackerSync` in nvim |
| `"module 'harpoon.mark' not found"` | Plugins not installed | Run `:PackerSync` in nvim |
| `"lualine" not found` | Plugins not installed | Run `:PackerSync` in nvim |
| `LSP not working` | LSP not installed | Run `:Mason` and press `i` to install |
| `deprecation warning about lspconfig` | Known issue with lsp-zero v3.x | Harmless, will be fixed in lsp-zero update |
| `PackerSync command not found` | Packer not installed | Delete nvim data (see reset steps above) |

#### Checking Neovim Configuration (Without Opening)

To test your Neovim config and see errors without getting stuck in the editor:

```bash
# This loads config, prints any errors, and exits immediately
nvim --headless -c 'quitall'
```

If there are no errors, it exits silently. If there are errors, they'll be printed to the terminal. This is perfect for testing after changes or during fresh setup.

#### Running Neovim Commands from Terminal

You can run any Neovim command from the terminal using `--headless` mode. This is incredibly useful for automation, troubleshooting, and CI/CD pipelines.

**Install/Update All Plugins (PackerSync)**

```bash
# Run PackerSync and wait for completion before quitting
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
```

**Install Specific LSP Servers**

```bash
# Install one LSP
nvim --headless -c 'MasonInstall lua_ls' -c 'quitall'

# Install multiple LSPs at once
nvim --headless -c 'MasonInstall lua_ls rust_analyzer ts_ls' -c 'quitall'
```

**Update Treesitter Parsers**

```bash
# Update all treesitter parsers
nvim --headless -c 'TSUpdateSync' -c 'quitall'

# Install specific parser
nvim --headless -c 'TSInstall swift' -c 'quitall'
```

**Generate Health Check Report**

```bash
# Output checkhealth to a file for review
nvim --headless -c 'checkhealth' -c 'write! /tmp/nvim-health.txt' -c 'quitall'
cat /tmp/nvim-health.txt

# Or check specific health (e.g., just LSP or Treesitter)
nvim --headless -c 'checkhealth lsp' -c 'write! /tmp/lsp-health.txt' -c 'quitall'
```

**General Pattern**

```bash
# Basic pattern for any command
nvim --headless -c '<command>' -c 'quitall'

# Alternative shorter syntax
nvim --headless +'<command>' +qa

# Chain multiple commands
nvim --headless -c '<command1>' -c '<command2>' -c 'quitall'
```

**Practical Examples**

```bash
# Full plugin setup from scratch (automated)
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
nvim --headless -c 'MasonInstall lua_ls rust_analyzer ts_ls' -c 'quitall'
nvim --headless -c 'TSUpdateSync' -c 'quitall'

# Verify setup without opening editor
nvim --headless -c 'checkhealth' -c 'write! /tmp/health.txt' -c 'quitall' && cat /tmp/health.txt

# Test config loads without errors
nvim --headless -c 'quitall' && echo "✓ Config loaded successfully"
```

#### Checking Neovim Health

To diagnose issues, use Neovim's built-in health check:

```bash
nvim
:checkhealth
```

This will show:
- Which LSPs are installed
- Treesitter parser status
- Plugin manager status
- Required dependencies

#### Verifying mise Tools

```bash
# Check what mise has installed
mise list

# Should show:
# neovim  0.11.5
# node    20.x.x
# ruby    3.4.0
# usage   latest

# Check if they're in PATH
which nvim  # Should be mise path, not homebrew
which node  # Should be mise path
```

### PATH Not Including Scripts

If scripts aren't found:

1. Check that `.zshenv` is symlinked: `ls -la ~/.zshenv`
2. Verify PATH in new shell: `echo $PATH`
3. Make sure you restarted your shell after installation

### Homebrew Permissions Issues

If brew bundle fails with permissions errors:

```bash
# Fix Homebrew permissions
sudo chown -R $(whoami) /opt/homebrew/*
```

### Checking Installation Status

Use the shell-doctor diagnostic tool:

```bash
shell-doctor
```

This will check:
- All symlinks are correct
- PATH includes script directories
- Environment variables are set
- Key commands are available
- Shell functions are loaded
- Script permissions are correct

Or run the installer's verification option:

```bash
bash install/install.sh
# Choose option 5: Verify installation
```

Or use the dedicated diagnostic tool:

```bash
shell-doctor
```

### Git Config Not Loading

If git configs aren't working:

```bash
# Check if files are symlinked
ls -la ~/.gitconfig

# Verify git is reading the config
git config --list --show-origin
```

## Uninstalling

To remove dotfiles and restore your system:

1. Remove symlinks:
```bash
rm ~/.zshrc ~/.zshenv ~/.gitconfig ~/.gitconfig-* ~/.p10k.zsh ~/.gvimrc ~/.gitpairs ~/.gitmessage ~/.macos ~/Brewfile
rm -rf ~/.config/nvim
```

2. Restore backups if you have them:
```bash
mv ~/.zshrc.backup ~/.zshrc
mv ~/.gitconfig.backup ~/.gitconfig
```

3. Remove from PATH by editing `/etc/paths` or removing the dotfiles directory

4. Optionally uninstall Homebrew packages:
```bash
# This will remove ALL Homebrew packages, not just ones from the Brewfile
# brew bundle cleanup --force --file=~/Brewfile
```

## License

Personal dotfiles - use at your own discretion.

## Contributing

This is a personal dotfiles repository, but feel free to fork and adapt for your own use!
