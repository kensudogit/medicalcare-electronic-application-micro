#!/bin/bash

echo "========================================"
echo "Microservices Log Viewer"
echo "========================================"
echo

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to show available services
show_services() {
    echo "Available services:"
    echo "-------------------"
    echo -e "${BLUE}Core Services:${NC}"
    echo "  service-discovery    - Eureka Service Discovery"
    echo "  api-gateway         - Spring Cloud Gateway"
    echo "  user-service        - User Management"
    echo "  application-service - Medical Applications"
    echo "  notification-service - Notifications"
    echo "  file-service        - File Management"
    echo "  audit-service       - Audit Logging"
    echo
    echo -e "${BLUE}Infrastructure:${NC}"
    echo "  nginx               - Load Balancer"
    echo "  prometheus          - Metrics Collection"
    echo "  grafana             - Monitoring Dashboard"
    echo
    echo -e "${BLUE}Databases:${NC}"
    echo "  postgres-users      - Users Database"
    echo "  postgres-applications - Applications Database"
    echo "  postgres-notifications - Notifications Database"
    echo "  postgres-files      - Files Database"
    echo "  postgres-audit      - Audit Database"
    echo "  redis               - Cache Database"
    echo
}

# Function to show log options
show_log_options() {
    echo "Log viewing options:"
    echo "-------------------"
    echo "  -f, --follow        Follow log output (real-time)"
    echo "  --tail=N            Show last N lines (default: 100)"
    echo "  --since=TIME        Show logs since TIME (e.g., 1h, 30m, 2d)"
    echo "  --until=TIME        Show logs until TIME"
    echo "  --grep=PATTERN      Filter logs by pattern"
    echo "  --error             Show only error logs"
    echo "  --warning           Show only warning logs"
    echo "  --info              Show only info logs"
    echo
}

# Function to show help
show_help() {
    echo "Usage: $0 [OPTIONS] [SERVICE]"
    echo
    echo "Options:"
    echo "  -f, --follow        Follow log output"
    echo "  -t, --tail N        Show last N lines (default: 100)"
    echo "  -s, --since TIME    Show logs since TIME"
    echo "  -u, --until TIME    Show logs until TIME"
    echo "  -g, --grep PATTERN  Filter logs by pattern"
    echo "  -e, --error         Show only error logs"
    echo "  -w, --warning       Show only warning logs"
    echo "  -i, --info          Show only info logs"
    echo "  -l, --list          List available services"
    echo "  -h, --help          Show this help message"
    echo
    echo "Examples:"
    echo "  $0 user-service                    # Show last 100 lines"
    echo "  $0 -f user-service                # Follow logs in real-time"
    echo "  $0 -t 50 user-service             # Show last 50 lines"
    echo "  $0 -s 1h user-service             # Show logs from last hour"
    echo "  $0 -g 'ERROR' user-service        # Show error logs"
    echo "  $0 -e user-service                # Show only error logs"
    echo "  $0 -l                             # List available services"
    echo
}

# Function to get log level filter
get_log_level_filter() {
    local level=""
    
    if [ "$ERROR_ONLY" = true ]; then
        level="ERROR"
    elif [ "$WARNING_ONLY" = true ]; then
        level="WARNING"
    elif [ "$INFO_ONLY" = true ]; then
        level="INFO"
    fi
    
    echo "$level"
}

# Function to view logs
view_logs() {
    local service_name=$1
    local follow_flag=""
    local tail_lines="100"
    local since_time=""
    local until_time=""
    local grep_pattern=""
    local log_level=$(get_log_level_filter)
    
    # Build docker-compose logs command
    local cmd="docker-compose logs"
    
    if [ "$FOLLOW" = true ]; then
        cmd="$cmd -f"
    fi
    
    if [ -n "$tail_lines" ]; then
        cmd="$cmd --tail=$tail_lines"
    fi
    
    if [ -n "$since_time" ]; then
        cmd="$cmd --since=$since_time"
    fi
    
    if [ -n "$until_time" ]; then
        cmd="$cmd --until=$until_time"
    fi
    
    cmd="$cmd $service_name"
    
    echo -e "${BLUE}Viewing logs for: $service_name${NC}"
    echo "Command: $cmd"
    echo "----------------------------------------"
    echo
    
    # Execute the command
    if [ -n "$grep_pattern" ]; then
        eval "$cmd" | grep -i "$grep_pattern"
    elif [ -n "$log_level" ]; then
        eval "$cmd" | grep -i "$log_level"
    else
        eval "$cmd"
    fi
}

