# ✨ Features

**Doc Version:** 0.9.0  
**Last Updated:** 2025-10-03

## ⚙️ User Configuration
-- **Centralized Setup:** Toggle features on/off in a single configuration block within `hostflow.sh`.
- **Flexible Options:** Configure domain, mail hosts, cloud remotes, verification, cron schedules, and notifications effortlessly.

## 📦 Backup
- **Website Archiving:** Compress website files into secure archives.
- **Database Export:** Use `mysqldump` for reliable MySQL database backups.
- **Email Preservation:** Archive email directories in Maildir format.

## 📧 Email Sync
- **Seamless Synchronization:** Leverage `imapsync` with `ACCOUNTS_FILE` for account mapping.
- **Resilient Execution:** Process each account individually with comprehensive logging.

## ☁️ Cloud Uploads
- **Multi-Platform Support:** Conditional uploads to Dropbox, Google Drive, OneDrive, or S3 using `rclone`.
- **Easy Configuration:** Set remote names directly in the User Configuration Block.

## ✅ Verification
- **Health Checks:** Send requests to `VERIFY_URL` to validate staging environments.
- **Status Tracking:** Failures update run status to `FAILED` and are detailed in summaries.

## 🔐 MD5 Checksums
- **Integrity Assurance:** Generate MD5 checksums for site archives, database dumps, and email backups.
- **Verification Files:** Upload checksum files alongside backups for easy integrity checks.

## 📊 Capability Matrix
| Feature | Description |
|---------|-------------|
| **Migration Matrix** | Generates `migration_matrix_<timestamp>.txt` with PHP/MySQL versions and asset sizes. |
| **MX Records** | Captures current domain MX records in `mxrecords_<timestamp>.txt` for DNS auditing. |

## 📧 Notifications
- **Automated Reports:** Send summary reports via SMTP, curl, or sendmail.
- **Smart Subjects:** Conditional email subjects based on migration `STATUS`.
- **Detailed Summaries:** Include `migration_summary_<timestamp>.log` in email bodies.
## 🖥️ Control Panel Modes
- **Supported Migrations:** `DA2DA`, `DA2CPANEL`, `CPANEL2DA`, `DA2PLESK`, `PLESK2DA`.
- **Adaptive Processing:** Modes dictate packaging and conversion steps, integrating with admin tools.

## 🔑 Root Awareness
- **Elevated Operations:** `IS_ROOT=true` enables root-level commands like pkgacct, Plesk tools, and DirectAdmin admin functions.
- **Fallback Mode:** Defaults to user-level tar, mysqldump, and imapsync when not root.

## ⏰ Cron Wrapper
- **Scheduled Automation:** Optional cron job installation for recurring migrations.
- **Customizable Timing:** Set nightly schedules via `CRON_SCHEDULE` with log redirection.

## 📈 Stats/Logs Backup
- **Audit Trail:** Optional backup of statistics and logs for comprehensive records.
- **Compressed Storage:** Package into `logs_stats_<timestamp>.tar.gz` and upload with other artifacts.

---
Made with ❤️ by ReadyPixels LLC