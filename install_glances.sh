#!/bin/bash

# Update and install Glances
echo "Updating package lists and installing Glances..."
sudo apt update
sudo apt install -y glances

# Open firewall port 61209 (optional)
echo "Opening firewall port 61209..."
sudo ufw allow 61209/tcp
sudo ufw reload

# Create systemd service file for Glances
echo "Creating systemd service for Glances..."
sudo bash -c 'cat <<EOF > /etc/systemd/system/glances.service
[Unit]
Description=Glances in server mode
After=network.target

[Service]
ExecStart=/usr/bin/glances -s
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF'

# Enable and start Glances service
echo "Enabling and starting Glances service..."
sudo systemctl enable glances
sudo systemctl start glances

# Check Glances status
echo "Glances installation and service setup complete!"
sudo systemctl status glances --no-pager
