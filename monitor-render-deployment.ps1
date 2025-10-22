#!/usr/bin/env pwsh
# Script pour surveiller le déploiement Render et vérifier la migration

Write-Host "🚀 Surveillance du déploiement Render - Migration V21" -ForegroundColor Green
Write-Host "=====================================================" -ForegroundColor Green

$API_URL = "https://vegn-bio-backend.onrender.com"
$maxAttempts = 10
$attempt = 1

Write-Host "`n⏳ Surveillance en cours..." -ForegroundColor Yellow
Write-Host "L'API peut prendre 5-10 minutes pour redémarrer complètement" -ForegroundColor Cyan

while ($attempt -le $maxAttempts) {
    Write-Host "`n🔄 Tentative $attempt/$maxAttempts..." -ForegroundColor Yellow
    
    try {
        # Test de santé de l'API
        $healthResponse = Invoke-RestMethod -Uri "$API_URL/actuator/health" -Method GET -TimeoutSec 15
        Write-Host "✅ API accessible - Status: $($healthResponse.status)" -ForegroundColor Green
        
        # Test des restaurants
        $restaurantsResponse = Invoke-RestMethod -Uri "$API_URL/api/restaurants" -Method GET -ContentType "application/json" -TimeoutSec 15
        Write-Host "✅ Restaurants: $($restaurantsResponse.Count) trouvés" -ForegroundColor Green
        
        # Test des menus
        $menusResponse = Invoke-RestMethod -Uri "$API_URL/api/menus" -Method GET -ContentType "application/json" -TimeoutSec 15
        Write-Host "✅ Menus: $($menusResponse.Count) trouvés" -ForegroundColor Green
        
        # Test des plats
        $menuItemsResponse = Invoke-RestMethod -Uri "$API_URL/api/menu-items" -Method GET -ContentType "application/json" -TimeoutSec 15
        Write-Host "✅ Plats: $($menuItemsResponse.Count) trouvés" -ForegroundColor Green
        
        Write-Host "`n🎉 Migration V21 déployée avec succès !" -ForegroundColor Green
        Write-Host "=====================================================" -ForegroundColor Green
        
        # Afficher un résumé des données
        Write-Host "`n📊 Résumé des données déployées:" -ForegroundColor Cyan
        Write-Host "- Restaurants: $($restaurantsResponse.Count)" -ForegroundColor White
        Write-Host "- Menus: $($menusResponse.Count)" -ForegroundColor White
        Write-Host "- Plats: $($menuItemsResponse.Count)" -ForegroundColor White
        
        # Test par restaurant
        Write-Host "`n🏪 Menus par restaurant:" -ForegroundColor Cyan
        $restaurantCodes = @('BAS', 'REP', 'NAT', 'ITA', 'BOU')
        foreach ($code in $restaurantCodes) {
            try {
                $menuResponse = Invoke-RestMethod -Uri "$API_URL/api/restaurants/$code/menus" -Method GET -ContentType "application/json" -TimeoutSec 15
                Write-Host "  - $code : $($menuResponse.Count) menu(s)" -ForegroundColor White
            } catch {
                Write-Host "  - $code : Erreur" -ForegroundColor Red
            }
        }
        
        break
        
    } catch {
        Write-Host "❌ Tentative $attempt échouée" -ForegroundColor Red
        Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
        
        if ($attempt -lt $maxAttempts) {
            $waitTime = $attempt * 30  # Attendre de plus en plus longtemps
            Write-Host "⏳ Attente de $waitTime secondes avant la prochaine tentative..." -ForegroundColor Yellow
            Start-Sleep -Seconds $waitTime
        }
    }
    
    $attempt++
}

if ($attempt -gt $maxAttempts) {
    Write-Host "`n❌ Déploiement non accessible après $maxAttempts tentatives" -ForegroundColor Red
    Write-Host "Veuillez vérifier manuellement le dashboard Render" -ForegroundColor Yellow
    Write-Host "URL Render Dashboard: https://dashboard.render.com" -ForegroundColor Cyan
}

Write-Host "`n📋 Migration V21 - Résumé:" -ForegroundColor Yellow
Write-Host "- Création de 3 menus par restaurant (Principal, Déjeuner, Soir)" -ForegroundColor White
Write-Host "- Ajout de 15+ plats par restaurant avec descriptions détaillées" -ForegroundColor White
Write-Host "- Gestion des allergènes (gluten, soja, sésame, fruits à coque)" -ForegroundColor White
Write-Host "- Couverture de tous les restaurants VEG'N BIO" -ForegroundColor White
Write-Host "- Prix en centimes pour une gestion précise" -ForegroundColor White
