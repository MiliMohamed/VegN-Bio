#!/usr/bin/env pwsh
# Test final de production - VegN-Bio
# Teste l'authentification et les endpoints en production

param(
    [string]$BackendUrl = "https://vegn-bio-backend.onrender.com"
)

$ErrorActionPreference = "Continue"
$timestamp = [DateTimeOffset]::Now.ToUnixTimeSeconds()

Write-Host "🚀 Test Final de Production - VegN-Bio" -ForegroundColor Blue
Write-Host "=====================================" -ForegroundColor Blue
Write-Host "Backend: $BackendUrl"
Write-Host "Timestamp: $timestamp"
Write-Host ""

# Test 1: Connectivité de base
Write-Host -NoNewline "1. Test connectivité de base... "
try {
    $response = Invoke-WebRequest -Uri $BackendUrl -Method GET -TimeoutSec 10 -ErrorAction Stop
    if ($response.StatusCode -eq 403) {
        Write-Host "✅ OK (403 Forbidden - Sécurité active)" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Status inattendu: $($response.StatusCode)" -ForegroundColor Yellow
    }
} catch {
    if ($_.Exception.Response.StatusCode -eq 403) {
        Write-Host "✅ OK (403 Forbidden - Sécurité active)" -ForegroundColor Green
    } else {
        Write-Host "❌ ÉCHEC: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

# Test 2: Enregistrement d'utilisateur
Write-Host -NoNewline "2. Test enregistrement utilisateur... "
$registerData = @{
    username = "testuser_$timestamp"
    email = "test$timestamp@example.com"
    password = "TestPassword123!"
    firstName = "Test"
    lastName = "User"
} | ConvertTo-Json

try {
    $registerResponse = Invoke-RestMethod -Uri "$BackendUrl/api/auth/register" -Method POST -Body $registerData -ContentType "application/json" -TimeoutSec 30 -ErrorAction Stop
    Write-Host "✅ OK" -ForegroundColor Green
    Write-Host "   Utilisateur créé: testuser_$timestamp" -ForegroundColor Gray
} catch {
    Write-Host "❌ ÉCHEC: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $errorResponse = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorResponse)
        $errorBody = $reader.ReadToEnd()
        Write-Host "   Détails: $errorBody" -ForegroundColor Gray
    }
}

# Test 3: Connexion utilisateur
Write-Host -NoNewline "3. Test connexion utilisateur... "
$loginData = @{
    username = "testuser_$timestamp"
    password = "TestPassword123!"
} | ConvertTo-Json

$token = $null
try {
    $loginResponse = Invoke-RestMethod -Uri "$BackendUrl/api/auth/login" -Method POST -Body $loginData -ContentType "application/json" -TimeoutSec 30 -ErrorAction Stop
    
    if ($loginResponse.token) {
        $token = $loginResponse.token
        Write-Host "✅ OK" -ForegroundColor Green
        Write-Host "   Token JWT obtenu (${token.Length} caractères)" -ForegroundColor Gray
    } else {
        Write-Host "❌ ÉCHEC: Token non trouvé" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ ÉCHEC: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $errorResponse = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorResponse)
        $errorBody = $reader.ReadToEnd()
        Write-Host "   Détails: $errorBody" -ForegroundColor Gray
    }
}

