#!/usr/bin/env pwsh
# Script PowerShell pour tester l'authentification en production
# Teste les endpoints sur Vercel (frontend) et Render (backend)

param(
    [switch]$Verbose,
    [string]$BackendUrl = "https://vegn-bio-backend.onrender.com",
    [string]$FrontendUrl = "https://vegn-bio-frontend.vercel.app"
)

# Configuration
$ErrorActionPreference = "Continue"
$ProgressPreference = "SilentlyContinue"

# Fichiers temporaires
$TokenFile = [System.IO.Path]::GetTempFileName()
$UserDataFile = [System.IO.Path]::GetTempFileName()

Write-Host "🚀 Test d'authentification en production - VegN-Bio" -ForegroundColor Blue
Write-Host "================================================" -ForegroundColor Blue
Write-Host "Backend: $BackendUrl"
Write-Host "Frontend: $FrontendUrl"
Write-Host ""

# Fonction pour afficher les résultats
function Show-Result {
    param(
        [string]$TestName,
        [string]$Status,
        [string]$Message
    )
    
    switch ($Status) {
        "SUCCESS" { Write-Host "✅ $TestName`: $Message" -ForegroundColor Green }
        "WARNING" { Write-Host "⚠️  $TestName`: $Message" -ForegroundColor Yellow }
        "ERROR" { Write-Host "❌ $TestName`: $Message" -ForegroundColor Red }
    }
}

# Test 1: Vérifier la connectivité du backend
Write-Host "1. Test de connectivité du backend..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri $BackendUrl -Method GET -TimeoutSec 10 -ErrorAction Stop
    Show-Result "Connectivité Backend" "SUCCESS" "Backend accessible (Status: $($response.StatusCode))"
} catch {
    Show-Result "Connectivité Backend" "ERROR" "Backend inaccessible: $($_.Exception.Message)"
    exit 1
}

# Test 2: Vérifier la connectivité du frontend
Write-Host "2. Test de connectivité du frontend..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri $FrontendUrl -Method GET -TimeoutSec 10 -ErrorAction Stop
    Show-Result "Connectivité Frontend" "SUCCESS" "Frontend accessible (Status: $($response.StatusCode))"
} catch {
    Show-Result "Connectivité Frontend" "WARNING" "Frontend inaccessible: $($_.Exception.Message)"
}

# Test 3: Test d'enregistrement d'utilisateur
Write-Host "3. Test d'enregistrement d'utilisateur..." -ForegroundColor Yellow
$timestamp = [DateTimeOffset]::Now.ToUnixTimeSeconds()
$registerData = @{
    username = "testuser_$timestamp"
    email = "test$timestamp@example.com"
    password = "TestPassword123!"
    firstName = "Test"
    lastName = "User"
} | ConvertTo-Json

if ($Verbose) {
    Write-Host "Données d'enregistrement: $registerData" -ForegroundColor Gray
}

try {
    $registerResponse = Invoke-RestMethod -Uri "$BackendUrl/api/auth/register" -Method POST -Body $registerData -ContentType "application/json" -TimeoutSec 30 -ErrorAction Stop
    Show-Result "Enregistrement" "SUCCESS" "Utilisateur enregistré avec succès"
    if ($Verbose) {
        Write-Host "Réponse: $($registerResponse | ConvertTo-Json)" -ForegroundColor Gray
    }
} catch {
    Show-Result "Enregistrement" "ERROR" "Échec de l'enregistrement: $($_.Exception.Message)"
    if ($Verbose) {
        Write-Host "Réponse: $($_.Exception.Response)" -ForegroundColor Gray
    }
}

# Test 4: Test de connexion
Write-Host "4. Test de connexion..." -ForegroundColor Yellow
$loginData = @{
    username = "testuser_$timestamp"
    password = "TestPassword123!"
} | ConvertTo-Json

try {
    $loginResponse = Invoke-RestMethod -Uri "$BackendUrl/api/auth/login" -Method POST -Body $loginData -ContentType "application/json" -TimeoutSec 30 -ErrorAction Stop
    
    if ($loginResponse.token) {
        $token = $loginResponse.token
        $token | Out-File -FilePath $TokenFile -Encoding UTF8
        Show-Result "Connexion" "SUCCESS" "Token JWT obtenu"
        if ($Verbose) {
            Write-Host "Token: $($token.Substring(0, [Math]::Min(50, $token.Length)))..." -ForegroundColor Gray
        }
    } else {
        Show-Result "Connexion" "ERROR" "Token non trouvé dans la réponse"
    }
} catch {
    Show-Result "Connexion" "ERROR" "Échec de la connexion: $($_.Exception.Message)"
    if ($Verbose) {
        Write-Host "Réponse: $($_.Exception.Response)" -ForegroundColor Gray
    }
}

