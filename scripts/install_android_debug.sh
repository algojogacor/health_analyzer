#!/usr/bin/env sh
set -eu

APK_PATH="${1:-build/app/outputs/flutter-apk/app-debug.apk}"
PACKAGE_NAME="${HEALTH_ANALYZER_PACKAGE:-com.healthanalyzer.health_analyzer}"

if [ "${BUILD_APK:-0}" = "1" ]; then
  flutter build apk --debug
fi

if [ ! -f "$APK_PATH" ]; then
  echo "APK not found: $APK_PATH" >&2
  echo "Build first: flutter build apk --debug" >&2
  exit 1
fi

DEVICE_COUNT="$(adb devices | awk '/device$/{count++} END{print count+0}')"
if [ "$DEVICE_COUNT" -eq 0 ]; then
  echo "No authorized Android device found. Enable USB debugging and approve the RSA prompt." >&2
  exit 1
fi
if [ "$DEVICE_COUNT" -gt 1 ]; then
  echo "Multiple Android devices found. Disconnect extras or use adb -s manually." >&2
  exit 1
fi

if [ "${UNINSTALL_FIRST:-0}" = "1" ]; then
  adb uninstall "$PACKAGE_NAME" || true
fi

adb install -r -d "$APK_PATH"

if [ "${LAUNCH_APP:-0}" = "1" ]; then
  adb shell monkey -p "$PACKAGE_NAME" -c android.intent.category.LAUNCHER 1
fi
