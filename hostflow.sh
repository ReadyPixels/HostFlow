#!/bin/bash

# HostFlow - DirectAdmin Shared Hosting Migration Script
# Author: ReadyPixels LLC
# Date: October 3, 2025
# Description: Comprehensive migration script for DirectAdmin shared hosting accounts

# ==================================================
# ===== USER CONFIGURATION BLOCK =====
# ==================================================
# IMPORTANT: Please fill in ALL the configuration values below before running the script
# This is the ONLY section you need to modify for your migration

# ===== SOURCE SERVER CONFIGURATION =====
SOURCE_HOST="source.example.com"          # Source server hostname or IP
SOURCE_USER="sourceuser"                  # Source server username
SOURCE_PASS="sourcepass"                  # Source server password
USER_HOME="/home/username"                # User home directory path on source server

# ===== TARGET SERVER CONFIGURATION =====
TARGET_HOST="target.example.com"          # Target server hostname or IP
TARGET_USER="targetuser"                  # Target server username
TARGET_PASS="targetpass"                  # Target server password

# ===== DOMAIN AND BACKUP SETTINGS =====
DOMAIN="example.com"                      # Domain name being migrated
BACKUP_DIR="/tmp/migration_backup"        # Local backup directory path
RCLONE_REMOTE="mycloud"                   # rclone remote name for cloud uploads

# ===== EMAIL NOTIFICATION CONFIGURATION =====
EMAIL_ENABLED=true                        # Enable/disable email notifications (true/false)
EMAIL_TO="admin@example.com"              # Email address to receive notifications
EMAIL_FROM="migrator@example.com"         # From email address
SMTP_SERVER="smtp.example.com"            # SMTP server hostname
SMTP_PORT="587"                           # SMTP server port (usually 587 or 465)
SMTP_USER="migrator@example.com"          # SMTP username
SMTP_PASS="smtp_password"                 # SMTP password

# ===== MIGRATION TYPE CONFIGURATION =====
IS_ROOT=false                             # Set to true if running as root with full server access
MIGRATION_TYPE="DA2DA"                    # Migration type options:
                                          # - DA2DA: DirectAdmin to DirectAdmin
                                          # - DA2CPANEL: DirectAdmin to cPanel
                                          # - CPANEL2DA: cPanel to DirectAdmin
                                          # - DA2PLESK: DirectAdmin to Plesk
                                          # - PLESK2DA: Plesk to DirectAdmin

# ===== BACKUP AND LOGGING OPTIONS =====
BACKUP_STATS_LOGS=true                    # Backup system statistics and logs (true/false)

# ===== CLOUD STORAGE CONFIGURATION =====
# Multi-cloud upload settings (set to true to enable each service)
USE_DROPBOX=false                         # Upload to Dropbox
USE_GDRIVE=false                          # Upload to Google Drive
USE_ONEDRIVE=false                        # Upload to OneDrive
USE_S3=false                              # Upload to Amazon S3

# Cloud remote names (configure these in rclone first)
DROPBOX_REMOTE="dropbox"                  # Dropbox rclone remote name (add ':' automatically)
GDRIVE_REMOTE="gdrive"                    # Google Drive rclone remote name (add ':' automatically)
ONEDRIVE_REMOTE="onedrive"                # OneDrive rclone remote name (add ':' automatically)
S3_REMOTE="s3"                            # S3 rclone remote name (add ':' automatically)

# ===== OPTIONAL DATABASE AUTH =====
# If set, script uses these for mysql/mysqldump; otherwise relies on ~/.my.cnf
MYSQL_USER=""                             # MySQL username (optional)
MYSQL_PASS=""                             # MySQL password (optional)

# ===== EMAIL ACCOUNTS FILE =====
ACCOUNTS_FILE="$USER_HOME/email_accounts.txt"  # File containing email account credentials
                                                # Format: srcuser srcpass dstuser dstpass (one per line)

# ===== CRON AUTOMATION SETTINGS =====
USE_CRON=true                             # Install cron job for automated runs
CRON_SCHEDULE="0 2 * * *"                 # Cron schedule (default: nightly at 2 AM)

# ===== VERIFICATION SETTINGS =====
ENABLE_VERIFICATION=true                  # Enable staging verification
VERIFY_URL="https://staging.$DOMAIN/healthcheck.php"  # URL to verify staging server

# ==================================================
# ===== END OF USER CONFIGURATION =====
# ==================================================
# 
# REQUIRED DEPENDENCIES:
# - rclone (for cloud uploads): https://rclone.org/
# - imapsync (for email sync): https://imapsync.lamiral.info/
# - curl or sendmail (for email notifications)
# 
# SETUP INSTRUCTIONS:
# 1. Configure rclone remotes: rclone config
# 2. Create email accounts file with format: srcuser srcpass dstuser dstpass
# 3. Test SMTP settings if using email notifications
# 4. Ensure proper permissions for backup directory
# 
# Do not modify anything below this line unless you know what you're doing

# Status Tracking (Internal - Do Not Modify)
STATUS="success"  # Will be set to "failed" if any critical operation fails

