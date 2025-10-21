#!/usr/bin/env pwsh

# Script pour comparer l'API locale vs production
Write-Host "=== Comparaison API Locale vs Production ===" -ForegroundColor Green

$LOCAL_API_URL = "http://localhost:8080/api/v1"
$PROD_API_URL = "https://vegn-bio-backend.onrender.com/api/v1"
$FRONTEND_VERCEL = "https://veg-n-bio-front-pi.vercel.app"

# Headers pour simuler le frontend Vercel
$vercelHeaders = @{
    "Origin" = $FRONTEND_VERCEL
    "Referer" = "$FRONTEND_VERCEL/"
    "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
    "Accept" = "application/json"
}

function Test-APIEndpoint {
    param(
        [string]$ApiUrl,
        [string]$Endpoint,
        [string]$Environment,
        [hashtable]$Headers = @{}
    )
    
    Write-Host "`n🔍 Test $Environment - $Endpoint" -ForegroundColor Yellow
    
    try {
        $response = Invoke-RestMethod -Uri "$ApiUrl$Endpoint" -Method GET -Headers $Headers -TimeoutSec 30
        Write-Host "✅ $Environment - $Endpoint : SUCCÈS" -ForegroundColor Green
        
        if ($response -is [array]) {
            Write-Host "   📊 Nombre d'éléments: $($response.Count)" -ForegroundColor Cyan
        } elseif ($response -is [object]) {
            Write-Host "   📋 Réponse reçue" -ForegroundColor Cyan
        }
        return $true
        
    } catch {
        $errorMessage = $_.Exception.Message
        $statusCode = ""
        if ($_.Exception.Response) {
            $statusCode = " (Status: $($_.Exception.Response.StatusCode))"
        }
        Write-Host "❌ $Environment - $Endpoint : ÉCHEC" -ForegroundColor Red
        Write-Host "   Erreur: $errorMessage$statusCode" -ForegroundColor Red
        return $false
    }
}

Write-Host "`n🚀 === DÉMARRAGE DES TESTS COMPARATIFS ===" -ForegroundColor Magenta

# Test 1: Vérifier si l'API locale est accessible
Write-Host "`n🌐 Vérification de l'API locale..." -ForegroundColor Yellow

try {
    $localResponse = Invoke-WebRequest -Uri "$LOCAL_API_URL/restaurants" -Method GET -TimeoutSec 5 -ErrorAction Stop
    Write-Host "✅ API locale accessible - Status: $($localResponse.StatusCode)" -ForegroundColor Green
    $localApiAvailable = $true
} catch {
    Write-Host "❌ API locale inaccessible: $($_.Exception.Message)" -ForegroundColor Red
    $localApiAvailable = $false
}

# Test 2: Comparaison des endpoints
Write-Host "`n📊 === COMPARAISON DES ENDPOINTS ===" -ForegroundColor Magenta

$endpoints = @(
    "/restaurants",
    "/allergens", 
    "/menus",
    "/events"
)

$localResults = @{}
$prodResults = @{}

foreach ($endpoint in $endpoints) {
    Write-Host "`n--- Test de $endpoint ---" -ForegroundColor Cyan
    
    # Test API locale si disponible
    if ($localApiAvailable) {
        $localResults[$endpoint] = Test-APIEndpoint -ApiUrl $LOCAL_API_URL -Endpoint $endpoint -Environment "LOCAL"
    } else {
        Write-Host "⚠️ API locale non disponible - test ignoré" -ForegroundColor Yellow
        $localResults[$endpoint] = $false
    }
    
    # Test API production
    $prodResults[$endpoint] = Test-APIEndpoint -ApiUrl $PROD_API_URL -Endpoint $endpoint -Environment "PRODUCTION" -Headers $vercelHeaders
}

# Test 3: Test d'authentification
Write-Host "`n🔐 === TEST D'AUTHENTIFICATION ===" -ForegroundColor Magenta

$registerData = @{
    email = "comparison.test.$(Get-Date -Format 'yyyyMMddHHmmss')@example.com"
    password = "password123"
    fullName = "Comparison Test User"
    role = "CLIENT"
} | ConvertTo-Json

# Test registration locale
if ($localApiAvailable) {
    Write-Host "`n🔍 Test Registration - LOCAL" -ForegroundColor Yellow
    try {
        $localAuthResponse = Invoke-RestMethod -Uri "$LOCAL_API_URL/auth/register" -Method POST -Body $registerData -ContentType "application/json" -TimeoutSec 30
        Write-Host "✅ LOCAL - Registration : SUCCÈS" -ForegroundColor Green
        Write-Host "   🎫 Token reçu: $($localAuthResponse.accessToken.Substring(0, 20))..." -ForegroundColor Cyan
        $localAuthSuccess = $true
    } catch {
        Write-Host "❌ LOCAL - Registration : ÉCHEC - $($_.Exception.Message)" -ForegroundColor Red
        $localAuthSuccess = $false
    }
} else {
    $localAuthSuccess = $false
}

