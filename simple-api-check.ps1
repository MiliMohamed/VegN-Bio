#!/usr/bin/env pwsh
# Script simple pour vérifier le statut de l'API VEG'N BIO

Write-Host "🔍 Vérification simple de l'API VEG'N BIO" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

$API_URL = "https://vegn-bio-backend.onrender.com"

Write-Host "`n🌐 Test de connectivité..." -ForegroundColor Yellow

# Test simple avec curl
try {
    $response = curl -s -o $null -w "%{http_code}" $API_URL
    Write-Host "Status HTTP: $response" -ForegroundColor Cyan
    
    if ($response -eq "200") {
        Write-Host "✅ API accessible et fonctionnelle" -ForegroundColor Green
    } elseif ($response -eq "403") {
        Write-Host "⚠️ API accessible mais retourne 403 (Forbidden)" -ForegroundColor Yellow
        Write-Host "Cela peut indiquer:" -ForegroundColor White
        Write-Host "  - L'application est en cours de démarrage" -ForegroundColor Gray
        Write-Host "  - Problème de configuration de sécurité" -ForegroundColor Gray
        Write-Host "  - Migration en cours d'exécution" -ForegroundColor Gray
    } elseif ($response -eq "404") {
        Write-Host "❌ API non trouvée (404)" -ForegroundColor Red
    } else {
        Write-Host "⚠️ Status inattendu: $response" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ Impossible de se connecter à l'API" -ForegroundColor Red
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n📋 Solutions recommandées:" -ForegroundColor Yellow
Write-Host "1. Attendre 5-10 minutes pour que Render termine le déploiement" -ForegroundColor White
Write-Host "2. Vérifier le dashboard Render pour voir les logs" -ForegroundColor White
Write-Host "3. Si le problème persiste, redémarrer manuellement le service" -ForegroundColor White

Write-Host "`n🔗 Liens utiles:" -ForegroundColor Cyan
Write-Host "- Dashboard Render: https://dashboard.render.com" -ForegroundColor White
Write-Host "- API Health: $API_URL/actuator/health" -ForegroundColor White
Write-Host "- API Docs: $API_URL/swagger-ui.html" -ForegroundColor White

Write-Host "`n⏳ Test dans 2 minutes..." -ForegroundColor Yellow
Start-Sleep -Seconds 120

Write-Host "`n🔄 Nouveau test après attente..." -ForegroundColor Yellow
try {
    $response = curl -s -o $null -w "%{http_code}" $API_URL
    Write-Host "Nouveau status: $response" -ForegroundColor Cyan
    
    if ($response -eq "200") {
        Write-Host "✅ API maintenant accessible !" -ForegroundColor Green
        
        # Test rapide des endpoints
        Write-Host "`n🧪 Test des endpoints..." -ForegroundColor Yellow
        try {
            $restaurants = Invoke-RestMethod -Uri "$API_URL/api/restaurants" -Method GET -TimeoutSec 10
            Write-Host "✅ Restaurants: $($restaurants.Count) trouvés" -ForegroundColor Green
        } catch {
            Write-Host "❌ Erreur restaurants: $($_.Exception.Message)" -ForegroundColor Red
        }
        
        try {
            $menus = Invoke-RestMethod -Uri "$API_URL/api/menus" -Method GET -TimeoutSec 10
            Write-Host "✅ Menus: $($menus.Count) trouvés" -ForegroundColor Green
        } catch {
            Write-Host "❌ Erreur menus: $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        Write-Host "⚠️ API toujours non accessible (Status: $response)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ Erreur lors du nouveau test" -ForegroundColor Red
}
