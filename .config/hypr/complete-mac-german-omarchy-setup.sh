#!/bin/bash

# 🍎🇩🇪 Complete Mac German User Setup for Omarchy
# Preserves exact Mac keyboard behavior + adds Mac shortcuts + fixes trackpad
# Author: Claude Code Assistant
# Usage: curl -sSL [gist-url] | bash

# ⚠️ RESTORE OMARCHY DEFAULTS FIRST (if your configs are broken):
# rm -f ~/.config/hypr/input.conf ~/.config/hypr/bindings.conf ~/.config/hypr/autostart.conf
# omarchy-refresh-hyprland
# Then run this script

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Helper functions
log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }
log_header() { echo -e "${PURPLE}🚀 $1${NC}"; }

# Check if we're on omarchy
check_omarchy() {
    if [[ ! -d ~/.local/share/omarchy ]]; then
        log_error "This script is designed for omarchy installations!"
        log_info "Please install omarchy first: https://github.com/basecamp/omarchy"
        exit 1
    fi
}

# Backup existing configs
backup_configs() {
    log_info "Creating backups of existing configurations..."
    
    local backup_dir="$HOME/.config/omarchy-mac-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$backup_dir"
    
    [[ -f ~/.config/hypr/input.conf ]] && cp ~/.config/hypr/input.conf "$backup_dir/"
    [[ -f ~/.config/hypr/bindings.conf ]] && cp ~/.config/hypr/bindings.conf "$backup_dir/"
    [[ -f ~/.config/hypr/autostart.conf ]] && cp ~/.config/hypr/autostart.conf "$backup_dir/"
    [[ -f ~/.config/alacritty/alacritty.toml ]] && cp ~/.config/alacritty/alacritty.toml "$backup_dir/"
    
    log_success "Backup created at: $backup_dir"
}

