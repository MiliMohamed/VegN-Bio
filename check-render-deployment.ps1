#!/usr/bin/env pwsh
# Script pour vérifier le statut du déploiement Render

Write-Host "🔍 Vérification du déploiement Render" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green

# URLs de test
$API_URL = "https://vegn-bio-backend.onrender.com"
$FRONTEND_URL = "https://veg-n-bio-front-git-main-milimohameds-projects.vercel.app"

Write-Host "`n🌐 Test de connectivité..." -ForegroundColor Yellow

# Test de ping simple
Write-Host "`n🏥 Test de connectivité API..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri $API_URL -Method GET -TimeoutSec 10
    Write-Host "✅ API accessible - Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Content-Type: $($response.Headers.'Content-Type')" -ForegroundColor Cyan
} catch {
    Write-Host "❌ API non accessible" -ForegroundColor Red
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
    
    if ($_.Exception.Message -like "*403*") {
        Write-Host "💡 Erreur 403: L'API pourrait être en cours de redémarrage" -ForegroundColor Yellow
    } elseif ($_.Exception.Message -like "*timeout*") {
        Write-Host "💡 Timeout: L'API pourrait être en cours de démarrage" -ForegroundColor Yellow
    }
}

# Test du frontend
Write-Host "`n🌐 Test du frontend..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri $FRONTEND_URL -Method GET -TimeoutSec 10
    Write-Host "✅ Frontend accessible - Status: $($response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "❌ Frontend non accessible" -ForegroundColor Red
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

# Test avec curl si disponible
Write-Host "`n🔧 Test avec curl..." -ForegroundColor Yellow
try {
    $curlResponse = curl -s -o $null -w "%{http_code}" $API_URL
    Write-Host "✅ Curl test - Status: $curlResponse" -ForegroundColor Green
} catch {
    Write-Host "❌ Curl non disponible ou erreur" -ForegroundColor Red
}

Write-Host "`n⏳ Attente de 30 secondes pour le redémarrage..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Nouveau test après attente
Write-Host "`n🔄 Nouveau test après attente..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$API_URL/api/restaurants" -Method GET -TimeoutSec 15
    Write-Host "✅ API des restaurants accessible - Status: $($response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "❌ API des restaurants toujours non accessible" -ForegroundColor Red
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n📋 Recommandations:" -ForegroundColor Yellow
Write-Host "- Vérifiez le dashboard Render pour le statut du déploiement" -ForegroundColor White
Write-Host "- L'API peut prendre plusieurs minutes à redémarrer" -ForegroundColor White
Write-Host "- La migration V21 sera appliquée automatiquement au redémarrage" -ForegroundColor White
