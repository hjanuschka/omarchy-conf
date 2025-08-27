# Omarchy Config - Mac-Style German Keyboard Setup

My personal omarchy (Hyprland) configuration with Mac-style keybindings and German keyboard layout support.

## Features

### 🎹 Mac-Style Keyboard
- German Mac keyboard layout with proper AltGr/Option special characters
- Mac-style clipboard (Super+C/V/X/A)  
- Mac-style window management (Super+W closes tabs, Super+Q quits apps)
- Tab management (Super+T for new tabs everywhere)
- Smart floating windows (Super+D)

### 🎨 Kitty Terminal Integration
- Automatic theme synchronization with omarchy themes
- Bulletproof TOML parsing for all theme formats
- Support for 11+ omarchy themes
- Live theme switching with SIGUSR1

### ⌨️ Key Bindings

| Key Combo | Action |
|-----------|--------|
| Super+C/V/X/A | Copy/Paste/Cut/Select All |
| Super+T | New Tab (smart detection for kitty/browsers) |
| Super+W | Close Tab/Window |
| Super+Q | Quit Application |
| Super+D | Toggle Floating (centered, 80% size) |
| Ctrl+Space | App Launcher |
| Super+Shift+3/4/5 | Screenshots |

### 🇩🇪 German Special Characters
Full German Mac keyboard support with AltGr/Option:
- AltGr+Q = @
- AltGr+E = €
- AltGr+7/8/9 = \|{}[]
- And more...

## Installation

```bash
# Clone this repo
gh repo clone hjanuschka/omarchy-conf ~/.config-backup

# Copy configs (backup existing first!)
cp -r ~/.config-backup/.config/hypr/* ~/.config/hypr/
cp -r ~/.config-backup/.config/kitty/* ~/.config/kitty/
cp ~/.config-backup/.local/bin/* ~/.local/bin/

# Reload Hyprland
hyprctl reload
```

## Files

- `.config/hypr/` - Hyprland configuration
  - `bindings.conf` - All keyboard shortcuts
  - `input.conf` - German Mac keyboard setup
- `.config/kitty/` - Kitty terminal config with theme support
- `.local/bin/` - Helper scripts
  - `toggle-float` - Smart floating window toggle
  - `omarchy-generate-kitty-theme` - Theme generator

## Contributing

Feel free to fork and adapt for your own setup!