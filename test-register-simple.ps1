#!/usr/bin/env pwsh

Write-Host "=== Test simple de l'endpoint de Registration ===" -ForegroundColor Green

# Test 1: Registration avec des données valides
Write-Host "`n1. Test de registration avec des données valides..." -ForegroundColor Yellow

try {
    $body = '{"email":"test3@example.com","password":"password123","fullName":"Test User 3","role":"CLIENT"}'
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/v1/auth/register" -Method POST -Body $body -ContentType "application/json"
    
    Write-Host "✅ Registration réussie!" -ForegroundColor Green
    Write-Host "Token: $($response.accessToken)" -ForegroundColor Cyan
    Write-Host "Role: $($response.role)" -ForegroundColor Cyan
    Write-Host "Full Name: $($response.fullName)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Erreur lors de la registration:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    if ($_.Exception.Response) {
        Write-Host "Code de statut: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    }
}

# Test 2: Test de login avec les mêmes credentials
Write-Host "`n2. Test de login avec les credentials créés..." -ForegroundColor Yellow

try {
    $body = '{"email":"test3@example.com","password":"password123"}'
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/v1/auth/login" -Method POST -Body $body -ContentType "application/json"
    
    Write-Host "✅ Login réussi!" -ForegroundColor Green
    Write-Host "Token: $($response.accessToken)" -ForegroundColor Cyan
    Write-Host "Role: $($response.role)" -ForegroundColor Cyan
    Write-Host "Full Name: $($response.fullName)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Erreur lors du login:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    if ($_.Exception.Response) {
        Write-Host "Code de statut: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    }
}

Write-Host "`n=== Test terminé ===" -ForegroundColor Green
