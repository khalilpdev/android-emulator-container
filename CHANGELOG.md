# CHANGELOG

All notable changes for the Android scripts and AVD setup.

## Unreleased - 2026-06-14

- Fixed Android emulator: Temurin JDK 21 + C:\Android\Sdk configuration working.
- Added Genymotion + Docker + ADB TCP/IP workspace under `genymotion/`.
- Created `Maui_Solo` AVD (Android 28, google_apis, x86_64, Pixel 3a profile).
- **Emulator startup**: Using WHPX/Hyper-V when available with `swiftshader_indirect` to avoid Intel GPU crashes.
- Updated start-fast-emulator-avd.ps1 with optimized flags: `-accel on -gpu swiftshader_indirect -memory 4096 -cores 2`
- Updated create-fast-emulator-android.ps1 to rewrite config.ini for 2 cores, 4GB RAM, no cameras, no audio, no device frame, and software GPU.

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
