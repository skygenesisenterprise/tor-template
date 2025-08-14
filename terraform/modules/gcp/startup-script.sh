#!/bin/bash
set -e

# Update system
apt-get update
apt-get upgrade -y

# Install required packages
apt-get install -y tor tor-arm htop fail2ban ufw

# Configure firewall
ufw --force enable
ufw allow ssh
ufw allow 9001/tcp
ufw allow 9030/tcp

# Configure Tor (same as AWS user-data.sh)
cat > /etc/tor/torrc << EOF
# Basic relay configuration
Nickname ${tor_nickname}
ContactInfo ${tor_contact_info}

# Network settings
ORPort 9001
DirPort 9030

# This is a relay, not an exit node
ExitPolicy reject *:*

# Logging
Log notice file /var/log/tor/notices.log
Log info file /var/log/tor/info.log

# Security settings
CookieAuthentication 1
DataDirectory /var/lib/tor

# Performance tuning
NumCPUs 0
DisableDebuggerAttachment 0

# Additional security
RunAsDaemon 1
User debian-tor

# Control port for monitoring
ControlPort 9051
HashedControlPassword 16:872860B76453A77D60CA2BB8C1A7042072093276A3D701AD684053EC4C
EOF

# Set proper permissions and start services
chown debian-tor:debian-tor /etc/tor/torrc
chmod 644 /etc/tor/torrc

systemctl enable tor
systemctl restart tor
systemctl enable fail2ban
systemctl start fail2ban

echo "Tor relay setup completed successfully!"
