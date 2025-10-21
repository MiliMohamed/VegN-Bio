#!/usr/bin/env pwsh
# Test simple d'authentification pour diagnostiquer le problème

param(
    [string]$BackendUrl = "https://vegn-bio-backend.onrender.com"
)

$ErrorActionPreference = "Continue"

Write-Host "🔍 Test Simple d'Authentification" -ForegroundColor Blue
Write-Host "================================" -ForegroundColor Blue
Write-Host "Backend: $BackendUrl"
Write-Host ""

# Test 1: Vérifier la connectivité de base
Write-Host "1. Test de connectivité..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri $BackendUrl -Method GET -TimeoutSec 10 -ErrorAction Stop
    Write-Host "   ✅ Backend accessible (Status: $($response.StatusCode))" -ForegroundColor Green
} catch {
    if ($_.Exception.Response.StatusCode -eq 403) {
        Write-Host "   ✅ Backend accessible (403 - Sécurité active)" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Backend inaccessible: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

# Test 2: Test d'enregistrement avec curl (si disponible)
Write-Host ""
Write-Host "2. Test d'enregistrement avec curl..." -ForegroundColor Yellow
$timestamp = [DateTimeOffset]::Now.ToUnixTimeSeconds()
$testUser = "testuser_$timestamp"
$testEmail = "test$timestamp@example.com"

$curlCommand = @"
curl -X POST "$BackendUrl/api/v1/auth/register" \
  -H "Content-Type: application/json" \
  -H "Origin: https://vegn-bio-frontend.vercel.app" \
  -d '{
    "username": "$testUser",
    "email": "$testEmail",
    "password": "TestPassword123!",
    "firstName": "Test",
    "lastName": "User"
  }' \
  -v
"@

Write-Host "   Commande curl:" -ForegroundColor Gray
Write-Host "   $curlCommand" -ForegroundColor Gray

try {
    $curlResult = curl -X POST "$BackendUrl/api/v1/auth/register" -H "Content-Type: application/json" -H "Origin: https://vegn-bio-frontend.vercel.app" -d "{\`"username\`": \`"$testUser\`", \`"email\`": \`"$testEmail\`", \`"password\`": \`"TestPassword123!\`", \`"firstName\`": \`"Test\`", \`"lastName\`": \`"User\`"}" -v 2>&1
    
    Write-Host "   Résultat curl:" -ForegroundColor Gray
    Write-Host "   $curlResult" -ForegroundColor Gray
    
    if ($curlResult -match "HTTP/2 200" -or $curlResult -match "HTTP/1.1 200" -or $curlResult -match "HTTP/2 201" -or $curlResult -match "HTTP/1.1 201") {
        Write-Host "   ✅ Enregistrement réussi avec curl!" -ForegroundColor Green
    } elseif ($curlResult -match "HTTP/2 403" -or $curlResult -match "HTTP/1.1 403") {
        Write-Host "   ❌ Enregistrement échoué - 403 Forbidden" -ForegroundColor Red
    } else {
        Write-Host "   ⚠️ Réponse inattendue" -ForegroundColor Yellow
    }
} catch {
    Write-Host "   ❌ Erreur curl: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: Test avec PowerShell et headers détaillés
Write-Host ""
Write-Host "3. Test avec PowerShell détaillé..." -ForegroundColor Yellow

$registerData = @{
    username = $testUser
    email = $testEmail
    password = "TestPassword123!"
    firstName = "Test"
    lastName = "User"
} | ConvertTo-Json

$headers = @{
    "Content-Type" = "application/json"
    "Origin" = "https://vegn-bio-frontend.vercel.app"
    "Referer" = "https://vegn-bio-frontend.vercel.app/register"
    "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
    "Accept" = "application/json, text/plain, */*"
    "Accept-Language" = "fr-FR,fr;q=0.9,en;q=0.8"
}

try {
    Write-Host "   Tentative d'enregistrement..." -ForegroundColor Gray
    $response = Invoke-RestMethod -Uri "$BackendUrl/api/v1/auth/register" -Method POST -Body $registerData -Headers $headers -TimeoutSec 30 -ErrorAction Stop
    Write-Host "   ✅ Enregistrement réussi!" -ForegroundColor Green
    Write-Host "   Réponse: $($response | ConvertTo-Json)" -ForegroundColor Gray
} catch {
    Write-Host "   ❌ Échec de l'enregistrement" -ForegroundColor Red
    Write-Host "   Erreur: $($_.Exception.Message)" -ForegroundColor Red
    
    if ($_.Exception.Response) {
        Write-Host "   Status Code: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
        Write-Host "   Status Description: $($_.Exception.Response.StatusDescription)" -ForegroundColor Red
        
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

# Test 4: Test de connexion
Write-Host ""
Write-Host "4. Test de connexion..." -ForegroundColor Yellow

$loginData = @{
    username = $testUser
    password = "TestPassword123!"
} | ConvertTo-Json

try {
    $loginResponse = Invoke-RestMethod -Uri "$BackendUrl/api/v1/auth/login" -Method POST -Body $loginData -Headers $headers -TimeoutSec 30 -ErrorAction Stop
    
    if ($loginResponse.token) {
        Write-Host "   ✅ Connexion réussie!" -ForegroundColor Green
        Write-Host "   Token: $($loginResponse.token.Substring(0, [Math]::Min(50, $loginResponse.token.Length)))..." -ForegroundColor Gray
        
        # Test du profil
        Write-Host ""
        Write-Host "5. Test du profil utilisateur..." -ForegroundColor Yellow
        
        $authHeaders = $headers.Clone()
        $authHeaders["Authorization"] = "Bearer $($loginResponse.token)"
        
        try {
            $profileResponse = Invoke-RestMethod -Uri "$BackendUrl/api/v1/auth/me" -Method GET -Headers $authHeaders -TimeoutSec 30 -ErrorAction Stop
            Write-Host "   ✅ Profil récupéré!" -ForegroundColor Green
            Write-Host "   Username: $($profileResponse.username)" -ForegroundColor Cyan
            Write-Host "   Email: $($profileResponse.email)" -ForegroundColor Cyan
        } catch {
            Write-Host "   ❌ Échec de récupération du profil: $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        Write-Host "   ❌ Connexion échouée - Pas de token" -ForegroundColor Red
    }
} catch {
    Write-Host "   ❌ Échec de connexion: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        Write-Host "   Status Code: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "📊 Résumé du Test Simple" -ForegroundColor Blue
Write-Host "========================" -ForegroundColor Blue

Write-Host ""
Write-Host "🔗 URLs testées:" -ForegroundColor Blue
Write-Host "- Register: $BackendUrl/api/v1/auth/register"
Write-Host "- Login: $BackendUrl/api/v1/auth/login"
Write-Host "- Profil: $BackendUrl/api/v1/auth/me"

Write-Host ""
Write-Host "💡 Si tous les tests échouent avec 403:" -ForegroundColor Cyan
Write-Host "1. Le problème vient de la configuration Spring Security" -ForegroundColor White
Write-Host "2. Vérifiez les logs Render pour plus de détails" -ForegroundColor White
Write-Host "3. La configuration pourrait ne pas être appliquée" -ForegroundColor White

Write-Host ""
Write-Host "🎯 Test simple terminé!" -ForegroundColor Green
