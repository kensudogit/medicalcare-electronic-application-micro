@echo off
echo ========================================
echo Microservices Health Check
echo ========================================
echo.

echo 1. Checking Docker containers...
echo ---------------------------------

echo Checking service-discovery (Service Discovery)...
docker ps --format "table {{.Names}}\t{{.Status}}" | findstr "service-discovery.*Up" >nul
if %errorlevel% equ 0 (
    echo   ✓ RUNNING
) else (
    echo   ✗ NOT RUNNING
)

echo Checking api-gateway (API Gateway)...
docker ps --format "table {{.Names}}\t{{.Status}}" | findstr "api-gateway.*Up" >nul
if %errorlevel% equ 0 (
    echo   ✓ RUNNING
) else (
    echo   ✗ NOT RUNNING
)

echo Checking user-service (User Service)...
docker ps --format "table {{.Names}}\t{{.Status}}" | findstr "user-service.*Up" >nul
if %errorlevel% equ 0 (
    echo   ✓ RUNNING
) else (
    echo   ✗ NOT RUNNING
)

echo Checking application-service (Application Service)...
docker ps --format "table {{.Names}}\t{{.Status}}" | findstr "application-service.*Up" >nul
if %errorlevel% equ 0 (
    echo   ✓ RUNNING
) else (
    echo   ✗ NOT RUNNING
)

echo Checking notification-service (Notification Service)...
docker ps --format "table {{.Names}}\t{{.Status}}" | findstr "notification-service.*Up" >nul
if %errorlevel% equ 0 (
    echo   ✓ RUNNING
) else (
    echo   ✗ NOT RUNNING
)

echo Checking file-service (File Service)...
docker ps --format "table {{.Names}}\t{{.Status}}" | findstr "file-service.*Up" >nul
if %errorlevel% equ 0 (
    echo   ✓ RUNNING
) else (
    echo   ✗ NOT RUNNING
)

echo Checking audit-service (Audit Service)...
docker ps --format "table {{.Names}}\t{{.Status}}" | findstr "audit-service.*Up" >nul
if %errorlevel% equ 0 (
    echo   ✓ RUNNING
) else (
    echo   ✗ NOT RUNNING
)

echo Checking nginx (Nginx Load Balancer)...
docker ps --format "table {{.Names}}\t{{.Status}}" | findstr "nginx.*Up" >nul
if %errorlevel% equ 0 (
    echo   ✓ RUNNING
) else (
    echo   ✗ NOT RUNNING
)

echo Checking prometheus (Prometheus)...
docker ps --format "table {{.Names}}\t{{.Status}}" | findstr "prometheus.*Up" >nul
if %errorlevel% equ 0 (
    echo   ✓ RUNNING
) else (
    echo   ✗ NOT RUNNING
)

echo Checking grafana (Grafana)...
docker ps --format "table {{.Names}}\t{{.Status}}" | findstr "grafana.*Up" >nul
if %errorlevel% equ 0 (
    echo   ✓ RUNNING
) else (
    echo   ✗ NOT RUNNING
)

echo.
echo 2. Checking database containers...
echo ----------------------------------

echo Checking postgres-users (PostgreSQL Users)...
docker ps --format "table {{.Names}}\t{{.Status}}" | findstr "postgres-users.*Up" >nul
if %errorlevel% equ 0 (
    echo   ✓ RUNNING
) else (
    echo   ✗ NOT RUNNING
)

echo Checking postgres-applications (PostgreSQL Applications)...
docker ps --format "table {{.Names}}\t{{.Status}}" | findstr "postgres-applications.*Up" >nul
if %errorlevel% equ 0 (
    echo   ✓ RUNNING
) else (
    echo   ✗ NOT RUNNING
)

echo Checking postgres-notifications (PostgreSQL Notifications)...
docker ps --format "table {{.Names}}\t{{.Status}}" | findstr "postgres-notifications.*Up" >nul
if %errorlevel% equ 0 (
    echo   ✓ RUNNING
) else (
    echo   ✗ NOT RUNNING
)

echo Checking postgres-files (PostgreSQL Files)...
docker ps --format "table {{.Names}}\t{{.Status}}" | findstr "postgres-files.*Up" >nul
if %errorlevel% equ 0 (
    echo   ✓ RUNNING
) else (
    echo   ✗ NOT RUNNING
)

echo Checking postgres-audit (PostgreSQL Audit)...
docker ps --format "table {{.Names}}\t{{.Status}}" | findstr "postgres-audit.*Up" >nul
if %errorlevel% equ 0 (
    echo   ✓ RUNNING
) else (
    echo   ✗ NOT RUNNING
)

