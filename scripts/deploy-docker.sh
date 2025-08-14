#!/bin/bash

# Docker deployment script for Tor Relay

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

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

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    log "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    usermod -aG docker $USER
    rm get-docker.sh
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    log "Installing Docker Compose..."
    curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

# Create environment file if it doesn't exist
if [ ! -f .env ]; then
    log "Creating environment file..."
    cat > .env << EOF
TOR_NICKNAME=MyTorRelay
TOR_CONTACT=tor-operator@example.com
GRAFANA_PASSWORD=admin
EOF
    warn "Please edit .env file with your relay details"
fi

# Create configuration from template if needed
if [ ! -f config/torrc ]; then
    log "Creating Tor configuration from template..."
    cp config/torrc.template config/torrc
    warn "Please edit config/torrc with your relay details"
fi

# Configure firewall for Docker
log "Configuring firewall..."
if command -v ufw &> /dev/null; then
    ufw allow 9001/tcp
    ufw allow 9030/tcp
    ufw allow 3000/tcp  # Grafana
    ufw allow 9090/tcp  # Prometheus
fi

# Start the services
log "Starting Tor relay with Docker Compose..."
cd docker
docker-compose up -d

# Wait for services to start
log "Waiting for services to start..."
sleep 30

# Check service status
log "Checking service status..."
docker-compose ps

# Show logs
log "Recent logs:"
docker-compose logs --tail=20 tor-relay

log "Deployment completed!"
log "Services:"
log "- Tor Relay: Running on ports 9001 (OR) and 9030 (Dir)"
log "- Prometheus: http://localhost:9090"
log "- Grafana: http://localhost:3000 (admin/admin)"
log ""
log "To view logs: docker-compose logs -f tor-relay"
log "To stop: docker-compose down"
log "To restart: docker-compose restart"

warn "Don't forget to:"
warn "1. Edit config/torrc with your relay information"
warn "2. Edit .env with your details"
warn "3. Restart after configuration changes: docker-compose restart"
