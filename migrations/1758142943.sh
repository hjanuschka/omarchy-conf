echo "Adding graceful Chromium shutdown service"

# Copy the systemd service file to user systemd directory
mkdir -p ~/.config/systemd/user
cp ~/.local/share/omarchy/config/systemd/user/omarchy-chromium-shutdown.service ~/.config/systemd/user/

# Copy the helper script to user bin directory
mkdir -p ~/.local/bin
cp ~/.local/share/omarchy/bin/omarchy-chromium-shutdown-helper ~/.local/bin/
chmod +x ~/.local/bin/omarchy-chromium-shutdown-helper

# Enable user lingering so service runs during shutdown
sudo loginctl enable-linger $USER 2>/dev/null || echo "Note: Could not enable lingering automatically, may need manual setup"

# Reload systemd daemon and enable the service
systemctl --user daemon-reload
systemctl --user enable omarchy-chromium-shutdown.service

# Start the service if we're in a Wayland session
if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
    systemctl --user start omarchy-chromium-shutdown.service
fi

echo "Chromium graceful shutdown service installed and enabled"