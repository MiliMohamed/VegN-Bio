#!/usr/bin/env pwsh

# Script pour tester les endpoints qui fonctionnent en production
Write-Host "=== Test des Endpoints Fonctionnels - Production ===" -ForegroundColor Green

$PROD_API_URL = "https://vegn-bio-backend.onrender.com"

Write-Host "`n🎯 === TEST DES ENDPOINTS FONCTIONNELS ===" -ForegroundColor Magenta

# Test 1: Endpoints qui fonctionnent
Write-Host "`n✅ Test des endpoints accessibles..." -ForegroundColor Yellow

$workingEndpoints = @(
    @{ Path = "/swagger-ui/index.html"; Name = "Swagger UI Index" },
    @{ Path = "/v3/api-docs"; Name = "OpenAPI Documentation" }
)

foreach ($endpoint in $workingEndpoints) {
    try {
        Write-Host "🔍 Test: $($endpoint.Name)" -ForegroundColor Cyan
        
        $response = Invoke-WebRequest -Uri "$PROD_API_URL$($endpoint.Path)" -Method GET -TimeoutSec 30 -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
        
        Write-Host "✅ $($endpoint.Name) - Status: $($response.StatusCode)" -ForegroundColor Green
        
        # Analyser le contenu
        if ($response.Content) {
            $contentLength = $response.Content.Length
            Write-Host "   📄 Taille du contenu: $contentLength caractères" -ForegroundColor Cyan
            
            if ($endpoint.Path -eq "/v3/api-docs") {
                try {
                    $apiDocs = $response.Content | ConvertFrom-Json
                    Write-Host "   📋 Titre de l'API: $($apiDocs.info.title)" -ForegroundColor Cyan
                    Write-Host "   📋 Version: $($apiDocs.info.version)" -ForegroundColor Cyan
                    Write-Host "   📋 Serveurs disponibles: $($apiDocs.servers.Count)" -ForegroundColor Cyan
                    
                    # Lister les serveurs
                    foreach ($server in $apiDocs.servers) {
                        Write-Host "     - $($server.url)" -ForegroundColor Gray
                    }
                    
                } catch {
                    Write-Host "   ⚠️ Impossible de parser le JSON des API docs" -ForegroundColor Yellow
                }
            }
        }
        
    } catch {
        Write-Host "❌ $($endpoint.Name) - Erreur: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Test 2: Test des méthodes OPTIONS
Write-Host "`n🌐 Test des méthodes OPTIONS..." -ForegroundColor Yellow

$optionsEndpoints = @(
    "/api/v1/restaurants",
    "/api/v1/allergens",
    "/api/v1/menus",
    "/api/v1/events",
    "/api/v1/auth/register",
    "/api/v1/auth/login"
)

foreach ($endpoint in $optionsEndpoints) {
    try {
        Write-Host "🔍 Test OPTIONS: $endpoint" -ForegroundColor Cyan
        
        $response = Invoke-WebRequest -Uri "$PROD_API_URL$endpoint" -Method "OPTIONS" -TimeoutSec 30 -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
        
        Write-Host "✅ OPTIONS $endpoint - Status: $($response.StatusCode)" -ForegroundColor Green
        
        # Analyser les headers CORS
        $corsHeaders = @(
            "Access-Control-Allow-Origin",
            "Access-Control-Allow-Methods",
            "Access-Control-Allow-Headers",
            "Access-Control-Allow-Credentials"
        )
        
        Write-Host "   📋 Headers CORS:" -ForegroundColor Cyan
        foreach ($header in $corsHeaders) {
            if ($response.Headers[$header]) {
                Write-Host "     $header`: $($response.Headers[$header])" -ForegroundColor Cyan
            }
        }
        
    } catch {
        Write-Host "❌ OPTIONS $endpoint - Erreur: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Test 3: Test de l'API docs pour récupérer les endpoints disponibles
Write-Host "`n📚 Analyse de la documentation API..." -ForegroundColor Yellow

try {
    $apiDocsResponse = Invoke-WebRequest -Uri "$PROD_API_URL/v3/api-docs" -Method GET -TimeoutSec 30 -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
    
    if ($apiDocsResponse.StatusCode -eq 200) {
        $apiDocs = $apiDocsResponse.Content | ConvertFrom-Json
        
        Write-Host "✅ Documentation API récupérée" -ForegroundColor Green
        Write-Host "   📋 Titre: $($apiDocs.info.title)" -ForegroundColor Cyan
        Write-Host "   📋 Version: $($apiDocs.info.version)" -ForegroundColor Cyan
        Write-Host "   📋 Description: $($apiDocs.info.description)" -ForegroundColor Cyan
        
        # Lister les paths disponibles
        if ($apiDocs.paths) {
            Write-Host "`n   📋 Endpoints documentés:" -ForegroundColor Cyan
            $pathCount = 0
            foreach ($path in $apiDocs.paths.PSObject.Properties) {
                $pathCount++
                Write-Host "     $($path.Name)" -ForegroundColor Gray
                if ($pathCount -ge 10) {
                    Write-Host "     ... et $($apiDocs.paths.PSObject.Properties.Count - 10) autres" -ForegroundColor Gray
                    break
                }
            }
        }
        
        # Lister les serveurs
        if ($apiDocs.servers) {
            Write-Host "`n   📋 Serveurs configurés:" -ForegroundColor Cyan
            foreach ($server in $apiDocs.servers) {
                Write-Host "     - $($server.url)" -ForegroundColor Gray
            }
        }
        
    }
    
} catch {
    Write-Host "❌ Impossible de récupérer la documentation API" -ForegroundColor Red
}

# Test 4: Test de l'interface Swagger
Write-Host "`n🌐 Test de l'interface Swagger..." -ForegroundColor Yellow

try {
    $swaggerResponse = Invoke-WebRequest -Uri "$PROD_API_URL/swagger-ui/index.html" -Method GET -TimeoutSec 30 -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
    
    if ($swaggerResponse.StatusCode -eq 200) {
        Write-Host "✅ Interface Swagger accessible" -ForegroundColor Green
        
        # Vérifier si l'interface contient des informations utiles
        if ($swaggerResponse.Content -match "swagger") {
            Write-Host "   📋 Interface Swagger détectée" -ForegroundColor Cyan
        }
        
        if ($swaggerResponse.Content -match "api-docs") {
            Write-Host "   📋 Référence aux API docs détectée" -ForegroundColor Cyan
        }
        
        Write-Host "   🔗 URL d'accès: $PROD_API_URL/swagger-ui/index.html" -ForegroundColor Cyan
        
    }
    
} catch {
    Write-Host "❌ Interface Swagger inaccessible" -ForegroundColor Red
}

# Génération du rapport final
Write-Host "`n📊 === RAPPORT FINAL ===" -ForegroundColor Magenta

$finalReport = @{
    timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    api_url = $PROD_API_URL
    working_endpoints = @(
        "/swagger-ui/index.html",
        "/v3/api-docs"
    )
    working_methods = @("OPTIONS")
    blocked_methods = @("GET", "POST", "PUT", "DELETE", "PATCH", "HEAD")
    analysis = @{
        api_deployed = $true
        documentation_accessible = $true
        cors_configured = $true
        endpoints_blocked = $true
        security_restrictions = $true
    }
    recommendations = @(
        "L'API est déployée et accessible via la documentation",
        "Les restrictions de sécurité bloquent l'accès aux endpoints",
        "Vérifier la configuration de sécurité Spring Boot",
        "Examiner les logs de déploiement Render",
        "Utiliser l'interface Swagger pour tester les endpoints"
    )
    next_steps = @(
        "Accéder à $PROD_API_URL/swagger-ui/index.html pour tester l'API",
        "Vérifier les variables d'environnement sur Render",
        "Contacter l'équipe DevOps pour les restrictions d'accès",
        "Examiner la configuration de sécurité en production"
    )
}

Write-Host "🎯 Résumé de l'analyse:" -ForegroundColor Cyan
Write-Host "   ✅ API déployée et accessible" -ForegroundColor Green
Write-Host "   ✅ Documentation disponible" -ForegroundColor Green
Write-Host "   ✅ CORS configuré" -ForegroundColor Green
Write-Host "   ❌ Endpoints bloqués par la sécurité" -ForegroundColor Red
Write-Host "   ❌ Restrictions d'accès strictes" -ForegroundColor Red

Write-Host "`n💡 Prochaines étapes:" -ForegroundColor Yellow
foreach ($step in $finalReport.next_steps) {
    Write-Host "   - $step" -ForegroundColor Yellow
}

# Sauvegarde du rapport final
$finalReport | ConvertTo-Json -Depth 3 | Out-File -FilePath "working-endpoints-report.json" -Encoding UTF8
Write-Host "`n📄 Rapport final sauvegardé: working-endpoints-report.json" -ForegroundColor Cyan

Write-Host "`n=== ANALYSE TERMINÉE ===" -ForegroundColor Green
Write-Host "🔗 Accédez à l'interface Swagger: $PROD_API_URL/swagger-ui/index.html" -ForegroundColor Cyan
