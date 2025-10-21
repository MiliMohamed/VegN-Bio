#!/usr/bin/env pwsh

# Script pour surveiller le déploiement et tester l'API
Write-Host "=== Surveillance du Déploiement Render ===" -ForegroundColor Green

$API_BASE_URL = "https://vegn-bio-backend.onrender.com/api/v1"
$SWAGGER_URL = "https://vegn-bio-backend.onrender.com/swagger-ui/index.html"

Write-Host "`n🚀 === SURVEILLANCE DU DÉPLOIEMENT ===" -ForegroundColor Magenta

# Fonction pour tester si l'API est accessible
function Test-APIAccess {
    param([string]$Url, [string]$TestName)
    
    try {
        $response = Invoke-WebRequest -Uri $Url -Method GET -TimeoutSec 10 -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
        
        if ($response.StatusCode -eq 200) {
            Write-Host "✅ $TestName - Status: 200 OK" -ForegroundColor Green
            return $true
        } else {
            Write-Host "⚠️ $TestName - Status: $($response.StatusCode)" -ForegroundColor Yellow
            return $false
        }
        
    } catch {
        $statusCode = ""
        if ($_.Exception.Response) {
            $statusCode = " (Status: $($_.Exception.Response.StatusCode))"
        }
        Write-Host "❌ $TestName - Erreur: $($_.Exception.Message)$statusCode" -ForegroundColor Red
        return $false
    }
}

# Fonction pour tester l'authentification
function Test-Authentication {
    $registerData = @{
        email = "deployment.test.$(Get-Date -Format 'yyyyMMddHHmmss')@example.com"
        password = "password123"
        fullName = "Deployment Test User"
        role = "CLIENT"
    } | ConvertTo-Json
    
    try {
        $response = Invoke-RestMethod -Uri "$API_BASE_URL/auth/register" -Method POST -Body $registerData -ContentType "application/json" -TimeoutSec 30 -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
        
        Write-Host "✅ Authentification - Registration réussie" -ForegroundColor Green
        Write-Host "   🎫 Token généré: $($response.accessToken.Substring(0, 20))..." -ForegroundColor Cyan
        return $true
        
    } catch {
        $statusCode = ""
        if ($_.Exception.Response) {
            $statusCode = " (Status: $($_.Exception.Response.StatusCode))"
        }
        Write-Host "❌ Authentification - Erreur: $($_.Exception.Message)$statusCode" -ForegroundColor Red
        return $false
    }
}

# Surveillance du déploiement
Write-Host "`n⏱️ Surveillance du déploiement en cours..." -ForegroundColor Yellow
Write-Host "   Vérification toutes les 30 secondes..." -ForegroundColor Cyan
Write-Host "   Appuyez sur Ctrl+C pour arrêter" -ForegroundColor Gray

$maxAttempts = 20  # Maximum 10 minutes d'attente
$attempt = 0
$deploymentSuccessful = $false

while ($attempt -lt $maxAttempts -and -not $deploymentSuccessful) {
    $attempt++
    Write-Host "`n🔍 Tentative $attempt/$maxAttempts - $(Get-Date -Format 'HH:mm:ss')" -ForegroundColor Cyan
    
    # Test 1: Interface Swagger
    $swaggerAccessible = Test-APIAccess -Url $SWAGGER_URL -TestName "Interface Swagger"
    
    # Test 2: Documentation API
    $apiDocsAccessible = Test-APIAccess -Url "https://vegn-bio-backend.onrender.com/v3/api-docs" -TestName "Documentation API"
    
    # Test 3: Endpoint restaurants (peut retourner 403 si la sécurité est active)
    $restaurantsAccessible = Test-APIAccess -Url "$API_BASE_URL/restaurants" -TestName "Endpoint Restaurants"
    
    # Si Swagger et API docs sont accessibles, on considère que le déploiement est réussi
    if ($swaggerAccessible -and $apiDocsAccessible) {
        Write-Host "`n🎉 DÉPLOIEMENT RÉUSSI !" -ForegroundColor Green
        Write-Host "   ✅ Interface Swagger accessible" -ForegroundColor Green
        Write-Host "   ✅ Documentation API accessible" -ForegroundColor Green
        
        # Test de l'authentification
        Write-Host "`n🔐 Test de l'authentification..." -ForegroundColor Yellow
        $authSuccessful = Test-Authentication
        
        if ($authSuccessful) {
            Write-Host "`n🎯 TOUS LES TESTS SONT PASSÉS !" -ForegroundColor Green
            Write-Host "   ✅ Déploiement réussi" -ForegroundColor Green
            Write-Host "   ✅ API fonctionnelle" -ForegroundColor Green
            Write-Host "   ✅ Authentification opérationnelle" -ForegroundColor Green
            
            Write-Host "`n🔗 Liens utiles:" -ForegroundColor Cyan
            Write-Host "   - Interface Swagger: $SWAGGER_URL" -ForegroundColor White
            Write-Host "   - Documentation API: https://vegn-bio-backend.onrender.com/v3/api-docs" -ForegroundColor White
            Write-Host "   - API Base URL: $API_BASE_URL" -ForegroundColor White
            
        } else {
            Write-Host "`n⚠️ Déploiement réussi mais problème d'authentification" -ForegroundColor Yellow
            Write-Host "   Vérifiez la configuration de sécurité" -ForegroundColor Yellow
        }
        
        $deploymentSuccessful = $true
        
    } else {
        Write-Host "`n⏳ Déploiement en cours... Attente de 30 secondes" -ForegroundColor Yellow
        
        if ($attempt -lt $maxAttempts) {
            Start-Sleep -Seconds 30
        }
    }
}

if (-not $deploymentSuccessful) {
    Write-Host "`n⏰ TIMEOUT - Déploiement non terminé après $maxAttempts tentatives" -ForegroundColor Red
    Write-Host "   Vérifiez manuellement le statut sur Render" -ForegroundColor Red
}

Write-Host "`n=== SURVEILLANCE TERMINÉE ===" -ForegroundColor Green
