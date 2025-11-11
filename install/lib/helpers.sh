#!/bin/bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters for summary
SUCCESS_COUNT=0
FAILURE_COUNT=0
SKIP_COUNT=0

# Log messages with colors
log_success() {
    printf "${GREEN}✓${NC} %s\n" "$1"
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
}

log_error() {
    printf "${RED}✗${NC} %s\n" "$1"
    FAILURE_COUNT=$((FAILURE_COUNT + 1))
}

log_warning() {
    printf "${YELLOW}⚠${NC} %s\n" "$1"
}

log_info() {
    printf "${BLUE}→${NC} %s\n" "$1"
}

log_skip() {
    printf "${YELLOW}⊘${NC} %s\n" "$1"
    SKIP_COUNT=$((SKIP_COUNT + 1))
}

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Backup existing file or directory
backup_existing() {
    local target="$1"
    
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        local backup="${target}.backup.$(date +%Y%m%d_%H%M%S)"
        log_info "Backing up existing file: $target -> $backup"
        mv "$target" "$backup"
        return 0
    fi
    return 1
}

# Safely create a symlink with validation
symlink_safe() {
    local source="$1"
    local target="$2"
    local description="${3:-$target}"
    
    # Validate source exists
    if [ ! -e "$source" ]; then
        log_error "Source file does not exist: $source"
        return 1
    fi
    
    # If target already exists and is a symlink to the correct location
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        log_skip "Already linked: $description"
        return 0
    fi
    
    # If target exists but is not the correct symlink
    if [ -e "$target" ] || [ -L "$target" ]; then
        backup_existing "$target"
    fi
    
    # Create parent directory if it doesn't exist
    local target_dir=$(dirname "$target")
    if [ ! -d "$target_dir" ]; then
        mkdir -p "$target_dir"
    fi
    
    # Create the symlink
    if ln -sf "$source" "$target" 2>/dev/null; then
        log_success "Linked: $description"
        return 0
    else
        log_error "Failed to link: $description"
        return 1
    fi
}

# Print a summary of operations
print_summary() {
    echo ""
    echo "═══════════════════════════════════════════"
    echo "  Installation Summary"
    echo "═══════════════════════════════════════════"
    printf "${GREEN}Success:${NC} %s\n" "$SUCCESS_COUNT"
    if [ $SKIP_COUNT -gt 0 ]; then
        printf "${YELLOW}Skipped:${NC} %s\n" "$SKIP_COUNT"
    fi
    if [ $FAILURE_COUNT -gt 0 ]; then
        printf "${RED}Failures:${NC} %s\n" "$FAILURE_COUNT"
    fi
    echo "═══════════════════════════════════════════"
    echo ""
    
    if [ $FAILURE_COUNT -gt 0 ]; then
        printf "${YELLOW}Some operations failed. Please review the output above.${NC}\n"
        return 1
    else
        printf "${GREEN}All operations completed successfully!${NC}\n"
        return 0
    fi
}

# Prompt user for confirmation
confirm() {
    local prompt="$1"
    local default="${2:-y}"
    
    if [ "$default" = "y" ]; then
        prompt="$prompt [Y/n]"
    else
        prompt="$prompt [y/N]"
    fi
    
    read -p "$prompt " response
    response=${response:-$default}
    
    case "$response" in
        [yY][eE][sS]|[yY]) 
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Check if running on macOS
is_macos() {
    [[ "$OSTYPE" == "darwin"* ]]
}

# Reset counters (useful between different install sections)
reset_counters() {
    SUCCESS_COUNT=0
    FAILURE_COUNT=0
    SKIP_COUNT=0
}

