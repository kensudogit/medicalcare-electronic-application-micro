#!/bin/bash

echo "========================================"
echo "Microservices Health Check"
echo "========================================"
echo

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check service health
check_service() {
    local service_name=$1
    local url=$2
    local description=$3
    
    echo -n "Checking $service_name ($description)... "
    
    if curl -s -f "$url" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ HEALTHY${NC}"
        return 0
    else
        echo -e "${RED}✗ UNHEALTHY${NC}"
        return 1
    fi
}

# Function to check Docker container status
check_container() {
    local container_name=$1
    local description=$2
    
    echo -n "Checking $container_name ($description)... "
    
    if docker ps --format "table {{.Names}}\t{{.Status}}" | grep -q "$container_name.*Up"; then
        echo -e "${GREEN}✓ RUNNING${NC}"
        return 0
    else
        echo -e "${RED}✗ NOT RUNNING${NC}"
        return 1
    fi
}

# Function to check port availability
check_port() {
    local port=$1
    local service_name=$2
    
    echo -n "Checking port $port ($service_name)... "
    
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo -e "${GREEN}✓ IN USE${NC}"
        return 0
    else
        echo -e "${RED}✗ NOT IN USE${NC}"
        return 1
    fi
}

echo "1. Checking Docker containers..."
echo "--------------------------------"

check_container "service-discovery" "Service Discovery"
check_container "api-gateway" "API Gateway"
check_container "user-service" "User Service"
check_container "application-service" "Application Service"
check_container "notification-service" "Notification Service"
check_container "file-service" "File Service"
check_container "audit-service" "Audit Service"
check_container "nginx" "Nginx Load Balancer"
check_container "prometheus" "Prometheus"
check_container "grafana" "Grafana"

echo
echo "2. Checking database containers..."
echo "----------------------------------"

check_container "postgres-users" "PostgreSQL Users"
check_container "postgres-applications" "PostgreSQL Applications"
check_container "postgres-notifications" "PostgreSQL Notifications"
check_container "postgres-files" "PostgreSQL Files"
check_container "postgres-audit" "PostgreSQL Audit"
check_container "redis" "Redis Cache"

echo
echo "3. Checking service health endpoints..."
echo "---------------------------------------"

check_service "Service Discovery" "http://localhost:8761/actuator/health" "Eureka Server"
check_service "API Gateway" "http://localhost:8080/actuator/health" "Spring Cloud Gateway"
check_service "User Service" "http://localhost:8081/actuator/health" "User Management"
check_service "Application Service" "http://localhost:8082/actuator/health" "Medical Applications"
check_service "Notification Service" "http://localhost:8083/actuator/health" "Notifications"
check_service "File Service" "http://localhost:8084/actuator/health" "File Management"
check_service "Audit Service" "http://localhost:8085/actuator/health" "Audit Logging"
check_service "Nginx" "http://localhost/health" "Load Balancer"
check_service "Prometheus" "http://localhost:9090/-/healthy" "Metrics Collection"
check_service "Grafana" "http://localhost:3000/api/health" "Monitoring Dashboard"

echo
echo "4. Checking port availability..."
echo "--------------------------------"

check_port "8761" "Service Discovery"
check_port "8080" "API Gateway"
check_port "8081" "User Service"
check_port "8082" "Application Service"
check_port "8083" "Notification Service"
check_port "8084" "File Service"
check_port "8085" "Audit Service"
check_port "80" "Nginx"
check_port "9090" "Prometheus"
check_port "3000" "Grafana"
check_port "5433" "PostgreSQL Users"
check_port "5434" "PostgreSQL Applications"
check_port "5435" "PostgreSQL Notifications"
check_port "5436" "PostgreSQL Files"
check_port "5437" "PostgreSQL Audit"
check_port "6381" "Redis"

echo
echo "5. Checking service discovery registration..."
echo "---------------------------------------------"

if curl -s "http://localhost:8761/eureka/apps" > /dev/null 2>&1; then
    echo "Service Discovery is accessible"
    
    # Check registered services
    echo "Registered services:"
    curl -s "http://localhost:8761/eureka/apps" | grep -o '<instance><hostName>[^<]*</hostName>' | sed 's/<[^>]*>//g' | sort | uniq
else
    echo -e "${RED}Service Discovery is not accessible${NC}"
fi

echo
echo "6. Checking overall system health..."
echo "------------------------------------"

if curl -s -f "http://localhost/health" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Overall system is healthy${NC}"
else
    echo -e "${RED}✗ Overall system health check failed${NC}"
fi

echo
echo "========================================"
echo "Health Check Complete"
echo "========================================"
echo

# Summary
echo "To view detailed logs:"
echo "  docker-compose logs -f [service-name]"
echo
echo "To restart a service:"
echo "  docker-compose restart [service-name]"
echo
echo "To stop all services:"
echo "  docker-compose down"
echo
echo "To start all services:"
echo "  ./start-all-services.sh"
