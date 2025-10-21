#!/usr/bin/env pwsh
# Test d'accès aux différents endpoints pour identifier les problèmes de sécurité
# VegN-Bio Backend

param(
    [string]$BackendUrl = "https://vegn-bio-backend.onrender.com"
)

$ErrorActionPreference = "Continue"

Write-Host "🔍 Test d'Accès aux Endpoints - VegN-Bio" -ForegroundColor Blue
Write-Host "=======================================" -ForegroundColor Blue
Write-Host "Backend: $BackendUrl"
Write-Host ""

# Liste des endpoints à tester
$endpoints = @(
    @{ Path = "/"; Method = "GET"; Description = "Root endpoint" },
    @{ Path = "/api"; Method = "GET"; Description = "API root" },
    @{ Path = "/api/v1"; Method = "GET"; Description = "API v1 root" },
    @{ Path = "/api/v1/auth"; Method = "GET"; Description = "Auth root" },
    @{ Path = "/api/v1/auth/register"; Method = "POST"; Description = "Register endpoint" },
    @{ Path = "/api/v1/auth/login"; Method = "POST"; Description = "Login endpoint" },
    @{ Path = "/api/v1/auth/me"; Method = "GET"; Description = "Profile endpoint" },
    @{ Path = "/api/v1/restaurants"; Method = "GET"; Description = "Restaurants endpoint" },
    @{ Path = "/api/v1/menus"; Method = "GET"; Description = "Menus endpoint" },
    @{ Path = "/api/v1/chatbot"; Method = "GET"; Description = "Chatbot endpoint" },
    @{ Path = "/api/v1/error-reports"; Method = "GET"; Description = "Error reports endpoint" },
    @{ Path = "/swagger-ui"; Method = "GET"; Description = "Swagger UI" },
    @{ Path = "/v3/api-docs"; Method = "GET"; Description = "API docs" },
    @{ Path = "/actuator/health"; Method = "GET"; Description = "Health check" },
    @{ Path = "/actuator/info"; Method = "GET"; Description = "Info endpoint" }
)

Write-Host "🧪 Test des endpoints sans authentification..." -ForegroundColor Yellow
Write-Host ""

