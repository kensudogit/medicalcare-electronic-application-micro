#!/bin/bash

echo "========================================"
echo "Microservices System Information"
echo "========================================"
echo

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print section header
print_section() {
    local title=$1
    echo -e "${BLUE}=== $title ===${NC}"
    echo
}

# Function to print subsection header
print_subsection() {
    local title=$1
    echo -e "${CYAN}--- $title ---${NC}"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to get Docker version
get_docker_info() {
    print_section "Docker Information"
    
    if command_exists docker; then
        echo -e "${GREEN}Docker Version:${NC}"
        docker --version
        echo
        
        echo -e "${GREEN}Docker Compose Version:${NC}"
        if command_exists docker-compose; then
            docker-compose --version
        else
            echo -e "${YELLOW}Docker Compose not found${NC}"
        fi
        echo
        
        echo -e "${GREEN}Docker Daemon Status:${NC}"
        if docker info >/dev/null 2>&1; then
            echo -e "${GREEN}✓ Docker daemon is running${NC}"
        else
            echo -e "${RED}✗ Docker daemon is not running${NC}"
        fi
    else
        echo -e "${RED}Docker is not installed${NC}"
    fi
    echo
}

# Function to get system information
get_system_info() {
    print_section "System Information"
    
    echo -e "${GREEN}Operating System:${NC}"
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        cat /etc/os-release | grep "PRETTY_NAME" | cut -d'"' -f2
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        sw_vers -productName
        sw_vers -productVersion
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        echo "Windows"
    else
        echo "Unknown OS: $OSTYPE"
    fi
    echo
    
    echo -e "${GREEN}Kernel Version:${NC}"
    uname -r
    echo
    
    echo -e "${GREEN}Architecture:${NC}"
    uname -m
    echo
    
    echo -e "${GREEN}Hostname:${NC}"
    hostname
    echo
    
    echo -e "${GREEN}Current User:${NC}"
    whoami
    echo
}

# Function to get resource usage
get_resource_usage() {
    print_section "Resource Usage"
    
    print_subsection "Memory Usage"
    if command_exists free; then
        free -h
    else
        echo "Memory information not available"
    fi
    echo
    
    print_subsection "Disk Usage"
    if command_exists df; then
        df -h
    else
        echo "Disk information not available"
    fi
    echo
    
    print_subsection "CPU Information"
    if command_exists lscpu; then
        lscpu | grep -E "Model name|CPU\(s\)|Thread|Core"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        sysctl -n machdep.cpu.brand_string
        sysctl -n hw.ncpu
    else
        echo "CPU information not available"
    fi
    echo
}

# Function to get network information
get_network_info() {
    print_section "Network Information"
    
    print_subsection "Network Interfaces"
    if command_exists ip; then
        ip addr show | grep -E "inet|UP|DOWN"
    elif command_exists ifconfig; then
        ifconfig | grep -E "inet|UP|DOWN"
    else
        echo "Network information not available"
    fi
    echo
    
    print_subsection "Port Usage"
    if command_exists netstat; then
        echo "Checking ports used by microservices..."
        local ports=(8761 8080 8081 8082 8083 8084 8085 80 9090 3000 5433 5434 5435 5436 5437 6381)
        for port in "${ports[@]}"; do
            if netstat -an | grep -q ":$port "; then
                echo -e "  Port $port: ${GREEN}IN USE${NC}"
            else
                echo -e "  Port $port: ${YELLOW}NOT IN USE${NC}"
            fi
        done
    elif command_exists lsof; then
        echo "Checking ports used by microservices..."
        local ports=(8761 8080 8081 8082 8083 8084 8085 80 9090 3000 5433 5434 5435 5436 5437 6381)
        for port in "${ports[@]}"; do
            if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
                echo -e "  Port $port: ${GREEN}IN USE${NC}"
            else
                echo -e "  Port $port: ${YELLOW}NOT IN USE${NC}"
            fi
        done
    else
        echo "Port checking not available"
    fi
    echo
}

# Function to get Docker containers status
get_docker_status() {
    print_section "Docker Containers Status"
    
    if command_exists docker; then
        echo -e "${GREEN}Running Containers:${NC}"
        docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.Size}}"
        echo
        
        echo -e "${GREEN}All Containers (including stopped):${NC}"
        docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
        echo
        
        echo -e "${GREEN}Container Resource Usage:${NC}"
        docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"
        echo
    else
        echo "Docker not available"
    fi
}

