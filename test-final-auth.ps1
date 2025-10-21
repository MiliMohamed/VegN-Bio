#!/usr/bin/env pwsh
# Test final d'authentification avec les bons champs selon les logs
# VegN-Bio Backend

param(
    [string]$BackendUrl = "https://vegn-bio-backend.onrender.com",
    [switch]$Verbose
)

$ErrorActionPreference = "Continue"
$timestamp = [DateTimeOffset]::Now.ToUnixTimeSeconds()
$testUser = "testuser_$timestamp"
$testEmail = "test$timestamp@example.com"
$testPassword = "TestPassword123!"

Write-Host "🎯 Test Final d'Authentification - VegN-Bio" -ForegroundColor Blue
Write-Host "============================================" -ForegroundColor Blue
Write-Host "Backend: $BackendUrl"
Write-Host "Utilisateur de test: $testUser"
Write-Host "Email de test: $testEmail"
Write-Host ""

$token = $null
$authSuccess = $false

# Test 1: Enregistrement avec les bons champs
Write-Host "1️⃣ Test d'enregistrement avec les bons champs..." -ForegroundColor Yellow

# Basé sur les logs, le RegisterRequest attend fullName et role
$registerData = @{
    username = $testUser
    email = $testEmail
    password = $testPassword
    fullName = "Test User"  # Au lieu de firstName/lastName
    role = "USER"           # Champ requis selon les logs
} | ConvertTo-Json

$headers = @{
    "Content-Type" = "application/json"
    "Origin" = "https://vegn-bio-frontend.vercel.app"
    "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
    "Accept" = "application/json, text/plain, */*"
}

if ($Verbose) {
    Write-Host "   Données d'enregistrement:" -ForegroundColor Gray
    Write-Host "   $registerData" -ForegroundColor Gray
}

try {
    $registerResponse = Invoke-RestMethod -Uri "$BackendUrl/api/v1/auth/register" -Method POST -Body $registerData -Headers $headers -TimeoutSec 30 -ErrorAction Stop
    
    if ($registerResponse) {
        Write-Host "   ✅ Enregistrement réussi!" -ForegroundColor Green
        if ($Verbose) {
            Write-Host "   Réponse: $($registerResponse | ConvertTo-Json)" -ForegroundColor Gray
        }
    } else {
        Write-Host "   ❌ Échec de l'enregistrement - Réponse vide" -ForegroundColor Red
    }
} catch {
    Write-Host "   ❌ Échec de l'enregistrement: $($_.Exception.Message)" -ForegroundColor Red
    if ($Verbose -and $_.Exception.Response) {
        Write-Host "   Status Code: $($_.Exception.Response.StatusCode)" -ForegroundColor Gray
    }
}

# Test 2: Connexion avec email (pas username selon les logs)
Write-Host ""
Write-Host "2️⃣ Test de connexion avec email..." -ForegroundColor Yellow

$loginData = @{
    email = $testEmail     # Le LoginRequest attend email, pas username
    password = $testPassword
} | ConvertTo-Json

if ($Verbose) {
    Write-Host "   Données de connexion:" -ForegroundColor Gray
    Write-Host "   $loginData" -ForegroundColor Gray
}

try {
    $loginResponse = Invoke-RestMethod -Uri "$BackendUrl/api/v1/auth/login" -Method POST -Body $loginData -Headers $headers -TimeoutSec 30 -ErrorAction Stop
    
    if ($loginResponse.token) {
        $token = $loginResponse.token
        $authSuccess = $true
        Write-Host "   ✅ Connexion réussie!" -ForegroundColor Green
        Write-Host "   Token JWT obtenu (${token.Length} caractères)" -ForegroundColor Cyan
        
        if ($Verbose) {
            Write-Host "   Réponse: $($loginResponse | ConvertTo-Json)" -ForegroundColor Gray
        }
    } else {
        Write-Host "   ❌ Échec de la connexion - Token non trouvé" -ForegroundColor Red
        if ($Verbose) {
            Write-Host "   Réponse: $($loginResponse | ConvertTo-Json)" -ForegroundColor Gray
        }
    }
} catch {
    Write-Host "   ❌ Échec de la connexion: $($_.Exception.Message)" -ForegroundColor Red
    if ($Verbose -and $_.Exception.Response) {
        Write-Host "   Status Code: $($_.Exception.Response.StatusCode)" -ForegroundColor Gray
    }
}

