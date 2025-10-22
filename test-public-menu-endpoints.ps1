#!/usr/bin/env pwsh
# Script pour tester les nouveaux endpoints publics des menus

Write-Host "🍽️  Test des endpoints publics des menus VEG'N BIO" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green

$API_URL = "https://vegn-bio-backend.onrender.com"

Write-Host "`n🌐 Test des endpoints publics..." -ForegroundColor Yellow
Write-Host "URL: $API_URL" -ForegroundColor Cyan

# Test de santé de l'API
Write-Host "`n🏥 Test de santé de l'API..." -ForegroundColor Yellow
try {
    $healthResponse = Invoke-RestMethod -Uri "$API_URL/actuator/health" -Method GET -TimeoutSec 15
    Write-Host "✅ API accessible - Status: $($healthResponse.status)" -ForegroundColor Green
} catch {
    Write-Host "❌ API non accessible" -ForegroundColor Red
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Test des restaurants
Write-Host "`n🏪 Test des restaurants..." -ForegroundColor Yellow
try {
    $restaurantsResponse = Invoke-RestMethod -Uri "$API_URL/api/restaurants" -Method GET -ContentType "application/json" -TimeoutSec 15
    Write-Host "✅ Restaurants récupérés: $($restaurantsResponse.Count)" -ForegroundColor Green
    
    foreach ($restaurant in $restaurantsResponse) {
        Write-Host "  - $($restaurant.name) (Code: $($restaurant.code))" -ForegroundColor White
    }
} catch {
    Write-Host "❌ Erreur lors de la récupération des restaurants" -ForegroundColor Red
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

# Test des menus publics
Write-Host "`n🍽️  Test des menus publics..." -ForegroundColor Yellow
try {
    $menusResponse = Invoke-RestMethod -Uri "$API_URL/api/public/menus" -Method GET -ContentType "application/json" -TimeoutSec 15
    Write-Host "✅ Menus publics récupérés: $($menusResponse.Count)" -ForegroundColor Green
    
    foreach ($menu in $menusResponse) {
        Write-Host "  - $($menu.title) (Restaurant: $($menu.restaurantName))" -ForegroundColor White
    }
} catch {
    Write-Host "❌ Erreur lors de la récupération des menus publics" -ForegroundColor Red
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

# Test des plats publics
Write-Host "`n🥗 Test des plats publics..." -ForegroundColor Yellow
try {
    $menuItemsResponse = Invoke-RestMethod -Uri "$API_URL/api/public/menu-items" -Method GET -ContentType "application/json" -TimeoutSec 15
    Write-Host "✅ Plats publics récupérés: $($menuItemsResponse.Count)" -ForegroundColor Green
    
    # Afficher quelques exemples
    $count = 0
    foreach ($item in $menuItemsResponse) {
        if ($count -lt 5) {
            Write-Host "  - $($item.name) - $([math]::Round($item.priceCents / 100, 2)) €" -ForegroundColor White
            $count++
        }
    }
    if ($menuItemsResponse.Count -gt 5) {
        Write-Host "  ... et $($menuItemsResponse.Count - 5) autres plats" -ForegroundColor Gray
    }
} catch {
    Write-Host "❌ Erreur lors de la récupération des plats publics" -ForegroundColor Red
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

# Test par restaurant
Write-Host "`n🏪 Test des menus par restaurant..." -ForegroundColor Yellow
$restaurantCodes = @('BAS', 'REP', 'NAT', 'ITA', 'BOU')
foreach ($code in $restaurantCodes) {
    try {
        $menuResponse = Invoke-RestMethod -Uri "$API_URL/api/public/menus/restaurant/$code" -Method GET -ContentType "application/json" -TimeoutSec 15
        Write-Host "✅ Restaurant $code : $($menuResponse.Count) menu(s)" -ForegroundColor Green
        
        foreach ($menu in $menuResponse) {
            Write-Host "    - $($menu.title)" -ForegroundColor Gray
        }
    } catch {
        Write-Host "❌ Erreur pour le restaurant $code" -ForegroundColor Red
        Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Test des plats par restaurant
Write-Host "`n🥗 Test des plats par restaurant..." -ForegroundColor Yellow
foreach ($code in $restaurantCodes) {
    try {
        $menuItemsResponse = Invoke-RestMethod -Uri "$API_URL/api/public/menu-items/restaurant/$code" -Method GET -ContentType "application/json" -TimeoutSec 15
        Write-Host "✅ Restaurant $code : $($menuItemsResponse.Count) plat(s)" -ForegroundColor Green
        
        # Afficher quelques exemples
        $count = 0
        foreach ($item in $menuItemsResponse) {
            if ($count -lt 3) {
                Write-Host "    - $($item.name) - $([math]::Round($item.priceCents / 100, 2)) €" -ForegroundColor Gray
                $count++
            }
        }
    } catch {
        Write-Host "❌ Erreur pour les plats du restaurant $code" -ForegroundColor Red
        Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Test de recherche
Write-Host "`n🔍 Test de recherche de plats..." -ForegroundColor Yellow
try {
    $searchResponse = Invoke-RestMethod -Uri "$API_URL/api/public/menu-items/search?name=burger" -Method GET -ContentType "application/json" -TimeoutSec 15
    Write-Host "✅ Recherche 'burger': $($searchResponse.Count) résultat(s)" -ForegroundColor Green
    
    foreach ($item in $searchResponse) {
        Write-Host "  - $($item.name) - $([math]::Round($item.priceCents / 100, 2)) €" -ForegroundColor White
    }
} catch {
    Write-Host "❌ Erreur lors de la recherche" -ForegroundColor Red
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n✅ Test des endpoints publics terminé !" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green

Write-Host "`n📋 Endpoints publics disponibles:" -ForegroundColor Yellow
Write-Host "- GET /api/public/menus - Tous les menus" -ForegroundColor White
Write-Host "- GET /api/public/menus/restaurant/{code} - Menus par restaurant" -ForegroundColor White
Write-Host "- GET /api/public/menu-items - Tous les plats" -ForegroundColor White
Write-Host "- GET /api/public/menu-items/restaurant/{code} - Plats par restaurant" -ForegroundColor White
Write-Host "- GET /api/public/menu-items/search?name={nom} - Recherche de plats" -ForegroundColor White
Write-Host "- GET /api/public/menus/{id} - Menu par ID" -ForegroundColor White
Write-Host "- GET /api/public/menu-items/{id} - Plat par ID" -ForegroundColor White
