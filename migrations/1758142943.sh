echo "Adding graceful Chromium shutdown service"

# Copy the systemd service file to user systemd directory
mkdir -p ~/.config/systemd/user
cp $OMARCHY_PATH/config/systemd/user/omarchy-chromium-shutdown.service ~/.config/systemd/user/

# Reload systemd daemon and enable the service
systemctl --user daemon-reload
systemctl --user enable omarchy-chromium-shutdown.service
systemctl --user start omarchy-chromium-shutdown.service

echo "Chromium graceful shutdown service installed and enabled"