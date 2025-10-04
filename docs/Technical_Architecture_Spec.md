# Technical Architecture Specification (TASKS) 🏗️

Doc Version: 0.9.0 📅
Last Updated: 2025-10-03 🕒

## 1. System Overview 🔍
-- Single bash script `hostflow.sh` orchestrates backups, syncs, uploads, and verification.
- External tools: `rclone`, `imapsync`, `curl`/`sendmail`.

## 2. Components 🧩

| Component | Description |
|-----------|-------------|
| **Config Block** | User-editable settings grouped by source/target, domain, cloud, cron, verification, notifications |
| **Backup Engine** | File compression (`tar`), database export (`mysqldump`), email data archive (Maildir) |
| **Email Sync** | `imapsync` loop consuming `ACCOUNTS_FILE` |
| **Cloud Uploads** | `rclone` wrappers for Dropbox, Google Drive, OneDrive, S3 |
| **Verification** | HTTP GET to `VERIFY_URL` with result logging |
| **Notifications** | Summary generation and sending via SMTP/curl/sendmail |
| **Control Panel Modes** | Case-based dispatch with root-aware stubs |
| **Logging & Errors** | `log_message`, `handle_error`, `STATUS` tracking |

## 3. Data Flow 📊

| Aspect | Details |
|--------|---------|
| **Inputs** | Config values, credentials file, environment |
| **Artifacts** | `sitefiles_*.tar.gz`, `emaildata_*.tar.gz`, `*.sql`, `migration.log`, optional checksum files |
| **Outputs** | Cloud uploads and email notifications |

## 4. Task Breakdown (Implementation) 📋
- **Config Consolidation**: Ensure single user-editable block.
- **Backup Tasks**: Implement file backup, DB export, email archive with error handling.
- **Email Sync Tasks**: Implement `imapsync` loop; capture per-account results.
- **Cloud Upload Tasks**: Conditional uploads to configured remotes.
- **Verification Tasks**: Call `VERIFY_URL` and log outcome.
- **Notification Tasks**: Generate summary, send via chosen transport.
- **Control Panel Tasks**: Implement DA2DA minimal; structure stubs for others with root checks.
- **Cron Tasks**: Optional installation based on `USE_CRON` settings.
- **Stats/Logs Tasks**: Conditional backup and inclusion in summary.

## 5. Error Handling Strategy 🚨
- Fail fast on critical backup/export operations with `handle_error`.
- Continue non-critical tasks where safe; mark STATUS accordingly.
- Log all actions and errors with timestamps.

## 6. Security Considerations 🔒
- Avoid logging sensitive passwords.
- Ensure backups are stored with appropriate permissions.
- Validate remote endpoints before data transfer.

## 7. Configuration Reference 📖
- See [`Config_Reference.md`](Config_Reference.md) for details of the in-script configuration block and how settings map to components.

## 8. Testing Approach 🧪
- Manual runs against test environments.
- Validate cloud uploads with `rclone` commands.
- Verify email sync with sample accounts.

## 9. Operational Guidelines 📝
- Use cron for off-hours runs.
- Monitor `migration.log` after each run.
- Keep `ACCOUNTS_FILE` secure.


---
Made with ❤️ by ReadyPixels LLC