# Function to get service health status
get_service_health() {
    print_section "Service Health Status"
    
    local services=(
        "service-discovery:8761/actuator/health"
        "api-gateway:8080/actuator/health"
        "user-service:8081/actuator/health"
        "application-service:8082/actuator/health"
        "notification-service:8083/actuator/health"
        "file-service:8084/actuator/health"
        "audit-service:8085/actuator/health"
        "nginx:80/health"
        "prometheus:9090/-/healthy"
        "grafana:3000/api/health"
    )
    
    for service_info in "${services[@]}"; do
        IFS=':' read -r service_name port_path <<< "$service_info"
        local url="http://localhost:$port_path"
        
        echo -n "  $service_name: "
        if curl -s -f "$url" > /dev/null 2>&1; then
            echo -e "${GREEN}✓ Healthy${NC}"
        else
            echo -e "${RED}✗ Unhealthy${NC}"
        fi
    done
    echo
}

# Function to get database information
get_database_info() {
    print_section "Database Information"
    
    print_subsection "PostgreSQL Databases"
    local databases=(
        "postgres-users:medicalcare_users:5433"
        "postgres-applications:medicalcare_applications:5434"
        "postgres-notifications:medicalcare_notifications:5435"
        "postgres-files:medicalcare_files:5436"
        "postgres-audit:medicalcare_audit:5437"
    )
    
    for db_info in "${databases[@]}"; do
        IFS=':' read -r container_name db_name port <<< "$db_info"
        
        echo -n "  $db_name ($container_name): "
        if docker ps --format "table {{.Names}}" | grep -q "^$container_name$"; then
            echo -e "${GREEN}✓ Running${NC}"
        else
            echo -e "${RED}✗ Not Running${NC}"
        fi
    done
    echo
    
    print_subsection "Redis Cache"
    if docker ps --format "table {{.Names}}" | grep -q "^redis$"; then
        echo -e "  Redis: ${GREEN}✓ Running${NC}"
    else
        echo -e "  Redis: ${RED}✗ Not Running${NC}"
    fi
    echo
}

# Function to get volume information
get_volume_info() {
    print_section "Docker Volumes"
    
    if command_exists docker; then
        echo -e "${GREEN}Named Volumes:${NC}"
        docker volume ls --format "table {{.Name}}\t{{.Driver}}"
        echo
        
        echo -e "${GREEN}Volume Usage:${NC}"
        docker system df -v | grep -A 20 "VOLUMES"
        echo
    else
        echo "Docker not available"
    fi
}

# Function to get environment information
get_environment_info() {
    print_section "Environment Information"
    
    echo -e "${GREEN}Java Version:${NC}"
    if command_exists java; then
        java -version 2>&1 | head -1
    else
        echo "Java not found"
    fi
    echo
    
    echo -e "${GREEN}Gradle Version:${NC}"
    if command_exists gradle; then
        gradle --version | head -1
    else
        echo "Gradle not found"
    fi
    echo
    
    echo -e "${GREEN}Node.js Version:${NC}"
    if command_exists node; then
        node --version
    else
        echo "Node.js not found"
    fi
    echo
    
    echo -e "${GREEN}NPM Version:${NC}"
    if command_exists npm; then
        npm --version
    else
        echo "NPM not found"
    fi
    echo
    
    echo -e "${GREEN}Git Version:${NC}"
    if command_exists git; then
        git --version
    else
        echo "Git not found"
    fi
    echo
}