foreach ($endpoint in $endpoints) {
    $url = $BackendUrl + $endpoint.Path
    Write-Host -NoNewline "Testing $($endpoint.Description) ($($endpoint.Path))... "
    
    try {
        if ($endpoint.Method -eq "POST") {
            # Pour les endpoints POST, on teste d'abord avec une requête GET
            $response = Invoke-WebRequest -Uri $url -Method GET -TimeoutSec 10 -ErrorAction Stop
            Write-Host "✅ GET OK (Status: $($response.StatusCode))" -ForegroundColor Green
        } else {
            $response = Invoke-WebRequest -Uri $url -Method $endpoint.Method -TimeoutSec 10 -ErrorAction Stop
            Write-Host "✅ OK (Status: $($response.StatusCode))" -ForegroundColor Green
        }
    } catch {
        if ($_.Exception.Response) {
            $statusCode = $_.Exception.Response.StatusCode
            switch ($statusCode) {
                200 { Write-Host "✅ OK (200)" -ForegroundColor Green }
                403 { Write-Host "🔒 Forbidden (403)" -ForegroundColor Yellow }
                401 { Write-Host "🔐 Unauthorized (401)" -ForegroundColor Yellow }
                404 { Write-Host "❌ Not Found (404)" -ForegroundColor Red }
                405 { Write-Host "⚠️ Method Not Allowed (405)" -ForegroundColor Yellow }
                500 { Write-Host "💥 Server Error (500)" -ForegroundColor Red }
                default { Write-Host "⚠️ Status: $statusCode" -ForegroundColor Yellow }
            }
        } else {
            Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "🧪 Test des endpoints avec données POST..." -ForegroundColor Yellow
Write-Host ""

# Test des endpoints POST avec des données
$postEndpoints = @(
    @{
        Path = "/api/v1/auth/register"
        Data = @{
            username = "testuser_$(Get-Date -Format 'yyyyMMddHHmmss')"
            email = "test$(Get-Date -Format 'yyyyMMddHHmmss')@example.com"
            password = "TestPassword123!"
            firstName = "Test"
            lastName = "User"
        }
        Description = "Register with data"
    },
    @{
        Path = "/api/v1/auth/login"
        Data = @{
            username = "testuser"
            password = "testpassword"
        }
        Description = "Login with data"
    }
)

foreach ($endpoint in $postEndpoints) {
    $url = $BackendUrl + $endpoint.Path
    Write-Host -NoNewline "Testing $($endpoint.Description) ($($endpoint.Path))... "
    
    try {
        $jsonData = $endpoint.Data | ConvertTo-Json
        $response = Invoke-RestMethod -Uri $url -Method POST -Body $jsonData -ContentType "application/json" -TimeoutSec 30 -ErrorAction Stop
        Write-Host "✅ POST OK" -ForegroundColor Green
    } catch {
        if ($_.Exception.Response) {
            $statusCode = $_.Exception.Response.StatusCode
            switch ($statusCode) {
                200 { Write-Host "✅ OK (200)" -ForegroundColor Green }
                201 { Write-Host "✅ Created (201)" -ForegroundColor Green }
                403 { Write-Host "🔒 Forbidden (403)" -ForegroundColor Yellow }
                401 { Write-Host "🔐 Unauthorized (401)" -ForegroundColor Yellow }
                404 { Write-Host "❌ Not Found (404)" -ForegroundColor Red }
                405 { Write-Host "⚠️ Method Not Allowed (405)" -ForegroundColor Yellow }
                500 { Write-Host "💥 Server Error (500)" -ForegroundColor Red }
                default { Write-Host "⚠️ Status: $statusCode" -ForegroundColor Yellow }
            }
        } else {
            Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "🔍 Test des endpoints avec OPTIONS (CORS)..." -ForegroundColor Yellow
Write-Host ""

# Test des options CORS
$corsEndpoints = @("/api/v1/auth/register", "/api/v1/auth/login", "/api/v1/restaurants")

foreach ($endpoint in $corsEndpoints) {
    $url = $BackendUrl + $endpoint
    Write-Host -NoNewline "Testing CORS for $endpoint... "
    
    try {
        $response = Invoke-WebRequest -Uri $url -Method OPTIONS -TimeoutSec 10 -ErrorAction Stop
        Write-Host "✅ OPTIONS OK (Status: $($response.StatusCode))" -ForegroundColor Green
        
        # Vérifier les headers CORS
        $corsHeaders = @()
        if ($response.Headers["Access-Control-Allow-Origin"]) { $corsHeaders += "Allow-Origin" }
        if ($response.Headers["Access-Control-Allow-Methods"]) { $corsHeaders += "Allow-Methods" }
        if ($response.Headers["Access-Control-Allow-Headers"]) { $corsHeaders += "Allow-Headers" }
        
        if ($corsHeaders.Count -gt 0) {
            Write-Host "   CORS Headers: $($corsHeaders -join ', ')" -ForegroundColor Cyan
        }
    } catch {
        if ($_.Exception.Response) {
            $statusCode = $_.Exception.Response.StatusCode
            Write-Host "⚠️ OPTIONS Status: $statusCode" -ForegroundColor Yellow
        } else {
            Write-Host "❌ OPTIONS Error: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "📊 Résumé des Tests" -ForegroundColor Blue
Write-Host "===================" -ForegroundColor Blue
Write-Host ""
Write-Host "🔍 Analyse des résultats:" -ForegroundColor Cyan
Write-Host "- ✅ OK: Endpoint accessible et fonctionnel" -ForegroundColor Green
Write-Host "- 🔒 Forbidden (403): Endpoint protégé par la sécurité" -ForegroundColor Yellow
Write-Host "- 🔐 Unauthorized (401): Authentification requise" -ForegroundColor Yellow
Write-Host "- ❌ Not Found (404): Endpoint inexistant" -ForegroundColor Red
Write-Host "- ⚠️ Method Not Allowed (405): Méthode HTTP non autorisée" -ForegroundColor Yellow
Write-Host "- 💥 Server Error (500): Erreur interne du serveur" -ForegroundColor Red

Write-Host ""
Write-Host "💡 Recommandations:" -ForegroundColor Cyan
Write-Host "1. Vérifiez la configuration Spring Security" -ForegroundColor White
Write-Host "2. Assurez-vous que les endpoints d'auth sont bien en permitAll()" -ForegroundColor White
Write-Host "3. Vérifiez les logs Render pour plus de détails" -ForegroundColor White
Write-Host "4. Testez avec un client REST comme Postman ou Insomnia" -ForegroundColor White

Write-Host ""
Write-Host "🔗 URLs utiles:" -ForegroundColor Blue
Write-Host "- Backend: $BackendUrl"
Write-Host "- Logs Render: https://dashboard.render.com/web/srv-d3i2ci9r0fns73cpojgg/logs"
Write-Host "- Dashboard Render: https://dashboard.render.com"

Write-Host ""
Write-Host "🎯 Test des endpoints terminé!" -ForegroundColor Green
