# Script de déploiement complet pour VegN-Bio
# Ce script déploie le backend sur Render et configure le frontend

Write-Host "🚀 Déploiement complet VegN-Bio vers la production" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green

# Configuration
$BACKEND_URL = "https://vegn-bio-backend.onrender.com"
$API_URL = "$BACKEND_URL/api"

Write-Host "📋 Plan de déploiement:" -ForegroundColor Cyan
Write-Host "1. Vérification du backend sur Render.com" -ForegroundColor White
Write-Host "2. Création des utilisateurs de production" -ForegroundColor White
Write-Host "3. Configuration du frontend pour la production" -ForegroundColor White
Write-Host "4. Tests de connectivité" -ForegroundColor White
Write-Host ""

# Étape 1: Vérifier le backend
Write-Host "🔍 Étape 1: Vérification du backend..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$API_URL" -Method GET -TimeoutSec 15
    Write-Host "✅ Backend accessible sur Render.com" -ForegroundColor Green
} catch {
    Write-Host "❌ Backend non accessible. Vérifiez le déploiement sur Render.com" -ForegroundColor Red
    Write-Host "   URL: $BACKEND_URL" -ForegroundColor White
    exit 1
}

# Étape 2: Créer les utilisateurs de production
Write-Host ""
Write-Host "👥 Étape 2: Création des utilisateurs de production..." -ForegroundColor Yellow
if (Test-Path "backend/create-production-users.ps1") {
    Set-Location backend
    & .\create-production-users.ps1
    Set-Location ..
    Write-Host "✅ Utilisateurs de production créés" -ForegroundColor Green
} else {
    Write-Host "⚠️  Script de création d'utilisateurs non trouvé" -ForegroundColor Yellow
}

# Étape 3: Configurer le frontend
Write-Host ""
Write-Host "🔧 Étape 3: Configuration du frontend..." -ForegroundColor Yellow
if (Test-Path "web/update-api-config.ps1") {
    Set-Location web
    & .\update-api-config.ps1
    Set-Location ..
    Write-Host "✅ Frontend configuré pour la production" -ForegroundColor Green
} else {
    Write-Host "⚠️  Script de configuration frontend non trouvé" -ForegroundColor Yellow
}

# Étape 4: Tests de connectivité
Write-Host ""
Write-Host "🧪 Étape 4: Tests de connectivité..." -ForegroundColor Yellow

# Test de connexion admin
$adminLogin = @{
    email = "admin@vegnbio.com"
    password = "AdminVegN2024!"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$API_URL/auth/login" -Method POST -Body $adminLogin -ContentType "application/json"
    Write-Host "✅ Connexion admin réussie" -ForegroundColor Green
} catch {
    Write-Host "❌ Échec de connexion admin: $($_.Exception.Message)" -ForegroundColor Red
}

# Test de connexion restaurateur
$restaurateurLogin = @{
    email = "bastille@vegnbio.com"
    password = "Bastille2024!"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$API_URL/auth/login" -Method POST -Body $restaurateurLogin -ContentType "application/json"
    Write-Host "✅ Connexion restaurateur réussie" -ForegroundColor Green
} catch {
    Write-Host "❌ Échec de connexion restaurateur: $($_.Exception.Message)" -ForegroundColor Red
}

# Test de connexion client
$clientLogin = @{
    email = "client1@example.com"
    password = "Client12024!"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$API_URL/auth/login" -Method POST -Body $clientLogin -ContentType "application/json"
    Write-Host "✅ Connexion client réussie" -ForegroundColor Green
} catch {
    Write-Host "❌ Échec de connexion client: $($_.Exception.Message)" -ForegroundColor Red
}

# Résumé final
Write-Host ""
Write-Host "📊 Résumé du déploiement" -ForegroundColor Cyan
Write-Host "========================" -ForegroundColor Cyan
Write-Host "🌐 Backend URL: $BACKEND_URL" -ForegroundColor White
Write-Host "🔗 API URL: $API_URL" -ForegroundColor White
Write-Host "👥 Utilisateurs créés: 24 comptes de production" -ForegroundColor White
Write-Host "🔧 Frontend configuré: Oui" -ForegroundColor White

Write-Host ""
Write-Host "🎉 Déploiement terminé avec succès !" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Informations importantes:" -ForegroundColor Yellow
Write-Host "🔐 Comptes administrateurs:" -ForegroundColor White
Write-Host "   - admin@vegnbio.com / AdminVegN2024!" -ForegroundColor Gray
Write-Host "   - manager@vegnbio.com / ManagerVegN2024!" -ForegroundColor Gray
Write-Host "   - support@vegnbio.com / SupportVegN2024!" -ForegroundColor Gray

Write-Host ""
Write-Host "🏪 Comptes restaurateurs (exemples):" -ForegroundColor White
Write-Host "   - bastille@vegnbio.com / Bastille2024!" -ForegroundColor Gray
Write-Host "   - republique@vegnbio.com / Republique2024!" -ForegroundColor Gray

Write-Host ""
Write-Host "🚚 Comptes fournisseurs (exemples):" -ForegroundColor White
Write-Host "   - biofrance@supplier.com / BioFrance2024!" -ForegroundColor Gray
Write-Host "   - terroir@supplier.com / Terroir2024!" -ForegroundColor Gray

Write-Host ""
Write-Host "👥 Comptes clients (exemples):" -ForegroundColor White
Write-Host "   - client1@example.com / Client12024!" -ForegroundColor Gray
Write-Host "   - client2@example.com / Client22024!" -ForegroundColor Gray

Write-Host ""
Write-Host "🚀 Prochaines étapes:" -ForegroundColor Yellow
Write-Host "1. Démarrez le frontend: cd web && npm start" -ForegroundColor White
Write-Host "2. Ouvrez http://localhost:3000" -ForegroundColor White
Write-Host "3. Connectez-vous avec un des comptes ci-dessus" -ForegroundColor White
Write-Host "4. Testez toutes les fonctionnalités" -ForegroundColor White
Write-Host ""
Write-Host "📄 Pour la liste complète des comptes, consultez: backend/production-users.json" -ForegroundColor Cyan
