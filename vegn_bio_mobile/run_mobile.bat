@echo off
REM Script de lancement simplifié pour Windows
REM Usage: run_mobile.bat [web|android|ios|windows]

echo ╔══════════════════════════════════════════════════════════╗
echo ║     🚀 VegN-Bio Mobile - Lanceur d'Application 📱      ║
echo ╚══════════════════════════════════════════════════════════╝
echo.

REM Vérifier Flutter
where flutter >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Erreur: Flutter n'est pas installé!
    echo    Installez Flutter depuis: https://flutter.dev/docs/get-started/install
    exit /b 1
)

echo ✅ Flutter détecté
echo.

REM Vérifier le fichier pubspec.yaml
if not exist "pubspec.yaml" (
    echo ❌ Erreur: Vous devez être dans le dossier vegn_bio_mobile/
    echo    Utilisez: cd vegn_bio_mobile
    exit /b 1
)

REM Installer les dépendances
echo 📦 Installation des dépendances...
call flutter pub get
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Erreur lors de l'installation des dépendances!
    exit /b 1
)
echo ✅ Dépendances installées!
echo.

REM Déterminer la plateforme
set PLATFORM=%1
if "%PLATFORM%"=="" set PLATFORM=web

echo 🚀 Lancement sur: %PLATFORM%
echo.

REM Lancer selon la plateforme
if "%PLATFORM%"=="web" (
    echo 🌐 Lancement sur Chrome...
    echo    URL: http://localhost:3000
    echo.
    flutter run -d chrome --web-port=3000
) else if "%PLATFORM%"=="android" (
    echo 🤖 Lancement sur Android...
    flutter run -d android
) else if "%PLATFORM%"=="windows" (
    echo 💻 Lancement sur Windows...
    flutter run -d windows
) else (
    echo ⚠️  Plateforme inconnue: %PLATFORM%
    echo    Utilisations valides: web, android, windows
    exit /b 1
)

echo.
echo ✅ Application lancée!