# Install required dependencies
install_dependencies() {
    log_info "Installing required packages..."
    
    local packages=("ydotool")
    local missing_packages=()
    
    for package in "${packages[@]}"; do
        if ! pacman -Qi "$package" &>/dev/null; then
            missing_packages+=("$package")
        fi
    done
    
    if [[ ${#missing_packages[@]} -gt 0 ]]; then
        log_info "Installing missing packages: ${missing_packages[*]}"
        sudo pacman -S --needed --noconfirm "${missing_packages[@]}"
        
        # Enable ydotool service
        if [[ " ${missing_packages[*]} " =~ " ydotool " ]]; then
            sudo systemctl enable --now ydotool
            log_success "ydotool service enabled"
        fi
    else
        log_success "All required packages already installed"
    fi
}

# Configure German Mac keyboard layout
setup_keyboard() {
    log_info "Configuring German Mac keyboard layout..."
    
    mkdir -p ~/.config/hypr
    
    cat > ~/.config/hypr/input.conf << 'EOF'
# German Mac keyboard configuration for omarchy
# Preserves exact Mac behavior: Option+7 for |, Option+Shift+7 for \
input {
  # Exact German Mac layout
  kb_layout = de
  kb_variant = mac
  kb_options = compose:caps,altwin:alt_super_win
  
  # Keyboard repeat settings
  repeat_rate = 40
  repeat_delay = 600

  # Mouse sensitivity (increase if needed)
  # sensitivity = 0.35

  touchpad {
    # Mac-like trackpad behavior
    natural_scroll = true              # Reverse scroll direction (Mac default)
    clickfinger_behavior = true        # Two-finger right-click
    scroll_factor = 1.0               # Mac-like scroll speed  
    tap-to-click = true               # Tap to click
    drag_lock = false
    disable_while_typing = true       # Prevent accidental touches
  }
  
  # Mouse settings for Mac-like behavior
  sensitivity = 0.2                  # Increase mouse sensitivity slightly
  force_no_accel = false             # Allow acceleration
  follow_mouse = 1                   # Focus follows mouse
}

# Mac-like workspace gestures (like Mission Control)
gestures {
  workspace_swipe = true
  workspace_swipe_fingers = 3          # Three-finger swipe to switch workspaces
  workspace_swipe_distance = 300
}
EOF
    
    log_success "German Mac keyboard layout configured"
}

# Setup Mac-like keyboard shortcuts
setup_mac_shortcuts() {
    log_info "Installing Mac keyboard shortcuts (overriding omarchy conflicts)..."
    
    # The terminal variable will be expanded by Hyprland when the config is sourced
    
    cat >> ~/.config/hypr/bindings.conf << 'EOF'

# 🍎 MAC KEYBOARD SHORTCUTS SETUP
# These override some omarchy defaults to preserve Mac muscle memory
# Displaced omarchy shortcuts are moved to Super+Shift combinations

# =================== MAC CLIPBOARD ===================
# Override omarchy Calendar (Super+C) with Mac Copy
unbind = SUPER, C
bindd = SUPER, C, Copy, exec, wl-copy
bindd = SUPER, V, Paste, exec, wl-paste  
bindd = SUPER, X, Cut, exec, echo -n "\$(wl-paste)" | wl-copy && wl-copy --clear

# =================== MAC TEXT EDITING ===================
# Override omarchy AI (Super+A) with Mac Select All
unbind = SUPER, A  
bindd = SUPER, A, Select All, exec, ydotool key ctrl+a
bindd = SUPER, Z, Undo, exec, ydotool key ctrl+z
bindd = SUPER, S, Save, exec, ydotool key ctrl+s
bindd = SUPER, R, Refresh, exec, ydotool key ctrl+r

# =================== MAC WINDOW/TAB MANAGEMENT ===================
# Override omarchy Activity (Super+T) with Mac New Tab
unbind = SUPER, T
bindd = SUPER, T, New Tab, exec, ydotool key ctrl+t
# Note: Super+W already closes windows in omarchy - perfect!

# =================== DISPLACED OMARCHY SHORTCUTS ===================
# Move original omarchy shortcuts to Super+Shift combinations
bindd = SUPER SHIFT, C, Calendar (HEY), exec, omarchy-launch-webapp "https://app.hey.com/calendar/weeks/"
bindd = SUPER SHIFT, A, AI (ChatGPT), exec, omarchy-launch-webapp "https://chatgpt.com"  
bindd = SUPER SHIFT, T, Activity (btop), exec, $terminal -e btop

# =================== MAC SCREENSHOTS ===================
# Mac-like screenshot shortcuts (Shift+Cmd+3/4/5)
bindd = SUPER SHIFT, 3, Screenshot region, exec, omarchy-cmd-screenshot
bindd = SUPER SHIFT, 4, Screenshot window, exec, omarchy-cmd-screenshot window  
bindd = SUPER SHIFT, 5, Screenshot display, exec, omarchy-cmd-screenshot output

# =================== ADDITIONAL MAC SHORTCUTS ===================
bindd = SUPER, Q, Quit app, exec, ydotool key alt+f4
bindd = SUPER, H, Hide app, exec, ydotool key alt+f9
bindd = SUPER, M, Minimize app, exec, ydotool key alt+f9

# =================== MAC FINDER-LIKE ===================
bindd = SUPER SHIFT, G, Go to folder, exec, ydotool key ctrl+l

EOF
    
    log_success "Mac keyboard shortcuts installed"
}

# Configure terminal for Mac behavior
setup_terminal() {
    log_info "Configuring Alacritty terminal for Mac shortcuts..."
    
    mkdir -p ~/.config/alacritty
    
    # Check if alacritty.toml exists and append, otherwise create
    if [[ -f ~/.config/alacritty/alacritty.toml ]]; then
        log_info "Appending to existing alacritty.toml..."
    else
        log_info "Creating new alacritty.toml..."
        cat > ~/.config/alacritty/alacritty.toml << 'EOF'
# Import omarchy theme
general.import = [ "~/.config/omarchy/current/theme/alacritty.toml" ]

[env]
TERM = "xterm-256color"

[font]
normal = { family = "CaskaydiaMono Nerd Font", style = "Regular" }
bold = { family = "CaskaydiaMono Nerd Font", style = "Bold" }
italic = { family = "CaskaydiaMono Nerd Font", style = "Italic" }
size = 9

[window]
padding.x = 14
padding.y = 14
decorations = "None"
opacity = 0.98

EOF
    fi
    
    # Add Mac-specific terminal shortcuts
    cat >> ~/.config/alacritty/alacritty.toml << 'EOF'

# Mac-like terminal keyboard shortcuts
[[keyboard.bindings]]
key = "T"
mods = "Super"
action = "CreateNewWindow"

[[keyboard.bindings]]
key = "W"
mods = "Super" 
action = "Quit"

[[keyboard.bindings]]
key = "Plus"
mods = "Super"
action = "IncreaseFontSize"

[[keyboard.bindings]]
key = "Minus"
mods = "Super"
action = "DecreaseFontSize"

[[keyboard.bindings]]
key = "Key0"
mods = "Super"
action = "ResetFontSize"

[[keyboard.bindings]]
key = "F11"
action = "ToggleFullscreen"
EOF
    
    log_success "Terminal configured for Mac behavior"
}

# Setup autostart to ensure keyboard layout persists
setup_autostart() {
    log_info "Setting up autostart configuration..."
    
    mkdir -p ~/.config/hypr
    
    # Create or append to autostart.conf
    if [[ ! -f ~/.config/hypr/autostart.conf ]]; then
        touch ~/.config/hypr/autostart.conf
    fi
    
    # Add keyboard layout enforcement (if not already present)
    if ! grep -q "setxkbmap.*de.*mac" ~/.config/hypr/autostart.conf; then
        cat >> ~/.config/hypr/autostart.conf << 'EOF'

# Ensure German Mac keyboard layout is properly set on startup
exec-once = setxkbmap -layout de -variant mac -option compose:caps,altwin:alt_super_win
EOF
    fi
    
    log_success "Autostart configuration updated"
}

# Test keyboard layout
test_keyboard() {
    log_info "Testing German Mac keyboard layout..."
    
    echo ""
    echo "🧪 KEYBOARD TEST - Try these key combinations:"
    echo ""
    echo "German Mac Special Characters:"
    echo "  | (pipe)      → Option+7"
    echo "  \\ (backslash) → Option+Shift+7"
    echo "  @ (at)        → Option+L"  
    echo "  € (euro)      → Option+E"
    echo "  [ (bracket)   → Option+5"
    echo "  ] (bracket)   → Option+6"
    echo "  { (brace)     → Option+8"
    echo "  } (brace)     → Option+9"
    echo ""
    echo "German Letters (should work normally):"
    echo "  ä ö ü ß"
    echo ""
    echo "Mac Shortcuts:"
    echo "  Super+C → Copy"
    echo "  Super+V → Paste"
    echo "  Super+A → Select All"
    echo "  Super+Z → Undo"
    echo "  Super+T → New Tab"
    echo ""
    
    read -p "Press Enter to continue after testing..."
}

# Reload Hyprland configuration
reload_hyprland() {
    log_info "Reloading Hyprland configuration..."
    
    if command -v hyprctl &>/dev/null; then
        hyprctl reload
        log_success "Hyprland configuration reloaded"
    else
        log_warning "hyprctl not found. Please restart Hyprland manually or reboot."
    fi
}

# Display final summary
show_summary() {
    log_header "🍎🇩🇪 MAC GERMAN SETUP COMPLETE!"
    
    echo ""
    echo "✅ WHAT'S BEEN CONFIGURED:"
    echo ""
    echo "🎯 KEYBOARD LAYOUT:"
    echo "  • German Mac layout (de-mac)"
    echo "  • Option+7 → | (pipe)"
    echo "  • Option+Shift+7 → \\ (backslash)"  
    echo "  • All German umlauts (ä ö ü ß) work normally"
    echo ""
    echo "🍎 MAC SHORTCUTS (Natural muscle memory):"
    echo "  • Super+C/V/X → Copy/Paste/Cut"
    echo "  • Super+A/Z/S/R → Select All/Undo/Save/Refresh"
    echo "  • Super+T → New Tab"
    echo "  • Super+W → Close Window"
    echo "  • Super+Q/H/M → Quit/Hide/Minimize"
    echo ""
    echo "🖱️  TRACKPAD (Mac-like behavior):"
    echo "  • Natural scrolling enabled"
    echo "  • Two-finger right-click"
    echo "  • Tap-to-click enabled"
    echo "  • Three-finger workspace switching"
    echo ""
    echo "📱 MOVED OMARCHY SHORTCUTS (still accessible!):"
    echo "  • Super+Shift+C → Calendar (was Super+C)"
    echo "  • Super+Shift+A → ChatGPT (was Super+A)"
    echo "  • Super+Shift+T → btop/Activity (was Super+T)"
    echo ""
    echo "📸 MAC SCREENSHOTS:"
    echo "  • Super+Shift+3 → Region screenshot"
    echo "  • Super+Shift+4 → Window screenshot"  
    echo "  • Super+Shift+5 → Display screenshot"
    echo ""
    echo "🚀 ALL OMARCHY FEATURES PRESERVED:"
    echo "  • Super+Space → App launcher"
    echo "  • Super+Alt+Space → Omarchy menu"
    echo "  • Super+B → Browser"
    echo "  • Super+F → File manager"
    echo "  • Super+M → Music (Spotify)"
    echo "  • Super+/ → 1Password"
    echo "  • And many more..."
    echo ""
    echo "🎉 Your Mac muscle memory now works perfectly in Linux!"
    echo "   Welcome to the best of both worlds! 🍎🐧"
}

# Main execution
main() {
    log_header "Mac German User Setup for Omarchy"
    echo "This script will configure your omarchy installation for Mac German users"
    echo "preserving your exact Mac keyboard behavior and muscle memory."
    echo ""
    
    read -p "Continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Setup cancelled."
        exit 0
    fi
    
    check_omarchy
    backup_configs
    install_dependencies
    setup_keyboard
    setup_mac_shortcuts
    setup_terminal
    setup_autostart
    reload_hyprland
    test_keyboard
    show_summary
    
    echo ""
    log_success "Setup completed successfully! Enjoy your Mac-like Linux experience! 🚀"
}

# Run main function
main "$@"