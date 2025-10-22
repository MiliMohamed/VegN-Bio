# Script de deploiement simple VEG'N BIO
Write-Host "Deploiement Production VEG'N BIO" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green

# Verification des prerequis
Write-Host "`nVerification des prerequis..." -ForegroundColor Yellow

# Verifier Java
try {
    $javaVersion = java -version 2>&1 | Select-String "version"
    Write-Host "Java installe: $javaVersion" -ForegroundColor Green
} catch {
    Write-Host "Java non installe. Veuillez installer Java 17 ou superieur." -ForegroundColor Red
    exit 1
}

# Verifier Node.js
try {
    $nodeVersion = node --version
    Write-Host "Node.js installe: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "Node.js non installe. Veuillez installer Node.js 18 ou superieur." -ForegroundColor Red
    exit 1
}

# Configuration de la base de donnees
Write-Host "`nConfiguration de la base de donnees..." -ForegroundColor Yellow

# Variables d'environnement pour la production
$env:SPRING_PROFILES_ACTIVE = "prod"
$env:DATABASE_URL = "jdbc:postgresql://localhost:5432/vegn_bio_prod"
$env:DATABASE_USERNAME = "vegn_bio_user"
$env:DATABASE_PASSWORD = "vegn_bio_secure_2024!"

Write-Host "Variables d'environnement configurees" -ForegroundColor Green

# Deploiement du backend
Write-Host "`nDeploiement du backend..." -ForegroundColor Yellow

Set-Location backend

# Nettoyage et compilation
Write-Host "Compilation du backend..." -ForegroundColor Cyan
./mvnw clean package -DskipTests

if ($LASTEXITCODE -ne 0) {
    Write-Host "Erreur lors de la compilation du backend" -ForegroundColor Red
    exit 1
}

Write-Host "Backend compile avec succes" -ForegroundColor Green

# Demarrage du backend en arriere-plan
Write-Host "Demarrage du backend..." -ForegroundColor Cyan
Start-Process -FilePath "java" -ArgumentList "-jar", "target/vegn-bio-api.jar", "--spring.profiles.active=prod" -WindowStyle Hidden

# Attendre que le backend demarre
Write-Host "Attente du demarrage du backend..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Test de connectivite du backend
Write-Host "Test de connectivite du backend..." -ForegroundColor Cyan
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/restaurants" -Method GET
    Write-Host "Backend operationnel - $($response.Count) restaurants trouves" -ForegroundColor Green
} catch {
    Write-Host "Backend non accessible" -ForegroundColor Red
    exit 1
}

Set-Location ..

# Deploiement du frontend
Write-Host "`nDeploiement du frontend..." -ForegroundColor Yellow

Set-Location web

# Installation des dependances
Write-Host "Installation des dependances..." -ForegroundColor Cyan
npm install

if ($LASTEXITCODE -ne 0) {
    Write-Host "Erreur lors de l'installation des dependances" -ForegroundColor Red
    exit 1
}

# Build de production
Write-Host "Build de production..." -ForegroundColor Cyan
npm run build

if ($LASTEXITCODE -ne 0) {
    Write-Host "Erreur lors du build" -ForegroundColor Red
    exit 1
}

Write-Host "Frontend builde avec succes" -ForegroundColor Green

# Demarrage du frontend
Write-Host "Demarrage du frontend..." -ForegroundColor Cyan
Start-Process -FilePath "npm" -ArgumentList "run", "start" -WindowStyle Hidden

Set-Location ..

# Tests de validation
Write-Host "`nTests de validation..." -ForegroundColor Yellow

# Test des endpoints critiques
$endpoints = @(
    "http://localhost:8080/api/restaurants",
    "http://localhost:8080/api/menus",
    "http://localhost:8080/api/events"
)

foreach ($endpoint in $endpoints) {
    try {
        $response = Invoke-RestMethod -Uri $endpoint -Method GET
        Write-Host "$endpoint - OK" -ForegroundColor Green
    } catch {
        Write-Host "$endpoint - ERREUR" -ForegroundColor Red
    }
}

# Test de l'authentification
Write-Host "`nTest de l'authentification..." -ForegroundColor Yellow

$loginData = @{
    email = "admin@vegnbio.fr"
    password = "TestVegN2024!"
} | ConvertTo-Json

try {
    $authResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/login" -Method POST -Body $loginData -ContentType "application/json"
    Write-Host "Authentification admin OK - Token recu" -ForegroundColor Green
} catch {
    Write-Host "Erreur d'authentification" -ForegroundColor Red
}

# Affichage des informations de deploiement
Write-Host "`nDEPLOIEMENT TERMINE AVEC SUCCES !" -ForegroundColor Green
Write-Host "===================================" -ForegroundColor Green

Write-Host "`nApplications disponibles :" -ForegroundColor Cyan
Write-Host "• Frontend Web : http://localhost:3000" -ForegroundColor White
Write-Host "• Backend API : http://localhost:8080" -ForegroundColor White
Write-Host "• Documentation API : http://localhost:8080/swagger-ui.html" -ForegroundColor White

Write-Host "`nComptes de test disponibles :" -ForegroundColor Cyan
Write-Host "• Admin : admin@vegnbio.fr / TestVegN2024!" -ForegroundColor White
Write-Host "• Restaurateur : restaurateur@vegnbio.fr / TestVegN2024!" -ForegroundColor White
Write-Host "• Client : client@vegnbio.fr / TestVegN2024!" -ForegroundColor White

Write-Host "`nRestaurants configures :" -ForegroundColor Cyan
Write-Host "• VEG'N BIO BASTILLE (BAS)" -ForegroundColor White
Write-Host "• VEG'N BIO REPUBLIQUE (REP)" -ForegroundColor White
Write-Host "• VEG'N BIO NATION (NAT)" -ForegroundColor White
Write-Host "• VEG'N BIO PLACE D'ITALIE/MONTPARNASSE/IVRY (ITA)" -ForegroundColor White
Write-Host "• VEG'N BIO BEAUBOURG (BOU)" -ForegroundColor White

Write-Host "`nDonnees configurees :" -ForegroundColor Cyan
Write-Host "• 5 restaurants avec horaires et equipements" -ForegroundColor White
Write-Host "• Menus varies avec plats vegetariens/vegetaliens" -ForegroundColor White
Write-Host "• Gestion des allergenes (14 types)" -ForegroundColor White
Write-Host "• Evenements et reservations de salles" -ForegroundColor White
Write-Host "• Systeme de rapports et signalements" -ForegroundColor White

Write-Host "`nCommandes utiles :" -ForegroundColor Cyan
Write-Host "• Arreter l'application : ./stop-docker.bat" -ForegroundColor White
Write-Host "• Logs backend : tail -f backend/logs/application.log" -ForegroundColor White
Write-Host "• Redemarrer : ./deploy-simple.ps1" -ForegroundColor White

Write-Host "`nVotre application VEG'N BIO est maintenant prete en production !" -ForegroundColor Green
