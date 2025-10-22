#!/usr/bin/env pwsh
# Script pour surveiller le déploiement corrigé sur Render

Write-Host "🔧 Surveillance du déploiement corrigé - Migration V21/V22" -ForegroundColor Green
Write-Host "=========================================================" -ForegroundColor Green

$API_URL = "https://vegn-bio-backend.onrender.com"
$maxAttempts = 8
$attempt = 1

Write-Host "`n⏳ Surveillance en cours..." -ForegroundColor Yellow
Write-Host "Correction des conflits d'allergènes déployée" -ForegroundColor Cyan

while ($attempt -le $maxAttempts) {
    Write-Host "`n🔄 Tentative $attempt/$maxAttempts..." -ForegroundColor Yellow
    
    try {
        # Test de santé de l'API
        $healthResponse = Invoke-RestMethod -Uri "$API_URL/actuator/health" -Method GET -TimeoutSec 20
        Write-Host "✅ API accessible - Status: $($healthResponse.status)" -ForegroundColor Green
        
        # Test des restaurants
        $restaurantsResponse = Invoke-RestMethod -Uri "$API_URL/api/restaurants" -Method GET -ContentType "application/json" -TimeoutSec 20
        Write-Host "✅ Restaurants: $($restaurantsResponse.Count) trouvés" -ForegroundColor Green
        
        # Test des menus
        $menusResponse = Invoke-RestMethod -Uri "$API_URL/api/menus" -Method GET -ContentType "application/json" -TimeoutSec 20
        Write-Host "✅ Menus: $($menusResponse.Count) trouvés" -ForegroundColor Green
        
        # Test des plats
        $menuItemsResponse = Invoke-RestMethod -Uri "$API_URL/api/menu-items" -Method GET -ContentType "application/json" -TimeoutSec 20
        Write-Host "✅ Plats: $($menuItemsResponse.Count) trouvés" -ForegroundColor Green
        
        Write-Host "`n🎉 Migration V21/V22 déployée avec succès !" -ForegroundColor Green
        Write-Host "=========================================================" -ForegroundColor Green
        
        # Afficher un résumé des données
        Write-Host "`n📊 Résumé des données déployées:" -ForegroundColor Cyan
        Write-Host "- Restaurants: $($restaurantsResponse.Count)" -ForegroundColor White
        Write-Host "- Menus: $($menusResponse.Count)" -ForegroundColor White
        Write-Host "- Plats: $($menuItemsResponse.Count)" -ForegroundColor White
        
        # Test par restaurant avec détails
        Write-Host "`n🏪 Menus par restaurant:" -ForegroundColor Cyan
        $restaurantCodes = @('BAS', 'REP', 'NAT', 'ITA', 'BOU')
        foreach ($code in $restaurantCodes) {
            try {
                $menuResponse = Invoke-RestMethod -Uri "$API_URL/api/restaurants/$code/menus" -Method GET -ContentType "application/json" -TimeoutSec 20
                Write-Host "  - $code : $($menuResponse.Count) menu(s)" -ForegroundColor White
                
                # Afficher les menus pour ce restaurant
                foreach ($menu in $menuResponse) {
                    Write-Host "    * $($menu.title)" -ForegroundColor Gray
                }
            } catch {
                Write-Host "  - $code : Erreur" -ForegroundColor Red
            }
        }
        
        # Test d'un plat spécifique
        Write-Host "`n🔍 Exemple de plat:" -ForegroundColor Cyan
        if ($menuItemsResponse.Count -gt 0) {
            $firstItem = $menuItemsResponse[0]
            Write-Host "  - Nom: $($firstItem.name)" -ForegroundColor White
            Write-Host "  - Description: $($firstItem.description)" -ForegroundColor Gray
            Write-Host "  - Prix: $([math]::Round($firstItem.priceCents / 100, 2)) €" -ForegroundColor Cyan
            Write-Host "  - Vegan: $($firstItem.isVegan)" -ForegroundColor Green
        }
        
        break
        
    } catch {
        Write-Host "❌ Tentative $attempt échouée" -ForegroundColor Red
        Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
        
        if ($attempt -lt $maxAttempts) {
            $waitTime = $attempt * 45  # Attendre de plus en plus longtemps
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

Write-Host "`n📋 Corrections apportées:" -ForegroundColor Yellow
Write-Host "- Migration V21: Ajout de ON CONFLICT DO NOTHING pour les allergènes" -ForegroundColor White
Write-Host "- Migration V22: Correction des conflits avec NOT EXISTS" -ForegroundColor White
Write-Host "- Gestion robuste des doublons d'allergènes" -ForegroundColor White
Write-Host "- Migration idempotente (peut être exécutée plusieurs fois)" -ForegroundColor White
