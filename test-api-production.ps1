# Script de test pour vérifier l'API de production VegN-Bio
# Teste la connectivité et les fonctionnalités principales

Write-Host "🔍 Test de l'API de production VegN-Bio" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green

# Configuration
$API_BASE_URL = "https://vegn-bio-backend.onrender.com/api"
$BACKEND_URL = "https://vegn-bio-backend.onrender.com"

Write-Host "🌐 URL du backend: $BACKEND_URL" -ForegroundColor Cyan
Write-Host "🔗 URL de l'API: $API_BASE_URL" -ForegroundColor Cyan
Write-Host ""

# Test 1: Vérification de la connectivité de base
Write-Host "📡 Test 1: Connectivité de base..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri $BACKEND_URL -Method GET -TimeoutSec 15
    Write-Host "✅ Backend accessible" -ForegroundColor Green
} catch {
    Write-Host "❌ Backend non accessible: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "   Code d'erreur: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
}

# Test 2: Vérification de l'endpoint API
Write-Host ""
Write-Host "🔌 Test 2: Endpoint API..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri $API_BASE_URL -Method GET -TimeoutSec 15
    Write-Host "✅ Endpoint API accessible" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Endpoint API non accessible: $($_.Exception.Message)" -ForegroundColor Yellow
    Write-Host "   Code d'erreur: $($_.Exception.Response.StatusCode)" -ForegroundColor Yellow
}

# Test 3: Test de connexion avec compte admin
Write-Host ""
Write-Host "🔐 Test 3: Connexion admin..." -ForegroundColor Yellow
$adminLogin = @{
    email = "admin@vegnbio.com"
    password = "AdminVegN2024!"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$API_BASE_URL/auth/login" -Method POST -Body $adminLogin -ContentType "application/json" -TimeoutSec 15
    Write-Host "✅ Connexion admin réussie" -ForegroundColor Green
    Write-Host "   Token reçu: $($response.token.Substring(0, 20))..." -ForegroundColor Cyan
    $adminToken = $response.token
} catch {
    Write-Host "❌ Échec de connexion admin: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "   Code d'erreur: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    $adminToken = $null
}

# Test 4: Test de connexion avec compte restaurateur
Write-Host ""
Write-Host "🏪 Test 4: Connexion restaurateur..." -ForegroundColor Yellow
$restaurateurLogin = @{
    email = "bastille@vegnbio.com"
    password = "Bastille2024!"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$API_BASE_URL/auth/login" -Method POST -Body $restaurateurLogin -ContentType "application/json" -TimeoutSec 15
    Write-Host "✅ Connexion restaurateur réussie" -ForegroundColor Green
    Write-Host "   Token reçu: $($response.token.Substring(0, 20))..." -ForegroundColor Cyan
} catch {
    Write-Host "❌ Échec de connexion restaurateur: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "   Code d'erreur: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
}

# Test 5: Test de connexion avec compte client
Write-Host ""
Write-Host "👥 Test 5: Connexion client..." -ForegroundColor Yellow
$clientLogin = @{
    email = "client1@example.com"
    password = "Client12024!"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$API_BASE_URL/auth/login" -Method POST -Body $clientLogin -ContentType "application/json" -TimeoutSec 15
    Write-Host "✅ Connexion client réussie" -ForegroundColor Green
    Write-Host "   Token reçu: $($response.token.Substring(0, 20))..." -ForegroundColor Cyan
} catch {
    Write-Host "❌ Échec de connexion client: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "   Code d'erreur: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
}

