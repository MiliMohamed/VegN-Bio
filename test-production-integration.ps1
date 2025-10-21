#!/usr/bin/env pwsh

# Script de test d'intégration production - API Render + Frontend Vercel
Write-Host "=== Test d'intégration Production API + Frontend Vercel ===" -ForegroundColor Green

# URLs de production
$API_BASE_URL = "https://vegn-bio-backend.onrender.com/api/v1"
$FRONTEND_VERCEL_1 = "https://veg-n-bio-front-dujcso1tk-milimohameds-projects.vercel.app"
$FRONTEND_VERCEL_2 = "https://veg-n-bio-front-pi.vercel.app"

# Headers pour simuler les requêtes depuis Vercel
$vercelHeaders1 = @{
    "Origin" = $FRONTEND_VERCEL_1
    "Referer" = "$FRONTEND_VERCEL_1/"
    "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
    "Accept" = "application/json"
}

$vercelHeaders2 = @{
    "Origin" = $FRONTEND_VERCEL_2
    "Referer" = "$FRONTEND_VERCEL_2/"
    "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
    "Accept" = "application/json"
}

# Fonction pour tester un endpoint avec gestion d'erreur
function Test-Endpoint {
    param(
        [string]$Url,
        [string]$Method = "GET",
        [hashtable]$Headers = @{},
        [string]$Body = $null,
        [string]$TestName
    )
    
    Write-Host "`n🔍 $TestName" -ForegroundColor Yellow
    Write-Host "URL: $Url" -ForegroundColor Cyan
    
    try {
        $params = @{
            Uri = $Url
            Method = $Method
            Headers = $Headers
            TimeoutSec = 30
            ErrorAction = 'Stop'
        }
        
        if ($Body) {
            $params.Body = $Body
            $params.ContentType = "application/json"
        }
        
        $response = Invoke-RestMethod @params
        
        Write-Host "✅ Succès - Status: OK" -ForegroundColor Green
        if ($response -is [array]) {
            Write-Host "📊 Nombre d'éléments: $($response.Count)" -ForegroundColor Cyan
        } elseif ($response -is [object]) {
            Write-Host "📋 Réponse reçue: $($response | ConvertTo-Json -Depth 2 -Compress)" -ForegroundColor Cyan
        }
        return $true
    } catch {
        Write-Host "❌ Erreur: $($_.Exception.Message)" -ForegroundColor Red
        if ($_.Exception.Response) {
            Write-Host "Status Code: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
        }
        return $false
    }
}

# Test 1: Vérification de l'API backend
Write-Host "`n🚀 === TESTS API BACKEND ===" -ForegroundColor Magenta

# Test des endpoints publics
Test-Endpoint -Url "$API_BASE_URL/restaurants" -TestName "Test restaurants (public)"
Test-Endpoint -Url "$API_BASE_URL/allergens" -TestName "Test allergens (public)"
Test-Endpoint -Url "$API_BASE_URL/menus" -TestName "Test menus (public)"
Test-Endpoint -Url "$API_BASE_URL/events" -TestName "Test events (public)"

# Test 2: Authentification avec headers Vercel
Write-Host "`n🔐 === TESTS AUTHENTIFICATION AVEC HEADERS VERCEL ===" -ForegroundColor Magenta

# Test registration avec headers Vercel 1
$registerData1 = @{
    email = "test.vercel1@example.com"
    password = "password123"
    fullName = "Test Vercel User 1"
    role = "CLIENT"
} | ConvertTo-Json

Test-Endpoint -Url "$API_BASE_URL/auth/register" -Method "POST" -Headers $vercelHeaders1 -Body $registerData1 -TestName "Registration avec headers Vercel 1"

# Test registration avec headers Vercel 2
$registerData2 = @{
    email = "test.vercel2@example.com"
    password = "password123"
    fullName = "Test Vercel User 2"
    role = "CLIENT"
} | ConvertTo-Json

Test-Endpoint -Url "$API_BASE_URL/auth/register" -Method "POST" -Headers $vercelHeaders2 -Body $registerData2 -TestName "Registration avec headers Vercel 2"

# Test login avec headers Vercel
$loginData = @{
    email = "test.vercel1@example.com"
    password = "password123"
} | ConvertTo-Json

