#!/bin/bash
set -e

TARGET="${1:-127.0.0.1:5555}"
ADB="${ADB:-adb}"

echo "Connecting to ${TARGET}..."
"${ADB}" connect "${TARGET}"
"${ADB}" devices -l
