#!/usr/bin/env pwsh

# Script de test rapide pour la production
Write-Host "=== Test Rapide Production ===" -ForegroundColor Green

$API_BASE_URL = "https://vegn-bio-backend.onrender.com/api/v1"
$FRONTEND_VERCEL = "https://veg-n-bio-front-pi.vercel.app"

# Test 1: Frontend Vercel
Write-Host "`n🌐 Test Frontend Vercel..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri $FRONTEND_VERCEL -Method GET -TimeoutSec 30
    Write-Host "✅ Frontend accessible - Status: $($response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "❌ Frontend inaccessible: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 2: API Backend
Write-Host "`n🔗 Test API Backend..." -ForegroundColor Yellow
$headers = @{
    "Origin" = $FRONTEND_VERCEL
    "Referer" = "$FRONTEND_VERCEL/"
    "Accept" = "application/json"
}

try {
    $response = Invoke-RestMethod -Uri "$API_BASE_URL/restaurants" -Method GET -Headers $headers -TimeoutSec 30
    Write-Host "✅ API accessible - Restaurants: $($response.Count)" -ForegroundColor Green
} catch {
    Write-Host "❌ API inaccessible: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        Write-Host "   Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    }
}

# Test 3: Authentification
Write-Host "`n🔐 Test Authentification..." -ForegroundColor Yellow
$registerData = @{
    email = "quick.test.$(Get-Date -Format 'HHmmss')@example.com"
    password = "password123"
    fullName = "Quick Test User"
    role = "CLIENT"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$API_BASE_URL/auth/register" -Method POST -Body $registerData -ContentType "application/json" -Headers $headers -TimeoutSec 30
    Write-Host "✅ Authentification fonctionnelle" -ForegroundColor Green
    Write-Host "🎫 Token généré: $($response.accessToken.Substring(0, 20))..." -ForegroundColor Cyan
} catch {
    Write-Host "❌ Authentification échouée: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=== Test Rapide Terminé ===" -ForegroundColor Green