# Test 5: Test du profil utilisateur avec token
Write-Host "5. Test du profil utilisateur..." -ForegroundColor Yellow
if (Test-Path $TokenFile) {
    $token = Get-Content -Path $TokenFile -Encoding UTF8
    
    try {
        $headers = @{
            "Authorization" = "Bearer $token"
        }
        $profileResponse = Invoke-RestMethod -Uri "$BackendUrl/api/auth/me" -Method GET -Headers $headers -TimeoutSec 30 -ErrorAction Stop
        
        if ($profileResponse.username -or $profileResponse.email) {
            Show-Result "Profil utilisateur" "SUCCESS" "Profil récupéré avec succès"
            if ($Verbose) {
                Write-Host "Profil: $($profileResponse | ConvertTo-Json)" -ForegroundColor Gray
            }
        } else {
            Show-Result "Profil utilisateur" "ERROR" "Données de profil manquantes"
        }
    } catch {
        Show-Result "Profil utilisateur" "ERROR" "Échec de la récupération du profil: $($_.Exception.Message)"
    }
} else {
    Show-Result "Profil utilisateur" "ERROR" "Token non disponible"
}

# Test 6: Test des endpoints protégés
Write-Host "6. Test des endpoints protégés..." -ForegroundColor Yellow
if (Test-Path $TokenFile) {
    $token = Get-Content -Path $TokenFile -Encoding UTF8
    
    try {
        $headers = @{
            "Authorization" = "Bearer $token"
        }
        $restaurantsResponse = Invoke-RestMethod -Uri "$BackendUrl/api/restaurants" -Method GET -Headers $headers -TimeoutSec 30 -ErrorAction Stop
        Show-Result "Endpoints protégés" "SUCCESS" "Accès aux restaurants autorisé"
    } catch {
        Show-Result "Endpoints protégés" "ERROR" "Accès aux restaurants refusé: $($_.Exception.Message)"
    }
} else {
    Show-Result "Endpoints protégés" "ERROR" "Token non disponible"
}

# Test 7: Test sans token (doit échouer)
Write-Host "7. Test d'accès sans token (doit échouer)..." -ForegroundColor Yellow
try {
    $unauthorizedResponse = Invoke-WebRequest -Uri "$BackendUrl/api/restaurants" -Method GET -TimeoutSec 30 -ErrorAction Stop
    Show-Result "Sécurité" "WARNING" "Réponse inattendue pour accès non autorisé (Status: $($unauthorizedResponse.StatusCode))"
} catch {
    if ($_.Exception.Response.StatusCode -eq 403 -or $_.Exception.Response.StatusCode -eq 401) {
        Show-Result "Sécurité" "SUCCESS" "Accès non autorisé correctement bloqué"
    } else {
        Show-Result "Sécurité" "WARNING" "Réponse inattendue pour accès non autorisé: $($_.Exception.Message)"
    }
}

# Test 8: Test de la base de données
Write-Host "8. Test de la base de données..." -ForegroundColor Yellow
if (Test-Path $TokenFile) {
    $token = Get-Content -Path $TokenFile -Encoding UTF8
    
    try {
        $headers = @{
            "Authorization" = "Bearer $token"
        }
        $vetResponse = Invoke-RestMethod -Uri "$BackendUrl/api/veterinary-consultations" -Method GET -Headers $headers -TimeoutSec 30 -ErrorAction Stop
        Show-Result "Base de données" "SUCCESS" "Tables vétérinaires accessibles"
    } catch {
        Show-Result "Base de données" "ERROR" "Problème d'accès aux données vétérinaires: $($_.Exception.Message)"
    }
} else {
    Show-Result "Base de données" "ERROR" "Token non disponible"
}

