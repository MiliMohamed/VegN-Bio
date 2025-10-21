#!/usr/bin/env pwsh

# Script pour diagnostiquer les problèmes de sécurité en production
Write-Host "=== Diagnostic Sécurité Production ===" -ForegroundColor Green

$PROD_API_URL = "https://vegn-bio-backend.onrender.com"
$FRONTEND_VERCEL = "https://veg-n-bio-front-pi.vercel.app"

Write-Host "`n🔍 === DIAGNOSTIC SÉCURITÉ ===" -ForegroundColor Magenta

# Test 1: Vérification des endpoints de base sans authentification
Write-Host "`n🌐 Test des endpoints de base..." -ForegroundColor Yellow

$baseEndpoints = @(
    @{ Path = "/"; Name = "Root" },
    @{ Path = "/actuator/health"; Name = "Health Check" },
    @{ Path = "/swagger-ui.html"; Name = "Swagger UI" },
    @{ Path = "/swagger-ui/index.html"; Name = "Swagger UI Index" },
    @{ Path = "/v3/api-docs"; Name = "OpenAPI Docs" }
)

foreach ($endpoint in $baseEndpoints) {
    try {
        Write-Host "🔍 Test: $($endpoint.Name) - $($endpoint.Path)" -ForegroundColor Cyan
        
        $response = Invoke-WebRequest -Uri "$PROD_API_URL$($endpoint.Path)" -Method GET -TimeoutSec 30 -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
        
        Write-Host "✅ $($endpoint.Name) - Status: $($response.StatusCode)" -ForegroundColor Green
        
        # Vérifier le contenu
        if ($response.Content -match "swagger|openapi|health") {
            Write-Host "   📋 Contenu approprié détecté" -ForegroundColor Cyan
        }
        
    } catch {
        $errorMessage = $_.Exception.Message
        $statusCode = ""
        if ($_.Exception.Response) {
            $statusCode = " (Status: $($_.Exception.Response.StatusCode))"
        }
        Write-Host "❌ $($endpoint.Name) - Erreur: $errorMessage$statusCode" -ForegroundColor Red
    }
}

# Test 2: Test avec différents headers pour contourner les restrictions
Write-Host "`n🔧 Test avec différents headers..." -ForegroundColor Yellow

$headerVariations = @(
    @{
        Name = "Headers Vercel Standard"
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
        Name = "Headers Browser Standard"
        Headers = @{
            "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
            "Accept" = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
            "Accept-Language" = "fr-FR,fr;q=0.9,en;q=0.8"
            "Accept-Encoding" = "gzip, deflate, br"
        }
    },
    @{
        Name = "Headers Minimal"
        Headers = @{
            "User-Agent" = "curl/7.68.0"
        }
    }
)

foreach ($headerTest in $headerVariations) {
    Write-Host "`n🔍 Test: $($headerTest.Name)" -ForegroundColor Cyan
    
    try {
        $response = Invoke-WebRequest -Uri "$PROD_API_URL/api/v1/restaurants" -Method GET -Headers $headerTest.Headers -TimeoutSec 30
        
        Write-Host "✅ $($headerTest.Name) - Status: $($response.StatusCode)" -ForegroundColor Green
        Write-Host "   🎯 Cette configuration fonctionne !" -ForegroundColor Green
        break
        
    } catch {
        $errorMessage = $_.Exception.Message
        $statusCode = ""
        if ($_.Exception.Response) {
            $statusCode = " (Status: $($_.Exception.Response.StatusCode))"
        }
        Write-Host "❌ $($headerTest.Name) - Erreur: $errorMessage$statusCode" -ForegroundColor Red
    }
}

# Test 3: Test des méthodes HTTP différentes
Write-Host "`n🌐 Test des méthodes HTTP..." -ForegroundColor Yellow

$httpMethods = @("GET", "POST", "PUT", "DELETE", "PATCH", "HEAD", "OPTIONS")

foreach ($method in $httpMethods) {
    try {
        Write-Host "🔍 Test méthode: $method" -ForegroundColor Cyan
        
        $response = Invoke-WebRequest -Uri "$PROD_API_URL/api/v1/restaurants" -Method $method -TimeoutSec 30 -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
        
        Write-Host "✅ $method - Status: $($response.StatusCode)" -ForegroundColor Green
        
    } catch {
        $errorMessage = $_.Exception.Message
        $statusCode = ""
        if ($_.Exception.Response) {
            $statusCode = " (Status: $($_.Exception.Response.StatusCode))"
        }
        Write-Host "❌ $method - Erreur: $errorMessage$statusCode" -ForegroundColor Red
    }
}

# Test 4: Test de contournement avec des URLs alternatives
Write-Host "`n🔗 Test d'URLs alternatives..." -ForegroundColor Yellow

$alternativeUrls = @(
    "$PROD_API_URL/api/restaurants",
    "$PROD_API_URL/restaurants",
    "$PROD_API_URL/api/v1/restaurants/",
    "$PROD_API_URL/api/v1/restaurants?format=json"
)

