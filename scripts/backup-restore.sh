#!/bin/bash

echo "========================================"
echo "Microservices Backup & Restore Script"
echo "========================================"
echo

# Configuration
BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="microservices_backup_$DATE"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to create backup directory
create_backup_dir() {
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
        echo "Created backup directory: $BACKUP_DIR"
    fi
}

# Function to backup databases
backup_databases() {
    echo "Backing up PostgreSQL databases..."
    
    local databases=(
        "postgres-users:medicalcare_users"
        "postgres-applications:medicalcare_applications"
        "postgres-notifications:medicalcare_notifications"
        "postgres-files:medicalcare_files"
        "postgres-audit:medicalcare_audit"
    )
    
    for db_info in "${databases[@]}"; do
        IFS=':' read -r container_name db_name <<< "$db_info"
        
        echo "  Backing up $db_name from $container_name..."
        
        if docker exec "$container_name" pg_dump -U postgres "$db_name" > "$BACKUP_DIR/${db_name}_${DATE}.sql"; then
            echo -e "    ${GREEN}✓ Successfully backed up $db_name${NC}"
        else
            echo -e "    ${RED}✗ Failed to backup $db_name${NC}"
            return 1
        fi
    done
    
    echo
}

# Function to backup file uploads
backup_files() {
    echo "Backing up file uploads..."
    
    if docker exec file-service tar -czf - -C /app/uploads . > "$BACKUP_DIR/file_uploads_${DATE}.tar.gz" 2>/dev/null; then
        echo -e "  ${GREEN}✓ Successfully backed up file uploads${NC}"
    else
        echo -e "  ${YELLOW}⚠ No file uploads to backup or backup failed${NC}"
    fi
    
    echo
}

# Function to backup Redis data
backup_redis() {
    echo "Backing up Redis data..."
    
    if docker exec redis redis-cli SAVE > /dev/null 2>&1; then
        if docker cp redis:/data/dump.rdb "$BACKUP_DIR/redis_${DATE}.rdb"; then
            echo -e "  ${GREEN}✓ Successfully backed up Redis data${NC}"
        else
            echo -e "  ${YELLOW}⚠ Redis backup failed${NC}"
        fi
    else
        echo -e "  ${YELLOW}⚠ Redis backup failed${NC}"
    fi
    
    echo
}

# Function to backup configuration files
backup_configs() {
    echo "Backing up configuration files..."
    
    # Create config backup directory
    mkdir -p "$BACKUP_DIR/configs_${DATE}"
    
    # Copy important configuration files
    cp docker-compose.yml "$BACKUP_DIR/configs_${DATE}/"
    cp -r infrastructure "$BACKUP_DIR/configs_${DATE}/"
    cp -r monitoring "$BACKUP_DIR/configs_${DATE}/"
    cp -r scripts "$BACKUP_DIR/configs_${DATE}/"
    
    echo -e "  ${GREEN}✓ Successfully backed up configuration files${NC}"
    echo
}

# Function to create backup archive
create_backup_archive() {
    echo "Creating backup archive..."
    
    cd "$BACKUP_DIR"
    if tar -czf "${BACKUP_NAME}.tar.gz" \
        *${DATE}* \
        --exclude="*.tar.gz" \
        2>/dev/null; then
        
        echo -e "  ${GREEN}✓ Successfully created backup archive: ${BACKUP_NAME}.tar.gz${NC}"
        
        # Clean up individual backup files
        rm -rf *${DATE}*
        echo "  Cleaned up individual backup files"
    else
        echo -e "  ${RED}✗ Failed to create backup archive${NC}"
        return 1
    fi
    
    cd - > /dev/null
    echo
}

# Function to restore database
restore_database() {
    local backup_file=$1
    local container_name=$2
    local db_name=$3
    
    echo "Restoring $db_name from $backup_file..."
    
    if docker exec -i "$container_name" psql -U postgres "$db_name" < "$backup_file"; then
        echo -e "  ${GREEN}✓ Successfully restored $db_name${NC}"
        return 0
    else
        echo -e "  ${RED}✗ Failed to restore $db_name${NC}"
        return 1
    fi
}

