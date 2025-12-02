# Utility Scripts Guide

This document describes all the utility scripts available for managing the medical care microservices system.

## 📁 Scripts Directory

```
scripts/
├── health-check.sh          # Linux/Mac health check script
├── health-check.bat         # Windows health check script
├── scale-services.sh         # Service scaling script
├── backup-restore.sh         # Backup and restore script
├── service-logs.sh           # Service log viewer (Linux/Mac)
├── service-logs.bat          # Service log viewer (Windows)
├── system-info.sh            # Comprehensive system information
└── performance-monitor.sh    # Performance monitoring script
```

## 🔍 Health Check Scripts

### Linux/Mac: `health-check.sh`
Comprehensive health check for all microservices, containers, and ports.

**Usage:**
```bash
./scripts/health-check.sh
```

**Features:**
- Docker container status
- Service health endpoints
- Port availability
- Service discovery registration
- Overall system health

### Windows: `health-check.bat`
Windows batch file version of the health check script.

**Usage:**
```cmd
scripts\health-check.bat
```

**Features:**
- Same functionality as Linux/Mac version
- Windows-compatible commands
- Color-coded output

## 📈 Service Scaling Script

### `scale-services.sh`
Scale microservices up or down for load balancing and performance.

**Usage:**
```bash
# Scale specific service
./scripts/scale-services.sh -s user-service -i 3

# Scale all services
./scripts/scale-services.sh -a 2

# Show current scaling
./scripts/scale-services.sh -c

# Show help
./scripts/scale-services.sh -h
```

**Options:**
- `-s, --service SERVICE`: Service to scale
- `-i, --instances NUM`: Number of instances (1-5)
- `-a, --all NUM`: Scale all services
- `-c, --current`: Show current scaling status
- `-h, --help`: Show help message

**Supported Services:**
- user-service
- application-service
- notification-service
- file-service
- audit-service

## 💾 Backup & Restore Script

### `backup-restore.sh`
Complete backup and restore functionality for all microservices data.

**Usage:**
```bash
# Create backup
./scripts/backup-restore.sh backup

# Restore from backup
./scripts/backup-restore.sh restore backups/backup_file.tar.gz

# List available backups
./scripts/backup-restore.sh list

# Show help
./scripts/backup-restore.sh help
```

**Backup Includes:**
- PostgreSQL databases (all services)
- File uploads
- Redis data
- Configuration files
- Compressed archive creation

**Restore Features:**
- Database restoration
- File upload restoration
- Redis data restoration
- Safety confirmations
- Error handling

## 🚀 Startup Scripts

### `start-all-services.bat` (Windows)
Comprehensive startup script for Windows users.

**Usage:**
```cmd
start-all-services.bat
```

**Features:**
- Docker status verification
- Port availability checks
- Sequential service startup
- Health monitoring
- Service URL display

### `start-all-services.sh` (Linux/Mac)
Linux/Mac version of the startup script.

**Usage:**
```bash
./start-all-services.sh
```

**Features:**
- Same functionality as Windows version
- Unix-compatible commands
- Interactive prompts

## 🔧 Performance Monitoring

### `performance-monitor.sh`
Monitor system performance and resource usage.

**Usage:**
```bash
./scripts/performance-monitor.sh
```

**Features:**
- CPU and memory usage
- Docker container metrics
- Database performance
- Network statistics

## 📋 Service Log Viewer

### Linux/Mac: `service-logs.sh`
Advanced log viewing with filtering and real-time monitoring.

**Usage:**
```bash
# Show last 100 lines
./scripts/service-logs.sh user-service

# Follow logs in real-time
./scripts/service-logs.sh -f user-service

# Show last 50 lines
./scripts/service-logs.sh -t 50 user-service

# Show logs from last hour
./scripts/service-logs.sh -s 1h user-service

# Filter error logs
./scripts/service-logs.sh -e user-service

# Filter by pattern
./scripts/service-logs.sh -g 'ERROR' user-service

# List available services
./scripts/service-logs.sh -l

# Show help
./scripts/service-logs.sh -h
```

