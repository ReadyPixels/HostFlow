# Developer Guide 📚

Doc Version: 0.9.0 📅
Last Updated: 2025-10-03 🕒

## Codebase Overview 🔍
-- **`hostflow.sh`**: Main bash script.
- **`docs/`**: Documentation set.

## Configuration Model ⚙️
- Single in-script **USER CONFIGURATION BLOCK**; no external YAML files.

## Style Guidelines 🎨

| Guideline | Description |
|-----------|-------------|
| Keep changes minimal and targeted | Ensure modifications are focused and avoid unnecessary alterations. |
| Do not add inline comments unless requested | Maintain clean code without unsolicited comments. |
| Prefer clear function names, avoid single-letter variables | Use descriptive names for better readability and maintainability. |

## Extending Control Panel Modes 🔧
- Implement logic within `migrate_control_panel` dispatch.
- Add mode-specific functions, respecting `IS_ROOT`.

## Error Handling & Logging 🚨
- Use `handle_error` for failures and `log_message` for progress.
- Ensure `STATUS` reflects critical failures.

## Testing 🧪
- Use test environments with dummy domains and credentials.
- Validate `rclone` and `imapsync` operations independently.

## Contribution Process 🤝
- Fork the repo and create feature branches.
- Follow Semantic Versioning for releases.
- Update docs and [`CHANGELOG.md`](CHANGELOG.md) for new features.

---
Made with ❤️ by ReadyPixels LLC