# Function to restore from backup
restore_from_backup() {
    local backup_file=$1
    
    if [ ! -f "$backup_file" ]; then
        echo -e "${RED}Error: Backup file '$backup_file' not found${NC}"
        exit 1
    fi
    
    echo "Restoring from backup: $backup_file"
    echo "WARNING: This will overwrite existing data!"
    echo
    
    read -p "Are you sure you want to continue? (yes/no): " confirm
    if [ "$confirm" != "yes" ]; then
        echo "Restore cancelled."
        exit 0
    fi
    
    echo
    echo "Extracting backup..."
    
    # Create temporary restore directory
    local restore_dir="./restore_temp_$DATE"
    mkdir -p "$restore_dir"
    
    if tar -xzf "$backup_file" -C "$restore_dir"; then
        echo "✓ Backup extracted successfully"
    else
        echo -e "${RED}✗ Failed to extract backup${NC}"
        rm -rf "$restore_dir"
        exit 1
    fi
    
    echo
    echo "Restoring databases..."
    
    # Find and restore database backups
    local db_backups=($(find "$restore_dir" -name "*_*.sql" -type f))
    
    for backup in "${db_backups[@]}"; do
        local filename=$(basename "$backup")
        
        case "$filename" in
            *medicalcare_users*)
                restore_database "$backup" "postgres-users" "medicalcare_users"
                ;;
            *medicalcare_applications*)
                restore_database "$backup" "postgres-applications" "medicalcare_applications"
                ;;
            *medicalcare_notifications*)
                restore_database "$backup" "postgres-notifications" "medicalcare_notifications"
                ;;
            *medicalcare_files*)
                restore_database "$backup" "postgres-files" "medicalcare_files"
                ;;
            *medicalcare_audit*)
                restore_database "$backup" "postgres-audit" "medicalcare_audit"
                ;;
        esac
    done
    
    echo
    echo "Restoring file uploads..."
    
    # Find and restore file uploads
    local file_backup=$(find "$restore_dir" -name "*file_uploads*.tar.gz" -type f)
    if [ -n "$file_backup" ]; then
        if docker exec -i file-service tar -xzf - -C /app/uploads < "$file_backup"; then
            echo -e "  ${GREEN}✓ Successfully restored file uploads${NC}"
        else
            echo -e "  ${YELLOW}⚠ File uploads restore failed${NC}"
        fi
    fi
    
    echo
    echo "Restoring Redis data..."
    
    # Find and restore Redis data
    local redis_backup=$(find "$restore_dir" -name "*redis*.rdb" -type f)
    if [ -n "$redis_backup" ]; then
        if docker cp "$redis_backup" redis:/data/dump.rdb; then
            echo -e "  ${GREEN}✓ Successfully restored Redis data${NC}"
        else
            echo -e "  ${YELLOW}⚠ Redis restore failed${NC}"
        fi
    fi
    
    echo
    echo "Cleaning up temporary files..."
    rm -rf "$restore_dir"
    
    echo -e "${GREEN}✓ Restore completed successfully!${NC}"
}

# Function to list available backups
list_backups() {
    echo "Available backups:"
    echo "------------------"
    
    if [ ! -d "$BACKUP_DIR" ] || [ -z "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]; then
        echo "No backups found."
        return
    fi
    
    local backups=($(ls -t "$BACKUP_DIR"/*.tar.gz 2>/dev/null))
    
    if [ ${#backups[@]} -eq 0 ]; then
        echo "No backup archives found."
        return
    fi
    
    for backup in "${backups[@]}"; do
        local filename=$(basename "$backup")
        local size=$(du -h "$backup" | cut -f1)
        local date=$(echo "$filename" | grep -o '[0-9]\{8\}_[0-9]\{6\}')
        local formatted_date=$(date -d "${date:0:8} ${date:9:2}:${date:11:2}:${date:13:2}" "+%Y-%m-%d %H:%M:%S" 2>/dev/null || echo "Unknown date")
        
        echo "$formatted_date - $filename ($size)"
    done
    
    echo
}

# Function to show help
show_help() {
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo
    echo "Commands:"
    echo "  backup              Create a complete backup of all services"
    echo "  restore FILE        Restore from a backup file"
    echo "  list                List available backups"
    echo "  help                Show this help message"
    echo
    echo "Examples:"
    echo "  $0 backup                           # Create a new backup"
    echo "  $0 restore backups/backup_file.tar.gz # Restore from backup"
    echo "  $0 list                             # List available backups"
    echo
}

# Main script logic
case "${1:-help}" in
    backup)
        echo "Starting backup process..."
        echo
        
        create_backup_dir
        backup_databases
        backup_files
        backup_redis
        backup_configs
        create_backup_archive
        
        echo -e "${GREEN}✓ Backup completed successfully!${NC}"
        echo "Backup location: $BACKUP_DIR/${BACKUP_NAME}.tar.gz"
        ;;
        
    restore)
        if [ -z "$2" ]; then
            echo -e "${RED}Error: Please specify a backup file to restore from${NC}"
            echo "Usage: $0 restore <backup_file>"
            exit 1
        fi
        
        restore_from_backup "$2"
        ;;
        
    list)
        list_backups
        ;;
        
    help|*)
        show_help
        exit 0
        ;;
esac

echo
echo "========================================"
echo "Backup & Restore Script Complete"
echo "========================================"
