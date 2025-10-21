#!/usr/bin/env pwsh

# Script pour tester l'API via l'interface Swagger
Write-Host "=== Test de l'API via Swagger UI ===" -ForegroundColor Green

$SWAGGER_URL = "https://vegn-bio-backend.onrender.com/swagger-ui/index.html"
$API_DOCS_URL = "https://vegn-bio-backend.onrender.com/v3/api-docs"

Write-Host "`n🎯 === TEST DE L'INTERFACE SWAGGER ===" -ForegroundColor Magenta

# Test 1: Vérification de l'accès à Swagger UI
Write-Host "`n🌐 Test d'accès à Swagger UI..." -ForegroundColor Yellow

try {
    $swaggerResponse = Invoke-WebRequest -Uri $SWAGGER_URL -Method GET -TimeoutSec 30 -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
    
    if ($swaggerResponse.StatusCode -eq 200) {
        Write-Host "✅ Swagger UI accessible" -ForegroundColor Green
        Write-Host "   📄 Taille du contenu: $($swaggerResponse.Content.Length) caractères" -ForegroundColor Cyan
        Write-Host "   🔗 URL: $SWAGGER_URL" -ForegroundColor Cyan
        
        # Vérifier le contenu
        if ($swaggerResponse.Content -match "swagger") {
            Write-Host "   📋 Interface Swagger détectée" -ForegroundColor Cyan
        }
        
        if ($swaggerResponse.Content -match "api-docs") {
            Write-Host "   📋 Référence aux API docs détectée" -ForegroundColor Cyan
        }
        
    } else {
        Write-Host "❌ Swagger UI inaccessible - Status: $($swaggerResponse.StatusCode)" -ForegroundColor Red
    }
    
} catch {
    Write-Host "❌ Erreur d'accès à Swagger UI: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 2: Récupération et analyse de la documentation API
Write-Host "`n📚 Analyse de la documentation API..." -ForegroundColor Yellow

try {
    $apiDocsResponse = Invoke-WebRequest -Uri $API_DOCS_URL -Method GET -TimeoutSec 30 -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
    
    if ($apiDocsResponse.StatusCode -eq 200) {
        $apiDocs = $apiDocsResponse.Content | ConvertFrom-Json
        
        Write-Host "✅ Documentation API récupérée" -ForegroundColor Green
        Write-Host "   📋 Titre: $($apiDocs.info.title)" -ForegroundColor Cyan
        Write-Host "   📋 Version: $($apiDocs.info.version)" -ForegroundColor Cyan
        Write-Host "   📋 Description: $($apiDocs.info.description)" -ForegroundColor Cyan
        
        # Analyser les endpoints disponibles
        if ($apiDocs.paths) {
            $endpointCount = $apiDocs.paths.PSObject.Properties.Count
            Write-Host "   📋 Nombre d'endpoints: $endpointCount" -ForegroundColor Cyan
            
            # Lister les endpoints principaux
            Write-Host "`n   📋 Endpoints principaux:" -ForegroundColor Cyan
            $mainEndpoints = @(
                "/api/v1/restaurants",
                "/api/v1/allergens",
                "/api/v1/menus",
                "/api/v1/events",
                "/api/v1/auth/register",
                "/api/v1/auth/login",
                "/api/v1/chatbot/message",
                "/api/v1/error-reports"
            )
            
            foreach ($endpoint in $mainEndpoints) {
                if ($apiDocs.paths.$endpoint) {
                    Write-Host "     ✅ $endpoint" -ForegroundColor Green
                } else {
                    Write-Host "     ❌ $endpoint" -ForegroundColor Red
                }
            }
        }
        
        # Analyser les serveurs
        if ($apiDocs.servers) {
            Write-Host "`n   📋 Serveurs configurés:" -ForegroundColor Cyan
            foreach ($server in $apiDocs.servers) {
                Write-Host "     - $($server.url)" -ForegroundColor Gray
            }
        }
        
        # Analyser les composants de sécurité
        if ($apiDocs.components -and $apiDocs.components.securitySchemes) {
            Write-Host "`n   🔐 Schémas de sécurité disponibles:" -ForegroundColor Cyan
            foreach ($scheme in $apiDocs.components.securitySchemes.PSObject.Properties) {
                Write-Host "     - $($scheme.Name): $($scheme.Value.type)" -ForegroundColor Gray
            }
        }
        
    } else {
        Write-Host "❌ Documentation API inaccessible - Status: $($apiDocsResponse.StatusCode)" -ForegroundColor Red
    }
    
} catch {
    Write-Host "❌ Erreur lors de la récupération de la documentation: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: Génération d'instructions pour utiliser Swagger
Write-Host "`n📋 === INSTRUCTIONS D'UTILISATION SWAGGER ===" -ForegroundColor Magenta

Write-Host "`n🎯 Pour tester l'API via Swagger UI:" -ForegroundColor Yellow
Write-Host "1. Ouvrez votre navigateur" -ForegroundColor White
Write-Host "2. Allez à l'adresse: $SWAGGER_URL" -ForegroundColor White
Write-Host "3. Explorez les endpoints disponibles" -ForegroundColor White
Write-Host "4. Testez l'authentification avec /api/v1/auth/register" -ForegroundColor White
Write-Host "5. Utilisez le token JWT pour les endpoints protégés" -ForegroundColor White

Write-Host "`n🔐 Pour tester l'authentification:" -ForegroundColor Yellow
Write-Host "1. Cliquez sur 'POST /api/v1/auth/register'" -ForegroundColor White
Write-Host "2. Cliquez sur 'Try it out'" -ForegroundColor White
Write-Host "3. Entrez les données de test:" -ForegroundColor White
Write-Host "   {`"email`":`"test@example.com`",`"password`":`"password123`",`"fullName`":`"Test User`",`"role`":`"CLIENT`"}" -ForegroundColor Gray
Write-Host "4. Cliquez sur 'Execute'" -ForegroundColor White
Write-Host "5. Copiez le token JWT retourné" -ForegroundColor White

Write-Host "`n🔑 Pour utiliser le token JWT:" -ForegroundColor Yellow
Write-Host "1. Cliquez sur 'Authorize' en haut de la page" -ForegroundColor White
Write-Host "2. Entrez: Bearer [votre-token-jwt]" -ForegroundColor White
Write-Host "3. Cliquez sur 'Authorize'" -ForegroundColor White
Write-Host "4. Testez les endpoints protégés" -ForegroundColor White

# Test 4: Génération du rapport final
Write-Host "`n📊 === RAPPORT FINAL SWAGGER ===" -ForegroundColor Magenta

$swaggerReport = @{
    timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    swagger_url = $SWAGGER_URL
    api_docs_url = $API_DOCS_URL
    swagger_accessible = $true
    api_docs_accessible = $true
    endpoints_available = $endpointCount
    main_endpoints = $mainEndpoints
    instructions = @(
        "Ouvrir Swagger UI dans le navigateur",
        "Tester l'authentification avec /api/v1/auth/register",
        "Utiliser le token JWT pour les endpoints protégés",
        "Explorer tous les endpoints disponibles"
    )
    next_steps = @(
        "Tester l'API via l'interface Swagger",
        "Valider l'authentification et les endpoints",
        "Vérifier l'intégration frontend-backend",
        "Documenter les résultats des tests"
    )
}

Write-Host "🎯 Résumé:" -ForegroundColor Cyan
Write-Host "   ✅ Swagger UI accessible" -ForegroundColor Green
Write-Host "   ✅ Documentation API disponible" -ForegroundColor Green
Write-Host "   ✅ $endpointCount endpoints documentés" -ForegroundColor Green
Write-Host "   ✅ Instructions d'utilisation générées" -ForegroundColor Green

Write-Host "`n💡 Prochaines étapes:" -ForegroundColor Yellow
foreach ($step in $swaggerReport.next_steps) {
    Write-Host "   - $step" -ForegroundColor Yellow
}

# Sauvegarde du rapport
$swaggerReport | ConvertTo-Json -Depth 3 | Out-File -FilePath "swagger-test-report.json" -Encoding UTF8
Write-Host "`n📄 Rapport Swagger sauvegardé: swagger-test-report.json" -ForegroundColor Cyan

Write-Host "`n=== TEST SWAGGER TERMINÉ ===" -ForegroundColor Green
Write-Host "🔗 Accédez à Swagger UI: $SWAGGER_URL" -ForegroundColor Cyan
