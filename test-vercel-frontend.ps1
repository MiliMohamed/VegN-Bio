#!/usr/bin/env pwsh

# Script de test spécifique pour les frontends Vercel
Write-Host "=== Test des Frontends Vercel ===" -ForegroundColor Green

$FRONTENDS = @(
    @{
        Name = "Frontend Vercel 1"
        Url = "https://veg-n-bio-front-dujcso1tk-milimohameds-projects.vercel.app"
    },
    @{
        Name = "Frontend Vercel 2" 
        Url = "https://veg-n-bio-front-pi.vercel.app"
    }
)

$API_BASE_URL = "https://vegn-bio-backend.onrender.com/api/v1"

foreach ($frontend in $FRONTENDS) {
    Write-Host "`n🌐 === TEST: $($frontend.Name) ===" -ForegroundColor Magenta
    Write-Host "URL: $($frontend.Url)" -ForegroundColor Cyan
    
    # Test 1: Accès au frontend
    try {
        Write-Host "🔍 Test d'accès au frontend..." -ForegroundColor Yellow
        $response = Invoke-WebRequest -Uri $frontend.Url -Method GET -TimeoutSec 30 -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
        
        Write-Host "✅ Frontend accessible - Status: $($response.StatusCode)" -ForegroundColor Green
        Write-Host "📄 Content-Type: $($response.Headers.'Content-Type')" -ForegroundColor Cyan
        
        # Vérifier si c'est une page React/SPA
        if ($response.Content -match "react|React|vite|Vite") {
            Write-Host "⚛️ Application React détectée" -ForegroundColor Green
        }
        
        # Vérifier les scripts et ressources
        if ($response.Content -match "script.*src|link.*href") {
            Write-Host "📦 Ressources JavaScript/CSS détectées" -ForegroundColor Green
        }
        
    } catch {
        Write-Host "❌ Frontend inaccessible: $($_.Exception.Message)" -ForegroundColor Red
        if ($_.Exception.Response) {
            Write-Host "Status Code: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
        }
        continue
    }
    
    # Test 2: Test des appels API depuis le frontend (simulation)
    Write-Host "`n🔗 Test des appels API depuis le frontend..." -ForegroundColor Yellow
    
    $headers = @{
        "Origin" = $frontend.Url
        "Referer" = "$($frontend.Url)/"
        "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
        "Accept" = "application/json, text/plain, */*"
        "Accept-Language" = "fr-FR,fr;q=0.9,en;q=0.8"
        "Cache-Control" = "no-cache"
        "Pragma" = "no-cache"
    }
    
    # Test des endpoints publics
    $endpoints = @(
        @{ Path = "/restaurants"; Name = "Restaurants" },
        @{ Path = "/allergens"; Name = "Allergènes" },
        @{ Path = "/menus"; Name = "Menus" },
        @{ Path = "/events"; Name = "Événements" }
    )
    
    foreach ($endpoint in $endpoints) {
        try {
            Write-Host "🔍 Test $($endpoint.Name)..." -ForegroundColor Yellow
            $apiUrl = "$API_BASE_URL$($endpoint.Path)"
            
            # Test avec OPTIONS d'abord (CORS preflight)
            try {
                $optionsResponse = Invoke-WebRequest -Uri $apiUrl -Method "OPTIONS" -Headers $headers -TimeoutSec 10
                Write-Host "✅ CORS preflight OK pour $($endpoint.Name)" -ForegroundColor Green
            } catch {
                Write-Host "⚠️ CORS preflight échoué pour $($endpoint.Name)" -ForegroundColor Yellow
            }
            
            # Test GET
            $response = Invoke-RestMethod -Uri $apiUrl -Method GET -Headers $headers -TimeoutSec 30
            
            Write-Host "✅ $($endpoint.Name) - Succès" -ForegroundColor Green
            if ($response -is [array]) {
                Write-Host "📊 Nombre d'éléments: $($response.Count)" -ForegroundColor Cyan
            }
            
        } catch {
            Write-Host "❌ $($endpoint.Name) - Erreur: $($_.Exception.Message)" -ForegroundColor Red
            if ($_.Exception.Response) {
                Write-Host "   Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
            }
        }
    }
    
    # Test 3: Test d'authentification
    Write-Host "`n🔐 Test d'authentification..." -ForegroundColor Yellow
    
    $registerData = @{
        email = "test.vercel.$(Get-Date -Format 'yyyyMMddHHmmss')@example.com"
        password = "password123"
        fullName = "Test Vercel User"
        role = "CLIENT"
    } | ConvertTo-Json
    
    try {
        $authResponse = Invoke-RestMethod -Uri "$API_BASE_URL/auth/register" -Method POST -Body $registerData -ContentType "application/json" -Headers $headers -TimeoutSec 30
        
        Write-Host "✅ Registration réussie" -ForegroundColor Green
        Write-Host "🎫 Token reçu: $($authResponse.accessToken.Substring(0, 20))..." -ForegroundColor Cyan
        
        # Test avec le token
        $authHeaders = $headers.Clone()
        $authHeaders["Authorization"] = "Bearer $($authResponse.accessToken)"
        
        try {
            $meResponse = Invoke-RestMethod -Uri "$API_BASE_URL/auth/me" -Method GET -Headers $authHeaders -TimeoutSec 30
            Write-Host "✅ Endpoint /me accessible avec token" -ForegroundColor Green
            Write-Host "👤 Utilisateur: $($meResponse.fullName) ($($meResponse.email))" -ForegroundColor Cyan
        } catch {
            Write-Host "❌ Endpoint /me échoué: $($_.Exception.Message)" -ForegroundColor Red
        }
        
    } catch {
        Write-Host "❌ Registration échouée: $($_.Exception.Message)" -ForegroundColor Red
        if ($_.Exception.Response) {
            Write-Host "   Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
        }
    }
    
    Write-Host "`n" + "="*60 -ForegroundColor Gray
}

# Test 4: Vérification de la configuration CORS
Write-Host "`n🌐 === VÉRIFICATION CORS ===" -ForegroundColor Magenta

$corsTestHeaders = @{
    "Origin" = "https://veg-n-bio-front-pi.vercel.app"
    "Access-Control-Request-Method" = "GET"
    "Access-Control-Request-Headers" = "Content-Type,Authorization"
}

try {
    $corsResponse = Invoke-WebRequest -Uri "$API_BASE_URL/restaurants" -Method "OPTIONS" -Headers $corsTestHeaders -TimeoutSec 30
    
    Write-Host "✅ Test CORS réussi" -ForegroundColor Green
    Write-Host "📋 Headers CORS reçus:" -ForegroundColor Cyan
    
    $corsHeaders = @(
        "Access-Control-Allow-Origin",
        "Access-Control-Allow-Methods", 
        "Access-Control-Allow-Headers",
        "Access-Control-Allow-Credentials"
    )
    
    foreach ($header in $corsHeaders) {
        if ($corsResponse.Headers[$header]) {
            Write-Host "  $header`: $($corsResponse.Headers[$header])" -ForegroundColor Cyan
        }
    }
    
} catch {
    Write-Host "❌ Test CORS échoué: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=== RÉSUMÉ DES TESTS VERCEL ===" -ForegroundColor Green
Write-Host "🌐 Frontends testés: $($FRONTENDS.Count)" -ForegroundColor White
Write-Host "🔗 API testée: $API_BASE_URL" -ForegroundColor White
Write-Host "✅ Tests terminés !" -ForegroundColor Green
