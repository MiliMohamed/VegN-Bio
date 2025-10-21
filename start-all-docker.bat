@echo off
echo ========================================
echo   Démarrage complet avec Docker
echo ========================================
echo.

REM Vérifier si Docker est installé
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERREUR: Docker n'est pas installé ou n'est pas dans le PATH
    echo Veuillez installer Docker Desktop depuis: https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

echo Vérification de Docker... OK
echo.

REM Vérifier si Docker Compose est installé
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERREUR: Docker Compose n'est pas installé
    echo Veuillez installer Docker Compose
    pause
    exit /b 1
)

echo Vérification de Docker Compose... OK
echo.

REM Aller dans le dossier devops
cd /d "%~dp0devops"

echo 🚀 Démarrage de l'environnement complet...
echo.
echo Services qui vont démarrer:
echo - PostgreSQL (port 5432)
echo - Backend API (port 8080)
echo - Frontend Web (port 3000)
echo.

REM Construire et démarrer tous les services
docker-compose up --build

echo.
echo Environnement arrêté.
pause
