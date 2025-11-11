#!/bin/bash

# Main installation script for dotfiles
# This script sets up all configuration files, scripts, and tools

# Determine script directory and load helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Source manifest and helper functions
source "$SCRIPT_DIR/lib/manifest.sh"
source "$SCRIPT_DIR/lib/helpers.sh"

# Installation functions

install_configs() {
    log_info "Installing all configuration files..."
    reset_counters
    
    for entry in "${DOTFILES_SYMLINKS[@]}"; do
        IFS=: read -r source target type <<< "$entry"
        local full_source="$DOTFILES_DIR/$source"
        
        # Skip Brewfile in configs-only mode
        [[ "$source" == "brew/Brewfile" ]] && continue
        
        # Check if source exists
        if [ ! -e "$full_source" ]; then
            log_skip "$(basename "$target") - source not found"
            continue
        fi
        
        # Handle directory symlinks differently
        if [ "$type" = "dir" ]; then
            # For directories, we need special handling
            if [ -L "$target" ] && [ "$(readlink "$target")" = "$full_source" ]; then
                log_skip "$(basename "$target") already linked"
                continue
            fi
            
            if [ -e "$target" ] || [ -L "$target" ]; then
                backup_existing "$target"
            fi
            
            # Create parent directory if needed
            mkdir -p "$(dirname "$target")"
            
            if ln -sf "$full_source" "$target" 2>/dev/null; then
                log_success "Linked $(basename "$target") directory"
            else
                log_error "Failed to link $(basename "$target")"
            fi
        else
            # Regular file symlink
            symlink_safe "$full_source" "$target" "$(basename "$target")" || true
        fi
    done
    
    print_summary
}

install_brew() {
    log_info "Installing Homebrew packages..."
    reset_counters
    
    if ! is_macos; then
        log_skip "Not on macOS, skipping Homebrew installation"
        print_summary
        return 0
    fi
    
    # Check if Homebrew is installed
    if ! command_exists brew; then
        log_error "Homebrew is not installed. Run install/bootstrap.sh first."
        print_summary
        return 1
    fi
    
    # Symlink Brewfile
    local brewfile="$DOTFILES_DIR/brew/Brewfile"
    if [ -f "$brewfile" ]; then
        symlink_safe "$brewfile" "$HOME/Brewfile" "Brewfile" || true
        
        echo ""
        if confirm "Install Homebrew packages from Brewfile?"; then
            log_info "Running brew bundle install..."
            cd "$HOME"
            if brew bundle install; then
                log_success "Homebrew packages installed"
            else
                log_error "Some Homebrew packages failed to install"
            fi
        else
            log_skip "Skipped Homebrew package installation"
        fi
    else
        log_error "Brewfile not found at $brewfile"
    fi
    
    print_summary
}

install_macos_defaults() {
    log_info "Applying macOS defaults..."
    reset_counters
    
    if ! is_macos; then
        log_skip "Not on macOS, skipping macOS defaults"
        print_summary
        return 0
    fi
    
    if [ -f "$HOME/.macos" ]; then
        if confirm "Apply macOS system defaults? (This may require restart)"; then
            log_info "Sourcing .macos file..."
            if source "$HOME/.macos" 2>/dev/null; then
                log_success "macOS defaults applied"
            else
                log_error "Failed to apply some macOS defaults"
            fi
        else
            log_skip "Skipped macOS defaults"
        fi
    else
        log_warning ".macos file not found (should be symlinked first)"
    fi
    
    print_summary
}

verify_installation() {
    log_info "Verifying installation..."
    reset_counters
    
    # Use the manifest to check symlinks
    for entry in "${DOTFILES_SYMLINKS[@]}"; do
        IFS=: read -r source target type <<< "$entry"
        local full_source="$DOTFILES_DIR/$source"
        
        if [ -L "$target" ]; then
            local link_target=$(readlink "$target")
            if [ "$link_target" = "$full_source" ]; then
                log_success "$(basename "$target") is correctly linked"
            else
                log_warning "$(basename "$target") is linked but to wrong location"
            fi
        elif [ -e "$target" ]; then
            log_warning "$(basename "$target") exists but is not a symlink"
        else
            log_error "$(basename "$target") is not installed"
        fi
    done
    
    # Check if PATH includes our script directories
    log_info "Checking PATH configuration..."
    if [[ ":$PATH:" == *":$DOTFILES_DIR/scripts/utils:"* ]]; then
        log_success "scripts/utils is in PATH"
    else
        log_warning "scripts/utils is not in PATH (restart shell)"
    fi
    
    print_summary
}

show_menu() {
    echo ""
    echo "═══════════════════════════════════════════"
    echo "  Dotfiles Installation Menu"
    echo "═══════════════════════════════════════════"
    echo ""
    echo "Choose an installation option:"
    echo ""
    echo "  1) Full installation (configs + brew + macos)"
    echo "  2) Configs only (all symlinks)"
    echo "  3) Brew only (packages)"
    echo "  4) macOS defaults only"
    echo "  5) Verify installation (doctor)"
    echo "  6) Exit"
    echo ""
    read -p "Enter your choice [1-6]: " choice
    echo ""
    
    case $choice in
        1)
            install_configs
            install_brew
            install_macos_defaults
            ;;
        2)
            install_configs
            ;;
        3)
            install_brew
            ;;
        4)
            install_macos_defaults
            ;;
        5)
            verify_installation
            ;;
        6)
            log_info "Exiting..."
            exit 0
            ;;
        *)
            log_error "Invalid choice. Please try again."
            show_menu
            ;;
    esac
}

# Main execution
main() {
    echo ""
    echo "═══════════════════════════════════════════"
    echo "  Dotfiles Installation"
    echo "═══════════════════════════════════════════"
    echo ""
    echo "Dotfiles directory: $DOTFILES_DIR"
    echo ""
    
    # Show menu for interactive selection
    show_menu
    
    echo ""
    echo "═══════════════════════════════════════════"
    echo "  Installation Complete!"
    echo "═══════════════════════════════════════════"
    echo ""
    echo "Next steps:"
    echo "  • Restart your terminal or run: exec zsh"
    echo "  • Run 'shell-doctor' to verify everything"
    echo "  • Review any warnings or errors above"
    echo ""
}

# Run main function
main
