#!/usr/bin/env pwsh
# Test minimal d'authentification pour diagnostiquer les erreurs 500
# VegN-Bio Backend

param(
    [string]$BackendUrl = "https://vegn-bio-backend.onrender.com"
)

$ErrorActionPreference = "Continue"

Write-Host "🔧 Test Minimal d'Authentification" -ForegroundColor Blue
Write-Host "==================================" -ForegroundColor Blue
Write-Host "Backend: $BackendUrl"
Write-Host ""

# Test 1: Vérifier que le serveur répond
Write-Host "1. Test de connectivité..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri $BackendUrl -Method GET -TimeoutSec 10 -ErrorAction Stop
    Write-Host "   ✅ Serveur accessible (Status: $($response.StatusCode))" -ForegroundColor Green
} catch {
    if ($_.Exception.Response.StatusCode -eq 403) {
        Write-Host "   ✅ Serveur accessible (403 - Sécurité active)" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Serveur inaccessible: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

# Test 2: Test d'enregistrement minimal
Write-Host ""
Write-Host "2. Test d'enregistrement minimal..." -ForegroundColor Yellow

$timestamp = [DateTimeOffset]::Now.ToUnixTimeSeconds()
$testUser = "testuser_$timestamp"
$testEmail = "test$timestamp@example.com"

# Structure minimale basée sur les logs
$registerData = @{
    username = $testUser
    email = $testEmail
    password = "TestPassword123!"
    fullName = "Test User"
    role = "USER"
} | ConvertTo-Json

Write-Host "   Données: $registerData" -ForegroundColor Gray

try {
    $registerResponse = Invoke-RestMethod -Uri "$BackendUrl/api/v1/auth/register" -Method POST -Body $registerData -ContentType "application/json" -TimeoutSec 30 -ErrorAction Stop
    Write-Host "   ✅ Enregistrement réussi!" -ForegroundColor Green
    Write-Host "   Réponse: $($registerResponse | ConvertTo-Json)" -ForegroundColor Gray
} catch {
    Write-Host "   ❌ Échec d'enregistrement: $($_.Exception.Message)" -ForegroundColor Red
    
    if ($_.Exception.Response) {
        Write-Host "   Status Code: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
        
        # Essayer de lire le body de l'erreur
        try {
            $errorStream = $_.Exception.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($errorStream)
            $errorBody = $reader.ReadToEnd()
            Write-Host "   Error Body: $errorBody" -ForegroundColor Red
        } catch {
            Write-Host "   Impossible de lire le body de l'erreur" -ForegroundColor Gray
        }
    }
}

# Test 3: Test de connexion minimal
Write-Host ""
Write-Host "3. Test de connexion minimal..." -ForegroundColor Yellow

$loginData = @{
    email = $testEmail
    password = "TestPassword123!"
} | ConvertTo-Json

Write-Host "   Données: $loginData" -ForegroundColor Gray

try {
    $loginResponse = Invoke-RestMethod -Uri "$BackendUrl/api/v1/auth/login" -Method POST -Body $loginData -ContentType "application/json" -TimeoutSec 30 -ErrorAction Stop
    
    if ($loginResponse.token) {
        Write-Host "   ✅ Connexion réussie!" -ForegroundColor Green
        Write-Host "   Token: $($loginResponse.token.Substring(0, [Math]::Min(50, $loginResponse.token.Length)))..." -ForegroundColor Gray
        
        # Test du profil
        Write-Host ""
        Write-Host "4. Test du profil..." -ForegroundColor Yellow
        
        $authHeaders = @{
            "Authorization" = "Bearer $($loginResponse.token)"
            "Content-Type" = "application/json"
        }
        
        try {
            $profileResponse = Invoke-RestMethod -Uri "$BackendUrl/api/v1/auth/me" -Method GET -Headers $authHeaders -TimeoutSec 30 -ErrorAction Stop
            Write-Host "   ✅ Profil récupéré!" -ForegroundColor Green
            Write-Host "   Username: $($profileResponse.username)" -ForegroundColor Cyan
            Write-Host "   Email: $($profileResponse.email)" -ForegroundColor Cyan
            Write-Host "   Full Name: $($profileResponse.fullName)" -ForegroundColor Cyan
            Write-Host "   Role: $($profileResponse.role)" -ForegroundColor Cyan
        } catch {
            Write-Host "   ❌ Échec de récupération du profil: $($_.Exception.Message)" -ForegroundColor Red
        }
        
        # Test d'accès à l'accueil
        Write-Host ""
        Write-Host "5. Test d'accès à l'accueil..." -ForegroundColor Yellow
        
        try {
            $restaurantsResponse = Invoke-RestMethod -Uri "$BackendUrl/api/v1/restaurants" -Method GET -Headers $authHeaders -TimeoutSec 30 -ErrorAction Stop
            Write-Host "   ✅ Accès aux restaurants réussi!" -ForegroundColor Green
            Write-Host "   Nombre de restaurants: $($restaurantsResponse.Count)" -ForegroundColor Cyan
            
            Write-Host ""
            Write-Host "   🎉 REDIRECTION VERS L'ACCUEIL RÉUSSIE!" -ForegroundColor Green
            Write-Host "   🏠 L'utilisateur est maintenant sur la page d'accueil" -ForegroundColor Cyan
            Write-Host "   📊 Données de l'accueil chargées avec succès" -ForegroundColor Cyan
        } catch {
            Write-Host "   ❌ Échec d'accès aux restaurants: $($_.Exception.Message)" -ForegroundColor Red
        }
        
    } else {
        Write-Host "   ❌ Connexion échouée - Pas de token" -ForegroundColor Red
    }
} catch {
    Write-Host "   ❌ Échec de connexion: $($_.Exception.Message)" -ForegroundColor Red
    
    if ($_.Exception.Response) {
        Write-Host "   Status Code: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
        
        try {
            $errorStream = $_.Exception.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($errorStream)
            $errorBody = $reader.ReadToEnd()
            Write-Host "   Error Body: $errorBody" -ForegroundColor Red
        } catch {
            Write-Host "   Impossible de lire le body de l'erreur" -ForegroundColor Gray
        }
    }
}

Write-Host ""
Write-Host "📊 Résumé du Test Minimal" -ForegroundColor Blue
Write-Host "=========================" -ForegroundColor Blue

Write-Host ""
Write-Host "🔗 URLs testées:" -ForegroundColor Blue
Write-Host "- Register: $BackendUrl/api/v1/auth/register"
Write-Host "- Login: $BackendUrl/api/v1/auth/login"
Write-Host "- Profil: $BackendUrl/api/v1/auth/me"
Write-Host "- Restaurants: $BackendUrl/api/v1/restaurants"

Write-Host ""
Write-Host "💡 Structure des données:" -ForegroundColor Cyan
Write-Host "📝 Register: {username, email, password, fullName, role}" -ForegroundColor White
Write-Host "🔐 Login: {email, password}" -ForegroundColor White

Write-Host ""
Write-Host "🎯 Test minimal terminé!" -ForegroundColor Green
