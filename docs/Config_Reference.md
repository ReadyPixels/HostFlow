# Configuration Reference 🔧

Doc Version: 0.9.0 📅
Last Updated: 2025-10-03 🕒

## Overview 📖
This document describes the script-only configuration model. All settings live in the **USER CONFIGURATION BLOCK** within `hostflow.sh`.

## Providers 🏢

| Provider | Variables |
|----------|-----------|
| **source** | `SOURCE_HOST`, `SOURCE_USER`, `SOURCE_PASS`, `USER_HOME` |
| **target** | `TARGET_HOST`, `TARGET_USER`, `TARGET_PASS` |
| **control_panel** | `MIGRATION_TYPE` and `IS_ROOT` |

## Resources 📁

| Resource | Description |
|----------|-------------|
| **files** | Maps to site files under `USER_HOME/domains/$DOMAIN/public_html` |
| **database** | Auto-detected via `mysql` with export via `mysqldump` |
| **dns** | Verify via `VERIFY_URL` (out of scope for direct DNS changes) |
| **ssl** | Backup combined within site files; provisioning is out of scope |
| **control_panel_accounts** | `ACCOUNTS_FILE` for email sync |

## Migration Options ⚙️

| Option | Description |
|--------|-------------|
| **dry_run** | Not supported in script yet (future roadmap) |
| **backup_directory** | `BACKUP_DIR` |
| **concurrency** | Not configurable; sequential operations for safety |
| **timeouts** | Manage via external tools where applicable |

## Cloud Uploads ☁️
- `rclone` remotes: `RCLONE_REMOTE`, plus `DROPBOX_REMOTE`, `GDRIVE_REMOTE`, `ONEDRIVE_REMOTE`, `S3_REMOTE`.

## Notifications 📧
- SMTP and email settings align with `EMAIL_ENABLED`, `EMAIL_TO`, `EMAIL_FROM`, `SMTP_*`.

---
Made with ❤️ by ReadyPixels LLC