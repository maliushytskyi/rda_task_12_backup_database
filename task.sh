#!/bin/bash

### task.sh
### Backup and restore procedure for ShopDB database

set -e

# 1. Read database credentials from environment variables
if [ -z "$DB_USER" ] || [ -z "$DB_PASSWORD" ]; then
    echo "Error: DB_USER and DB_PASSWORD environment variables must be set"
    exit 1
fi

# 2. Full backup of ShopDB, restored to ShopDBReserve
echo "INFO: Creating full backup of ShopDB"
mysqldump -u "$DB_USER" -p"$DB_PASSWORD" ShopDB > full_backup.sql

echo "INFO: Restoring full backup to ShopDBReserve"
mysql -u "$DB_USER" -p"$DB_PASSWORD" ShopDBReserve < full_backup.sql

# 3. Data-only backup of ShopDB, restored to ShopDBDevelopment
echo "INFO: Creating data-only backup of ShopDB"
mysqldump -u "$DB_USER" -p"$DB_PASSWORD" --no-create-info ShopDB > data_backup.sql

echo "INFO: Restoring data-only backup to ShopDBDevelopment"
mysql -u "$DB_USER" -p"$DB_PASSWORD" ShopDBDevelopment < data_backup.sql

echo "INFO: Backup and restoration completed successfully"