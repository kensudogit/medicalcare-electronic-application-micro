# Medical Care Electronic Application - Complete Microservices Setup

## 🏥 Project Overview

This is a comprehensive microservices-based electronic application system for medical care management, featuring:

- **7 Microservices** with Spring Boot and Java 17
- **Service Discovery** with Netflix Eureka
- **API Gateway** for centralized routing
- **PostgreSQL Databases** for each service
- **Redis** for caching
- **Nginx** for load balancing
- **Monitoring** with Prometheus and Grafana
- **Docker** containerization for easy deployment

## 🚀 Quick Start

### Prerequisites
- Docker Desktop installed and running
- Java 17+ (for local development)
- Gradle 8.5+ (for local development)

### 1. Start All Services
```bash
# Windows
start-all-services.bat

# Linux/Mac
./start-all-services.sh
```

### 2. Access Services
- **Main Application**: http://localhost:80
- **Service Discovery**: http://localhost:8761
- **API Gateway**: http://localhost:8080
- **Monitoring**: http://localhost:3000 (admin/admin)

## 🏗️ Architecture

### Microservices

| Service | Port | Description | Database |
|---------|------|-------------|----------|
| **Service Discovery** | 8761 | Eureka Server | - |
| **API Gateway** | 8080 | Spring Cloud Gateway | - |
| **User Service** | 8081 | User management | postgres-users |
| **Application Service** | 8082 | Medical applications | postgres-applications |
| **Notification Service** | 8083 | Notifications | postgres-notifications |
| **File Service** | 8084 | File management | postgres-files |
| **Audit Service** | 8085 | Audit logging | postgres-audit |

### Infrastructure

| Service | Port | Description |
|---------|------|-------------|
| **PostgreSQL Users** | 5433 | User data |
| **PostgreSQL Applications** | 5434 | Application data |
| **PostgreSQL Notifications** | 5435 | Notification data |
| **PostgreSQL Files** | 5436 | File metadata |
| **PostgreSQL Audit** | 5437 | Audit logs |
| **Redis** | 6381 | Caching |
| **Nginx** | 80 | Load balancer |
| **Prometheus** | 9090 | Metrics collection |
| **Grafana** | 3000 | Monitoring dashboard |

## 📁 Project Structure

```
medicalcare-electronic-application-micro/
├── api-gateway/                 # API Gateway service
├── service-discovery/           # Eureka service discovery
├── user-service/               # User management service
├── application-service/         # Medical application service
├── notification-service/        # Notification service
├── file-service/               # File management service
├── audit-service/              # Audit logging service
├── infrastructure/             # Infrastructure configuration
│   ├── nginx/                 # Nginx configuration
│   └── postgres/              # PostgreSQL configuration
├── monitoring/                 # Monitoring configuration
│   ├── prometheus.yml         # Prometheus configuration
│   └── grafana-dashboard.json # Grafana dashboard
├── scripts/                    # Utility scripts
├── docker-compose.yml          # Docker services orchestration
├── start-all-services.bat      # Windows startup script
└── README.md                   # Project documentation
```

## 🔧 Service Details

### API Gateway
- **Port**: 8080
- **Features**: Route management, load balancing, security
- **Endpoints**: `/api/**` routes to appropriate microservices

### Service Discovery
- **Port**: 8761
- **Features**: Service registration, health monitoring
- **UI**: http://localhost:8761

### User Service
- **Port**: 8081
- **Features**: User CRUD, authentication, authorization
- **Database**: postgres-users (port 5433)

### Application Service
- **Port**: 8082
- **Features**: Medical application management
- **Database**: postgres-applications (port 5434)

### Notification Service
- **Port**: 8083
- **Features**: Email, SMS, push notifications
- **Database**: postgres-notifications (port 5435)

### File Service
- **Port**: 8084
- **Features**: File upload/download, metadata management
- **Database**: postgres-files (port 5436)
- **Storage**: Docker volume for file persistence

### Audit Service
- **Port**: 8085
- **Features**: Comprehensive audit logging, querying
- **Database**: postgres-audit (port 5437)
- **API**: `/api/audit/**` endpoints

## 📊 Monitoring & Observability