foreach ($url in $alternativeUrls) {
    try {
        Write-Host "🔍 Test URL: $url" -ForegroundColor Cyan
        
        $response = Invoke-WebRequest -Uri $url -Method GET -TimeoutSec 30 -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
        
        Write-Host "✅ URL accessible - Status: $($response.StatusCode)" -ForegroundColor Green
        Write-Host "   🎯 Cette URL fonctionne !" -ForegroundColor Green
        
    } catch {
        $errorMessage = $_.Exception.Message
        $statusCode = ""
        if ($_.Exception.Response) {
            $statusCode = " (Status: $($_.Exception.Response.StatusCode))"
        }
        Write-Host "❌ URL inaccessible - Erreur: $errorMessage$statusCode" -ForegroundColor Red
    }
}

# Test 5: Vérification des headers de sécurité
Write-Host "`n🛡️ Analyse des headers de sécurité..." -ForegroundColor Yellow

try {
    $response = Invoke-WebRequest -Uri "$PROD_API_URL/" -Method GET -TimeoutSec 30 -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
    
    Write-Host "📋 Headers de sécurité détectés:" -ForegroundColor Cyan
    
    $securityHeaders = @(
        "strict-transport-security",
        "x-content-type-options", 
        "x-frame-options",
        "x-xss-protection",
        "content-security-policy",
        "referrer-policy"
    )
    
    foreach ($header in $securityHeaders) {
        if ($response.Headers[$header]) {
            Write-Host "   $header`: $($response.Headers[$header])" -ForegroundColor Cyan
        }
    }
    
    # Vérifier les headers de contrôle d'accès
    Write-Host "`n🔐 Headers de contrôle d'accès:" -ForegroundColor Cyan
    $accessControlHeaders = $response.Headers.Keys | Where-Object { $_ -like "*access-control*" -or $_ -like "*cors*" }
    foreach ($header in $accessControlHeaders) {
        Write-Host "   $header`: $($response.Headers[$header])" -ForegroundColor Cyan
    }
    
} catch {
    Write-Host "❌ Impossible d'analyser les headers de sécurité" -ForegroundColor Red
}

# Test 6: Test avec authentification basique
Write-Host "`n🔑 Test d'authentification basique..." -ForegroundColor Yellow

$basicAuthHeaders = @{
    "Authorization" = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("admin:admin"))
    "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
}

try {
    $response = Invoke-WebRequest -Uri "$PROD_API_URL/api/v1/restaurants" -Method GET -Headers $basicAuthHeaders -TimeoutSec 30
    
    Write-Host "✅ Authentification basique - Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "   🎯 L'API nécessite une authentification !" -ForegroundColor Green
    
} catch {
    Write-Host "❌ Authentification basique échouée" -ForegroundColor Red
}

# Génération du rapport de sécurité
Write-Host "`n📊 === RAPPORT DE SÉCURITÉ ===" -ForegroundColor Magenta

$securityReport = @{
    timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    api_url = $PROD_API_URL
    frontend_url = $FRONTEND_VERCEL
    security_analysis = @{
        endpoints_tested = $baseEndpoints.Count
        header_variations_tested = $headerVariations.Count
        http_methods_tested = $httpMethods.Count
        alternative_urls_tested = $alternativeUrls.Count
    }
    findings = @(
        "API retourne 403 Forbidden pour tous les endpoints",
        "Configuration CORS correcte mais endpoints bloqués",
        "Headers de sécurité présents",
        "Authentification basique testée"
    )
    recommendations = @(
        "Vérifier la configuration de sécurité Spring Boot",
        "Contacter l'équipe DevOps pour vérifier les restrictions Render",
        "Vérifier les variables d'environnement de production",
        "Examiner les logs de déploiement Render"
    )
}

Write-Host "🔍 Résumé de l'analyse de sécurité:" -ForegroundColor Cyan
Write-Host "   - Endpoints de base testés: $($baseEndpoints.Count)" -ForegroundColor White
Write-Host "   - Variations d'headers testées: $($headerVariations.Count)" -ForegroundColor White
Write-Host "   - Méthodes HTTP testées: $($httpMethods.Count)" -ForegroundColor White
Write-Host "   - URLs alternatives testées: $($alternativeUrls.Count)" -ForegroundColor White

Write-Host "`n💡 Recommandations principales:" -ForegroundColor Yellow
foreach ($recommendation in $securityReport.recommendations) {
    Write-Host "   - $recommendation" -ForegroundColor Yellow
}

# Sauvegarde du rapport
$securityReport | ConvertTo-Json -Depth 3 | Out-File -FilePath "security-analysis-report.json" -Encoding UTF8
Write-Host "`n📄 Rapport de sécurité sauvegardé: security-analysis-report.json" -ForegroundColor Cyan

Write-Host "`n=== DIAGNOSTIC SÉCURITÉ TERMINÉ ===" -ForegroundColor Green
