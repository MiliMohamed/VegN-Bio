@echo off
echo ========================================
echo   Test de l'API Backend
echo ========================================
echo.

set API_URL=http://localhost:8080

echo Test de l'API Backend à l'adresse: %API_URL%
echo.

echo 1. Test de santé de l'API...
curl -s -o nul -w "Status: %%{http_code}\n" "%API_URL%/actuator/health" 2>nul
if %errorlevel% neq 0 (
    echo ❌ L'API n'est pas accessible
    echo Vérifiez que le backend est démarré sur le port 8080
    pause
    exit /b 1
)

echo ✅ API accessible!
echo.

echo 2. Test des restaurants...
curl -s "%API_URL%/api/restaurants" | findstr "name" >nul
if %errorlevel% equ 0 (
    echo ✅ Endpoint restaurants fonctionne
) else (
    echo ❌ Problème avec l'endpoint restaurants
)

echo.
echo 3. Test de l'authentification...
curl -s -X POST "%API_URL%/api/auth/login" ^
     -H "Content-Type: application/json" ^
     -d "{\"email\":\"admin@vegnbio.fr\",\"password\":\"admin123\"}" ^
     | findstr "token" >nul
if %errorlevel% equ 0 (
    echo ✅ Authentification fonctionne
) else (
    echo ❌ Problème avec l'authentification
)

echo.
echo 4. Test du chatbot vétérinaire...
curl -s -X POST "%API_URL%/api/chatbot/veterinary-diagnosis" ^
     -H "Content-Type: application/json" ^
     -d "{\"animalBreed\":\"Golden Retriever\",\"symptoms\":[\"fatigue\",\"perte d'appétit\"]}" ^
     | findstr "diagnosis" >nul
if %errorlevel% equ 0 (
    echo ✅ Chatbot vétérinaire fonctionne
) else (
    echo ❌ Problème avec le chatbot vétérinaire
)

echo.
echo ========================================
echo   Résumé des tests
echo ========================================
echo.
echo Pour tester manuellement:
echo - API Health: %API_URL%/actuator/health
echo - Restaurants: %API_URL%/api/restaurants
echo - Documentation: %API_URL%/swagger-ui.html
echo.

pause
