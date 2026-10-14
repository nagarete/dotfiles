#!/bin/bash
# One-time setup script to fix HDD cycling issue
# Run this with sudo

set -e

echo "=== HDD Keep-Awake Setup ==="
echo "This will fix the HDD cycling issue for /dev/sda"
echo ""

# Install required tools
echo "Step 1: Installing hdparm and smartmontools..."
pacman -S --noconfirm hdparm smartmontools || {
    echo "ERROR: Failed to install packages. Make sure you have internet connection."
    exit 1
}

# Copy the fixed script
echo ""
echo "Step 2: Installing the keep-awake script..."
cp /home/nagarete/keep_drive_awake_fixed.sh /usr/local/bin/keep_drive_awake.sh
chmod +x /usr/local/bin/keep_drive_awake.sh

# Copy the fixed service
echo ""
echo "Step 3: Installing the systemd service..."
cp /home/nagarete/keep-sdb-awake.service.fixed /etc/systemd/system/keep-sdb-awake.service

# Reload systemd
echo ""
echo "Step 4: Reloading systemd..."
systemctl daemon-reload

# Enable the service
echo ""
echo "Step 5: Enabling service to start on boot..."
systemctl enable keep-sdb-awake.service

# Start the service
echo ""
echo "Step 6: Starting the service..."
systemctl start keep-sdb-awake.service

# Check status
echo ""
echo "Step 7: Checking service status..."
sleep 2
systemctl status keep-sdb-awake.service --no-pager

echo ""
echo "=== Setup Complete ==="
echo ""
echo "The service is now running. Your HDD should stop cycling."
echo ""
echo "To verify it's working:"
echo "  1. Wait 2-3 minutes and listen - the drive should not spin down"
echo "  2. Check logs: sudo journalctl -u keep-sdb-awake.service -f"
echo "  3. Check drive power state: sudo hdparm -C /dev/sda"
echo ""
echo "To disable this fix later:"
echo "  sudo systemctl stop keep-sdb-awake.service"
echo "  sudo systemctl disable keep-sdb-awake.service"
