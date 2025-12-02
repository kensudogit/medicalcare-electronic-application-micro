# Audit Service

The Audit Service is a microservice responsible for logging and tracking all user actions and system events across the medical care electronic application system.

## Features

- **Comprehensive Audit Logging**: Tracks user actions, resource access, and system events
- **Flexible Querying**: Search audit logs by user, resource, action, or date range
- **IP Address Tracking**: Records client IP addresses for security monitoring
- **User Agent Logging**: Tracks client browser/application information
- **RESTful API**: Provides HTTP endpoints for audit operations
- **Service Discovery**: Integrates with Eureka service discovery

## API Endpoints

### Create Audit Log
```
POST /api/audit/log
Parameters:
- userId: User identifier
- action: Action performed (e.g., CREATE, READ, UPDATE, DELETE)
- resource: Resource type (e.g., USER, APPLICATION, FILE)
- resourceId: Resource identifier
- details: Optional additional details
```

### Query Audit Logs
```
GET /api/audit/user/{userId} - Get logs by user
GET /api/audit/resource/{resource}/{resourceId} - Get logs by resource
GET /api/audit/action/{action} - Get logs by action
GET /api/audit/date-range?start={start}&end={end} - Get logs by date range
GET /api/audit/user/{userId}/date-range?start={start}&end={end} - Get logs by user and date range
GET /api/audit/all - Get all audit logs
```

### Health Check
```
GET /api/audit/health - Service health status
```

## Database Schema

The service uses PostgreSQL with the following main table:

### audit_logs
- `id`: Primary key
- `user_id`: User identifier
- `action`: Action performed
- `resource`: Resource type
- `resource_id`: Resource identifier
- `details`: Additional details (optional)
- `timestamp`: When the action occurred
- `ip_address`: Client IP address
- `user_agent`: Client user agent string

## Configuration

The service is configured via `application.yml` with the following key settings:

- **Port**: 8085
- **Database**: PostgreSQL with configurable connection
- **Service Discovery**: Eureka client integration
- **Health Checks**: Actuator endpoints enabled

## Building and Running

### Prerequisites
- Java 17 or higher
- Gradle 8.5 or higher
- PostgreSQL database

### Build
```bash
./gradlew build
```

### Run
```bash
./gradlew bootRun
```

### Docker
```bash
docker build -t audit-service .
docker run -p 8085:8085 audit-service
```

## Integration

The Audit Service integrates with:
- **Service Discovery**: Registers with Eureka
- **Database**: PostgreSQL for persistent storage
- **Other Services**: Can be called by other microservices to log events

## Security Considerations

- All audit logs are immutable once created
- IP addresses and user agents are logged for security monitoring
- Timestamps are automatically generated and cannot be modified
- Audit logs should be retained according to compliance requirements
