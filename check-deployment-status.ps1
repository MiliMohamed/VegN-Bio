#!/usr/bin/env pwsh
# Script to check the deployment status and test the API

Write-Host "🔍 Checking VegN-Bio Backend Deployment Status..." -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green

$baseUrl = "https://vegn-bio-backend.onrender.com"

# Test if the service is responding
Write-Host "`n1. Testing Service Availability..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri $baseUrl -Method GET -TimeoutSec 10
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Service is responding (Status: $($response.StatusCode))" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Service responded with status: $($response.StatusCode)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ Service is not responding: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "This might mean the deployment is still in progress or failed." -ForegroundColor Yellow
}

# Test health endpoint
Write-Host "`n2. Testing Health Endpoint..." -ForegroundColor Yellow
try {
    $healthResponse = Invoke-RestMethod -Uri "$baseUrl/actuator/health" -Method GET -TimeoutSec 10
    Write-Host "✅ Health Check: $($healthResponse.status)" -ForegroundColor Green
} catch {
    Write-Host "❌ Health Check Failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test API info endpoint
Write-Host "`n3. Testing API Info..." -ForegroundColor Yellow
try {
    $infoResponse = Invoke-RestMethod -Uri "$baseUrl/api/info" -Method GET -TimeoutSec 10
    Write-Host "✅ API Info: $($infoResponse.message)" -ForegroundColor Green
} catch {
    Write-Host "❌ API Info Failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n📋 Deployment Status Summary:" -ForegroundColor Cyan
Write-Host "- If all tests pass: Migration fixes were successful! 🎉" -ForegroundColor Green
Write-Host "- If tests fail: Deployment might still be in progress or there are other issues" -ForegroundColor Yellow
Write-Host "- Check Render dashboard for detailed deployment logs" -ForegroundColor Cyan
