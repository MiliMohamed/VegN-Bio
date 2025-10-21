#!/usr/bin/env pwsh
# Test script to verify deployment after fixing Flyway migration conflicts

Write-Host "🔍 Testing VegN-Bio Backend Deployment Fix..." -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

$baseUrl = "https://vegn-bio-backend.onrender.com"

Write-Host "⏳ Waiting for deployment to complete (30 seconds)..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Test 1: Health Check
Write-Host "`n1. Testing Health Check..." -ForegroundColor Yellow
try {
    $healthResponse = Invoke-RestMethod -Uri "$baseUrl/actuator/health" -Method GET -TimeoutSec 30
    Write-Host "✅ Health Check: $($healthResponse.status)" -ForegroundColor Green
} catch {
    Write-Host "❌ Health Check Failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 2: API Info
Write-Host "`n2. Testing API Info..." -ForegroundColor Yellow
try {
    $infoResponse = Invoke-RestMethod -Uri "$baseUrl/api/info" -Method GET -TimeoutSec 30
    Write-Host "✅ API Info: $($infoResponse.message)" -ForegroundColor Green
} catch {
    Write-Host "❌ API Info Failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: Database Connection (via restaurants endpoint)
Write-Host "`n3. Testing Database Connection..." -ForegroundColor Yellow
try {
    $restaurantsResponse = Invoke-RestMethod -Uri "$baseUrl/api/restaurants" -Method GET -TimeoutSec 30
    Write-Host "✅ Database Connection: Found $($restaurantsResponse.Count) restaurants" -ForegroundColor Green
} catch {
    Write-Host "❌ Database Connection Failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 4: Swagger UI
Write-Host "`n4. Testing Swagger UI..." -ForegroundColor Yellow
try {
    $swaggerResponse = Invoke-WebRequest -Uri "$baseUrl/swagger-ui.html" -Method GET -TimeoutSec 30
    if ($swaggerResponse.StatusCode -eq 200) {
        Write-Host "✅ Swagger UI: Accessible" -ForegroundColor Green
    } else {
        Write-Host "❌ Swagger UI: Status $($swaggerResponse.StatusCode)" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Swagger UI Failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n🎉 Deployment Test Complete!" -ForegroundColor Green
Write-Host "If all tests pass, the Flyway migration conflict has been resolved." -ForegroundColor Cyan