echo Checking redis (Redis Cache)...
docker ps --format "table {{.Names}}\t{{.Status}}" | findstr "redis.*Up" >nul
if %errorlevel% equ 0 (
    echo   ✓ RUNNING
) else (
    echo   ✗ NOT RUNNING
)

echo.
echo 3. Checking port availability...
echo ---------------------------------

echo Checking port 8761 (Service Discovery)...
netstat -an | findstr ":8761" >nul
if %errorlevel% equ 0 (
    echo   ✓ IN USE
) else (
    echo   ✗ NOT IN USE
)

echo Checking port 8080 (API Gateway)...
netstat -an | findstr ":8080" >nul
if %errorlevel% equ 0 (
    echo   ✓ IN USE
) else (
    echo   ✗ NOT IN USE
)

echo Checking port 8081 (User Service)...
netstat -an | findstr ":8081" >nul
if %errorlevel% equ 0 (
    echo   ✓ IN USE
) else (
    echo   ✗ NOT IN USE
)

echo Checking port 8082 (Application Service)...
netstat -an | findstr ":8082" >nul
if %errorlevel% equ 0 (
    echo   ✓ IN USE
) else (
    echo   ✗ NOT IN USE
)

echo Checking port 8083 (Notification Service)...
netstat -an | findstr ":8083" >nul
if %errorlevel% equ 0 (
    echo   ✓ IN USE
) else (
    echo   ✗ NOT IN USE
)

echo Checking port 8084 (File Service)...
netstat -an | findstr ":8084" >nul
if %errorlevel% equ 0 (
    echo   ✓ IN USE
) else (
    echo   ✗ NOT IN USE
)

echo Checking port 8085 (Audit Service)...
netstat -an | findstr ":8085" >nul
if %errorlevel% equ 0 (
    echo   ✓ IN USE
) else (
    echo   ✗ NOT IN USE
)

echo Checking port 80 (Nginx)...
netstat -an | findstr ":80" >nul
if %errorlevel% equ 0 (
    echo   ✓ IN USE
) else (
    echo   ✗ NOT IN USE
)

echo Checking port 9090 (Prometheus)...
netstat -an | findstr ":9090" >nul
if %errorlevel% equ 0 (
    echo   ✓ IN USE
) else (
    echo   ✗ NOT IN USE
)

echo Checking port 3000 (Grafana)...
netstat -an | findstr ":3000" >nul
if %errorlevel% equ 0 (
    echo   ✓ IN USE
) else (
    echo   ✗ NOT IN USE
)

echo.
echo 4. Checking service health endpoints...
echo ---------------------------------------

echo Checking Service Discovery health...
curl -s -f "http://localhost:8761/actuator/health" >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✓ HEALTHY
) else (
    echo   ✗ UNHEALTHY
)

echo Checking API Gateway health...
curl -s -f "http://localhost:8080/actuator/health" >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✓ HEALTHY
) else (
    echo   ✗ UNHEALTHY
)

echo Checking User Service health...
curl -s -f "http://localhost:8081/actuator/health" >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✓ HEALTHY
) else (
    echo   ✗ UNHEALTHY
)

echo Checking Application Service health...
curl -s -f "http://localhost:8082/actuator/health" >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✓ HEALTHY
) else (
    echo   ✗ UNHEALTHY
)

echo Checking Notification Service health...
curl -s -f "http://localhost:8083/actuator/health" >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✓ HEALTHY
) else (
    echo   ✗ UNHEALTHY
)

echo Checking File Service health...
curl -s -f "http://localhost:8084/actuator/health" >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✓ HEALTHY
) else (
    echo   ✗ UNHEALTHY
)

echo Checking Audit Service health...
curl -s -f "http://localhost:8085/actuator/health" >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✓ HEALTHY
) else (
    echo   ✗ UNHEALTHY
)

echo Checking Nginx health...
curl -s -f "http://localhost/health" >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✓ HEALTHY
) else (
    echo   ✗ UNHEALTHY
)

echo.
echo 5. Checking overall system health...
echo -------------------------------------

curl -s -f "http://localhost/health" >nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ Overall system is healthy
) else (
    echo ✗ Overall system health check failed
)

echo.
echo ========================================
echo Health Check Complete
echo ========================================
echo.

echo To view detailed logs:
echo   docker-compose logs -f [service-name]
echo.
echo To restart a service:
echo   docker-compose restart [service-name]
echo.
echo To stop all services:
echo   docker-compose down
echo.
echo To start all services:
echo   start-all-services.bat
echo.
pause
