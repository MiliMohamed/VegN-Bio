#!/usr/bin/env pwsh

# Script de diagnostic des problèmes de production
Write-Host "=== Diagnostic des Problèmes de Production ===" -ForegroundColor Green

$API_BASE_URL = "https://vegn-bio-backend.onrender.com"
$FRONTEND_VERCEL = "https://veg-n-bio-front-pi.vercel.app"

Write-Host "`n🔍 === DIAGNOSTIC COMPLET ===" -ForegroundColor Magenta

# 1. Test de connectivité de base
Write-Host "`n🌐 Test de connectivité de base..." -ForegroundColor Yellow

try {
    $pingResult = Test-NetConnection -ComputerName "vegn-bio-backend.onrender.com" -Port 443 -WarningAction SilentlyContinue
    if ($pingResult.TcpTestSucceeded) {
        Write-Host "✅ Connexion TCP vers l'API réussie" -ForegroundColor Green
    } else {
        Write-Host "❌ Connexion TCP vers l'API échouée" -ForegroundColor Red
    }
} catch {
    Write-Host "⚠️ Test de connectivité non disponible" -ForegroundColor Yellow
}

# 2. Test des endpoints de base
Write-Host "`n🔗 Test des endpoints de base..." -ForegroundColor Yellow

$endpoints = @(
    @{ Path = "/"; Name = "Root" },
    @{ Path = "/actuator/health"; Name = "Health Check" },
    @{ Path = "/swagger-ui.html"; Name = "Swagger UI" },
    @{ Path = "/api/v1"; Name = "API v1 Base" }
)

foreach ($endpoint in $endpoints) {
    try {
        $url = "$API_BASE_URL$($endpoint.Path)"
        Write-Host "🔍 Test: $($endpoint.Name) - $url" -ForegroundColor Cyan
        
        $response = Invoke-WebRequest -Uri $url -Method GET -TimeoutSec 30 -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
        
        Write-Host "✅ $($endpoint.Name) - Status: $($response.StatusCode)" -ForegroundColor Green
        
        # Afficher les headers importants
        if ($response.Headers.'Content-Type') {
            Write-Host "   Content-Type: $($response.Headers.'Content-Type')" -ForegroundColor Gray
        }
        
    } catch {
        Write-Host "❌ $($endpoint.Name) - Erreur: $($_.Exception.Message)" -ForegroundColor Red
        if ($_.Exception.Response) {
            Write-Host "   Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
            
            # Analyser les headers de réponse pour diagnostiquer
            $responseHeaders = $_.Exception.Response.Headers
            if ($responseHeaders) {
                Write-Host "   Headers de réponse:" -ForegroundColor Gray
                foreach ($key in $responseHeaders.Keys) {
                    $value = $responseHeaders[$key]
                    Write-Host "     $key`: $value" -ForegroundColor Gray
                }
            }
        }
    }
}

# 3. Test avec différents User-Agents
Write-Host "`n🤖 Test avec différents User-Agents..." -ForegroundColor Yellow

$userAgents = @(
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
    "curl/7.68.0",
    "PostmanRuntime/7.26.8",
    "VegN-Bio-Test/1.0"
)

foreach ($ua in $userAgents) {
    try {
        Write-Host "🔍 Test avec User-Agent: $($ua.Substring(0, [Math]::Min(20, $ua.Length)))..." -ForegroundColor Cyan
        
        $response = Invoke-WebRequest -Uri "$API_BASE_URL/api/v1/restaurants" -Method GET -TimeoutSec 30 -UserAgent $ua
        
        Write-Host "✅ Succès avec User-Agent: $($ua.Substring(0, [Math]::Min(20, $ua.Length)))" -ForegroundColor Green
        break
        
    } catch {
        Write-Host "❌ Échec avec User-Agent: $($ua.Substring(0, [Math]::Min(20, $ua.Length)))" -ForegroundColor Red
    }
}

# 4. Test de l'API avec headers spécifiques
Write-Host "`n📋 Test avec headers spécifiques..." -ForegroundColor Yellow

