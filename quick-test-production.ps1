#!/usr/bin/env pwsh
# Test rapide d'authentification en production - PowerShell
# Script simple pour vérifier rapidement les endpoints essentiels

param(
    [string]$BackendUrl = "https://vegn-bio-backend.onrender.com"
)

$ErrorActionPreference = "Continue"
$timestamp = [DateTimeOffset]::Now.ToUnixTimeSeconds()

Write-Host "🚀 Test rapide d'authentification - VegN-Bio" -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Yellow

# Test 1: Connectivité
Write-Host -NoNewline "Test connectivité... "
try {
    $response = Invoke-WebRequest -Uri $BackendUrl -Method GET -TimeoutSec 5 -ErrorAction Stop
    Write-Host "✅ OK" -ForegroundColor Green
} catch {
    Write-Host "❌ ÉCHEC" -ForegroundColor Red
    exit 1
}

# Test 2: Enregistrement
Write-Host -NoNewline "Test enregistrement... "
$registerData = @{
    username = "test_$timestamp"
    email = "test$timestamp@example.com"
    password = "Test123!"
    firstName = "Test"
    lastName = "User"
} | ConvertTo-Json

try {
    $registerResponse = Invoke-RestMethod -Uri "$BackendUrl/api/auth/register" -Method POST -Body $registerData -ContentType "application/json" -TimeoutSec 30 -ErrorAction Stop
    Write-Host "✅ OK" -ForegroundColor Green
} catch {
    Write-Host "❌ ÉCHEC" -ForegroundColor Red
}

# Test 3: Connexion
Write-Host -NoNewline "Test connexion... "
$loginData = @{
    username = "test_$timestamp"
    password = "Test123!"
} | ConvertTo-Json

try {
    $loginResponse = Invoke-RestMethod -Uri "$BackendUrl/api/auth/login" -Method POST -Body $loginData -ContentType "application/json" -TimeoutSec 30 -ErrorAction Stop
    
    if ($loginResponse.token) {
        $token = $loginResponse.token
        Write-Host "✅ OK" -ForegroundColor Green
        
        # Test 4: Profil utilisateur
        Write-Host -NoNewline "Test profil utilisateur... "
        try {
            $headers = @{
                "Authorization" = "Bearer $token"
            }
            $profileResponse = Invoke-RestMethod -Uri "$BackendUrl/api/auth/me" -Method GET -Headers $headers -TimeoutSec 30 -ErrorAction Stop
            
            if ($profileResponse.username -or $profileResponse.email) {
                Write-Host "✅ OK" -ForegroundColor Green
            } else {
                Write-Host "❌ ÉCHEC" -ForegroundColor Red
            }
        } catch {
            Write-Host "❌ ÉCHEC" -ForegroundColor Red
        }
        
        # Test 5: Endpoints protégés
        Write-Host -NoNewline "Test endpoints protégés... "
        try {
            $headers = @{
                "Authorization" = "Bearer $token"
            }
            $restaurantsResponse = Invoke-RestMethod -Uri "$BackendUrl/api/restaurants" -Method GET -Headers $headers -TimeoutSec 30 -ErrorAction Stop
            Write-Host "✅ OK" -ForegroundColor Green
        } catch {
            Write-Host "❌ ÉCHEC" -ForegroundColor Red
        }
        
        # Test 6: Chatbot vétérinaire
        Write-Host -NoNewline "Test chatbot vétérinaire... "
        try {
            $headers = @{
                "Authorization" = "Bearer $token"
                "Content-Type" = "application/json"
            }
            $chatbotData = @{
                breed = "Chien"
                symptoms = @("Fièvre", "Perte d'appétit")
            } | ConvertTo-Json
            
            $chatbotResponse = Invoke-RestMethod -Uri "$BackendUrl/api/veterinary-consultations" -Method POST -Headers $headers -Body $chatbotData -TimeoutSec 30 -ErrorAction Stop
            Write-Host "✅ OK" -ForegroundColor Green
        } catch {
            Write-Host "❌ ÉCHEC" -ForegroundColor Red
        }
        
        # Test 7: Base de données
        Write-Host -NoNewline "Test base de données... "
        try {
            $headers = @{
                "Authorization" = "Bearer $token"
            }
            $vetResponse = Invoke-RestMethod -Uri "$BackendUrl/api/veterinary-consultations" -Method GET -Headers $headers -TimeoutSec 30 -ErrorAction Stop
            Write-Host "✅ OK" -ForegroundColor Green
        } catch {
            Write-Host "❌ ÉCHEC" -ForegroundColor Red
        }
        
    } else {
        Write-Host "❌ ÉCHEC" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ ÉCHEC" -ForegroundColor Red
}

# Test 8: Sécurité (accès sans token)
Write-Host -NoNewline "Test sécurité... "
try {
    $unauthorizedResponse = Invoke-WebRequest -Uri "$BackendUrl/api/restaurants" -Method GET -TimeoutSec 30 -ErrorAction Stop
    Write-Host "❌ ÉCHEC (devrait être bloqué)" -ForegroundColor Red
} catch {
    if ($_.Exception.Response.StatusCode -eq 403 -or $_.Exception.Response.StatusCode -eq 401) {
        Write-Host "✅ OK" -ForegroundColor Green
    } else {
        Write-Host "❌ ÉCHEC" -ForegroundColor Red
    }
}

# Test 9: Performance
Write-Host -NoNewline "Test performance... "
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
try {
    Invoke-WebRequest -Uri $BackendUrl -Method GET -TimeoutSec 30 -ErrorAction Stop | Out-Null
    $stopwatch.Stop()
    $responseTime = $stopwatch.ElapsedMilliseconds
    
    if ($responseTime -lt 5000) {
        Write-Host "✅ OK (${responseTime}ms)" -ForegroundColor Green
    } else {
        Write-Host "⚠️ LENT (${responseTime}ms)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ ÉCHEC" -ForegroundColor Red
}

Write-Host ""
Write-Host "🎉 Test rapide terminé!" -ForegroundColor Green
Write-Host "Backend: $BackendUrl" -ForegroundColor Yellow

Write-Host ""
Write-Host "💡 Instructions d'utilisation:" -ForegroundColor Cyan
Write-Host "  .\quick-test-production.ps1  # Test avec URL par défaut"
Write-Host "  .\quick-test-production.ps1 -BackendUrl 'https://your-backend.com'  # URL personnalisée"
