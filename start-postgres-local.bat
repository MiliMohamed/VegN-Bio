@echo off
echo ========================================
echo   Démarrage PostgreSQL en local (Docker)
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

REM Aller dans le dossier devops
cd /d "%~dp0devops"

echo Démarrage de PostgreSQL avec Docker...
echo.
echo Configuration:
echo - Base de données: vegnbiodb
echo - Utilisateur: postgres
echo - Mot de passe: postgres
echo - Port: 5432
echo.

REM Démarrer seulement PostgreSQL
docker-compose up -d db

if %errorlevel% equ 0 (
    echo.
    echo ✅ PostgreSQL démarré avec succès!
    echo.
    echo 📊 Informations de connexion:
    echo    Host: localhost
    echo    Port: 5432
    echo    Database: vegnbiodb
    echo    Username: postgres
    echo    Password: postgres
    echo.
    echo 🔗 URL de connexion JDBC:
    echo    jdbc:postgresql://localhost:5432/vegnbiodb
    echo.
    echo Pour arrêter PostgreSQL: docker-compose down
    echo Pour voir les logs: docker-compose logs db
    echo.
) else (
    echo ❌ Erreur lors du démarrage de PostgreSQL
    echo Vérifiez que Docker est en cours d'exécution
)

echo.
echo Appuyez sur une touche pour continuer...
pause >nul
