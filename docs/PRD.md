# 📋 Product Requirements Document (PRD)

**Doc Version:** 0.9.0  
**Last Updated:** 2025-10-03

## 1. 🎯 Product Summary
<span style="color: #007bff;">HostFlow</span> enables reliable migrations of shared hosting accounts with emphasis on DirectAdmin and cross-control panel scenarios.  
**Target users:** sysadmins, hosting providers, advanced users migrating accounts.

## 2. 🎯 Goals
- Provide a single script and config to perform comprehensive backups, email sync, verification, and optional cloud offloading.
- Support root-aware operations and control panel migration modes.
- Deliver clear logs, notifications, and summary reporting.

## 3. 🚫 Non-Goals
- Not a generic full-server orchestrator.
- Not a GUI application.

## 4. 📏 Scope
- User-level migrations for DA environments.
- Root-level enhancements when `IS_ROOT=true`.
- Cross-panel support stubs: DA2DA, DA2CPANEL, CPANEL2DA, DA2PLESK, PLESK2DA.

## 5. 👥 User Stories
- **As a sysadmin,** I want to back up site files and DBs with minimal downtime.
- **As a host,** I want email accounts migrated with live sync to avoid message loss.
- **As an operator,** I want a summary report and email notifications indicating success/failure.
- **As a security-conscious user,** I want cloud uploads to be optional and controlled.

## 6. 📋 Requirements

### Functional
- Backup website files, databases, email data.
- Live email sync via `imapsync` using `ACCOUNTS_FILE`.
- Generate logs and optional checksum.
- Upload archives to configured cloud providers via `rclone`.
- Perform staging verification call.
- Send email notification with summary report.

### Non-Functional
- Idempotent runs with clear logging.
- Config-only user input within the script; no external config files.
- CLI-only, works with typical Linux hosting environments.

## 7. 📊 Success Metrics
- Migration runs complete with `STATUS=success`.
- Zero or minimal email message discrepancies.
- Verification endpoint returns success.
- Restore artifacts available in cloud storage when configured.

## 8. 🔗 Dependencies
- `rclone`, `imapsync`, `curl`/`sendmail`, bash, access to servers.

## 9. ⚠️ Risks & Mitigations
- **Credential errors:** validate early and log; provide clear failure messages.
- **Network failures:** retries for critical operations where feasible.
- **Provider API limits:** user-configurable throttling via rclone settings.

## 10. 🚀 Release Plan

| Version | Description |
|---------|-------------|
| v1.0.0 | Stable DA2DA with email sync and cloud uploads. |
| v1.1.x | Expand cross-panel modes and root-level automation. |
| v1.2.x | Add richer reporting and test harness. |

---
Made with ❤️ by ReadyPixels LLC