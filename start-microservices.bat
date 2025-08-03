@echo off
echo Starting Medical Care Electronic Application Microservices...
echo.

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo Error: Docker is not running. Please start Docker Desktop first.
    pause
    exit /b 1
)

REM Stop any existing containers
echo Stopping existing containers...
docker-compose down --remove-orphans

REM Clean up networks
echo Cleaning up networks...
docker network prune -f

REM Build and start services
echo Building and starting services...
docker-compose build
if errorlevel 1 (
    echo Error: Failed to build services.
    pause
    exit /b 1
)

docker-compose up -d
if errorlevel 1 (
    echo Error: Failed to start services.
    pause
    exit /b 1
)

echo.
echo Services are starting up...
echo.
echo Service URLs:
echo - Service Discovery: http://localhost:8761
echo - API Gateway: http://localhost:8080
echo - User Service: http://localhost:8081
echo - Application Service: http://localhost:8082
echo - Notification Service: http://localhost:8083
echo - File Service: http://localhost:8084
echo - Nginx Load Balancer: http://localhost
echo.
echo To view logs: docker-compose logs -f
echo To stop services: docker-compose down
echo.
pause 