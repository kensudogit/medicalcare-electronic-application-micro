@echo off
echo ========================================
echo Medical Care Microservices Startup Script
echo ========================================
echo.

echo Checking Docker status...
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Docker is not installed or not running!
    echo Please start Docker Desktop and try again.
    pause
    exit /b 1
)

echo Docker is running.
echo.

echo Checking if ports are available...
netstat -an | findstr ":8761" >nul
if %errorlevel% equ 0 (
    echo WARNING: Port 8761 (Service Discovery) is already in use!
    echo Please stop any existing services using this port.
    pause
)

netstat -an | findstr ":8080" >nul
if %errorlevel% equ 0 (
    echo WARNING: Port 8080 (API Gateway) is already in use!
    echo Please stop any existing services using this port.
    pause
)

echo Ports are available.
echo.

echo Starting all microservices...
echo This may take a few minutes on first run...
echo.

echo Starting infrastructure services...
docker-compose up -d postgres-users postgres-applications postgres-notifications postgres-files postgres-audit redis

echo Waiting for databases to be ready...
timeout /t 10 /nobreak >nul

echo Starting service discovery...
docker-compose up -d service-discovery

echo Waiting for service discovery to be ready...
timeout /t 15 /nobreak >nul

echo Starting microservices...
docker-compose up -d user-service application-service notification-service file-service audit-service

echo Waiting for microservices to be ready...
timeout /t 20 /nobreak >nul

echo Starting API Gateway...
docker-compose up -d api-gateway

echo Waiting for API Gateway to be ready...
timeout /t 10 /nobreak >nul

echo Starting monitoring services...
docker-compose up -d prometheus grafana

echo Waiting for monitoring services to be ready...
timeout /t 15 /nobreak >nul

echo Starting Nginx load balancer...
docker-compose up -d nginx

echo.
echo ========================================
echo All services are starting up!
echo ========================================
echo.
echo Service URLs:
echo - Service Discovery: http://localhost:8761
echo - API Gateway: http://localhost:8080
echo - User Service: http://localhost:8081
echo - Application Service: http://localhost:8082
echo - Notification Service: http://localhost:8083
echo - File Service: http://localhost:8084
echo - Audit Service: http://localhost:8085
echo - Prometheus: http://localhost:9090
echo - Grafana: http://localhost:3000 (admin/admin)
echo - Nginx: http://localhost:80
echo.
echo Health Check: http://localhost/health
echo.
echo To view logs: docker-compose logs -f [service-name]
echo To stop all: docker-compose down
echo.
pause
