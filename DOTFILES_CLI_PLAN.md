# Dotfiles CLI Command - Implementation Plan

> **Status:** Planning stage - not yet implemented
> 
> This plan outlines a unified `dotfiles` CLI command for easier dotfiles management from anywhere.

## Goal

Create a unified `dotfiles` command with minimal subcommands (doctor, backup) that works from anywhere and is easy to extend later.

## Design

### Command Structure

```bash
dotfiles doctor         # Run shell-doctor diagnostics
dotfiles backup         # Generate new Brewfile backup
dotfiles help           # Show usage
dotfiles                # Show usage (no args)
```

### Location

`scripts/dotfiles-cli/dotfiles` - Main executable script (in its own directory for future expansion)

### Key Features

- Works from **anywhere** (uses `$DOTFILES` env var internally)
- Minimal and focused (just doctor and backup to start)
- Easy to extend with new subcommands later
- Follows existing script patterns (like `shell-doctor`, `claude`)

## Implementation

### 1. Create Directory and Main Script

File: `scripts/dotfiles-cli/dotfiles`

```bash
#!/usr/bin/env zsh

# Dotfiles CLI - Unified interface for dotfiles management
# Usage: dotfiles <subcommand>

# Ensure DOTFILES is set
if [ -z "$DOTFILES" ]; then
    echo "Error: DOTFILES environment variable not set"
    echo "Please restart your shell or source ~/.zshenv"
    exit 1
fi

# Change to dotfiles directory for all operations
cd "$DOTFILES" || exit 1

# Subcommand dispatcher
case "$1" in
    doctor)
        # Run shell diagnostics
        exec "$DOTFILES/scripts/utils/shell-doctor"
        ;;
    
    backup)
        # Generate new Brewfile backup
        backup_dir="$DOTFILES/brew/backup-brewfiles"
        backup_file="$backup_dir/Brewfile.$(date +%Y-%m-%d)"
        
        echo "→ Generating Brewfile backup..."
        brew bundle dump --file="$backup_file" --force
        
        if [ $? -eq 0 ]; then
            echo "✓ Backup created: $backup_file"
            echo ""
            echo "To compare with tracked Brewfile:"
            echo "  diff brew/Brewfile $backup_file"
        else
            echo "✗ Backup failed"
            exit 1
        fi
        ;;
    
    help|--help|-h)
        cat << 'EOF'
Dotfiles CLI - Unified interface for dotfiles management

Usage:
  dotfiles <subcommand>

Subcommands:
  doctor      Run diagnostics to verify dotfiles setup
  backup      Generate timestamped Brewfile backup
  help        Show this help message

Examples:
  dotfiles doctor        # Check symlinks, PATH, environment
  dotfiles backup        # Create brew/backup-brewfiles/Brewfile.YYYY-MM-DD

Environment:
  Requires $DOTFILES to be set (should be ~/Developer/dotfiles)
EOF
        ;;
    
    "")
        echo "Error: No subcommand provided"
        echo "Run 'dotfiles help' for usage"
        exit 1
        ;;
    
    *)
        echo "Error: Unknown subcommand '$1'"
        echo "Run 'dotfiles help' for available subcommands"
        exit 1
        ;;
esac
```

### 2. Make Executable

```bash
chmod +x scripts/dotfiles-cli/dotfiles
```

### 3. Update PATH

File: `config/shell/.zshenv`

Update PATH to include dotfiles-cli:

```bash
DOTBIN="$DOTFILES/scripts/utils"
DOTCLI="$DOTFILES/scripts/dotfiles-cli"
DOTGIT="$DOTFILES/scripts/git"
DOTSHELL="$DOTFILES/scripts/shell"

path=(
    $GEM_HOME/bin
    $DOTBIN
    $DOTCLI
    $DOTGIT
    $DOTSHELL
    $DOTLOCAL
    $HOMEBREW
    $path
)
```

### 4. Update Documentation

File: `README.md`

Add new section under "Key Files":

**Dotfiles CLI**
- `scripts/dotfiles-cli/dotfiles` - Unified command interface
  - `dotfiles doctor` - Run diagnostics
  - `dotfiles backup` - Generate Brewfile backup

### 5. Update Manifest (Symlinks)

No changes needed - command is in PATH, doesn't need symlinks.

## Benefits

- **Consistent interface** - One command to remember
- **Works anywhere** - No need to cd to dotfiles dir
- **Extensible** - Easy to add more subcommands later
- **Self-documenting** - Built-in help
- **Follows conventions** - Uses existing $DOTFILES, matches script style

## Implementation Checklist

- [ ] Create `scripts/dotfiles-cli/` directory
- [ ] Create `scripts/dotfiles-cli/dotfiles` script
- [ ] Make the dotfiles script executable (`chmod +x`)
- [ ] Update `config/shell/.zshenv` to include `$DOTCLI` in PATH
- [ ] Update README.md documentation
- [ ] Test `dotfiles doctor` from different directories
- [ ] Test `dotfiles backup` from different directories

## Future Expansion Ideas

(Not implemented in initial version, just for reference)

```bash
dotfiles update         # Pull repo and run install.sh
dotfiles status         # Git status + outdated brew packages
dotfiles sync           # Pull, install, mise install, brew upgrade
dotfiles clean          # Remove backup files, clean brew cache
dotfiles edit <target>  # Open config in $EDITOR
```

## Notes

- The `dotfiles` command doesn't affect how symlinks work - it's just a convenient wrapper
- All subcommands use `$DOTFILES` to find the repo location
- The script changes to `$DOTFILES` directory before executing any operations
- This follows the same pattern as existing scripts like `shell-doctor` and `claude`

