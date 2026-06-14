# CHANGELOG

All notable changes for the Android scripts and AVD setup.

## Unreleased - 2026-06-14

- Fixed Android emulator: Temurin JDK 21 + E:\Android\Sdkwin configuration working.
- Created Fast_Android_34 AVD (Android 34, google_apis_playstore, x86_64, Pixel 6 profile).
- **Emulator startup**: Using software rendering (GPU off, no HAXM acceleration) for compatibility.
- Updated start-fast-emulator-avd.ps1 with proven working flags: `-no-boot-anim -no-audio -gpu off -no-accel`
- Emulator verified running and stable for Maui development.

## 2026-06-13

- Created AVD: Pixel_3a_API_28_Lite_2 (android-28 google_apis x86_64). Fixed missing kernel by copying from backup.
- Added start script: start-pixel3a-api28-lite.ps1 (tries GPU host then swiftshader).
- Added diagnostics and automation: create/start scripts (powershell/sh/bat).
- Added container docs: ANDOID-Container.md and docker-compose (android-container-docker-compose.yml).
- Added helper container scripts: check-kvm.sh, run-redroid-wsl.sh, run-docker-android-wsl.sh.
- Added backup/restore scripts for Windows and Linux (backup-avd-*.ps1/.sh, restore-avd-*.ps1/.sh).
- Added checksum generation (.sha256) for backups and verification on restore (Windows and Linux).

Notes:
- Current Windows backup default: E:\Android\avd-backups
- Linux backup default updated to: /media/leandro/DADOS/avd-backups
