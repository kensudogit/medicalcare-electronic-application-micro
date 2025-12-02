#!/bin/bash

echo "========================================"
echo "Medical Care Microservices Startup Script"
echo "========================================"
echo

echo "Checking Docker status..."
if ! command -v docker &> /dev/null; then
    echo "ERROR: Docker is not installed!"
    echo "Please install Docker and try again."
    exit 1
fi

if ! docker info &> /dev/null; then
    echo "ERROR: Docker is not running!"
    echo "Please start Docker and try again."
    exit 1
fi

echo "Docker is running."
echo

echo "Checking if ports are available..."
if lsof -Pi :8761 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo "WARNING: Port 8761 (Service Discovery) is already in use!"
    echo "Please stop any existing services using this port."
    read -p "Press Enter to continue..."
fi

if lsof -Pi :8080 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo "WARNING: Port 8080 (API Gateway) is already in use!"
    echo "Please stop any existing services using this port."
    read -p "Press Enter to continue..."
fi

echo "Ports are available."
echo

echo "Starting all microservices..."
echo "This may take a few minutes on first run..."
echo

echo "Starting infrastructure services..."
docker-compose up -d postgres-users postgres-applications postgres-notifications postgres-files postgres-audit redis

echo "Waiting for databases to be ready..."
sleep 10

echo "Starting service discovery..."
docker-compose up -d service-discovery

echo "Waiting for service discovery to be ready..."
sleep 15

echo "Starting microservices..."
docker-compose up -d user-service application-service notification-service file-service audit-service

echo "Waiting for microservices to be ready..."
sleep 20

echo "Starting API Gateway..."
docker-compose up -d api-gateway

echo "Waiting for API Gateway to be ready..."
sleep 10

echo "Starting monitoring services..."
docker-compose up -d prometheus grafana

echo "Waiting for monitoring services to be ready..."
sleep 15

echo "Starting Nginx load balancer..."
docker-compose up -d nginx

echo
echo "========================================"
echo "All services are starting up!"
echo "========================================"
echo
echo "Service URLs:"
echo "- Service Discovery: http://localhost:8761"
echo "- API Gateway: http://localhost:8080"
echo "- User Service: http://localhost:8081"
echo "- Application Service: http://localhost:8082"
echo "- Notification Service: http://localhost:8083"
echo "- File Service: http://localhost:8084"
echo "- Audit Service: http://localhost:8085"
echo "- Prometheus: http://localhost:9090"
echo "- Grafana: http://localhost:3000 (admin/admin)"
echo "- Nginx: http://localhost:80"
echo
echo "Health Check: http://localhost/health"
echo
echo "To view logs: docker-compose logs -f [service-name]"
echo "To stop all: docker-compose down"
echo
read -p "Press Enter to continue..."