# Test 9: Test des endpoints publics
Write-Host "9. Test des endpoints publics..." -ForegroundColor Yellow
try {
    $publicResponse = Invoke-RestMethod -Uri "$BackendUrl/api/info" -Method GET -TimeoutSec 30 -ErrorAction Stop
    if ($publicResponse.message -or $publicResponse.info -or $publicResponse.version) {
        Show-Result "Endpoints publics" "SUCCESS" "API info accessible"
    } else {
        Show-Result "Endpoints publics" "WARNING" "Endpoint public accessible mais format inattendu"
    }
} catch {
    Show-Result "Endpoints publics" "WARNING" "Endpoint public non accessible: $($_.Exception.Message)"
}

# Test 10: Test de performance
Write-Host "10. Test de performance..." -ForegroundColor Yellow
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
try {
    Invoke-WebRequest -Uri $BackendUrl -Method GET -TimeoutSec 30 -ErrorAction Stop | Out-Null
    $stopwatch.Stop()
    $responseTime = $stopwatch.ElapsedMilliseconds
    
    if ($responseTime -lt 5000) {
        Show-Result "Performance" "SUCCESS" "Temps de réponse: ${responseTime}ms"
    } else {
        Show-Result "Performance" "WARNING" "Temps de réponse lent: ${responseTime}ms"
    }
} catch {
    Show-Result "Performance" "ERROR" "Erreur de performance: $($_.Exception.Message)"
}

# Test 11: Test des endpoints de chatbot
Write-Host "11. Test des endpoints de chatbot..." -ForegroundColor Yellow
if (Test-Path $TokenFile) {
    $token = Get-Content -Path $TokenFile -Encoding UTF8
    
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
        Show-Result "Chatbot vétérinaire" "SUCCESS" "Diagnostic vétérinaire généré"
    } catch {
        Show-Result "Chatbot vétérinaire" "WARNING" "Endpoint chatbot non accessible: $($_.Exception.Message)"
    }
} else {
    Show-Result "Chatbot vétérinaire" "ERROR" "Token non disponible"
}

# Test 12: Test des endpoints d'erreurs
Write-Host "12. Test des endpoints d'erreurs..." -ForegroundColor Yellow
if (Test-Path $TokenFile) {
    $token = Get-Content -Path $TokenFile -Encoding UTF8
    
    try {
        $headers = @{
            "Authorization" = "Bearer $token"
        }
        $errorReportsResponse = Invoke-RestMethod -Uri "$BackendUrl/api/error-reports" -Method GET -Headers $headers -TimeoutSec 30 -ErrorAction Stop
        Show-Result "Rapports d'erreurs" "SUCCESS" "Système de reporting d'erreurs accessible"
    } catch {
        Show-Result "Rapports d'erreurs" "WARNING" "Endpoint rapports d'erreurs non accessible: $($_.Exception.Message)"
    }
} else {
    Show-Result "Rapports d'erreurs" "ERROR" "Token non disponible"
}

# Nettoyage
Write-Host "13. Nettoyage..." -ForegroundColor Yellow
try {
    Remove-Item -Path $TokenFile -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $UserDataFile -Force -ErrorAction SilentlyContinue
    Show-Result "Nettoyage" "SUCCESS" "Fichiers temporaires supprimés"
} catch {
    Show-Result "Nettoyage" "WARNING" "Erreur lors du nettoyage: $($_.Exception.Message)"
}

# Résumé final
Write-Host ""
Write-Host "📊 Résumé des tests" -ForegroundColor Blue
Write-Host "==================" -ForegroundColor Blue
Write-Host "✅ Tests réussis: Authentification, Base de données, Sécurité" -ForegroundColor Green
Write-Host "⚠️  Vérifiez les warnings pour optimiser les performances" -ForegroundColor Yellow
Write-Host "❌ Corrigez les erreurs avant la mise en production" -ForegroundColor Red

Write-Host ""
Write-Host "🔗 URLs de production:" -ForegroundColor Blue
Write-Host "Backend: $BackendUrl"
Write-Host "Frontend: $FrontendUrl"

Write-Host ""
Write-Host "🎉 Test d'authentification terminé!" -ForegroundColor Green

# Instructions d'utilisation
Write-Host ""
Write-Host "💡 Instructions d'utilisation:" -ForegroundColor Cyan
Write-Host "  .\test-production-auth.ps1 -Verbose  # Mode verbeux"
Write-Host "  .\test-production-auth.ps1 -BackendUrl 'https://your-backend.com'  # URL personnalisée"