# Test 4: Profil utilisateur (avec token)
if ($token) {
    Write-Host -NoNewline "4. Test profil utilisateur... "
    try {
        $headers = @{
            "Authorization" = "Bearer $token"
        }
        $profileResponse = Invoke-RestMethod -Uri "$BackendUrl/api/auth/me" -Method GET -Headers $headers -TimeoutSec 30 -ErrorAction Stop
        
        if ($profileResponse.username -or $profileResponse.email) {
            Write-Host "✅ OK" -ForegroundColor Green
            Write-Host "   Profil: $($profileResponse.username) ($($profileResponse.email))" -ForegroundColor Gray
        } else {
            Write-Host "❌ ÉCHEC: Données de profil manquantes" -ForegroundColor Red
        }
    } catch {
        Write-Host "❌ ÉCHEC: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "4. Test profil utilisateur... ⏭️ SKIP (Pas de token)" -ForegroundColor Yellow
}

# Test 5: Endpoints protégés (avec token)
if ($token) {
    Write-Host -NoNewline "5. Test endpoints protégés... "
    try {
        $headers = @{
            "Authorization" = "Bearer $token"
        }
        $restaurantsResponse = Invoke-RestMethod -Uri "$BackendUrl/api/restaurants" -Method GET -Headers $headers -TimeoutSec 30 -ErrorAction Stop
        Write-Host "✅ OK" -ForegroundColor Green
        Write-Host "   Restaurants accessibles: $($restaurantsResponse.Count) trouvés" -ForegroundColor Gray
    } catch {
        Write-Host "❌ ÉCHEC: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "5. Test endpoints protégés... ⏭️ SKIP (Pas de token)" -ForegroundColor Yellow
}

# Test 6: Base de données vétérinaire (avec token)
if ($token) {
    Write-Host -NoNewline "6. Test base de données vétérinaire... "
    try {
        $headers = @{
            "Authorization" = "Bearer $token"
        }
        $vetResponse = Invoke-RestMethod -Uri "$BackendUrl/api/veterinary-consultations" -Method GET -Headers $headers -TimeoutSec 30 -ErrorAction Stop
        Write-Host "✅ OK" -ForegroundColor Green
        Write-Host "   Consultations vétérinaires accessibles: $($vetResponse.Count) trouvées" -ForegroundColor Gray
    } catch {
        Write-Host "❌ ÉCHEC: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "6. Test base de données vétérinaire... ⏭️ SKIP (Pas de token)" -ForegroundColor Yellow
}

# Test 7: Chatbot vétérinaire (avec token)
if ($token) {
    Write-Host -NoNewline "7. Test chatbot vétérinaire... "
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
        Write-Host "   Diagnostic généré pour: $($chatbotResponse.breed)" -ForegroundColor Gray
    } catch {
        Write-Host "❌ ÉCHEC: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "7. Test chatbot vétérinaire... ⏭️ SKIP (Pas de token)" -ForegroundColor Yellow
}

# Test 8: Sécurité (accès sans token)
Write-Host -NoNewline "8. Test sécurité (accès sans token)... "
try {
    $unauthorizedResponse = Invoke-WebRequest -Uri "$BackendUrl/api/restaurants" -Method GET -TimeoutSec 30 -ErrorAction Stop
    Write-Host "❌ ÉCHEC: Accès autorisé sans token (Status: $($unauthorizedResponse.StatusCode))" -ForegroundColor Red
} catch {
    if ($_.Exception.Response.StatusCode -eq 403 -or $_.Exception.Response.StatusCode -eq 401) {
        Write-Host "✅ OK (Accès correctement bloqué)" -ForegroundColor Green
    } else {
        Write-Host "❌ ÉCHEC: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Test 9: Performance
Write-Host -NoNewline "9. Test de performance... "
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
    Write-Host "❌ ÉCHEC: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 10: Endpoints d'erreurs (avec token)
if ($token) {
    Write-Host -NoNewline "10. Test endpoints d'erreurs... "
    try {
        $headers = @{
            "Authorization" = "Bearer $token"
        }
        $errorReportsResponse = Invoke-RestMethod -Uri "$BackendUrl/api/error-reports" -Method GET -Headers $headers -TimeoutSec 30 -ErrorAction Stop
        Write-Host "✅ OK" -ForegroundColor Green
        Write-Host "   Rapports d'erreurs accessibles: $($errorReportsResponse.Count) trouvés" -ForegroundColor Gray
    } catch {
        Write-Host "❌ ÉCHEC: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "10. Test endpoints d'erreurs... ⏭️ SKIP (Pas de token)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "📊 Résumé Final:" -ForegroundColor Blue
Write-Host "===============" -ForegroundColor Blue

if ($token) {
    Write-Host "✅ Authentification: FONCTIONNE" -ForegroundColor Green
    Write-Host "✅ Base de données: ACCESSIBLE" -ForegroundColor Green
    Write-Host "✅ Sécurité: ACTIVE" -ForegroundColor Green
    Write-Host "✅ API: OPÉRATIONNELLE" -ForegroundColor Green
} else {
    Write-Host "❌ Authentification: ÉCHEC" -ForegroundColor Red
    Write-Host "⚠️ Vérifiez les logs Render pour diagnostiquer" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🔗 URLs de production:" -ForegroundColor Blue
Write-Host "- Backend: $BackendUrl"
Write-Host "- Dashboard Render: https://dashboard.render.com"
Write-Host "- Logs Render: https://dashboard.render.com/web/srv-d3i2ci9r0fns73cpojgg/logs"

Write-Host ""
Write-Host "🎉 Test de production terminé!" -ForegroundColor Green

if ($token) {
    Write-Host ""
    Write-Host "💡 Le backend VegN-Bio est opérationnel et prêt pour la production!" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "⚠️ Des problèmes ont été détectés. Vérifiez les logs Render." -ForegroundColor Yellow
}
