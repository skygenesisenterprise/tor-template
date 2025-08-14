#!/bin/bash

# Tor Relay Installation Script
# This script installs and configures a Tor relay server

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"
    exit 1
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   error "This script must be run as root (use sudo)"
fi

log "Starting Tor Relay installation..."

# Update system
log "Updating system packages..."
apt update && apt upgrade -y

# Install required packages
log "Installing required packages..."
apt install -y \
    tor \
    tor-arm \
    ufw \
    fail2ban \
    htop \
    curl \
    wget \
    git \
    logrotate \
    unattended-upgrades \
    apt-listchanges

# Create tor user if it doesn't exist
if ! id "debian-tor" &>/dev/null; then
    log "Creating tor user..."
    useradd -r -s /bin/false debian-tor
fi

# Configure automatic updates
log "Configuring automatic security updates..."
cat > /etc/apt/apt.conf.d/50unattended-upgrades << EOF
Unattended-Upgrade::Allowed-Origins {
    "\${distro_id}:\${distro_codename}-security";
    "\${distro_id}ESMApps:\${distro_codename}-apps-security";
    "\${distro_id}ESM:\${distro_codename}-infra-security";
};
Unattended-Upgrade::AutoFixInterruptedDpkg "true";
Unattended-Upgrade::MinimalSteps "true";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Automatic-Reboot "false";
EOF

# Enable automatic updates
systemctl enable unattended-upgrades
systemctl start unattended-upgrades

# Configure firewall
log "Configuring firewall..."
ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 9001/tcp  # Tor ORPort
ufw allow 9030/tcp  # Tor DirPort
ufw --force enable

# Configure fail2ban
log "Configuring fail2ban..."
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
systemctl enable fail2ban
systemctl start fail2ban

# Backup original torrc
if [ -f /etc/tor/torrc ]; then
    cp /etc/tor/torrc /etc/tor/torrc.backup
fi

# Copy Tor configuration
log "Installing Tor configuration..."
if [ -f "config/torrc" ]; then
    cp config/torrc /etc/tor/torrc
else
    cp config/torrc.template /etc/tor/torrc
    warn "Using template configuration. Please edit /etc/tor/torrc with your details."
fi

# Set proper permissions
chown debian-tor:debian-tor /etc/tor/torrc
chmod 644 /etc/tor/torrc

# Create Tor data directory
mkdir -p /var/lib/tor
chown debian-tor:debian-tor /var/lib/tor
chmod 700 /var/lib/tor

# Configure log rotation
log "Configuring log rotation..."
cp config/logrotate.conf /etc/logrotate.d/tor

# Install systemd service
log "Installing systemd service..."
cp config/tor-relay.service /etc/systemd/system/
systemctl daemon-reload

# Enable and start Tor
log "Starting Tor relay..."
systemctl enable tor
systemctl start tor

# Wait for Tor to start
sleep 10

# Check Tor status
if systemctl is-active --quiet tor; then
    log "Tor relay started successfully!"
    
    # Get relay information
    log "Relay information:"
    echo "Status: $(systemctl is-active tor)"
    echo "Logs: journalctl -u tor -f"
    echo "Config: /etc/tor/torrc"
    
    # Show fingerprint when available
    if [ -f /var/lib/tor/fingerprint ]; then
        echo "Fingerprint: $(cat /var/lib/tor/fingerprint)"
    else
        warn "Fingerprint not yet generated. Check back in a few minutes."
    fi
else
    error "Failed to start Tor relay. Check logs: journalctl -u tor"
fi

# Install monitoring script
log "Installing monitoring script..."
cp scripts/monitor.sh /usr/local/bin/tor-monitor
chmod +x /usr/local/bin/tor-monitor

# Create cron job for monitoring
(crontab -l 2>/dev/null; echo "*/5 * * * * /usr/local/bin/tor-monitor") | crontab -

log "Installation completed successfully!"
log "Next steps:"
log "1. Edit /etc/tor/torrc with your relay details"
log "2. Restart Tor: systemctl restart tor"
log "3. Monitor logs: journalctl -u tor -f"
log "4. Check relay status: /usr/local/bin/tor-monitor"

warn "Remember to:"
warn "- Set your ContactInfo in /etc/tor/torrc"
warn "- Choose an appropriate Nickname"
warn "- Monitor your relay regularly"
warn "- Keep your system updated"
