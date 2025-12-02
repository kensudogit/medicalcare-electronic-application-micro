@echo off
echo ========================================
echo Microservices Log Viewer
echo ========================================
echo.

if "%1"=="" (
    echo Usage: %0 [SERVICE_NAME]
    echo.
    echo Available services:
    echo   Core Services:
    echo     service-discovery    - Eureka Service Discovery
    echo     api-gateway         - Spring Cloud Gateway
    echo     user-service        - User Management
    echo     application-service - Medical Applications
    echo     notification-service - Notifications
    echo     file-service        - File Management
    echo     audit-service       - Audit Logging
    echo.
    echo   Infrastructure:
    echo     nginx               - Load Balancer
    echo     prometheus          - Metrics Collection
    echo     grafana             - Monitoring Dashboard
    echo.
    echo   Databases:
    echo     postgres-users      - Users Database
    echo     postgres-applications - Applications Database
    echo     postgres-notifications - Notifications Database
    echo     postgres-files      - Files Database
    echo     postgres-audit      - Audit Database
    echo     redis               - Cache Database
    echo.
    echo Examples:
    echo   %0 user-service
    echo   %0 api-gateway
    echo   %0 postgres-users
    echo.
    pause
    exit /b 1
)

set SERVICE_NAME=%1

echo Viewing logs for: %SERVICE_NAME%
echo.
echo Log viewing options:
echo   Press Ctrl+C to stop following logs
echo   Use 'docker-compose logs --tail=N %SERVICE_NAME%' for specific number of lines
echo   Use 'docker-compose logs --since=1h %SERVICE_NAME%' for logs from last hour
echo   Use 'docker-compose logs %SERVICE_NAME% | findstr ERROR' to filter errors
echo.
echo ========================================
echo Starting log viewer...
echo ========================================
echo.

REM Check if service is running
docker-compose ps --format "table {{.Names}}" | findstr "^%SERVICE_NAME%$" >nul
if %errorlevel% neq 0 (
    echo ERROR: Service '%SERVICE_NAME%' is not running!
    echo.
    echo Running services:
    docker-compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"
    echo.
    pause
    exit /b 1
)

REM Show service status
echo Service Status:
echo ---------------
docker-compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}" | findstr "%SERVICE_NAME%"
echo.

REM Show last 100 lines by default
echo Showing last 100 lines of logs for %SERVICE_NAME%:
echo ------------------------------------------------
docker-compose logs --tail=100 %SERVICE_NAME%

echo.
echo ========================================
echo Log viewing complete
echo ========================================
echo.
echo Additional commands:
echo   docker-compose logs -f %SERVICE_NAME%          # Follow logs in real-time
echo   docker-compose logs --tail=50 %SERVICE_NAME%   # Last 50 lines
echo   docker-compose logs --since=1h %SERVICE_NAME%  # Last hour
echo   docker-compose logs %SERVICE_NAME% | findstr ERROR # Filter errors
echo.
echo To check service status: docker-compose ps
echo To restart service: docker-compose restart %SERVICE_NAME%
echo.
pause
