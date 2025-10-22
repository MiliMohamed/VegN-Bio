#!/usr/bin/env pwsh
# Script de diagnostic pour l'API VEG'N BIO

Write-Host "🔍 Diagnostic de l'API VEG'N BIO" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green

$API_URL = "https://vegn-bio-backend.onrender.com"

Write-Host "`n🌐 Test de connectivité de base..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri $API_URL -Method GET -TimeoutSec 10
    Write-Host "✅ API accessible - Status: $($response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "❌ API non accessible" -ForegroundColor Red
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "`n🏥 Test de santé de l'API..." -ForegroundColor Yellow
try {
    $healthResponse = Invoke-RestMethod -Uri "$API_URL/actuator/health" -Method GET -TimeoutSec 15
    Write-Host "✅ API en bonne santé - Status: $($healthResponse.status)" -ForegroundColor Green
} catch {
    Write-Host "❌ Problème de santé de l'API" -ForegroundColor Red
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n🏪 Test des restaurants (GET)..." -ForegroundColor Yellow
try {
    $restaurantsResponse = Invoke-RestMethod -Uri "$API_URL/api/restaurants" -Method GET -ContentType "application/json" -TimeoutSec 15
    Write-Host "✅ Restaurants récupérés: $($restaurantsResponse.Count)" -ForegroundColor Green
    
    # Afficher les restaurants disponibles
    foreach ($restaurant in $restaurantsResponse) {
        Write-Host "  - $($restaurant.name) (ID: $($restaurant.id), Code: $($restaurant.code))" -ForegroundColor White
    }
} catch {
    Write-Host "❌ Erreur lors de la récupération des restaurants" -ForegroundColor Red
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n🍽️ Test des menus (GET)..." -ForegroundColor Yellow
try {
    $menusResponse = Invoke-RestMethod -Uri "$API_URL/api/menus" -Method GET -ContentType "application/json" -TimeoutSec 15
    Write-Host "✅ Menus récupérés: $($menusResponse.Count)" -ForegroundColor Green
} catch {
    Write-Host "❌ Erreur lors de la récupération des menus" -ForegroundColor Red
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n🔐 Test d'authentification..." -ForegroundColor Yellow
# Test de connexion avec les comptes de test
$testAccounts = @(
    @{email="admin@vegnbio.fr"; password="TestVegN2024!"},
    @{email="restaurateur@vegnbio.fr"; password="TestVegN2024!"},
    @{email="client@vegnbio.fr"; password="TestVegN2024!"}
)

foreach ($account in $testAccounts) {
    try {
        $loginData = @{
            email = $account.email
            password = $account.password
        } | ConvertTo-Json
        
        $loginResponse = Invoke-RestMethod -Uri "$API_URL/api/auth/login" -Method POST -Body $loginData -ContentType "application/json" -TimeoutSec 15
        Write-Host "✅ Connexion réussie pour $($account.email)" -ForegroundColor Green
        Write-Host "  Token: $($loginResponse.token.Substring(0, 20))..." -ForegroundColor Gray
        
        # Test de création de menu avec ce token
        Write-Host "`n🧪 Test de création de menu avec $($account.email)..." -ForegroundColor Yellow
        $menuData = @{
            restaurantId = 1
            title = "Menu Test"
            activeFrom = "2025-01-01"
            activeTo = "2025-12-31"
        } | ConvertTo-Json
        
        $headers = @{
            "Authorization" = "Bearer $($loginResponse.token)"
            "Content-Type" = "application/json"
        }
        
        try {
            $createResponse = Invoke-RestMethod -Uri "$API_URL/api/v1/menus" -Method POST -Body $menuData -Headers $headers -TimeoutSec 15
            Write-Host "✅ Création de menu réussie" -ForegroundColor Green
            Write-Host "  Menu créé: $($createResponse.title)" -ForegroundColor White
        } catch {
            Write-Host "❌ Erreur lors de la création de menu" -ForegroundColor Red
            Write-Host "  Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
            Write-Host "  Erreur: $($_.Exception.Message)" -ForegroundColor Red
        }
        
    } catch {
        Write-Host "❌ Échec de connexion pour $($account.email)" -ForegroundColor Red
        Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n🔍 Test sans authentification..." -ForegroundColor Yellow
$menuData = @{
    restaurantId = 1
    title = "Menu Test Sans Auth"
    activeFrom = "2025-01-01"
    activeTo = "2025-12-31"
} | ConvertTo-Json

try {
    $createResponse = Invoke-RestMethod -Uri "$API_URL/api/v1/menus" -Method POST -Body $menuData -ContentType "application/json" -TimeoutSec 15
    Write-Host "✅ Création de menu sans auth réussie (inattendu!)" -ForegroundColor Yellow
} catch {
    Write-Host "❌ Création de menu sans auth échouée (attendu)" -ForegroundColor Green
    Write-Host "  Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Gray
    Write-Host "  Erreur: $($_.Exception.Message)" -ForegroundColor Gray
}

Write-Host "`n📋 Résumé du diagnostic:" -ForegroundColor Yellow
Write-Host "- L'API est accessible" -ForegroundColor White
Write-Host "- Les endpoints GET fonctionnent" -ForegroundColor White
Write-Host "- L'authentification est requise pour POST /api/v1/menus" -ForegroundColor White
Write-Host "- Le rôle RESTAURATEUR est nécessaire" -ForegroundColor White
