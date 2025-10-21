#!/usr/bin/env pwsh

# Script de test des fonctionnalités critiques en production
Write-Host "=== Test des Fonctionnalités Critiques - Production ===" -ForegroundColor Green

$API_BASE_URL = "https://vegn-bio-backend.onrender.com/api/v1"
$FRONTEND_VERCEL = "https://veg-n-bio-front-pi.vercel.app"

# Headers pour simuler le frontend
$headers = @{
    "Origin" = $FRONTEND_VERCEL
    "Referer" = "$FRONTEND_VERCEL/"
    "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
    "Accept" = "application/json"
}

$testResults = @()

# Fonction de test avec rapport
function Test-CriticalFeature {
    param(
        [string]$FeatureName,
        [string]$Url,
        [string]$Method = "GET",
        [hashtable]$Headers = @{},
        [string]$Body = $null,
        [string]$ExpectedField = $null
    )
    
    Write-Host "`n🔍 Test: $FeatureName" -ForegroundColor Yellow
    
    try {
        $params = @{
            Uri = $Url
            Method = $Method
            Headers = $Headers
            TimeoutSec = 30
            ErrorAction = 'Stop'
        }
        
        if ($Body) {
            $params.Body = $Body
            $params.ContentType = "application/json"
        }
        
        $response = Invoke-RestMethod @params
        
        # Vérifier si un champ spécifique est attendu
        if ($ExpectedField -and $response -is [object]) {
            if (-not $response.PSObject.Properties.Name -contains $ExpectedField) {
                throw "Champ '$ExpectedField' manquant dans la réponse"
            }
        }
        
        Write-Host "✅ $FeatureName - SUCCÈS" -ForegroundColor Green
        $testResults += @{
            Feature = $FeatureName
            Status = "SUCCESS"
            Details = "Fonctionnalité opérationnelle"
        }
        return $true
        
    } catch {
        Write-Host "❌ $FeatureName - ÉCHEC: $($_.Exception.Message)" -ForegroundColor Red
        $testResults += @{
            Feature = $FeatureName
            Status = "FAILED"
            Details = $_.Exception.Message
        }
        return $false
    }
}

Write-Host "🚀 === DÉMARRAGE DES TESTS CRITIQUES ===" -ForegroundColor Magenta

# 1. Tests des données de base
Test-CriticalFeature -FeatureName "Restaurants disponibles" -Url "$API_BASE_URL/restaurants" -Headers $headers -ExpectedField "name"
Test-CriticalFeature -FeatureName "Allergènes disponibles" -Url "$API_BASE_URL/allergens" -Headers $headers -ExpectedField "name"
Test-CriticalFeature -FeatureName "Menus disponibles" -Url "$API_BASE_URL/menus" -Headers $headers -ExpectedField "name"

# 2. Test d'authentification
$registerData = @{
    email = "critical.test@example.com"
    password = "password123"
    fullName = "Critical Test User"
    role = "CLIENT"
} | ConvertTo-Json

Test-CriticalFeature -FeatureName "Registration utilisateur" -Url "$API_BASE_URL/auth/register" -Method "POST" -Headers $headers -Body $registerData -ExpectedField "accessToken"

# 3. Test de login
$loginData = @{
    email = "critical.test@example.com"
    password = "password123"
} | ConvertTo-Json

$loginSuccess = Test-CriticalFeature -FeatureName "Login utilisateur" -Url "$API_BASE_URL/auth/login" -Method "POST" -Headers $headers -Body $loginData -ExpectedField "accessToken"

# 4. Test avec token d'authentification
if ($loginSuccess) {
    try {
        $loginResponse = Invoke-RestMethod -Uri "$API_BASE_URL/auth/login" -Method POST -Body $loginData -ContentType "application/json" -Headers $headers -TimeoutSec 30
        
        $authHeaders = $headers.Clone()
        $authHeaders["Authorization"] = "Bearer $($loginResponse.accessToken)"
        
        Test-CriticalFeature -FeatureName "Profil utilisateur (/me)" -Url "$API_BASE_URL/auth/me" -Headers $authHeaders -ExpectedField "email"
        
    } catch {
        Write-Host "⚠️ Impossible de tester les endpoints protégés" -ForegroundColor Yellow
    }
}