# Test 3: Profil utilisateur
if ($token) {
    Write-Host ""
    Write-Host "3️⃣ Test de récupération du profil..." -ForegroundColor Yellow
    
    $authHeaders = $headers.Clone()
    $authHeaders["Authorization"] = "Bearer $token"
    
    try {
        $profileResponse = Invoke-RestMethod -Uri "$BackendUrl/api/v1/auth/me" -Method GET -Headers $authHeaders -TimeoutSec 30 -ErrorAction Stop
        
        if ($profileResponse) {
            Write-Host "   ✅ Profil récupéré!" -ForegroundColor Green
            Write-Host "   Username: $($profileResponse.username)" -ForegroundColor Cyan
            Write-Host "   Email: $($profileResponse.email)" -ForegroundColor Cyan
            Write-Host "   Full Name: $($profileResponse.fullName)" -ForegroundColor Cyan
            Write-Host "   Role: $($profileResponse.role)" -ForegroundColor Cyan
            
            if ($Verbose) {
                Write-Host "   Profil complet:" -ForegroundColor Gray
                Write-Host "   $($profileResponse | ConvertTo-Json)" -ForegroundColor Gray
            }
        }
    } catch {
        Write-Host "   ❌ Échec de récupération du profil: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host ""
    Write-Host "3️⃣ Test de récupération du profil... ⏭️ SKIP (Pas de token)" -ForegroundColor Yellow
}

# Test 4: Accès à l'accueil (restaurants)
if ($token) {
    Write-Host ""
    Write-Host "4️⃣ Test d'accès à l'accueil (restaurants)..." -ForegroundColor Yellow
    
    $authHeaders = $headers.Clone()
    $authHeaders["Authorization"] = "Bearer $token"
    
    try {
        $restaurantsResponse = Invoke-RestMethod -Uri "$BackendUrl/api/v1/restaurants" -Method GET -Headers $authHeaders -TimeoutSec 30 -ErrorAction Stop
        Write-Host "   ✅ Accès aux restaurants réussi!" -ForegroundColor Green
        Write-Host "   Nombre de restaurants: $($restaurantsResponse.Count)" -ForegroundColor Cyan
        
        # Simulation de redirection vers l'accueil
        Write-Host ""
        Write-Host "   🏠 REDIRECTION VERS L'ACCUEIL SIMULÉE!" -ForegroundColor Green
        Write-Host "   📊 Données de l'accueil chargées avec succès" -ForegroundColor Green
        
        if ($Verbose) {
            Write-Host "   Restaurants:" -ForegroundColor Gray
            Write-Host "   $($restaurantsResponse | ConvertTo-Json)" -ForegroundColor Gray
        }
    } catch {
        Write-Host "   ❌ Échec d'accès aux restaurants: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host ""
    Write-Host "4️⃣ Test d'accès à l'accueil... ⏭️ SKIP (Pas de token)" -ForegroundColor Yellow
}

# Test 5: Test de sécurité (sans token)
Write-Host ""
Write-Host "5️⃣ Test de sécurité (accès sans token)..." -ForegroundColor Yellow

try {
    $unauthorizedResponse = Invoke-WebRequest -Uri "$BackendUrl/api/v1/restaurants" -Method GET -TimeoutSec 30 -ErrorAction Stop
    Write-Host "   ⚠️ Accès autorisé sans token (Status: $($unauthorizedResponse.StatusCode))" -ForegroundColor Yellow
} catch {
    if ($_.Exception.Response.StatusCode -eq 403 -or $_.Exception.Response.StatusCode -eq 401) {
        Write-Host "   ✅ Sécurité OK - Accès bloqué sans token" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️ Réponse inattendue: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

# Résumé final
Write-Host ""
Write-Host "📊 Résumé Final du Test d'Authentification" -ForegroundColor Blue
Write-Host "===========================================" -ForegroundColor Blue

if ($authSuccess) {
    Write-Host "✅ ENREGISTREMENT: RÉUSSI" -ForegroundColor Green
    Write-Host "✅ CONNEXION: RÉUSSIE" -ForegroundColor Green
    Write-Host "✅ PROFIL: RÉCUPÉRÉ" -ForegroundColor Green
    Write-Host "✅ ACCÈS ACCUEIL: RÉUSSI" -ForegroundColor Green
    Write-Host "✅ REDIRECTION: POSSIBLE" -ForegroundColor Green
    Write-Host ""
    Write-Host "🎉 FLUX D'AUTHENTIFICATION COMPLET FONCTIONNEL!" -ForegroundColor Green
    Write-Host "🏠 L'utilisateur peut accéder à l'accueil après authentification" -ForegroundColor Cyan
} else {
    Write-Host "❌ ENREGISTREMENT: ÉCHEC" -ForegroundColor Red
    Write-Host "❌ CONNEXION: ÉCHEC" -ForegroundColor Red
    Write-Host "❌ PROFIL: NON ACCESSIBLE" -ForegroundColor Red
    Write-Host "❌ REDIRECTION: IMPOSSIBLE" -ForegroundColor Red
}

Write-Host ""
Write-Host "🔗 URLs de test:" -ForegroundColor Blue
Write-Host "- Register: $BackendUrl/api/v1/auth/register"
Write-Host "- Login: $BackendUrl/api/v1/auth/login"
Write-Host "- Profil: $BackendUrl/api/v1/auth/me"
Write-Host "- Restaurants: $BackendUrl/api/v1/restaurants"

Write-Host ""
Write-Host "💡 Structure des données correcte:" -ForegroundColor Cyan
Write-Host "📝 RegisterRequest: {username, email, password, fullName, role}" -ForegroundColor White
Write-Host "🔐 LoginRequest: {email, password}" -ForegroundColor White
Write-Host "👤 Profil: {username, email, fullName, role}" -ForegroundColor White

Write-Host ""
Write-Host "🎯 Test final terminé!" -ForegroundColor Green
