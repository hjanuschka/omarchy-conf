echo "Adding graceful Chromium shutdown service (system-wide)"

# Disable old user service if it exists
systemctl --user disable omarchy-chromium-shutdown.service 2>/dev/null || true
systemctl --user stop omarchy-chromium-shutdown.service 2>/dev/null || true

# Copy the system service file
sudo cp ~/.local/share/omarchy/config/systemd/system/omarchy-chromium-shutdown.service /etc/systemd/system/

# Copy the system helper script
sudo cp ~/.local/share/omarchy/bin/omarchy-chromium-shutdown-system /usr/local/bin/
sudo chmod +x /usr/local/bin/omarchy-chromium-shutdown-system

# Reload system daemon and enable the service
sudo systemctl daemon-reload
sudo systemctl enable omarchy-chromium-shutdown.service
sudo systemctl start omarchy-chromium-shutdown.service

echo "System-wide Chromium graceful shutdown service installed and enabled"