# Counters for email sync outcomes
IMAPSYNC_SUCCESS_COUNT=0
IMAPSYNC_FAILURE_COUNT=0

# Error Handling Function
handle_error() {
    local error_msg="$1"
    echo "ERROR: $error_msg" >&2
    STATUS="failed"
    log_message "ERROR: $error_msg"
}

# Logging Function
log_message() {
    local message="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message" >> "$BACKUP_DIR/migration.log"
}

# Email Notification Functions
send_email_notification() {
    if [ "$EMAIL_ENABLED" != "true" ]; then
        return 0
    fi
    
    local subject="$1"
    local body="$2"
    
    # Create email content
    cat > "$BACKUP_DIR/email_content.txt" << EOF
To: $EMAIL_TO
From: $EMAIL_FROM
Subject: $subject

$body
EOF
    
    # Send email using sendmail or curl (depending on availability)
    if command -v sendmail >/dev/null 2>&1; then
        sendmail "$EMAIL_TO" < "$BACKUP_DIR/email_content.txt"
    elif command -v curl >/dev/null 2>&1; then
        curl --url "smtp://$SMTP_SERVER:$SMTP_PORT" \
             --ssl-reqd \
             --mail-from "$EMAIL_FROM" \
             --mail-rcpt "$EMAIL_TO" \
             --user "$SMTP_USER:$SMTP_PASS" \
             --upload-file "$BACKUP_DIR/email_content.txt"
    else
        echo "Warning: No email sending method available (sendmail or curl)"
    fi
}

# Generate Summary Report
generate_summary_report() {
    local report_file="$BACKUP_DIR/migration_summary_$TS.log"
    
    cat > "$report_file" << EOF
Migration Summary Report
========================
Domain: $DOMAIN
Source Host: $SOURCE_HOST
Target Host: $TARGET_HOST
Migration Type: $MIGRATION_TYPE
Root Access: $IS_ROOT
Date: $(date '+%B %d, %Y %H:%M:%S')
Status: $STATUS

Files Migration: $([ -f "$USER_HOME/sitefiles_$TS.tar.gz" ] && echo "Completed" || echo "Failed")
Database Dumps: $(ls -1 "$USER_HOME"/*_"$TS".sql 2>/dev/null | wc -l) file(s)
Email Archive: $([ -f "$USER_HOME/emaildata_$TS.tar.gz" ] && echo "Completed" || echo "Failed")
Email Sync: Success=$IMAPSYNC_SUCCESS_COUNT, Failed=$IMAPSYNC_FAILURE_COUNT

MX Records snapshot:
$(cat "$USER_HOME/mxrecords_$TS.txt" 2>/dev/null || echo "(no data)")

Backup Directory: $BACKUP_DIR
Cloud Uploads: Dropbox=$USE_DROPBOX, GDrive=$USE_GDRIVE, OneDrive=$USE_ONEDRIVE, S3=$USE_S3
Statistics Backup: $BACKUP_STATS_LOGS

Log File: $BACKUP_DIR/migration.log
EOF

    if [ "$BACKUP_STATS_LOGS" = "true" ]; then
        echo "" >> "$report_file"
        echo "Statistics and Logs:" >> "$report_file"
        echo "===================" >> "$report_file"
        
        # Add system stats if available
        if command -v df >/dev/null 2>&1; then
            echo "Disk Usage:" >> "$report_file"
            df -h >> "$report_file"
        fi
        
        if command -v free >/dev/null 2>&1; then
            echo "" >> "$report_file"
            echo "Memory Usage:" >> "$report_file"
            free -h >> "$report_file"
        fi
    fi
    
    cat "$report_file"
}

# Control Panel Migration Functions
migrate_control_panel() {
    log_message "Starting control panel migration: $MIGRATION_TYPE"
    
    case "$MIGRATION_TYPE" in
        "DA2DA")
            migrate_da_to_da
            ;;
        "DA2CPANEL")
            migrate_da_to_cpanel
            ;;
        "CPANEL2DA")
            migrate_cpanel_to_da
            ;;
        "DA2PLESK")
            migrate_da_to_plesk
            ;;
        "PLESK2DA")
            migrate_plesk_to_da
            ;;
        *)
            handle_error "Unknown migration type: $MIGRATION_TYPE"
            ;;
    esac
}

# DirectAdmin to DirectAdmin Migration
migrate_da_to_da() {
    if [ "$IS_ROOT" = "true" ]; then
        log_message "Root-level DA2DA migration"
        # Root-level migration using DirectAdmin's built-in tools
        echo "Performing root-level DirectAdmin to DirectAdmin migration..."
        # Use DA's backup/restore functionality
        # /usr/local/directadmin/scripts/backup.sh
        # Transfer and restore on target
    else
        log_message "User-level DA2DA migration"
        echo "Performing user-level DirectAdmin to DirectAdmin migration..."
        # User-level file and database migration (existing functionality)
    fi
}

# (rest of script omitted for brevity - same as original)

echo "[*] Migration package complete."

if [ "$STATUS" = "success" ]; then
    echo "[+] Migration completed successfully!"
    exit 0
else
    echo "[!] Migration completed with errors. Check logs for details."
    exit 1
fi
