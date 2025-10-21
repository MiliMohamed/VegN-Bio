# ========================================
#   Démarrage Backend Spring Boot en local
# ========================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Démarrage Backend Spring Boot en local" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Vérifier si Java est installé
try {
    $javaVersion = java -version 2>&1 | Select-String "version"
    Write-Host "Vérification de Java... OK" -ForegroundColor Green
    Write-Host "Version: $javaVersion" -ForegroundColor Gray
} catch {
    Write-Host "ERREUR: Java n'est pas installé ou n'est pas dans le PATH" -ForegroundColor Red
    Write-Host "Veuillez installer Java 17 ou plus récent" -ForegroundColor Yellow
    Read-Host "Appuyez sur Entrée pour continuer"
    exit 1
}

Write-Host ""

# Vérifier si Maven est installé
try {
    $mavenVersion = mvn --version | Select-String "Apache Maven"
    Write-Host "Vérification de Maven... OK" -ForegroundColor Green
    Write-Host "Version: $mavenVersion" -ForegroundColor Gray
} catch {
    Write-Host "ERREUR: Maven n'est pas installé ou n'est pas dans le PATH" -ForegroundColor Red
    Write-Host "Veuillez installer Maven depuis: https://maven.apache.org/download.cgi" -ForegroundColor Yellow
    Read-Host "Appuyez sur Entrée pour continuer"
    exit 1
}

Write-Host ""

# Aller dans le dossier backend
$backendPath = Join-Path $PSScriptRoot "backend"
Set-Location $backendPath

Write-Host "Configuration des variables d'environnement..." -ForegroundColor Yellow

# Configuration des variables d'environnement
$env:SPRING_DATASOURCE_URL = "jdbc:postgresql://localhost:5432/vegnbiodb"
$env:SPRING_DATASOURCE_USERNAME = "postgres"
$env:SPRING_DATASOURCE_PASSWORD = "postgres"
$env:JWT_SECRET = "a1f4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4"
$env:SPRING_PROFILES_ACTIVE = "default"

Write-Host ""
Write-Host "🚀 Démarrage du backend Spring Boot..." -ForegroundColor Yellow
Write-Host ""
Write-Host "📊 Configuration:" -ForegroundColor Cyan
Write-Host "   Database URL: $env:SPRING_DATASOURCE_URL" -ForegroundColor White
Write-Host "   Username: $env:SPRING_DATASOURCE_USERNAME" -ForegroundColor White
Write-Host "   Profile: $env:SPRING_PROFILES_ACTIVE" -ForegroundColor White
Write-Host "   Port: 8080" -ForegroundColor White
Write-Host ""

# Compiler et démarrer l'application
Write-Host "Compilation en cours..." -ForegroundColor Yellow
try {
    mvn clean compile -q
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Erreur lors de la compilation" -ForegroundColor Red
        Read-Host "Appuyez sur Entrée pour continuer"
        exit 1
    }
    
    Write-Host "Compilation réussie!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Démarrage de l'application Spring Boot..." -ForegroundColor Yellow
    Write-Host ""
    
    # Démarrer l'application
    mvn spring-boot:run
    
} catch {
    Write-Host "❌ Erreur lors de l'exécution de Maven" -ForegroundColor Red
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "Application arrêtée." -ForegroundColor Yellow
Read-Host "Appuyez sur Entrée pour continuer"
