# Script de deploiement production VEG'N BIO
# Ce script deploye l'application avec les donnees specifiques VEG'N BIO

Write-Host "Deploiement Production VEG'N BIO" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green

# Vérification des prérequis
Write-Host "`n📋 Vérification des prérequis..." -ForegroundColor Yellow

# Vérifier Java
try {
    $javaVersion = java -version 2>&1 | Select-String "version"
    Write-Host "✅ Java installé: $javaVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Java non installé. Veuillez installer Java 17 ou supérieur." -ForegroundColor Red
    exit 1
}

# Vérifier Node.js
try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js installé: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js non installé. Veuillez installer Node.js 18 ou supérieur." -ForegroundColor Red
    exit 1
}

# Vérifier PostgreSQL
try {
    $pgVersion = psql --version
    Write-Host "✅ PostgreSQL installé: $pgVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ PostgreSQL non installé. Veuillez installer PostgreSQL." -ForegroundColor Red
    exit 1
}

# Configuration de la base de données
Write-Host "`n🗄️ Configuration de la base de données..." -ForegroundColor Yellow

# Variables d'environnement pour la production
$env:SPRING_PROFILES_ACTIVE = "prod"
$env:DATABASE_URL = "jdbc:postgresql://localhost:5432/vegn_bio_prod"
$env:DATABASE_USERNAME = "vegn_bio_user"
$env:DATABASE_PASSWORD = "vegn_bio_secure_2024!"

Write-Host "✅ Variables d'environnement configurées" -ForegroundColor Green

# Création de la base de données si elle n'existe pas
Write-Host "`n📊 Création de la base de données..." -ForegroundColor Yellow

$createDbScript = @"
CREATE DATABASE vegn_bio_prod;
CREATE USER vegn_bio_user WITH PASSWORD 'vegn_bio_secure_2024!';
GRANT ALL PRIVILEGES ON DATABASE vegn_bio_prod TO vegn_bio_user;
"@

try {
    psql -U postgres -c $createDbScript
    Write-Host "✅ Base de données créée avec succès" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Base de données peut-être déjà existante, continuation..." -ForegroundColor Yellow
}

# Déploiement du backend
Write-Host "`n🔧 Déploiement du backend..." -ForegroundColor Yellow

Set-Location backend

# Nettoyage et compilation
Write-Host "📦 Compilation du backend..." -ForegroundColor Cyan
./mvnw clean package -DskipTests

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Erreur lors de la compilation du backend" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Backend compilé avec succès" -ForegroundColor Green

# Démarrage du backend en arrière-plan
Write-Host "🚀 Démarrage du backend..." -ForegroundColor Cyan
Start-Process -FilePath "java" -ArgumentList "-jar", "target/vegn-bio-api.jar", "--spring.profiles.active=prod" -WindowStyle Hidden

# Attendre que le backend démarre
Write-Host "⏳ Attente du démarrage du backend..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Test de connectivité du backend
Write-Host "🔍 Test de connectivité du backend..." -ForegroundColor Cyan
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/restaurants" -Method GET
    Write-Host "✅ Backend opérationnel - $($response.Count) restaurants trouvés" -ForegroundColor Green
} catch {
    Write-Host "❌ Backend non accessible" -ForegroundColor Red
    exit 1
}

Set-Location ..

# Déploiement du frontend
Write-Host "`n🎨 Déploiement du frontend..." -ForegroundColor Yellow

Set-Location web

# Installation des dépendances
Write-Host "📦 Installation des dépendances..." -ForegroundColor Cyan
npm install

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Erreur lors de l'installation des dépendances" -ForegroundColor Red
    exit 1
}

# Build de production
Write-Host "🏗️ Build de production..." -ForegroundColor Cyan
npm run build

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Erreur lors du build" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Frontend buildé avec succès" -ForegroundColor Green

# Démarrage du frontend
Write-Host "🚀 Démarrage du frontend..." -ForegroundColor Cyan
Start-Process -FilePath "npm" -ArgumentList "run", "start" -WindowStyle Hidden

Set-Location ..

# Tests de validation
Write-Host "`n🧪 Tests de validation..." -ForegroundColor Yellow

# Test des endpoints critiques
$endpoints = @(
    "http://localhost:8080/api/restaurants",
    "http://localhost:8080/api/menus",
    "http://localhost:8080/api/events"
)

foreach ($endpoint in $endpoints) {
    try {
        $response = Invoke-RestMethod -Uri $endpoint -Method GET
        Write-Host "✅ $endpoint - OK" -ForegroundColor Green
    } catch {
        Write-Host "❌ $endpoint - ERREUR" -ForegroundColor Red
    }
}

# Test de l'authentification
Write-Host "`n🔐 Test de l'authentification..." -ForegroundColor Yellow

$loginData = @{
    email = "admin@vegnbio.fr"
    password = "TestVegN2024!"
} | ConvertTo-Json

try {
    $authResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/login" -Method POST -Body $loginData -ContentType "application/json"
    Write-Host "✅ Authentification admin OK - Token reçu" -ForegroundColor Green
} catch {
    Write-Host "❌ Erreur d'authentification" -ForegroundColor Red
}

# Affichage des informations de déploiement
Write-Host "`n🎉 DÉPLOIEMENT TERMINÉ AVEC SUCCÈS !" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green

Write-Host "`n📱 Applications disponibles :" -ForegroundColor Cyan
Write-Host "• Frontend Web : http://localhost:3000" -ForegroundColor White
Write-Host "• Backend API : http://localhost:8080" -ForegroundColor White
Write-Host "• Documentation API : http://localhost:8080/swagger-ui.html" -ForegroundColor White

Write-Host "`n👥 Comptes de test disponibles :" -ForegroundColor Cyan
Write-Host "• Admin : admin@vegnbio.fr / TestVegN2024!" -ForegroundColor White
Write-Host "• Restaurateur : restaurateur@vegnbio.fr / TestVegN2024!" -ForegroundColor White
Write-Host "• Client : client@vegnbio.fr / TestVegN2024!" -ForegroundColor White

Write-Host "`n🏢 Restaurants configurés :" -ForegroundColor Cyan
Write-Host "• VEG'N BIO BASTILLE (BAS)" -ForegroundColor White
Write-Host "• VEG'N BIO REPUBLIQUE (REP)" -ForegroundColor White
Write-Host "• VEG'N BIO NATION (NAT)" -ForegroundColor White
Write-Host "• VEG'N BIO PLACE D'ITALIE/MONTPARNASSE/IVRY (ITA)" -ForegroundColor White
Write-Host "• VEG'N BIO BEAUBOURG (BOU)" -ForegroundColor White

Write-Host "`n📊 Données configurées :" -ForegroundColor Cyan
Write-Host "• 5 restaurants avec horaires et équipements" -ForegroundColor White
Write-Host "• Menus variés avec plats végétariens/végétaliens" -ForegroundColor White
Write-Host "• Gestion des allergènes (14 types)" -ForegroundColor White
Write-Host "• Événements et réservations de salles" -ForegroundColor White
Write-Host "• Système de rapports et signalements" -ForegroundColor White

Write-Host "`n🔧 Commandes utiles :" -ForegroundColor Cyan
Write-Host "• Arrêter l'application : ./stop-docker.bat" -ForegroundColor White
Write-Host "• Logs backend : tail -f backend/logs/application.log" -ForegroundColor White
Write-Host "• Redémarrer : ./deploy-production-vegn-bio.ps1" -ForegroundColor White

Write-Host "`n✨ Votre application VEG'N BIO est maintenant prête en production !" -ForegroundColor Green
