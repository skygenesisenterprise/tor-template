# Tor Relay Server Template

A comprehensive template for deploying a Tor relay server with proper security configurations and monitoring.

## ⚠️ Important Legal Notice

This template is designed for deploying **Tor relay servers** (middle relays and guard relays) for legitimate privacy and security purposes. 

**Legal Considerations:**
- Ensure Tor relay operation is legal in your jurisdiction
- This template is for educational and legitimate privacy purposes only
- Review your local laws and ISP terms of service before deployment
- Consider liability and abuse handling procedures

**Recommended Use Cases:**
- Supporting internet freedom and privacy
- Educational purposes and research
- Contributing to the Tor network's diversity and capacity

## 🚀 Quick Start

### Prerequisites

- Linux server (Ubuntu 20.04+ recommended)
- Root or sudo access
- Stable internet connection
- At least 1GB RAM and 10GB storage
- Open firewall ports (9001, 9030)

### One-Click Deployment Options

#### Option 1: Docker Deployment
```bash
git clone hhttps://github.com/skygenesisenterprise/tor-template.git
cd tor-template
chmod +x scripts/deploy-docker.sh
./scripts/deploy-docker.sh
```

#### Option 2: Native Installation
```bash
git clone https://github.com/skygenesisenterprise/tor-template.git
cd tor-template
chmod +x scripts/install.sh
sudo ./scripts/install.sh
```

#### Option 3: Cloud Deployment
- [Deploy to DigitalOcean](./docs/deploy-digitalocean.md)
- [Deploy to AWS](./docs/deploy-aws.md)
- [Deploy to Linode](./docs/deploy-linode.md)

## 📋 Features

- ✅ Automated Tor installation and configuration
- ✅ Security hardening scripts
- ✅ Monitoring and logging setup
- ✅ Automatic updates configuration
- ✅ Firewall configuration
- ✅ Performance optimization
- ✅ Health check scripts
- ✅ Backup and restore procedures
- ✅ Multiple deployment options

## 📁 Repository Structure

```
tor-relay-template/
├── README.md
├── LICENSE
├── .github/
│   └── workflows/
│       └── security-scan.yml
├── config/
│   ├── torrc.template
│   ├── tor-relay.service
│   └── logrotate.conf
├── scripts/
│   ├── install.sh
│   ├── deploy-docker.sh
│   ├── update.sh
│   ├── monitor.sh
│   └── backup.sh
├── docker/
│   ├── Dockerfile
│   └── docker-compose.yml
├── monitoring/
│   ├── prometheus.yml
│   └── grafana-dashboard.json
├── docs/
│   ├── configuration.md
│   ├── security.md
│   ├── troubleshooting.md
│   └── deployment/
└── terraform/
    ├── aws/
    ├── digitalocean/
    └── linode/
```

## 🔧 Configuration

### Basic Configuration

1. **Edit the configuration file:**
```bash
cp config/torrc.template config/torrc
nano config/torrc
```

2. **Set your relay information:**
```
Nickname YourRelayName
ContactInfo your-email@example.com
ORPort 9001
DirPort 9030
ExitPolicy reject *:*
```

### Advanced Configuration

See [Configuration Guide](./docs/configuration.md) for detailed setup options.

## 🛡️ Security

This template includes several security measures:

- Automatic security updates
- Firewall configuration (UFW)
- Fail2ban integration
- Log monitoring
- Resource limits
- Network isolation (Docker)

For detailed security information, see [Security Guide](./docs/security.md).

## 📊 Monitoring

The template includes monitoring setup with:

- Tor relay statistics
- System resource monitoring
- Log analysis
- Alert notifications
- Grafana dashboards

Access monitoring at: `http://{your-server-ip}:3000`

## 🔄 Maintenance

### Regular Updates
```bash
./scripts/update.sh
```

### Health Checks
```bash
./scripts/monitor.sh
```

### Backup Configuration
```bash
./scripts/backup.sh
```

## 📚 Documentation

- [Configuration Guide](./docs/configuration.md)
- [Security Best Practices](./docs/security.md)
- [Troubleshooting](./docs/troubleshooting.md)
- [Deployment Guides](./docs/deployment/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 🆘 Support

- [Tor Project Documentation](https://community.torproject.org/relay/)
- [Issue Tracker](https://github.com/skygenesisenterprise/tor-template/issues)
- [Community Forum](https://forum.torproject.net/)

## ⚖️ Disclaimer

This software is provided "as is" without warranty. Users are responsible for compliance with local laws and regulations. The maintainers are not responsible for any misuse of this software.

---

**Remember:** Running a Tor relay helps protect privacy and freedom online. Thank you for contributing to internet freedom! 🌐

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.