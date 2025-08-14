# Security Best Practices

## System Security

### 1. Keep System Updated
\`\`\`bash
# Enable automatic security updates
sudo apt install unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades
\`\`\`

### 2. Firewall Configuration
\`\`\`bash
# Configure UFW
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 9001/tcp  # Tor ORPort
sudo ufw allow 9030/tcp  # Tor DirPort
sudo ufw enable
\`\`\`

### 3. Fail2Ban Setup
\`\`\`bash
# Install and configure fail2ban
sudo apt install fail2ban
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo systemctl enable fail2ban
\`\`\`

### 4. SSH Hardening
\`\`\`bash
# Edit SSH configuration
sudo nano /etc/ssh/sshd_config

# Recommended settings:
Port 2222  # Change default port
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
MaxAuthTries 3
\`\`\`

## Tor-Specific Security

### 1. Proper File Permissions
\`\`\`bash
# Ensure correct permissions
sudo chown -R debian-tor:debian-tor /var/lib/tor
sudo chmod 700 /var/lib/tor
sudo chmod 644 /etc/tor/torrc
\`\`\`

### 2. Resource Limits
Add to `/etc/security/limits.conf`:
\`\`\`
debian-tor soft nofile 65536
debian-tor hard nofile 65536
debian-tor soft nproc 4096
debian-tor hard nproc 4096
\`\`\`

### 3. Network Security
\`\`\`bash
# Disable IPv6 if not needed
echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.conf

# Enable IP forwarding protection
echo 'net.ipv4.conf.all.send_redirects = 0' >> /etc/sysctl.conf
echo 'net.ipv4.conf.all.accept_redirects = 0' >> /etc/sysctl.conf
\`\`\`

## Monitoring and Logging

### 1. Log Monitoring
\`\`\`bash
# Monitor Tor logs
sudo journalctl -u tor -f

# Check for suspicious activity
sudo grep -i "warn\|error" /var/log/tor/notices.log
\`\`\`

### 2. System Monitoring
\`\`\`bash
# Install monitoring tools
sudo apt install htop iotop nethogs

# Monitor resource usage
htop
iotop
nethogs
\`\`\`

### 3. Automated Alerts
Create `/usr/local/bin/tor-alert.sh`:
\`\`\`bash
#!/bin/bash
if ! systemctl is-active --quiet tor; then
    echo "Tor relay is down!" | mail -s "Tor Alert" your-email@example.com
fi
\`\`\`

## Backup and Recovery

### 1. Configuration Backup
\`\`\`bash
# Backup script
#!/bin/bash
tar -czf tor-backup-$(date +%Y%m%d).tar.gz \
    /etc/tor/torrc \
    /var/lib/tor/keys \
    /var/lib/tor/fingerprint
\`\`\`

### 2. Key Management
- Keep your relay keys secure
- Back up `/var/lib/tor/keys/` directory
- Never share your private keys

## Incident Response

### 1. Abuse Handling
- Monitor abuse complaints
- Respond promptly to legitimate requests
- Keep logs for investigation

### 2. Compromise Response
If your relay is compromised:
1. Immediately shut down the relay
2. Investigate the breach
3. Rebuild from clean backups
4. Generate new keys if necessary

## Legal Considerations

### 1. Documentation
- Keep records of your relay operation
- Document security measures
- Maintain abuse handling procedures

### 2. Compliance
- Understand local laws
- Review ISP terms of service
- Consider liability insurance

## Regular Security Tasks

### Daily
- Check system logs
- Monitor resource usage
- Verify Tor is running

### Weekly
- Review security updates
- Check abuse reports
- Analyze traffic patterns

### Monthly
- Update system packages
- Review firewall rules
- Test backup procedures
- Rotate log files

## Security Checklist

- [ ] System fully updated
- [ ] Firewall properly configured
- [ ] SSH hardened
- [ ] Fail2ban installed
- [ ] Proper file permissions set
- [ ] Resource limits configured
- [ ] Monitoring in place
- [ ] Backup procedures tested
- [ ] Incident response plan ready
- [ ] Legal compliance verified