# Test registration production
Write-Host "`n🔍 Test Registration - PRODUCTION" -ForegroundColor Yellow
try {
    $prodAuthResponse = Invoke-RestMethod -Uri "$PROD_API_URL/auth/register" -Method POST -Body $registerData -ContentType "application/json" -Headers $vercelHeaders -TimeoutSec 30
    Write-Host "✅ PRODUCTION - Registration : SUCCÈS" -ForegroundColor Green
    Write-Host "   🎫 Token reçu: $($prodAuthResponse.accessToken.Substring(0, 20))..." -ForegroundColor Cyan
    $prodAuthSuccess = $true
} catch {
    Write-Host "❌ PRODUCTION - Registration : ÉCHEC - $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        Write-Host "   Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    }
    $prodAuthSuccess = $false
}

# Test 4: Analyse des résultats
Write-Host "`n📊 === ANALYSE DES RÉSULTATS ===" -ForegroundColor Magenta

$localSuccessCount = ($localResults.Values | Where-Object { $_ -eq $true }).Count
$prodSuccessCount = ($prodResults.Values | Where-Object { $_ -eq $true }).Count

Write-Host "🎯 Résumé comparatif:" -ForegroundColor Cyan
Write-Host "   API Locale:" -ForegroundColor White
Write-Host "     - Endpoints fonctionnels: $localSuccessCount/$($endpoints.Count)" -ForegroundColor White
Write-Host "     - Authentification: $(if($localAuthSuccess){'✅ Succès'}else{'❌ Échec'})" -ForegroundColor White

Write-Host "   API Production:" -ForegroundColor White
Write-Host "     - Endpoints fonctionnels: $prodSuccessCount/$($endpoints.Count)" -ForegroundColor White
Write-Host "     - Authentification: $(if($prodAuthSuccess){'✅ Succès'}else{'❌ Échec'})" -ForegroundColor White

# Détection des problèmes
Write-Host "`n🔍 === DIAGNOSTIC DES PROBLÈMES ===" -ForegroundColor Magenta

if ($localApiAvailable -and $localSuccessCount -gt 0 -and $prodSuccessCount -eq 0) {
    Write-Host "🚨 PROBLÈME IDENTIFIÉ: L'API locale fonctionne mais l'API production ne fonctionne pas" -ForegroundColor Red
    Write-Host "   💡 Causes possibles:" -ForegroundColor Yellow
    Write-Host "     - Problème de déploiement sur Render" -ForegroundColor Yellow
    Write-Host "     - Configuration de sécurité différente" -ForegroundColor Yellow
    Write-Host "     - Variables d'environnement manquantes" -ForegroundColor Yellow
    Write-Host "     - Restrictions d'accès sur Render" -ForegroundColor Yellow
} elseif (-not $localApiAvailable -and $prodSuccessCount -eq 0) {
    Write-Host "⚠️ PROBLÈME: Aucune API n'est accessible" -ForegroundColor Red
    Write-Host "   💡 Actions recommandées:" -ForegroundColor Yellow
    Write-Host "     - Démarrer l'API locale avec Docker" -ForegroundColor Yellow
    Write-Host "     - Vérifier le déploiement sur Render" -ForegroundColor Yellow
} elseif ($prodSuccessCount -gt 0) {
    Write-Host "✅ API Production fonctionnelle !" -ForegroundColor Green
} else {
    Write-Host "❓ Situation non identifiée" -ForegroundColor Yellow
}

# Sauvegarde du rapport comparatif
$comparisonReport = @{
    timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    local_api_url = $LOCAL_API_URL
    prod_api_url = $PROD_API_URL
    frontend_vercel = $FRONTEND_VERCEL
    local_api_available = $localApiAvailable
    local_endpoints_success = $localSuccessCount
    prod_endpoints_success = $prodSuccessCount
    local_auth_success = $localAuthSuccess
    prod_auth_success = $prodAuthSuccess
    endpoints_tested = $endpoints
    local_results = $localResults
    prod_results = $prodResults
}

$comparisonReport | ConvertTo-Json -Depth 3 | Out-File -FilePath "api-comparison-report.json" -Encoding UTF8
Write-Host "`n📄 Rapport comparatif sauvegardé: api-comparison-report.json" -ForegroundColor Cyan

Write-Host "`n=== COMPARAISON TERMINÉE ===" -ForegroundColor Green
