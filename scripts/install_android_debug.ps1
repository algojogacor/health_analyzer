param(
  [string]$ApkPath = "build\app\outputs\flutter-apk\app-debug.apk",
  [string]$PackageName = "com.healthanalyzer.health_analyzer",
  [switch]$Build,
  [switch]$UninstallFirst,
  [switch]$Launch
)

$ErrorActionPreference = "Stop"

function Require-Command($Name) {
  if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
    throw "Command '$Name' was not found in PATH."
  }
}

Require-Command adb

if ($Build) {
  Require-Command flutter
  Write-Host "Building debug APK..." -ForegroundColor Cyan
  flutter build apk --debug
}

if (-not (Test-Path $ApkPath)) {
  throw "APK not found: $ApkPath. Run with -Build or build manually first."
}

$devices = adb devices | Select-String "device$" | ForEach-Object {
  ($_ -split "\s+")[0]
}

if ($devices.Count -eq 0) {
  throw "No authorized Android device found. Enable USB debugging and approve the RSA prompt."
}

if ($devices.Count -gt 1) {
  throw "Multiple Android devices found. Disconnect extras or set up a more specific adb command."
}

if ($UninstallFirst) {
  Write-Host "Uninstalling existing package $PackageName..." -ForegroundColor Yellow
  adb uninstall $PackageName | Out-Host
}

Write-Host "Installing $ApkPath..." -ForegroundColor Cyan
adb install -r -d $ApkPath | Out-Host

if ($Launch) {
  Write-Host "Launching $PackageName..." -ForegroundColor Cyan
  adb shell monkey -p $PackageName -c android.intent.category.LAUNCHER 1 | Out-Host
}

Write-Host "Done." -ForegroundColor Green