$testHeaders = @(
    @{
        Name = "Headers Vercel"
        Headers = @{
            "Origin" = $FRONTEND_VERCEL
            "Referer" = "$FRONTEND_VERCEL/"
            "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
            "Accept" = "application/json"
        }
    },
    @{
        Name = "Headers API Client"
        Headers = @{
            "User-Agent" = "VegN-Bio-API-Client/1.0"
            "Accept" = "application/json"
            "Content-Type" = "application/json"
        }
    },
    @{
        Name = "Headers Mobile"
        Headers = @{
            "User-Agent" = "VegN-Bio-Mobile/1.0"
            "Accept" = "application/json"
            "X-Requested-With" = "XMLHttpRequest"
        }
    }
)

foreach ($test in $testHeaders) {
    try {
        Write-Host "🔍 Test: $($test.Name)" -ForegroundColor Cyan
        
        $response = Invoke-WebRequest -Uri "$API_BASE_URL/api/v1/restaurants" -Method GET -Headers $test.Headers -TimeoutSec 30
        
        Write-Host "✅ Succès avec $($test.Name)" -ForegroundColor Green
        break
        
    } catch {
        Write-Host "❌ Échec avec $($test.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
}

# 5. Test des endpoints d'authentification spécifiquement
Write-Host "`n🔐 Test spécifique des endpoints d'authentification..." -ForegroundColor Yellow

$authEndpoints = @(
    @{ Path = "/api/v1/auth/register"; Method = "POST"; Body = '{"email":"test@example.com","password":"password123","fullName":"Test User","role":"CLIENT"}' },
    @{ Path = "/api/v1/auth/login"; Method = "POST"; Body = '{"email":"test@example.com","password":"password123"}' }
)

foreach ($endpoint in $authEndpoints) {
    try {
        Write-Host "🔍 Test: $($endpoint.Path)" -ForegroundColor Cyan
        
        $headers = @{
            "Origin" = $FRONTEND_VERCEL
            "Referer" = "$FRONTEND_VERCEL/"
            "Content-Type" = "application/json"
            "Accept" = "application/json"
        }
        
        $response = Invoke-RestMethod -Uri "$API_BASE_URL$($endpoint.Path)" -Method $endpoint.Method -Body $endpoint.Body -Headers $headers -TimeoutSec 30
        
        Write-Host "✅ $($endpoint.Path) - Succès" -ForegroundColor Green
        
    } catch {
        Write-Host "❌ $($endpoint.Path) - Erreur: $($_.Exception.Message)" -ForegroundColor Red
        if ($_.Exception.Response) {
            Write-Host "   Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
        }
    }
}

# 6. Génération du rapport de diagnostic
Write-Host "`n📊 === RAPPORT DE DIAGNOSTIC ===" -ForegroundColor Magenta

$diagnosticResults = @{
    timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    api_url = $API_BASE_URL
    frontend_url = $FRONTEND_VERCEL
    issues_found = @()
    recommendations = @()
}

# Analyser les problèmes identifiés
if ($false) { # Cette condition sera mise à jour selon les résultats
    $diagnosticResults.issues_found += "API inaccessible avec erreur 403"
    $diagnosticResults.recommendations += "Vérifier la configuration de sécurité de l'API"
    $diagnosticResults.recommendations += "Contacter l'équipe DevOps pour vérifier les restrictions d'accès"
}

$diagnosticResults.issues_found += "Endpoints API retournent 403 Forbidden"
$diagnosticResults.recommendations += "Vérifier la configuration CORS et de sécurité"
$diagnosticResults.recommendations += "Vérifier si l'API nécessite une authentification préalable"
$diagnosticResults.recommendations += "Contacter l'équipe de déploiement pour vérifier l'état du service"

Write-Host "🔍 Problèmes identifiés:" -ForegroundColor Red
foreach ($issue in $diagnosticResults.issues_found) {
    Write-Host "  - $issue" -ForegroundColor Red
}

Write-Host "`n💡 Recommandations:" -ForegroundColor Yellow
foreach ($recommendation in $diagnosticResults.recommendations) {
    Write-Host "  - $recommendation" -ForegroundColor Yellow
}

# Sauvegarder le rapport
$diagnosticResults | ConvertTo-Json -Depth 3 | Out-File -FilePath "diagnostic-production-report.json" -Encoding UTF8
Write-Host "`n📄 Rapport de diagnostic sauvegardé: diagnostic-production-report.json" -ForegroundColor Cyan

Write-Host "`n=== DIAGNOSTIC TERMINÉ ===" -ForegroundColor Green