# Function to get configuration files
get_config_info() {
    print_section "Configuration Files"
    
    local config_files=(
        "docker-compose.yml"
        "infrastructure/nginx/nginx.conf"
        "infrastructure/postgres/postgresql.conf"
        "monitoring/prometheus.yml"
        "monitoring/grafana-dashboard.json"
    )
    
    for config_file in "${config_files[@]}"; do
        if [ -f "$config_file" ]; then
            echo -e "  $config_file: ${GREEN}✓ Exists${NC}"
        else
            echo -e "  $config_file: ${RED}✗ Missing${NC}"
        fi
    done
    echo
}

# Function to get script information
get_script_info() {
    print_section "Available Scripts"
    
    local scripts=(
        "start-all-services.sh"
        "start-all-services.bat"
        "scripts/health-check.sh"
        "scripts/health-check.bat"
        "scripts/scale-services.sh"
        "scripts/backup-restore.sh"
        "scripts/service-logs.sh"
        "scripts/service-logs.bat"
        "scripts/system-info.sh"
        "scripts/performance-monitor.sh"
    )
    
    for script in "${scripts[@]}"; do
        if [ -f "$script" ]; then
            if [ -x "$script" ] || [[ "$script" == *.bat ]]; then
                echo -e "  $script: ${GREEN}✓ Available${NC}"
            else
                echo -e "  $script: ${YELLOW}⚠ Not Executable${NC}"
            fi
        else
            echo -e "  $script: ${RED}✗ Missing${NC}"
        fi
    done
    echo
}

# Function to get summary
get_summary() {
    print_section "System Summary"
    
    local total_services=7
    local running_services=0
    local healthy_services=0
    
    # Count running services
    if command_exists docker; then
        running_services=$(docker ps --format "table {{.Names}}" | grep -E "(service-discovery|api-gateway|user-service|application-service|notification-service|file-service|audit-service)" | wc -l)
    fi
    
    # Count healthy services
    local services=(
        "service-discovery:8761/actuator/health"
        "api-gateway:8080/actuator/health"
        "user-service:8081/actuator/health"
        "application-service:8082/actuator/health"
        "notification-service:8083/actuator/health"
        "file-service:8084/actuator/health"
        "audit-service:8085/actuator/health"
    )
    
    for service_info in "${services[@]}"; do
        IFS=':' read -r service_name port_path <<< "$service_info"
        local url="http://localhost:$port_path"
        if curl -s -f "$url" > /dev/null 2>&1; then
            ((healthy_services++))
        fi
    done
    
    echo -e "${GREEN}Microservices Status:${NC}"
    echo "  Total Services: $total_services"
    echo "  Running Services: $running_services"
    echo "  Healthy Services: $healthy_services"
    echo
    
    if [ $running_services -eq $total_services ] && [ $healthy_services -eq $total_services ]; then
        echo -e "${GREEN}✓ All services are running and healthy${NC}"
    elif [ $running_services -eq $total_services ]; then
        echo -e "${YELLOW}⚠ All services are running but some are unhealthy${NC}"
    else
        echo -e "${RED}✗ Some services are not running${NC}"
    fi
    echo
}

# Main execution
main() {
    get_docker_info
    get_system_info
    get_resource_usage
    get_network_info
    get_docker_status
    get_service_health
    get_database_info
    get_volume_info
    get_environment_info
    get_config_info
    get_script_info
    get_summary
    
    echo "========================================"
    echo "System Information Complete"
    echo "========================================"
    echo
    echo "For detailed logs: ./scripts/service-logs.sh [service-name]"
    echo "For health checks: ./scripts/health-check.sh"
    echo "For service scaling: ./scripts/scale-services.sh -h"
    echo "For backup/restore: ./scripts/backup-restore.sh -h"
    echo
}

# Run main function
main
