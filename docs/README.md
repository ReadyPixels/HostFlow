# 📖 HostFlow

**Doc Version:** 0.9.0  
**Last Updated:** 2025-10-03

## 🚀 Overview
Welcome to HostFlow, a powerful toolkit designed for seamless hosting migrations. Focused on DirectAdmin shared hosting, it supports both user-level and root-aware operations. The core script, `hostflow.sh`, handles everything from website and database backups to live IMAP synchronization, staging verification, multi-cloud uploads, cron automation, email notifications, and various control panel migration modes.

## ✨ Key Features
- **Website & Database Backup:** Compress and backup with optional MD5 checksums for integrity.
- **Email Data Management:** Backup Maildir and perform live sync using `imapsync`.
- **Multi-Cloud Integration:** Upload to Dropbox, Google Drive, OneDrive, or S3 via `rclone`.
- **Staging Verification:** Healthcheck via custom URL to ensure migration success.
- **Automation:** Cron wrapper for scheduled runs.
- **Notifications:** Email alerts with conditional subjects and detailed reports.
- **Control Panel Migrations:** Root-aware modes like `DA2DA`, `DA2CPANEL`, `CPANEL2DA`, `DA2PLESK`, `PLESK2DA`.
- **Optional Extras:** Statistics and logs backup for comprehensive auditing.

## ⚙️ Requirements
- **Runtime:** Bash on Linux/Unix-like systems.
- **Tools:** `rclone` for cloud uploads, `imapsync` for email sync, `curl` or `sendmail` for notifications.
- **Access:** Credentials for source and target servers as configured.

## 🏁 Quick Start
1. 📝 Edit the "USER CONFIGURATION BLOCK" in `hostflow.sh`.
2. ☁️ Configure `rclone` remotes with `rclone config` and set remote names in the script.
3. 📧 Prepare `ACCOUNTS_FILE` with email account mappings (one per line: `srcuser srctoken dstuser dsttoken`).
4. ▶️ Run the migrator:
   ```bash
   bash hostflow.sh
   ```

## 📋 Usage
- **Configuration:** Adjust settings for servers, domain, backup paths, cloud remotes, cron schedules, verification URLs, and email notifications.
- **Root Migrations:** Enable with `IS_ROOT=true` and select `MIGRATION_TYPE`.
- **Cloud Uploads:** Toggle `USE_DROPBOX`, `USE_GDRIVE`, `USE_ONEDRIVE`, `USE_S3` and configure remotes.
- **Automation:** Set `USE_CRON=true` and customize `CRON_SCHEDULE`.

## 🔧 Configuration Quick Reference
| Category          | Configurations |
|-------------------|----------------|
| **Providers**    | `SOURCE_HOST`, `SOURCE_USER`, `SOURCE_PASS`, `USER_HOME`, `TARGET_HOST`, `TARGET_USER`, `TARGET_PASS` |
| **Domain & Backup** | `DOMAIN`, `BACKUP_DIR`, `BACKUP_STATS_LOGS` |
| **Control Panel** | `IS_ROOT`, `MIGRATION_TYPE` |
| **Cloud**        | `USE_DROPBOX`, `USE_GDRIVE`, `USE_ONEDRIVE`, `USE_S3`, `RCLONE_REMOTE` |
| **Email Sync**   | `ACCOUNTS_FILE`, `OLD_MAIL_HOST`, `NEW_MAIL_HOST` |
| **Verification** | `ENABLE_VERIFICATION`, `VERIFY_URL` |
| **Notifications**| `EMAIL_ENABLED`, `EMAIL_TO`, `EMAIL_FROM`, `SMTP_SERVER`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASS` |
| **Cron**         | `USE_CRON`, `CRON_SCHEDULE` |

## ✅ Verification
- When `ENABLE_VERIFICATION=true`, the script performs a healthcheck on `VERIFY_URL` post-migration.
- Review detailed logs in `BACKUP_DIR/migration.log` for insights.

## 📧 Notifications
- Enable with `EMAIL_ENABLED=true` and configure SMTP details.
- Receive summary reports via email, with subjects indicating success or failure based on migration status.

## 🔍 Troubleshooting
- **Cloud Issues:** Verify `rclone` remotes with `rclone listremotes`.
- **Email Sync:** Confirm IMAP credentials and host accessibility for `OLD_MAIL_HOST` and `NEW_MAIL_HOST`.
- **Logs:** Check `BACKUP_DIR/migration.log` for errors.
- **Verification:** Ensure `VERIFY_URL` is reachable from the script's environment.

## 🤝 Contributing
- Dive into the [Developer Guide](Developer_Guide.md) for coding standards, extending control panel modes, and PR guidelines.

## 📈 Versioning
- Follows Semantic Versioning (SemVer) for releases and documentation.
- Check the [CHANGELOG](CHANGELOG.md) for release notes and updates.

## 📚 Related Docs
- [User Manual](User_Manual.md)
- [Config Reference](Config_Reference.md)
- [Technical Architecture Spec](Technical_Architecture_Spec.md)
- [Features](Features.md)
- [Project Roadmap](Project_Roadmap.md)
- [Developer Guide](Developer_Guide.md)
- [PRD](PRD.md)

---
Made with ❤️ by ReadyPixels LLC