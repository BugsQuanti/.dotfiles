#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root."
    exit 1
fi

# Install acpid if not already installed
if ! pacman -Qi acpid > /dev/null; then
    echo "Installing acpid..."
    pacman -S --noconfirm acpid
fi

# Enable and start acpid service
echo "Enabling and starting acpid service..."
systemctl enable acpid
systemctl start acpid

# Configure systemd-logind to ignore power button
echo "Configuring systemd-logind..."
sed -i '/^#HandlePowerKey=/c\HandlePowerKey=ignore' /etc/systemd/logind.conf
systemctl restart systemd-logind

# Create the ACPI event configuration for the power button
echo "Creating ACPI event configuration..."
cat <<EOL > /etc/acpi/events/powerbtn
event=button/power
action=/etc/acpi/powerbtn.sh
EOL

# Create the script that will handle the power button action
echo "Creating power button script..."
cat <<EOL > /etc/acpi/powerbtn.sh
#!/bin/sh
/usr/bin/sudo /sbin/reboot now
EOL

# Make the script executable
chmod +x /etc/acpi/powerbtn.sh

# Add the sudoers rule to allow reboot without password
echo "Adding sudoers rule..."
yourusername=$(logname)
echo "$yourusername ALL=(ALL) NOPASSWD: /sbin/reboot" | EDITOR='tee -a' visudo

# Restart the acpid service to apply changes
echo "Restarting acpid service..."
systemctl restart acpid

echo "Configuration complete. The computer will now reboot when the power button is pressed."