$loginResult = Test-Endpoint -Url "$API_BASE_URL/auth/login" -Method "POST" -Headers $vercelHeaders1 -Body $loginData -TestName "Login avec headers Vercel"

# Test 3: Endpoints protégés avec token
Write-Host "`n🛡️ === TESTS ENDPOINTS PROTÉGÉS ===" -ForegroundColor Magenta

# Récupérer un token pour les tests protégés
try {
    $loginResponse = Invoke-RestMethod -Uri "$API_BASE_URL/auth/login" -Method POST -Body $loginData -ContentType "application/json" -Headers $vercelHeaders1 -TimeoutSec 30
    
    $authHeaders = $vercelHeaders1.Clone()
    $authHeaders["Authorization"] = "Bearer $($loginResponse.accessToken)"
    
    Test-Endpoint -Url "$API_BASE_URL/auth/me" -Headers $authHeaders -TestName "Test endpoint /me avec token"
    
} catch {
    Write-Host "⚠️ Impossible de récupérer un token pour les tests protégés" -ForegroundColor Yellow
}

# Test 4: Test CORS avec OPTIONS
Write-Host "`n🌐 === TESTS CORS ===" -ForegroundColor Magenta

try {
    $corsResponse = Invoke-WebRequest -Uri "$API_BASE_URL/auth/register" -Method "OPTIONS" -Headers @{
        "Origin" = $FRONTEND_VERCEL_1
        "Access-Control-Request-Method" = "POST"
        "Access-Control-Request-Headers" = "Content-Type,Authorization"
    } -TimeoutSec 30
    
    Write-Host "✅ Test CORS OPTIONS réussi" -ForegroundColor Green
    Write-Host "Headers CORS:" -ForegroundColor Cyan
    $corsResponse.Headers | ForEach-Object {
        if ($_.Key -like "*Access-Control*") {
            Write-Host "  $($_.Key): $($_.Value -join ', ')" -ForegroundColor Cyan
        }
    }
} catch {
    Write-Host "❌ Test CORS échoué: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 5: Vérification des frontends Vercel
Write-Host "`n🌍 === TESTS FRONTENDS VERCEL ===" -ForegroundColor Magenta

try {
    Write-Host "🔍 Test accès Frontend Vercel 1..." -ForegroundColor Yellow
    $response1 = Invoke-WebRequest -Uri $FRONTEND_VERCEL_1 -Method GET -TimeoutSec 30
    Write-Host "✅ Frontend Vercel 1 accessible - Status: $($response1.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "❌ Frontend Vercel 1 inaccessible: $($_.Exception.Message)" -ForegroundColor Red
}

try {
    Write-Host "🔍 Test accès Frontend Vercel 2..." -ForegroundColor Yellow
    $response2 = Invoke-WebRequest -Uri $FRONTEND_VERCEL_2 -Method GET -TimeoutSec 30
    Write-Host "✅ Frontend Vercel 2 accessible - Status: $($response2.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "❌ Frontend Vercel 2 inaccessible: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 6: Test de performance
Write-Host "`n⚡ === TESTS DE PERFORMANCE ===" -ForegroundColor Magenta

$endpoints = @(
    "$API_BASE_URL/restaurants",
    "$API_BASE_URL/allergens",
    "$API_BASE_URL/menus"
)

foreach ($endpoint in $endpoints) {
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        $response = Invoke-RestMethod -Uri $endpoint -Method GET -TimeoutSec 30
        $stopwatch.Stop()
        $responseTime = $stopwatch.ElapsedMilliseconds
        Write-Host "✅ $endpoint - Temps de réponse: ${responseTime}ms" -ForegroundColor Green
    } catch {
        Write-Host "❌ $endpoint - Erreur: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n=== RÉSUMÉ DES TESTS ===" -ForegroundColor Green
Write-Host "🔗 API Backend: $API_BASE_URL" -ForegroundColor White
Write-Host "🌐 Frontend Vercel 1: $FRONTEND_VERCEL_1" -ForegroundColor White
Write-Host "🌐 Frontend Vercel 2: $FRONTEND_VERCEL_2" -ForegroundColor White
Write-Host "`n✅ Tests d'intégration terminés !" -ForegroundColor Green