### Prometheus
- **URL**: http://localhost:9090
- **Features**: Metrics collection, alerting rules
- **Targets**: All microservices, databases, infrastructure

### Grafana
- **URL**: http://localhost:3000
- **Credentials**: admin/admin
- **Dashboards**: Pre-configured microservices monitoring

### Health Checks
- **Main Health**: http://localhost/health
- **Individual Services**: `/actuator/health` on each service
- **Database Health**: Built-in PostgreSQL health checks

## 🐳 Docker Commands

### Start Services
```bash
# Start all services
docker-compose up -d

# Start specific service
docker-compose up -d [service-name]

# Start with logs
docker-compose up
```

### Stop Services
```bash
# Stop all services
docker-compose down

# Stop and remove volumes
docker-compose down -v

# Stop specific service
docker-compose stop [service-name]
```

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f [service-name]

# Last 100 lines
docker-compose logs --tail=100 [service-name]
```

### Service Status
```bash
# Check running services
docker-compose ps

# Check service health
docker-compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"
```

## 🔍 Troubleshooting

### Common Issues

#### Port Already in Use
```bash
# Check what's using a port
netstat -an | findstr :8080

# Kill process using port (Windows)
netstat -ano | findstr :8080
taskkill /PID [PID] /F
```

#### Service Not Starting
```bash
# Check service logs
docker-compose logs [service-name]

# Check service status
docker-compose ps

# Restart service
docker-compose restart [service-name]
```

#### Database Connection Issues
```bash
# Check database logs
docker-compose logs postgres-users

# Check database connectivity
docker exec -it [container-name] psql -U postgres -d [db-name]
```

### Health Check Endpoints
- **Service Discovery**: http://localhost:8761/actuator/health
- **API Gateway**: http://localhost:8080/actuator/health
- **User Service**: http://localhost:8081/actuator/health
- **Application Service**: http://localhost:8082/actuator/health
- **Notification Service**: http://localhost:8083/actuator/health
- **File Service**: http://localhost:8084/actuator/health
- **Audit Service**: http://localhost:8085/actuator/health

## 🚀 Development

### Local Development
```bash
# Clone repository
git clone [repository-url]
cd medicalcare-electronic-application-micro

# Start only infrastructure
docker-compose up -d postgres-users postgres-applications postgres-notifications postgres-files postgres-audit redis

# Run services locally with Gradle
cd [service-name]
./gradlew bootRun
```

### Building Services
```bash
# Build specific service
cd [service-name]
./gradlew build

# Build all services
./gradlew build -x test

# Run tests
./gradlew test
```

### Adding New Services
1. Create service directory with Spring Boot structure
2. Add Dockerfile
3. Update docker-compose.yml
4. Add to nginx configuration
5. Update monitoring configuration
6. Add to startup scripts

## 📈 Performance & Scaling

### Resource Limits
- **Memory**: 1GB per service (configurable)
- **CPU**: Shared (configurable)
- **Database**: Optimized PostgreSQL configuration

### Scaling
```bash
# Scale specific service
docker-compose up -d --scale [service-name]=3

# Scale with load balancer
docker-compose up -d --scale user-service=3 --scale application-service=2
```

### Performance Monitoring
- **JVM Metrics**: Memory, GC, threads
- **HTTP Metrics**: Request rate, response time, error rate
- **Database Metrics**: Connections, query performance
- **Infrastructure Metrics**: CPU, memory, disk usage

## 🔒 Security

### Network Security
- **Internal Network**: All services on `medicalcare-network`
- **Port Exposure**: Only necessary ports exposed
- **Health Checks**: Regular service health monitoring

### Data Security
- **Database Isolation**: Separate databases per service
- **Connection Security**: Internal network communication
- **Audit Logging**: Comprehensive action tracking

## 📚 Additional Resources

- **Spring Boot**: https://spring.io/projects/spring-boot
- **Spring Cloud**: https://spring.io/projects/spring-cloud
- **Docker Compose**: https://docs.docker.com/compose/
- **Prometheus**: https://prometheus.io/docs/
- **Grafana**: https://grafana.com/docs/

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Make changes
4. Test thoroughly
5. Submit pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Note**: This is a development setup. For production deployment, additional security, monitoring, and backup configurations should be implemented.
