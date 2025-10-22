#!/usr/bin/env pwsh
# Script pour tester la migration V21 en production sur Render

Write-Host "🚀 Test de la migration V21 en production - Render" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green

# URL de l'API en production (à ajuster selon votre configuration Render)
$API_URL = "https://vegn-bio-backend.onrender.com"

Write-Host "`n🌐 Test de l'API de production..." -ForegroundColor Yellow
Write-Host "URL: $API_URL" -ForegroundColor Cyan

# Attendre que le déploiement soit terminé
Write-Host "`n⏳ Attente du déploiement Render..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Test de santé de l'API
Write-Host "`n🏥 Test de santé de l'API..." -ForegroundColor Yellow
try {
    $healthResponse = Invoke-RestMethod -Uri "$API_URL/actuator/health" -Method GET -TimeoutSec 30
    Write-Host "✅ API en production accessible" -ForegroundColor Green
    Write-Host "Status: $($healthResponse.status)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Erreur lors du test de santé de l'API" -ForegroundColor Red
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "L'API pourrait encore être en cours de déploiement..." -ForegroundColor Yellow
}

# Test de l'API des restaurants
Write-Host "`n🏪 Test de l'API des restaurants..." -ForegroundColor Yellow
try {
    $restaurantsResponse = Invoke-RestMethod -Uri "$API_URL/api/restaurants" -Method GET -ContentType "application/json" -TimeoutSec 30
    Write-Host "✅ API des restaurants accessible" -ForegroundColor Green
    Write-Host "📊 Nombre de restaurants: $($restaurantsResponse.Count)" -ForegroundColor Cyan
    
    # Afficher les restaurants
    foreach ($restaurant in $restaurantsResponse) {
        Write-Host "  - $($restaurant.name) ($($restaurant.code))" -ForegroundColor White
    }
} catch {
    Write-Host "❌ Erreur lors du test de l'API des restaurants" -ForegroundColor Red
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

# Test de l'API des menus
Write-Host "`n🍽️  Test de l'API des menus..." -ForegroundColor Yellow
try {
    $menusResponse = Invoke-RestMethod -Uri "$API_URL/api/menus" -Method GET -ContentType "application/json" -TimeoutSec 30
    Write-Host "✅ API des menus accessible" -ForegroundColor Green
    Write-Host "📊 Nombre de menus: $($menusResponse.Count)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Erreur lors du test de l'API des menus" -ForegroundColor Red
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

# Test de l'API des plats
Write-Host "`n🥗 Test de l'API des plats..." -ForegroundColor Yellow
try {
    $menuItemsResponse = Invoke-RestMethod -Uri "$API_URL/api/menu-items" -Method GET -ContentType "application/json" -TimeoutSec 30
    Write-Host "✅ API des plats accessible" -ForegroundColor Green
    Write-Host "📊 Nombre de plats: $($menuItemsResponse.Count)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Erreur lors du test de l'API des plats" -ForegroundColor Red
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

# Test spécifique pour chaque restaurant
Write-Host "`n🏪 Test des menus par restaurant..." -ForegroundColor Yellow
$restaurantCodes = @('BAS', 'REP', 'NAT', 'ITA', 'BOU')
foreach ($code in $restaurantCodes) {
    try {
        $menuResponse = Invoke-RestMethod -Uri "$API_URL/api/restaurants/$code/menus" -Method GET -ContentType "application/json" -TimeoutSec 30
        Write-Host "✅ Restaurant $code : $($menuResponse.Count) menu(s)" -ForegroundColor Green
        
        # Afficher les menus pour ce restaurant
        foreach ($menu in $menuResponse) {
            Write-Host "    - $($menu.title)" -ForegroundColor Gray
        }
    } catch {
        Write-Host "❌ Erreur pour le restaurant $code" -ForegroundColor Red
        Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Test d'un plat spécifique pour vérifier les détails
Write-Host "`n🔍 Test des détails d'un plat..." -ForegroundColor Yellow
try {
    $menuItemsResponse = Invoke-RestMethod -Uri "$API_URL/api/menu-items" -Method GET -ContentType "application/json" -TimeoutSec 30
    if ($menuItemsResponse.Count -gt 0) {
        $firstItem = $menuItemsResponse[0]
        Write-Host "✅ Détails d'un plat récupérés" -ForegroundColor Green
        Write-Host "  - Nom: $($firstItem.name)" -ForegroundColor White
        Write-Host "  - Description: $($firstItem.description)" -ForegroundColor Gray
        Write-Host "  - Prix: $([math]::Round($firstItem.priceCents / 100, 2)) €" -ForegroundColor Cyan
        Write-Host "  - Vegan: $($firstItem.isVegan)" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Erreur lors du test des détails d'un plat" -ForegroundColor Red
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n✅ Test de la migration en production terminé !" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green

# Résumé
Write-Host "`n📋 Résumé de la migration V21:" -ForegroundColor Yellow
Write-Host "- Création de 3 menus par restaurant (Principal, Déjeuner, Soir)" -ForegroundColor White
Write-Host "- Ajout de 15+ plats par restaurant avec descriptions détaillées" -ForegroundColor White
Write-Host "- Gestion des allergènes (gluten, soja, sésame, fruits à coque)" -ForegroundColor White
Write-Host "- Couverture de tous les restaurants VEG'N BIO" -ForegroundColor White
Write-Host "- Prix en centimes pour une gestion précise" -ForegroundColor White