**Options:**
- `-f, --follow`: Follow log output in real-time
- `-t, --tail N`: Show last N lines (default: 100)
- `-s, --since TIME`: Show logs since TIME (e.g., 1h, 30m, 2d)
- `-u, --until TIME`: Show logs until TIME
- `-g, --grep PATTERN`: Filter logs by pattern
- `-e, --error`: Show only error logs
- `-w, --warning`: Show only warning logs
- `-i, --info`: Show only info logs
- `-l, --list`: List available services
- `-h, --help`: Show help message

### Windows: `service-logs.bat`
Windows version of the service log viewer.

**Usage:**
```cmd
scripts\service-logs.bat user-service
scripts\service-logs.bat api-gateway
scripts\service-logs.bat postgres-users
```

**Features:**
- Same functionality as Linux/Mac version
- Windows-compatible commands
- Service status checking
- Log filtering examples

## 🔍 System Information

### `system-info.sh`
Comprehensive system information and diagnostics.

**Usage:**
```bash
./scripts/system-info.sh
```

**Features:**
- Docker information and status
- System information (OS, kernel, architecture)
- Resource usage (memory, disk, CPU)
- Network information and port usage
- Docker containers status
- Service health status
- Database information
- Volume information
- Environment information (Java, Gradle, Node.js, Git)
- Configuration files status
- Available scripts status
- System summary with service counts

## 📋 Script Permissions

### Linux/Mac
Make scripts executable:
```bash
chmod +x scripts/*.sh
```

### Windows
Scripts are already executable as `.bat` files.

## 🎯 Common Use Cases

### 1. Daily Operations
```bash
# Start all services
./start-all-services.sh

# Check health
./scripts/health-check.sh

# Monitor performance
./scripts/performance-monitor.sh

# View system information
./scripts/system-info.sh
```

### 2. Scaling for Load
```bash
# Scale user service for high traffic
./scripts/scale-services.sh -s user-service -i 3

# Scale all services for peak load
./scripts/scale-services.sh -a 3
```

### 3. Backup & Recovery
```bash
# Create daily backup
./scripts/backup-restore.sh backup

# Restore from backup (if needed)
./scripts/backup-restore.sh restore backups/microservices_backup_20241201_143022.tar.gz
```

### 4. Troubleshooting
```bash
# Check system health
./scripts/health-check.sh

# View service logs
./scripts/service-logs.sh [service-name]

# View system information
./scripts/system-info.sh

# View service logs (Windows)
scripts\service-logs.bat [service-name]

# Restart specific service
docker-compose restart [service-name]
```

## ⚠️ Important Notes

### Script Dependencies
- **Docker**: Must be running
- **Docker Compose**: Must be available
- **curl**: For health checks (Linux/Mac)
- **lsof**: For port checking (Linux/Mac)
- **netstat**: For port checking (Windows)

### Backup Considerations
- Backups are stored in `./backups/` directory
- Backup files include timestamp in filename
- Restore operations overwrite existing data
- Always verify backup integrity before restore

### Scaling Limitations
- Maximum 5 instances per service
- Scaling affects load balancing
- Monitor resource usage when scaling
- Consider database connection limits

## 🆘 Troubleshooting

### Script Not Executable (Linux/Mac)
```bash
chmod +x scripts/script-name.sh
```

### Permission Denied
```bash
sudo ./scripts/script-name.sh
```

### Script Not Found
```bash
# Check current directory
pwd

# List scripts
ls -la scripts/

# Run from project root
./scripts/script-name.sh
```

### Windows Script Issues
- Ensure running as Administrator if needed
- Check Windows Defender exclusions
- Verify PowerShell execution policy

## 📚 Additional Resources

- **Docker Commands**: `docker --help`
- **Docker Compose**: `docker-compose --help`
- **Service Logs**: `docker-compose logs -f [service-name]`
- **Service Status**: `docker-compose ps`
- **Stop All**: `docker-compose down`
- **Start All**: `docker-compose up -d`

## 🤝 Contributing

To add new scripts:
1. Create script in `scripts/` directory
2. Add appropriate permissions
3. Update this documentation
4. Test on both Windows and Linux/Mac
5. Include help/usage information

---

**Note**: All scripts are designed to work with the microservices architecture defined in `docker-compose.yml`. Ensure all services are properly configured before running scripts.
