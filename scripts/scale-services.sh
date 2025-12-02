#!/bin/bash

echo "========================================"
echo "Microservices Scaling Script"
echo "========================================"
echo

# Function to show current scaling
show_current_scaling() {
    echo "Current service scaling:"
    echo "------------------------"
    
    local services=("user-service" "application-service" "notification-service" "file-service" "audit-service")
    
    for service in "${services[@]}"; do
        local count=$(docker-compose ps --format "table {{.Name}}" | grep -c "$service")
        echo "$service: $count instance(s)"
    done
    
    echo
}

# Function to scale a service
scale_service() {
    local service_name=$1
    local instances=$2
    
    echo "Scaling $service_name to $instances instance(s)..."
    
    if docker-compose up -d --scale "$service_name=$instances"; then
        echo "✓ Successfully scaled $service_name to $instances instance(s)"
    else
        echo "✗ Failed to scale $service_name"
        return 1
    fi
    
    echo
}

# Function to show scaling options
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  -s, --service SERVICE    Service to scale (user-service, application-service, etc.)"
    echo "  -i, --instances NUM      Number of instances (1-5)"
    echo "  -a, --all NUM            Scale all services to specified number of instances"
    echo "  -c, --current            Show current scaling status"
    echo "  -h, --help               Show this help message"
    echo
    echo "Examples:"
    echo "  $0 -s user-service -i 3          # Scale user-service to 3 instances"
    echo "  $0 -a 2                          # Scale all services to 2 instances"
    echo "  $0 -c                            # Show current scaling status"
    echo
}

# Main script logic
if [ $# -eq 0 ]; then
    show_help
    exit 1
fi

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--service)
            SERVICE_NAME="$2"
            shift 2
            ;;
        -i|--instances)
            INSTANCES="$2"
            shift 2
            ;;
        -a|--all)
            ALL_INSTANCES="$2"
            shift 2
            ;;
        -c|--current)
            show_current_scaling
            exit 0
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Validate inputs
if [ -n "$ALL_INSTANCES" ]; then
    if ! [[ "$ALL_INSTANCES" =~ ^[1-5]$ ]]; then
        echo "Error: All instances must be between 1 and 5"
        exit 1
    fi
    
    echo "Scaling all services to $ALL_INSTANCES instance(s)..."
    echo
    
    local services=("user-service" "application-service" "notification-service" "file-service" "audit-service")
    
    for service in "${services[@]}"; do
        scale_service "$service" "$ALL_INSTANCES"
    done
    
    echo "All services scaled successfully!"
    
elif [ -n "$SERVICE_NAME" ] && [ -n "$INSTANCES" ]; then
    if ! [[ "$INSTANCES" =~ ^[1-5]$ ]]; then
        echo "Error: Instances must be between 1 and 5"
        exit 1
    fi
    
    # Validate service name
    local valid_services=("user-service" "application-service" "notification-service" "file-service" "audit-service")
    local valid=false
    
    for service in "${valid_services[@]}"; do
        if [ "$service" = "$SERVICE_NAME" ]; then
            valid=true
            break
        fi
    done
    
    if [ "$valid" = false ]; then
        echo "Error: Invalid service name '$SERVICE_NAME'"
        echo "Valid services: ${valid_services[*]}"
        exit 1
    fi
    
    scale_service "$SERVICE_NAME" "$INSTANCES"
    
else
    echo "Error: Missing required arguments"
    show_help
    exit 1
fi

echo
echo "Current scaling status:"
show_current_scaling

echo "Note: After scaling, you may need to wait a few moments for services to fully start up."
echo "Use 'docker-compose ps' to check service status."
echo "Use 'docker-compose logs -f [service-name]' to monitor service logs."