# Test 6: Test de récupération des utilisateurs (si admin connecté)
if ($adminToken) {
    Write-Host ""
    Write-Host "👥 Test 6: Récupération des utilisateurs..." -ForegroundColor Yellow
    $headers = @{
        "Authorization" = "Bearer $adminToken"
        "Content-Type" = "application/json"
    }
    
    try {
        $response = Invoke-RestMethod -Uri "$API_BASE_URL/users" -Method GET -Headers $headers -TimeoutSec 15
        $userCount = $response.Count
        Write-Host "✅ Utilisateurs récupérés: $userCount utilisateurs" -ForegroundColor Green
        
        # Compter par rôle
        $adminCount = ($response | Where-Object { $_.role -eq "ADMIN" }).Count
        $restaurateurCount = ($response | Where-Object { $_.role -eq "RESTAURATEUR" }).Count
        $fournisseurCount = ($response | Where-Object { $_.role -eq "FOURNISSEUR" }).Count
        $clientCount = ($response | Where-Object { $_.role -eq "CLIENT" }).Count
        
        Write-Host "   📊 Répartition par rôle:" -ForegroundColor Cyan
        Write-Host "      - Administrateurs: $adminCount" -ForegroundColor White
        Write-Host "      - Restaurateurs: $restaurateurCount" -ForegroundColor White
        Write-Host "      - Fournisseurs: $fournisseurCount" -ForegroundColor White
        Write-Host "      - Clients: $clientCount" -ForegroundColor White
    } catch {
        Write-Host "❌ Échec de récupération des utilisateurs: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Test 7: Test de récupération des restaurants
Write-Host ""
Write-Host "🏪 Test 7: Récupération des restaurants..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$API_BASE_URL/restaurants" -Method GET -TimeoutSec 15
    $restaurantCount = $response.Count
    Write-Host "✅ Restaurants récupérés: $restaurantCount restaurants" -ForegroundColor Green
    
    if ($restaurantCount -gt 0) {
        Write-Host "   📋 Liste des restaurants:" -ForegroundColor Cyan
        foreach ($restaurant in $response) {
            Write-Host "      - $($restaurant.name) ($($restaurant.code))" -ForegroundColor White
        }
    }
} catch {
    Write-Host "❌ Échec de récupération des restaurants: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 8: Test de récupération des menus
Write-Host ""
Write-Host "🍽️ Test 8: Récupération des menus..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$API_BASE_URL/menus" -Method GET -TimeoutSec 15
    $menuCount = $response.Count
    Write-Host "✅ Menus récupérés: $menuCount menus" -ForegroundColor Green
} catch {
    Write-Host "❌ Échec de récupération des menus: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 9: Test de récupération des allergènes
Write-Host ""
Write-Host "⚠️ Test 9: Récupération des allergènes..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$API_BASE_URL/allergens" -Method GET -TimeoutSec 15
    $allergenCount = $response.Count
    Write-Host "✅ Allergènes récupérés: $allergenCount allergènes" -ForegroundColor Green
} catch {
    Write-Host "❌ Échec de récupération des allergènes: $($_.Exception.Message)" -ForegroundColor Red
}

# Résumé des tests
Write-Host ""
Write-Host "📊 Résumé des tests" -ForegroundColor Cyan
Write-Host "==================" -ForegroundColor Cyan
Write-Host "🌐 Backend: $BACKEND_URL" -ForegroundColor White
Write-Host "🔗 API: $API_BASE_URL" -ForegroundColor White
Write-Host "✅ Tests de connectivité: Effectués" -ForegroundColor Green
Write-Host "✅ Tests d'authentification: Effectués" -ForegroundColor Green
Write-Host "✅ Tests des endpoints: Effectués" -ForegroundColor Green

Write-Host ""
Write-Host "🎉 Tests terminés !" -ForegroundColor Green
Write-Host ""
Write-Host "💡 Si des tests ont échoué:" -ForegroundColor Yellow
Write-Host "1. Vérifiez que le backend est déployé sur Render.com" -ForegroundColor White
Write-Host "2. Vérifiez que les utilisateurs existent en base" -ForegroundColor White
Write-Host "3. Vérifiez la connectivité réseau" -ForegroundColor White
Write-Host "4. Consultez les logs sur Render.com" -ForegroundColor White


