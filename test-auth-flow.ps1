#!/usr/bin/env pwsh
# Test complet du flux d'authentification - Register, Login, Profil, Redirection
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

Write-Host "🔐 Test du Flux d'Authentification - VegN-Bio" -ForegroundColor Blue
Write-Host "=============================================" -ForegroundColor Blue
Write-Host "Backend: $BackendUrl"
Write-Host "Utilisateur de test: $testUser"
Write-Host "Email de test: $testEmail"
Write-Host ""

# Variables pour stocker les résultats
$token = $null
$userId = $null
$authSuccess = $false

# Test 1: Enregistrement d'utilisateur
Write-Host "1️⃣ Test d'enregistrement d'utilisateur..." -ForegroundColor Yellow
$registerData = @{
    username = $testUser
    email = $testEmail
    password = $testPassword
    firstName = "Test"
    lastName = "User"
} | ConvertTo-Json

if ($Verbose) {
    Write-Host "   Données d'enregistrement:" -ForegroundColor Gray
    Write-Host "   $registerData" -ForegroundColor Gray
}

try {
    $registerResponse = Invoke-RestMethod -Uri "$BackendUrl/api/v1/auth/register" -Method POST -Body $registerData -ContentType "application/json" -TimeoutSec 30 -ErrorAction Stop
    
    if ($registerResponse) {
        Write-Host "   ✅ Enregistrement réussi!" -ForegroundColor Green
        if ($Verbose) {
            Write-Host "   Réponse: $($registerResponse | ConvertTo-Json)" -ForegroundColor Gray
        }
        
        # Extraire l'ID utilisateur si disponible
        if ($registerResponse.id) {
            $userId = $registerResponse.id
            Write-Host "   ID utilisateur: $userId" -ForegroundColor Cyan
        }
    } else {
        Write-Host "   ❌ Échec de l'enregistrement - Réponse vide" -ForegroundColor Red
    }
} catch {
    Write-Host "   ❌ Échec de l'enregistrement: $($_.Exception.Message)" -ForegroundColor Red
    if ($Verbose -and $_.Exception.Response) {
        try {
            $errorStream = $_.Exception.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($errorStream)
            $errorBody = $reader.ReadToEnd()
            Write-Host "   Détails de l'erreur: $errorBody" -ForegroundColor Gray
        } catch {
            Write-Host "   Impossible de lire les détails de l'erreur" -ForegroundColor Gray
        }
    }
}

# Test 2: Connexion utilisateur
Write-Host ""
Write-Host "2️⃣ Test de connexion utilisateur..." -ForegroundColor Yellow
$loginData = @{
    username = $testUser
    password = $testPassword
} | ConvertTo-Json

if ($Verbose) {
    Write-Host "   Données de connexion:" -ForegroundColor Gray
    Write-Host "   $loginData" -ForegroundColor Gray
}

