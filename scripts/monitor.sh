#!/bin/bash

# Tor Relay Monitoring Script

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check if Tor is running
if ! systemctl is-active --quiet tor; then
    echo -e "${RED}ERROR: Tor service is not running${NC}"
    exit 1
fi

echo -e "${GREEN}=== Tor Relay Status ===${NC}"

# Basic service status
echo "Service Status: $(systemctl is-active tor)"
echo "Uptime: $(systemctl show tor --property=ActiveEnterTimestamp --value | cut -d' ' -f2-)"

# Memory and CPU usage
echo -e "\n${GREEN}=== Resource Usage ===${NC}"
ps aux | grep tor | grep -v grep | awk '{print "CPU: " $3 "%, Memory: " $4 "%"}'

# Network connections
echo -e "\n${GREEN}=== Network Connections ===${NC}"
netstat -tlnp | grep tor | wc -l | awk '{print "Active connections: " $1}'

# Relay information
if [ -f /var/lib/tor/fingerprint ]; then
    echo -e "\n${GREEN}=== Relay Information ===${NC}"
    cat /var/lib/tor/fingerprint
    
    # Get relay statistics from Tor metrics
    FINGERPRINT=$(cat /var/lib/tor/fingerprint | cut -d' ' -f2)
    echo "Metrics: https://metrics.torproject.org/rs.html#details/$FINGERPRINT"
fi

# Log analysis
echo -e "\n${GREEN}=== Recent Log Entries ===${NC}"
journalctl -u tor --since "1 hour ago" --no-pager | tail -5

# Bandwidth usage (if available)
if [ -f /var/lib/tor/stats/bandwidth-history ]; then
    echo -e "\n${GREEN}=== Bandwidth Statistics ===${NC}"
    tail -1 /var/lib/tor/stats/bandwidth-history
fi

# Disk usage
echo -e "\n${GREEN}=== Disk Usage ===${NC}"
du -sh /var/lib/tor /var/log/tor 2>/dev/null || echo "Tor directories not accessible"

# Port connectivity test
echo -e "\n${GREEN}=== Port Connectivity ===${NC}"
if timeout 5 bash -c "</dev/tcp/127.0.0.1/9001" 2>/dev/null; then
    echo "ORPort 9001: Open"
else
    echo -e "${YELLOW}ORPort 9001: Not accessible${NC}"
fi

if timeout 5 bash -c "</dev/tcp/127.0.0.1/9030" 2>/dev/null; then
    echo "DirPort 9030: Open"
else
    echo -e "${YELLOW}DirPort 9030: Not accessible${NC}"
fi

echo -e "\n${GREEN}Monitoring completed at $(date)${NC}"
