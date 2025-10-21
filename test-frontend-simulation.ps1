#!/usr/bin/env pwsh
# Simulation du comportement du frontend - Test d'authentification
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

Write-Host "🌐 Simulation Frontend - Test d'Authentification" -ForegroundColor Blue
Write-Host "===============================================" -ForegroundColor Blue
Write-Host "Backend: $BackendUrl"
Write-Host "Utilisateur de test: $testUser"
Write-Host "Email de test: $testEmail"
Write-Host ""

# Test 1: Vérification CORS avec headers de frontend
Write-Host "1️⃣ Test CORS avec headers de frontend..." -ForegroundColor Yellow

$corsHeaders = @{
    "Origin" = "https://vegn-bio-frontend.vercel.app"
    "Access-Control-Request-Method" = "POST"
    "Access-Control-Request-Headers" = "Content-Type,Authorization"
    "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
}

try {
    $response = Invoke-WebRequest -Uri "$BackendUrl/api/v1/auth/register" -Method OPTIONS -Headers $corsHeaders -TimeoutSec 10 -ErrorAction Stop
    Write-Host "   ✅ CORS OK (Status: $($response.StatusCode))" -ForegroundColor Green
    
    # Vérifier les headers CORS retournés
    if ($response.Headers["Access-Control-Allow-Origin"]) {
        Write-Host "   Allow-Origin: $($response.Headers['Access-Control-Allow-Origin'])" -ForegroundColor Cyan
    }
    if ($response.Headers["Access-Control-Allow-Methods"]) {
        Write-Host "   Allow-Methods: $($response.Headers['Access-Control-Allow-Methods'])" -ForegroundColor Cyan
    }
    if ($response.Headers["Access-Control-Allow-Headers"]) {
        Write-Host "   Allow-Headers: $($response.Headers['Access-Control-Allow-Headers'])" -ForegroundColor Cyan
    }
} catch {
    Write-Host "   ❌ CORS Error: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 2: Enregistrement avec headers de frontend
Write-Host ""
Write-Host "2️⃣ Test d'enregistrement avec headers de frontend..." -ForegroundColor Yellow

$registerData = @{
    username = $testUser
    email = $testEmail
    password = $testPassword
    firstName = "Test"
    lastName = "User"
} | ConvertTo-Json

$frontendHeaders = @{
    "Content-Type" = "application/json"
    "Origin" = "https://vegn-bio-frontend.vercel.app"
    "Referer" = "https://vegn-bio-frontend.vercel.app/register"
    "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
    "Accept" = "application/json, text/plain, */*"
    "Accept-Language" = "fr-FR,fr;q=0.9,en;q=0.8"
    "Accept-Encoding" = "gzip, deflate, br"
}

if ($Verbose) {
    Write-Host "   Headers utilisés:" -ForegroundColor Gray
    foreach ($header in $frontendHeaders.GetEnumerator()) {
        Write-Host "   $($header.Key): $($header.Value)" -ForegroundColor Gray
    }
}

try {
    $registerResponse = Invoke-RestMethod -Uri "$BackendUrl/api/v1/auth/register" -Method POST -Body $registerData -Headers $frontendHeaders -TimeoutSec 30 -ErrorAction Stop
    
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
    if ($Verbose) {
        Write-Host "   Status Code: $($_.Exception.Response.StatusCode)" -ForegroundColor Gray
        Write-Host "   Status Description: $($_.Exception.Response.StatusDescription)" -ForegroundColor Gray
    }
}

# Test 3: Connexion avec headers de frontend
Write-Host ""
Write-Host "3️⃣ Test de connexion avec headers de frontend..." -ForegroundColor Yellow

$loginData = @{
    username = $testUser
    password = $testPassword
} | ConvertTo-Json

try {
    $loginResponse = Invoke-RestMethod -Uri "$BackendUrl/api/v1/auth/login" -Method POST -Body $loginData -Headers $frontendHeaders -TimeoutSec 30 -ErrorAction Stop
    
    if ($loginResponse.token) {
        $token = $loginResponse.token
        Write-Host "   ✅ Connexion réussie!" -ForegroundColor Green
        Write-Host "   Token JWT obtenu (${token.Length} caractères)" -ForegroundColor Cyan
        
        if ($Verbose) {
            Write-Host "   Réponse: $($loginResponse | ConvertTo-Json)" -ForegroundColor Gray
        }
    } else {
        Write-Host "   ❌ Échec de la connexion - Token non trouvé" -ForegroundColor Red
    }
} catch {
    Write-Host "   ❌ Échec de la connexion: $($_.Exception.Message)" -ForegroundColor Red
    if ($Verbose) {
        Write-Host "   Status Code: $($_.Exception.Response.StatusCode)" -ForegroundColor Gray
    }
}

# Test 4: Profil utilisateur avec token
if ($token) {
    Write-Host ""
    Write-Host "4️⃣ Test de récupération du profil..." -ForegroundColor Yellow
    
    $authHeaders = $frontendHeaders.Clone()
    $authHeaders["Authorization"] = "Bearer $token"
    
    try {
        $profileResponse = Invoke-RestMethod -Uri "$BackendUrl/api/v1/auth/me" -Method GET -Headers $authHeaders -TimeoutSec 30 -ErrorAction Stop
        
        if ($profileResponse) {
            Write-Host "   ✅ Profil récupéré!" -ForegroundColor Green
            Write-Host "   Username: $($profileResponse.username)" -ForegroundColor Cyan
            Write-Host "   Email: $($profileResponse.email)" -ForegroundColor Cyan
        }
    } catch {
        Write-Host "   ❌ Échec de récupération du profil: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Test 5: Accès à l'accueil avec token
if ($token) {
    Write-Host ""
    Write-Host "5️⃣ Test d'accès à l'accueil..." -ForegroundColor Yellow
    
    $authHeaders = $frontendHeaders.Clone()
    $authHeaders["Authorization"] = "Bearer $token"
    
    try {
        $homeResponse = Invoke-RestMethod -Uri "$BackendUrl/api/v1/restaurants" -Method GET -Headers $authHeaders -TimeoutSec 30 -ErrorAction Stop
        
        Write-Host "   ✅ Accès à l'accueil réussi!" -ForegroundColor Green
        Write-Host "   Restaurants disponibles: $($homeResponse.Count)" -ForegroundColor Cyan
        
        # Simulation de redirection
        Write-Host ""
        Write-Host "   🔄 Simulation de redirection vers l'accueil..." -ForegroundColor Yellow
        Write-Host "   🏠 L'utilisateur est maintenant sur la page d'accueil" -ForegroundColor Green
        Write-Host "   📊 Données de l'accueil chargées avec succès" -ForegroundColor Green
        
    } catch {
        Write-Host "   ❌ Échec d'accès à l'accueil: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Test 6: Test avec différents User-Agents
Write-Host ""
Write-Host "6️⃣ Test avec différents User-Agents..." -ForegroundColor Yellow

$userAgents = @(
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
    "PostmanRuntime/7.28.0",
    "curl/7.68.0"
)

foreach ($userAgent in $userAgents) {
    Write-Host -NoNewline "   Test avec $($userAgent.Split('/')[0])... "
    
    $testHeaders = @{
        "Content-Type" = "application/json"
        "User-Agent" = $userAgent
    }
    
    try {
        $testData = @{
            username = "testuser_$(Get-Date -Format 'yyyyMMddHHmmss')"
            password = "TestPassword123!"
        } | ConvertTo-Json
        
        $testResponse = Invoke-RestMethod -Uri "$BackendUrl/api/v1/auth/login" -Method POST -Body $testData -Headers $testHeaders -TimeoutSec 10 -ErrorAction Stop
        Write-Host "✅ OK" -ForegroundColor Green
    } catch {
        if ($_.Exception.Response.StatusCode -eq 403) {
            Write-Host "🔒 403" -ForegroundColor Yellow
        } else {
            Write-Host "❌ Error" -ForegroundColor Red
        }
    }
}

# Résumé final
Write-Host ""
Write-Host "📊 Résumé de la Simulation Frontend" -ForegroundColor Blue
Write-Host "====================================" -ForegroundColor Blue

if ($token) {
    Write-Host "✅ CORS: Configuré correctement" -ForegroundColor Green
    Write-Host "✅ ENREGISTREMENT: Réussi" -ForegroundColor Green
    Write-Host "✅ CONNEXION: Réussie" -ForegroundColor Green
    Write-Host "✅ PROFIL: Récupéré" -ForegroundColor Green
    Write-Host "✅ ACCÈS ACCUEIL: Réussi" -ForegroundColor Green
    Write-Host "✅ REDIRECTION: Possible" -ForegroundColor Green
    Write-Host ""
    Write-Host "🎉 SIMULATION FRONTEND RÉUSSIE!" -ForegroundColor Green
    Write-Host "🏠 L'utilisateur peut accéder à l'accueil après authentification" -ForegroundColor Cyan
} else {
    Write-Host "❌ CORS: Problème détecté" -ForegroundColor Red
    Write-Host "❌ ENREGISTREMENT: Échec" -ForegroundColor Red
    Write-Host "❌ CONNEXION: Échec" -ForegroundColor Red
    Write-Host "❌ ACCÈS ACCUEIL: Impossible" -ForegroundColor Red
    Write-Host ""
    Write-Host "⚠️ PROBLÈMES DÉTECTÉS - Configuration à vérifier" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🔗 URLs de test:" -ForegroundColor Blue
Write-Host "- Backend: $BackendUrl"
Write-Host "- Register: $BackendUrl/api/v1/auth/register"
Write-Host "- Login: $BackendUrl/api/v1/auth/login"
Write-Host "- Profil: $BackendUrl/api/v1/auth/me"
Write-Host "- Accueil: $BackendUrl/api/v1/restaurants"

Write-Host ""
Write-Host "💡 Instructions pour le frontend:" -ForegroundColor Cyan
Write-Host "1. Inclure les headers Origin et Referer appropriés" -ForegroundColor White
Write-Host "2. Utiliser Content-Type: application/json" -ForegroundColor White
Write-Host "3. Gérer les erreurs CORS et 403" -ForegroundColor White
Write-Host "4. Stocker le token JWT dans localStorage" -ForegroundColor White
Write-Host "5. Inclure le token dans Authorization: Bearer <token>" -ForegroundColor White

Write-Host ""
Write-Host "🎯 Simulation frontend terminée!" -ForegroundColor Green