# Function to show service status
show_service_status() {
    echo "Service Status:"
    echo "---------------"
    docker-compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"
    echo
}

# Function to show recent errors across all services
show_recent_errors() {
    echo "Recent Errors Across All Services:"
    echo "----------------------------------"
    
    local services=("service-discovery" "api-gateway" "user-service" "application-service" "notification-service" "file-service" "audit-service")
    
    for service in "${services[@]}"; do
        echo -e "${BLUE}=== $service ===${NC}"
        docker-compose logs --tail=20 "$service" | grep -i "error\|exception\|failed" | tail -5
        echo
    done
}

# Function to show service performance
show_service_performance() {
    echo "Service Performance Overview:"
    echo "-----------------------------"
    
    echo -e "${BLUE}Container Resource Usage:${NC}"
    docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"
    echo
    
    echo -e "${BLUE}Service Response Times:${NC}"
    echo "Checking health endpoints..."
    
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
        
        echo -n "  $service_name: "
        if curl -s -f "$url" > /dev/null 2>&1; then
            echo -e "${GREEN}✓ Healthy${NC}"
        else
            echo -e "${RED}✗ Unhealthy${NC}"
        fi
    done
}

# Initialize variables
FOLLOW=false
TAIL_LINES=100
SINCE_TIME=""
UNTIL_TIME=""
GREP_PATTERN=""
ERROR_ONLY=false
WARNING_ONLY=false
INFO_ONLY=false
SERVICE_NAME=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--follow)
            FOLLOW=true
            shift
            ;;
        -t|--tail)
            TAIL_LINES="$2"
            shift 2
            ;;
        -s|--since)
            SINCE_TIME="$2"
            shift 2
            ;;
        -u|--until)
            UNTIL_TIME="$2"
            shift 2
            ;;
        -g|--grep)
            GREP_PATTERN="$2"
            shift 2
            ;;
        -e|--error)
            ERROR_ONLY=true
            shift
            ;;
        -w|--warning)
            WARNING_ONLY=true
            shift
            ;;
        -i|--info)
            INFO_ONLY=true
            shift
            ;;
        -l|--list)
            show_services
            exit 0
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        -*)
            echo -e "${RED}Error: Unknown option $1${NC}"
            show_help
            exit 1
            ;;
        *)
            if [ -z "$SERVICE_NAME" ]; then
                SERVICE_NAME="$1"
            else
                echo -e "${RED}Error: Multiple services specified${NC}"
                exit 1
            fi
            shift
            ;;
    esac
    shift
done

# Main script logic
if [ -z "$SERVICE_NAME" ]; then
    echo "No service specified. Use -l to list available services."
    echo
    show_help
    exit 1
fi

# Validate service name
local valid_services=(
    "service-discovery" "api-gateway" "user-service" "application-service" 
    "notification-service" "file-service" "audit-service" "nginx" 
    "prometheus" "grafana" "postgres-users" "postgres-applications" 
    "postgres-notifications" "postgres-files" "postgres-audit" "redis"
)

local valid=false
for service in "${valid_services[@]}"; do
    if [ "$service" = "$SERVICE_NAME" ]; then
        valid=true
        break
    fi
done

if [ "$valid" = false ]; then
    echo -e "${RED}Error: Invalid service name '$SERVICE_NAME'${NC}"
    echo
    show_services
    exit 1
fi

# Check if service is running
if ! docker-compose ps --format "table {{.Name}}" | grep -q "^$SERVICE_NAME$"; then
    echo -e "${RED}Error: Service '$SERVICE_NAME' is not running${NC}"
    echo
    show_service_status
    exit 1
fi

# Show log options if no specific options are set
if [ "$FOLLOW" = false ] && [ -z "$GREP_PATTERN" ] && [ "$ERROR_ONLY" = false ] && [ "$WARNING_ONLY" = false ] && [ "$INFO_ONLY" = false ]; then
    echo "Showing logs for: $SERVICE_NAME"
    echo "Use -h for more options"
    echo
fi

# View the logs
view_logs "$SERVICE_NAME"

echo
echo "========================================"
echo "Log viewing complete"
echo "========================================"
echo
echo "Additional commands:"
echo "  docker-compose logs -f $SERVICE_NAME          # Follow logs"
echo "  docker-compose logs --tail=50 $SERVICE_NAME   # Last 50 lines"
echo "  docker-compose logs --since=1h $SERVICE_NAME  # Last hour"
echo "  docker-compose logs $SERVICE_NAME | grep ERROR # Filter errors"
echo
echo "To check service status: docker-compose ps"
echo "To restart service: docker-compose restart $SERVICE_NAME"
