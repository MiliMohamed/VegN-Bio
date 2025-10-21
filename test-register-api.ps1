#!/usr/bin/env pwsh

# Script de test pour l'endpoint de registration
Write-Host "=== Test de l'endpoint de Registration ===" -ForegroundColor Green

# URL du backend (ajustez selon votre configuration)
$backendUrl = "http://localhost:8080"
$registerUrl = "$backendUrl/api/v1/auth/register"

# Test 1: Registration avec des données valides
Write-Host "`n1. Test de registration avec des données valides..." -ForegroundColor Yellow

$registerData = @{
    email = "test.user@example.com"
    password = "password123"
    fullName = "Test User"
    role = "CLIENT"
} | ConvertTo-Json -Depth 3

try {
    $response = Invoke-RestMethod -Uri $registerUrl -Method POST -Body $registerData -ContentType "application/json" -ErrorAction Stop
    
    Write-Host "✅ Registration réussie!" -ForegroundColor Green
    Write-Host "Token: $($response.token)" -ForegroundColor Cyan
    Write-Host "Role: $($response.role)" -ForegroundColor Cyan
    Write-Host "Full Name: $($response.fullName)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Erreur lors de la registration:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    
    if ($_.Exception.Response) {
        $statusCode = $_.Exception.Response.StatusCode
        Write-Host "Code de statut: $statusCode" -ForegroundColor Red
        
        try {
            $errorStream = $_.Exception.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($errorStream)
            $errorBody = $reader.ReadToEnd()
            Write-Host "Corps de l'erreur: $errorBody" -ForegroundColor Red
        } catch {
            Write-Host "Impossible de lire le corps de l'erreur" -ForegroundColor Red
        }
    }
}

# Test 2: Registration avec email déjà existant
Write-Host "`n2. Test de registration avec email déjà existant..." -ForegroundColor Yellow

$duplicateData = @{
    email = "test.user@example.com"
    password = "password123"
    fullName = "Another Test User"
    role = "CLIENT"
} | ConvertTo-Json -Depth 3

try {
    $response = Invoke-RestMethod -Uri $registerUrl -Method POST -Body $duplicateData -ContentType "application/json" -ErrorAction Stop
    Write-Host "⚠️ Registration réussie (ne devrait pas l'être)!" -ForegroundColor Yellow
} catch {
    Write-Host "✅ Erreur attendue pour email dupliqué" -ForegroundColor Green
    Write-Host "Message d'erreur: $($_.Exception.Message)" -ForegroundColor Cyan
}

# Test 3: Registration avec données invalides
Write-Host "`n3. Test de registration avec données invalides..." -ForegroundColor Yellow

$invalidData = @{
    email = "invalid-email"
    password = "123"
    fullName = ""
    role = "INVALID_ROLE"
} | ConvertTo-Json -Depth 3

try {
    $response = Invoke-RestMethod -Uri $registerUrl -Method POST -Body $invalidData -ContentType "application/json" -ErrorAction Stop
    Write-Host "⚠️ Registration réussie (ne devrait pas l'être)!" -ForegroundColor Yellow
} catch {
    Write-Host "✅ Erreur attendue pour données invalides" -ForegroundColor Green
    Write-Host "Message d'erreur: $($_.Exception.Message)" -ForegroundColor Cyan
}

Write-Host "`n=== Test terminé ===" -ForegroundColor Green