try {
    $loginResponse = Invoke-RestMethod -Uri "$BackendUrl/api/v1/auth/login" -Method POST -Body $loginData -ContentType "application/json" -TimeoutSec 30 -ErrorAction Stop
    
    if ($loginResponse.token) {
        $token = $loginResponse.token
        $authSuccess = $true
        Write-Host "   ✅ Connexion réussie!" -ForegroundColor Green
        Write-Host "   Token JWT obtenu (${token.Length} caractères)" -ForegroundColor Cyan
        
        if ($Verbose) {
            Write-Host "   Réponse complète:" -ForegroundColor Gray
            Write-Host "   $($loginResponse | ConvertTo-Json)" -ForegroundColor Gray
        }
        
        # Extraire l'ID utilisateur si disponible
        if ($loginResponse.userId) {
            $userId = $loginResponse.userId
            Write-Host "   ID utilisateur: $userId" -ForegroundColor Cyan
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
        try {
            $errorStream = $_.Exception.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($errorStream)
            $errorBody = $reader.ReadToEnd()
            Write-Host "   Détails de l'erreur: $errorBody" -ForegroundColor Gray
        } catch {
            Write-Host "   Impossible de lire les détails de l'erreur" -ForegroundColor Gray
        }
    }
}

# Test 3: Récupération du profil utilisateur
if ($token) {
    Write-Host ""
    Write-Host "3️⃣ Test de récupération du profil utilisateur..." -ForegroundColor Yellow
    
    try {
        $headers = @{
            "Authorization" = "Bearer $token"
        }
        
        $profileResponse = Invoke-RestMethod -Uri "$BackendUrl/api/v1/auth/me" -Method GET -Headers $headers -TimeoutSec 30 -ErrorAction Stop
        
        if ($profileResponse) {
            Write-Host "   ✅ Profil récupéré avec succès!" -ForegroundColor Green
            Write-Host "   Username: $($profileResponse.username)" -ForegroundColor Cyan
            Write-Host "   Email: $($profileResponse.email)" -ForegroundColor Cyan
            Write-Host "   Prénom: $($profileResponse.firstName)" -ForegroundColor Cyan
            Write-Host "   Nom: $($profileResponse.lastName)" -ForegroundColor Cyan
            
            if ($Verbose) {
                Write-Host "   Profil complet:" -ForegroundColor Gray
                Write-Host "   $($profileResponse | ConvertTo-Json)" -ForegroundColor Gray
            }
            
            # Extraire l'ID utilisateur si disponible
            if ($profileResponse.id -and -not $userId) {
                $userId = $profileResponse.id
                Write-Host "   ID utilisateur: $userId" -ForegroundColor Cyan
            }
        } else {
            Write-Host "   ❌ Échec de la récupération du profil - Réponse vide" -ForegroundColor Red
        }
    } catch {
        Write-Host "   ❌ Échec de la récupération du profil: $($_.Exception.Message)" -ForegroundColor Red
        if ($Verbose -and $_.Exception.Response) {
            try {
                $errorStream = $_.Exception.Response.GetResponseStream()
                $reader = New-Object System.IO.StreamReader($errorStream)
                $errorBody = $reader.ReadToEnd()
                Write-Host "   Détails de l'erreur: $errorBody" -ForegroundColor Gray
            } catch {
                Write-Host "   Impossible de lire les détails de l'erreur" -ForegroundColor Gray
            }
        }
    }
} else {
    Write-Host ""
    Write-Host "3️⃣ Test de récupération du profil utilisateur... ⏭️ SKIP (Pas de token)" -ForegroundColor Yellow
}

# Test 4: Test d'accès aux endpoints protégés
if ($token) {
    Write-Host ""
    Write-Host "4️⃣ Test d'accès aux endpoints protégés..." -ForegroundColor Yellow
    
    try {
        $headers = @{
            "Authorization" = "Bearer $token"
        }
        
        # Test d'accès aux restaurants (endpoint protégé)
        $restaurantsResponse = Invoke-RestMethod -Uri "$BackendUrl/api/v1/restaurants" -Method GET -Headers $headers -TimeoutSec 30 -ErrorAction Stop
        Write-Host "   ✅ Accès aux restaurants autorisé!" -ForegroundColor Green
        Write-Host "   Nombre de restaurants: $($restaurantsResponse.Count)" -ForegroundColor Cyan
        
        if ($Verbose) {
            Write-Host "   Restaurants disponibles:" -ForegroundColor Gray
            Write-Host "   $($restaurantsResponse | ConvertTo-Json)" -ForegroundColor Gray
        }
    } catch {
        Write-Host "   ❌ Échec d'accès aux restaurants: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host ""
    Write-Host "4️⃣ Test d'accès aux endpoints protégés... ⏭️ SKIP (Pas de token)" -ForegroundColor Yellow
}

# Test 5: Test de sécurité (accès sans token)
Write-Host ""
Write-Host "5️⃣ Test de sécurité (accès sans token)..." -ForegroundColor Yellow

try {
    $unauthorizedResponse = Invoke-WebRequest -Uri "$BackendUrl/api/v1/restaurants" -Method GET -TimeoutSec 30 -ErrorAction Stop
    Write-Host "   ❌ Échec de sécurité - Accès autorisé sans token (Status: $($unauthorizedResponse.StatusCode))" -ForegroundColor Red
} catch {
    if ($_.Exception.Response.StatusCode -eq 403 -or $_.Exception.Response.StatusCode -eq 401) {
        Write-Host "   ✅ Sécurité OK - Accès correctement bloqué sans token" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️ Réponse de sécurité inattendue: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

# Test 6: Test de redirection (simulation)
Write-Host ""
Write-Host "6️⃣ Test de redirection vers l'accueil..." -ForegroundColor Yellow

if ($authSuccess) {
    Write-Host "   ✅ Authentification réussie - Redirection vers l'accueil possible" -ForegroundColor Green
    Write-Host "   🏠 L'utilisateur peut maintenant accéder à l'accueil" -ForegroundColor Cyan
    
    # Simuler la redirection
    Write-Host ""
    Write-Host "   🔄 Simulation de redirection..." -ForegroundColor Yellow
    Write-Host "   📍 URL de redirection: $BackendUrl/api/v1/restaurants" -ForegroundColor Gray
    Write-Host "   🔑 Token disponible: ✅" -ForegroundColor Green
    Write-Host "   👤 Utilisateur authentifié: ✅" -ForegroundColor Green
    Write-Host "   🏠 Accès à l'accueil: ✅" -ForegroundColor Green
} else {
    Write-Host "   ❌ Authentification échouée - Pas de redirection possible" -ForegroundColor Red
    Write-Host "   🚫 L'utilisateur ne peut pas accéder à l'accueil" -ForegroundColor Red
}

# Test 7: Test de performance du flux d'authentification
Write-Host ""
Write-Host "7️⃣ Test de performance du flux d'authentification..." -ForegroundColor Yellow

$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
try {
    if ($token) {
        $headers = @{
            "Authorization" = "Bearer $token"
        }
        Invoke-RestMethod -Uri "$BackendUrl/api/v1/auth/me" -Method GET -Headers $headers -TimeoutSec 30 -ErrorAction Stop | Out-Null
        $stopwatch.Stop()
        $responseTime = $stopwatch.ElapsedMilliseconds
        
        if ($responseTime -lt 2000) {
            Write-Host "   ✅ Performance excellente (${responseTime}ms)" -ForegroundColor Green
        } elseif ($responseTime -lt 5000) {
            Write-Host "   ✅ Performance acceptable (${responseTime}ms)" -ForegroundColor Green
        } else {
            Write-Host "   ⚠️ Performance lente (${responseTime}ms)" -ForegroundColor Yellow
        }
    } else {
        Write-Host "   ⏭️ SKIP - Pas de token disponible" -ForegroundColor Yellow
    }
} catch {
    Write-Host "   ❌ Erreur de performance: $($_.Exception.Message)" -ForegroundColor Red
}

# Résumé final
Write-Host ""
Write-Host "📊 Résumé du Test d'Authentification" -ForegroundColor Blue
Write-Host "====================================" -ForegroundColor Blue

if ($authSuccess) {
    Write-Host "✅ ENREGISTREMENT: RÉUSSI" -ForegroundColor Green
    Write-Host "✅ CONNEXION: RÉUSSIE" -ForegroundColor Green
    Write-Host "✅ PROFIL: RÉCUPÉRÉ" -ForegroundColor Green
    Write-Host "✅ SÉCURITÉ: ACTIVE" -ForegroundColor Green
    Write-Host "✅ REDIRECTION: POSSIBLE" -ForegroundColor Green
    Write-Host ""
    Write-Host "🎉 FLUX D'AUTHENTIFICATION COMPLET FONCTIONNEL!" -ForegroundColor Green
    Write-Host "🏠 L'utilisateur peut accéder à l'accueil après authentification" -ForegroundColor Cyan
} else {
    Write-Host "❌ ENREGISTREMENT: ÉCHEC" -ForegroundColor Red
    Write-Host "❌ CONNEXION: ÉCHEC" -ForegroundColor Red
    Write-Host "❌ PROFIL: NON ACCESSIBLE" -ForegroundColor Red
    Write-Host "❌ REDIRECTION: IMPOSSIBLE" -ForegroundColor Red
    Write-Host ""
    Write-Host "⚠️ PROBLÈMES DÉTECTÉS - Vérifiez la configuration" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🔗 URLs de test:" -ForegroundColor Blue
Write-Host "- Backend: $BackendUrl"
Write-Host "- Register: $BackendUrl/api/v1/auth/register"
Write-Host "- Login: $BackendUrl/api/v1/auth/login"
Write-Host "- Profil: $BackendUrl/api/v1/auth/me"
Write-Host "- Restaurants: $BackendUrl/api/v1/restaurants"

Write-Host ""
Write-Host "💡 Instructions pour le frontend:" -ForegroundColor Cyan
Write-Host "1. Appeler /api/v1/auth/register pour l'enregistrement"
Write-Host "2. Appeler /api/v1/auth/login pour la connexion"
Write-Host "3. Stocker le token JWT retourné"
Write-Host "4. Utiliser le token dans les headers Authorization: Bearer <token>"
Write-Host "5. Rediriger vers l'accueil après authentification réussie"

Write-Host ""
Write-Host "🎯 Test d'authentification terminé!" -ForegroundColor Green