# 5. Test du chatbot
$chatbotData = @{
    message = "Bonjour, je voudrais des informations sur les produits bio"
    userId = 1
} | ConvertTo-Json

Test-CriticalFeature -FeatureName "Chatbot fonctionnel" -Url "$API_BASE_URL/chatbot/message" -Method "POST" -Headers $headers -Body $chatbotData -ExpectedField "response"

# 6. Test des événements
Test-CriticalFeature -FeatureName "Événements disponibles" -Url "$API_BASE_URL/events" -Headers $headers -ExpectedField "title"

# 7. Test des réservations (si disponible)
Test-CriticalFeature -FeatureName "Réservations disponibles" -Url "$API_BASE_URL/bookings" -Headers $headers

# 8. Test de reporting d'erreurs
$errorReportData = @{
    errorType = "FUNCTIONALITY"
    severity = "MEDIUM"
    description = "Test de reporting d'erreur automatique"
    stepsToReproduce = "Exécution du script de test"
    expectedBehavior = "Le système doit fonctionner normalement"
    actualBehavior = "Test en cours"
    userAgent = "Test Script"
    url = $FRONTEND_VERCEL
    userId = 1
} | ConvertTo-Json

Test-CriticalFeature -FeatureName "Reporting d'erreurs" -Url "$API_BASE_URL/error-reports" -Method "POST" -Headers $headers -Body $errorReportData -ExpectedField "id"

# 9. Test des fournisseurs
Test-CriticalFeature -FeatureName "Fournisseurs disponibles" -Url "$API_BASE_URL/suppliers" -Headers $headers

# 10. Test des offres
Test-CriticalFeature -FeatureName "Offres disponibles" -Url "$API_BASE_URL/offers" -Headers $headers

# Génération du rapport
Write-Host "`n📊 === RAPPORT DES TESTS ===" -ForegroundColor Magenta

$totalTests = $testResults.Count
$successfulTests = ($testResults | Where-Object { $_.Status -eq "SUCCESS" }).Count
$failedTests = ($testResults | Where-Object { $_.Status -eq "FAILED" }).Count

Write-Host "📈 Statistiques:" -ForegroundColor Cyan
Write-Host "  Total des tests: $totalTests" -ForegroundColor White
Write-Host "  ✅ Succès: $successfulTests" -ForegroundColor Green
Write-Host "  ❌ Échecs: $failedTests" -ForegroundColor Red
Write-Host "  📊 Taux de réussite: $([math]::Round(($successfulTests / $totalTests) * 100, 2))%" -ForegroundColor Yellow

if ($failedTests -gt 0) {
    Write-Host "`n❌ Tests échoués:" -ForegroundColor Red
    $testResults | Where-Object { $_.Status -eq "FAILED" } | ForEach-Object {
        Write-Host "  - $($_.Feature): $($_.Details)" -ForegroundColor Red
    }
}

Write-Host "`n✅ Tests des fonctionnalités critiques terminés !" -ForegroundColor Green

# Sauvegarde du rapport
$reportData = @{
    timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    api_url = $API_BASE_URL
    frontend_url = $FRONTEND_VERCEL
    total_tests = $totalTests
    successful_tests = $successfulTests
    failed_tests = $failedTests
    success_rate = [math]::Round(($successfulTests / $totalTests) * 100, 2)
    results = $testResults
} | ConvertTo-Json -Depth 3

$reportData | Out-File -FilePath "test-critical-features-report.json" -Encoding UTF8
Write-Host "📄 Rapport sauvegardé dans: test-critical-features-report.json" -ForegroundColor Cyan
