@echo off
echo ========================================
echo   Arrêt des services Docker
echo ========================================
echo.

REM Aller dans le dossier devops
cd /d "%~dp0devops"

echo Arrêt des services Docker...
docker-compose down

if %errorlevel% equ 0 (
    echo.
    echo ✅ Services arrêtés avec succès!
    echo.
    echo Pour supprimer aussi les volumes (données de la base):
    echo docker-compose down -v
    echo.
) else (
    echo ❌ Erreur lors de l'arrêt des services
)

echo.
pause
