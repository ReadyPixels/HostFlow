# 📚 User Manual

**Doc Version:** 0.9.0  
**Last Updated:** 2025-10-03

## 🌟 Introduction
This comprehensive guide walks you through configuring and running HostFlow. Whether you're migrating websites, databases, or email accounts, this manual ensures a smooth process.

## ✅ Prerequisites
- **Environment:** Linux system with Bash shell.
- **Tools:** Install `rclone`, `imapsync`, and `curl` or `sendmail`.
- **Permissions:** Access to source and target hosting servers.

## 🔧 Setup Steps
1. 📝 Open `hostflow.sh` and complete the "USER CONFIGURATION BLOCK" at the top.
2. ☁️ Set up `rclone` remotes using `rclone config` and update remote names in the script.
3. 📧 Create `ACCOUNTS_FILE` with email mappings (one account per line).
4. 📁 Ensure `BACKUP_DIR` exists and is writable.
5. ⚙️ All settings are configured directly in the script—no external files needed.

### 📧 ACCOUNTS_FILE Example
```
old_user1 old_app_password1 new_user1 new_app_password1
old_user2 old_app_password2 new_user2 new_app_password2
```
Each line maps a source mailbox to a destination using credentials or app passwords for secure synchronization.

## ▶️ Running the Script
-- **Command:** Execute with `bash hostflow.sh`.
- **Monitoring:** Watch the output and review `BACKUP_DIR/migration.log` for detailed progress.

## ⚙️ Options & Modes
| Option | Description |
|--------|-------------|
| `IS_ROOT` | Set to `true` for root-level operations. |
| `MIGRATION_TYPE` | Choose from `DA2DA`, `DA2CPANEL`, etc., for control panel migrations. |
| `USE_DROPBOX`, `USE_GDRIVE`, etc. | Enable cloud uploads to specified services. |
| `ENABLE_VERIFICATION` | Toggle staging verification with `VERIFY_URL`. |

## ✅ Verification
- The script sends a request to `VERIFY_URL` and logs the response.
- Confirm the endpoint is accessible to validate migration success.

## 📧 Notifications
- Enable email reports by setting `EMAIL_ENABLED=true` and configuring SMTP details.
- Ensure `curl` or `sendmail` is functional for delivery.

## 🔍 Troubleshooting
- **Credentials:** Verify access to source and target servers.
- **Rclone:** Test remotes with `rclone listremotes` and `rclone ls <remote>:`.
- **IMAP:** Check login credentials for `OLD_MAIL_HOST` and `NEW_MAIL_HOST`.
- **Logs:** Examine `BACKUP_DIR/migration.log` for errors.
- **Permissions:** Confirm write access to `BACKUP_DIR`.

## 🛡️ Safety Tips
- 🔒 Keep credentials secure—never commit `ACCOUNTS_FILE` to version control.
- ⏰ Schedule migrations during off-peak hours using cron to minimize downtime.


---
Made with ❤️ by ReadyPixels LLC