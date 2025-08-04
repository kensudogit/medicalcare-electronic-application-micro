#!/bin/bash

# Microservices Performance Monitor
# This script monitors the performance of all microservices

echo "=== Medical Care Microservices Performance Monitor ==="
echo "Timestamp: $(date)"
echo ""

# Function to check service health
check_service_health() {
    local service_name=$1
    local port=$2
    local url="http://localhost:${port}/actuator/health"
    
    echo "Checking ${service_name} (Port: ${port})..."
    if curl -s -f "$url" > /dev/null; then
        echo "  ✅ ${service_name} is healthy"
        return 0
    else
        echo "  ❌ ${service_name} is unhealthy"
        return 1
    fi
}

# Function to check service metrics
check_service_metrics() {
    local service_name=$1
    local port=$2
    local url="http://localhost:${port}/actuator/metrics"
    
    echo "  📊 Metrics available at: ${url}"
}

# Check all services
services=(
    "Service Discovery:8761"
    "API Gateway:8080"
    "User Service:8081"
    "Application Service:8082"
    "Notification Service:8083"
    "File Service:8084"
)

healthy_count=0
total_count=${#services[@]}

for service in "${services[@]}"; do
    IFS=':' read -r name port <<< "$service"
    if check_service_health "$name" "$port"; then
        ((healthy_count++))
        check_service_metrics "$name" "$port"
    fi
    echo ""
done

# Check Eureka Dashboard
echo "=== Eureka Service Registry ==="
if curl -s -f "http://localhost:8761" > /dev/null; then
    echo "✅ Eureka Dashboard: http://localhost:8761"
else
    echo "❌ Eureka Dashboard is not accessible"
fi

# Check Nginx
echo ""
echo "=== Load Balancer (Nginx) ==="
if curl -s -f "http://localhost/health" > /dev/null; then
    echo "✅ Nginx Load Balancer: http://localhost"
else
    echo "❌ Nginx Load Balancer is not accessible"
fi

# System Resources
echo ""
echo "=== System Resources ==="
echo "CPU Usage:"
top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1

echo "Memory Usage:"
free -h | grep -E "Mem|Swap"

echo "Disk Usage:"
df -h | grep -E "/dev/"

# Docker Container Status
echo ""
echo "=== Docker Container Status ==="
docker-compose ps

# Summary
echo ""
echo "=== Summary ==="
echo "Healthy Services: ${healthy_count}/${total_count}"
echo "Health Rate: $((healthy_count * 100 / total_count))%"

if [ $healthy_count -eq $total_count ]; then
    echo "🎉 All services are healthy!"
    exit 0
else
    echo "⚠️  Some services are unhealthy. Check logs for details."
    exit 1
fi 