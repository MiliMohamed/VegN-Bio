# Script de démarrage rapide VEG'N BIO Production
# Ce script démarre rapidement l'application en production

Write-Host "🚀 Démarrage Rapide VEG'N BIO Production" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

# Vérification des ports
Write-Host "`n🔍 Vérification des ports..." -ForegroundColor Yellow

$backendPort = 8080
$frontendPort = 3000

# Vérifier si les ports sont libres
$backendProcess = Get-NetTCPConnection -LocalPort $backendPort -ErrorAction SilentlyContinue
$frontendProcess = Get-NetTCPConnection -LocalPort $frontendPort -ErrorAction SilentlyContinue

if ($backendProcess) {
    Write-Host "⚠️ Port $backendPort déjà utilisé. Arrêt des processus..." -ForegroundColor Yellow
    $backendProcess | ForEach-Object { Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue }
}

if ($frontendProcess) {
    Write-Host "⚠️ Port $frontendPort déjà utilisé. Arrêt des processus..." -ForegroundColor Yellow
    $frontendProcess | ForEach-Object { Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue }
}

# Attendre que les ports se libèrent
Start-Sleep -Seconds 3

# Démarrage du backend
Write-Host "`n🔧 Démarrage du backend..." -ForegroundColor Yellow

Set-Location backend

# Vérifier si le JAR existe
if (-not (Test-Path "target/vegn-bio-api.jar")) {
    Write-Host "📦 Compilation du backend..." -ForegroundColor Cyan
    ./mvnw clean package -DskipTests -q
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Erreur lors de la compilation" -ForegroundColor Red
        exit 1
    }
}

# Démarrage du backend en arrière-plan
Write-Host "🚀 Lancement du backend..." -ForegroundColor Cyan
Start-Process -FilePath "java" -ArgumentList "-jar", "target/vegn-bio-api.jar", "--spring.profiles.active=prod" -WindowStyle Hidden

Set-Location ..

# Démarrage du frontend
Write-Host "`n🎨 Démarrage du frontend..." -ForegroundColor Yellow

Set-Location web

# Vérifier si node_modules existe
if (-not (Test-Path "node_modules")) {
    Write-Host "📦 Installation des dépendances..." -ForegroundColor Cyan
    npm install --silent
}

# Démarrage du frontend en arrière-plan
Write-Host "🚀 Lancement du frontend..." -ForegroundColor Cyan
Start-Process -FilePath "npm" -ArgumentList "run", "start" -WindowStyle Hidden

Set-Location ..

# Attendre que les services démarrent
Write-Host "`n⏳ Attente du démarrage des services..." -ForegroundColor Yellow

$maxAttempts = 30
$attempt = 0

while ($attempt -lt $maxAttempts) {
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:8080/api/restaurants" -Method GET -TimeoutSec 5
        Write-Host "✅ Backend démarré avec succès" -ForegroundColor Green
        break
    } catch {
        $attempt++
        Write-Host "." -NoNewline -ForegroundColor Yellow
        Start-Sleep -Seconds 2
    }
}

if ($attempt -eq $maxAttempts) {
    Write-Host "`n❌ Timeout du démarrage du backend" -ForegroundColor Red
    exit 1
}

# Attendre le frontend
Start-Sleep -Seconds 10

# Test de connectivité frontend
try {
    $frontendResponse = Invoke-WebRequest -Uri "http://localhost:3000" -Method GET -TimeoutSec 5
    if ($frontendResponse.StatusCode -eq 200) {
        Write-Host "✅ Frontend démarré avec succès" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠️ Frontend en cours de démarrage..." -ForegroundColor Yellow
}

# Affichage des informations
Write-Host "`n🎉 APPLICATION VEG'N BIO DÉMARRÉE !" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green

Write-Host "`n🌐 Accès aux applications :" -ForegroundColor Cyan
Write-Host "• Frontend Web : http://localhost:3000" -ForegroundColor White
Write-Host "• Backend API : http://localhost:8080/api" -ForegroundColor White
Write-Host "• Documentation : http://localhost:8080/swagger-ui.html" -ForegroundColor White

Write-Host "`n👥 Comptes de test :" -ForegroundColor Cyan
Write-Host "• Admin : admin@vegnbio.fr / TestVegN2024!" -ForegroundColor White
Write-Host "• Restaurateur : restaurateur@vegnbio.fr / TestVegN2024!" -ForegroundColor White
Write-Host "• Client : client@vegnbio.fr / TestVegN2024!" -ForegroundColor White

Write-Host "`n🏢 Restaurants disponibles :" -ForegroundColor Cyan
Write-Host "• VEG'N BIO BASTILLE" -ForegroundColor White
Write-Host "• VEG'N BIO REPUBLIQUE" -ForegroundColor White
Write-Host "• VEG'N BIO NATION" -ForegroundColor White
Write-Host "• VEG'N BIO PLACE D'ITALIE/MONTPARNASSE/IVRY" -ForegroundColor White
Write-Host "• VEG'N BIO BEAUBOURG" -ForegroundColor White

Write-Host "`n📱 Fonctionnalités disponibles :" -ForegroundColor Cyan
Write-Host "• Consultation des menus" -ForegroundColor White
Write-Host "• Réservation de salles de réunion" -ForegroundColor White
Write-Host "• Gestion des allergènes" -ForegroundColor White
Write-Host "• Rapports et signalements" -ForegroundColor White
Write-Host "• Événements et conférences" -ForegroundColor White

Write-Host "`n🔧 Commandes utiles :" -ForegroundColor Cyan
Write-Host "• Arrêter : ./stop-docker.bat" -ForegroundColor White
Write-Host "• Tests : ./test-production-vegn-bio.ps1" -ForegroundColor White
Write-Host "• Logs : tail -f backend/logs/application.log" -ForegroundColor White

Write-Host "`n✨ Votre application VEG'N BIO est prête à l'emploi !" -ForegroundColor Green
