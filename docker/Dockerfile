FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    tor \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Create tor user
RUN useradd -r -s /bin/false debian-tor

# Create directories
RUN mkdir -p /var/lib/tor /var/log/tor /etc/tor
RUN chown -R debian-tor:debian-tor /var/lib/tor /var/log/tor

# Copy configuration
COPY config/torrc.template /etc/tor/torrc
RUN chown debian-tor:debian-tor /etc/tor/torrc

# Copy monitoring script
COPY scripts/monitor.sh /usr/local/bin/tor-monitor
RUN chmod +x /usr/local/bin/tor-monitor

# Expose ports
EXPOSE 9001 9030

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD /usr/local/bin/tor-monitor || exit 1

# Switch to tor user
USER debian-tor

# Start Tor
CMD ["tor", "-f", "/etc/tor/torrc"]
