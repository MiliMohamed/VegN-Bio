@echo off
echo ========================================
echo   Démarrage Backend Spring Boot en local
echo ========================================
echo.

REM Vérifier si Java est installé
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERREUR: Java n'est pas installé ou n'est pas dans le PATH
    echo Veuillez installer Java 17 ou plus récent
    pause
    exit /b 1
)

echo Vérification de Java... OK
echo.

REM Vérifier si Maven est installé
mvn --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERREUR: Maven n'est pas installé ou n'est pas dans le PATH
    echo Veuillez installer Maven depuis: https://maven.apache.org/download.cgi
    pause
    exit /b 1
)

echo Vérification de Maven... OK
echo.

REM Aller dans le dossier backend
cd /d "%~dp0backend"

echo Configuration des variables d'environnement...
set SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/vegnbiodb
set SPRING_DATASOURCE_USERNAME=postgres
set SPRING_DATASOURCE_PASSWORD=postgres
set JWT_SECRET=a1f4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4
set SPRING_PROFILES_ACTIVE=default

echo.
echo 🚀 Démarrage du backend Spring Boot...
echo.
echo 📊 Configuration:
echo    Database URL: %SPRING_DATASOURCE_URL%
echo    Username: %SPRING_DATASOURCE_USERNAME%
echo    Profile: %SPRING_PROFILES_ACTIVE%
echo    Port: 8080
echo.

REM Compiler et démarrer l'application
echo Compilation en cours...
mvn clean compile -q

if %errorlevel% neq 0 (
    echo ❌ Erreur lors de la compilation
    pause
    exit /b 1
)

echo Compilation réussie!
echo.
echo Démarrage de l'application Spring Boot...
echo.

REM Démarrer l'application
mvn spring-boot:run

echo.
echo Application arrêtée.
pause
