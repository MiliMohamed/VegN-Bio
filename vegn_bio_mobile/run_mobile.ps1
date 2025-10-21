#!/usr/bin/env pwsh
# Script de lancement de l'application mobile VegN-Bio
# Usage: .\run_mobile.ps1 [web|android|ios|windows]

param(
    [Parameter(Position=0)]
    [ValidateSet('web', 'android', 'ios', 'windows', 'chrome')]
    [string]$Platform = 'web'
)

Write-Host "╔══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║     🚀 VegN-Bio Mobile - Lanceur d'Application 📱      ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Vérifier que Flutter est installé
Write-Host "🔍 Vérification de Flutter..." -ForegroundColor Yellow
$flutterInstalled = Get-Command flutter -ErrorAction SilentlyContinue
if (-not $flutterInstalled) {
    Write-Host "❌ Erreur: Flutter n'est pas installé!" -ForegroundColor Red
    Write-Host "   Installez Flutter depuis: https://flutter.dev/docs/get-started/install" -ForegroundColor Yellow
    exit 1
}

$flutterVersion = flutter --version 2>&1 | Select-String "Flutter" | Select-Object -First 1
Write-Host "✅ Flutter détecté: $flutterVersion" -ForegroundColor Green
Write-Host ""

# Vérifier que nous sommes dans le bon dossier
if (-not (Test-Path "pubspec.yaml")) {
    Write-Host "❌ Erreur: Vous devez être dans le dossier vegn_bio_mobile/" -ForegroundColor Red
    Write-Host "   Utilisez: cd vegn_bio_mobile" -ForegroundColor Yellow
    exit 1
}

# Installer les dépendances
Write-Host "📦 Installation des dépendances..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Erreur lors de l'installation des dépendances!" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Dépendances installées avec succès!" -ForegroundColor Green
Write-Host ""

# Vérifier que le backend est accessible
Write-Host "🔌 Vérification du backend..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/api/v1/restaurants" -Method GET -TimeoutSec 5 -ErrorAction Stop
    Write-Host "✅ Backend accessible sur http://localhost:8080" -ForegroundColor Green
} catch {
    Write-Host "⚠️  ATTENTION: Le backend ne répond pas!" -ForegroundColor Red
    Write-Host "   Assurez-vous que le backend est lancé:" -ForegroundColor Yellow
    Write-Host "   cd backend && mvn spring-boot:run" -ForegroundColor Cyan
    Write-Host ""
    $continue = Read-Host "   Continuer quand même? (o/N)"
    if ($continue -ne 'o' -and $continue -ne 'O') {
        exit 1
    }
}
Write-Host ""

# Lister les appareils disponibles
Write-Host "📱 Appareils disponibles:" -ForegroundColor Yellow
flutter devices
Write-Host ""

# Lancer l'application selon la plateforme
Write-Host "🚀 Lancement de l'application..." -ForegroundColor Cyan
Write-Host "   Plateforme: $Platform" -ForegroundColor Cyan
Write-Host ""

switch ($Platform) {
    'web' {
        Write-Host "🌐 Lancement sur Chrome (Web)..." -ForegroundColor Green
        Write-Host "   URL: http://localhost:3000" -ForegroundColor Yellow
        Write-Host ""
        flutter run -d chrome --web-port=3000
    }
    'chrome' {
        Write-Host "🌐 Lancement sur Chrome (Web)..." -ForegroundColor Green
        Write-Host "   URL: http://localhost:3000" -ForegroundColor Yellow
        Write-Host ""
        flutter run -d chrome --web-port=3000
    }
    'android' {
        Write-Host "🤖 Lancement sur Android..." -ForegroundColor Green
        flutter run -d android
    }
    'ios' {
        Write-Host "🍎 Lancement sur iOS..." -ForegroundColor Green
        flutter run -d ios
    }
    'windows' {
        Write-Host "💻 Lancement sur Windows..." -ForegroundColor Green
        flutter run -d windows
    }
}

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "❌ Erreur lors du lancement de l'application!" -ForegroundColor Red
    Write-Host ""
    Write-Host "💡 Solutions possibles:" -ForegroundColor Yellow
    Write-Host "   1. Vérifiez que tous les appareils sont bien configurés: flutter devices" -ForegroundColor Cyan
    Write-Host "   2. Nettoyez le projet: flutter clean && flutter pub get" -ForegroundColor Cyan
    Write-Host "   3. Vérifiez la configuration: flutter doctor" -ForegroundColor Cyan
    exit 1
}



