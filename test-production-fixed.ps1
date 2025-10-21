#!/usr/bin/env pwsh

# Script de test de production corrigé et amélioré
Write-Host "=== Test de Production - Version Corrigée ===" -ForegroundColor Green

$API_BASE_URL = "https://vegn-bio-backend.onrender.com/api/v1"
$FRONTEND_VERCEL = "https://veg-n-bio-front-pi.vercel.app"

# Fonction pour afficher les résultats de manière claire
function Write-TestResult {
    param(
        [string]$TestName,
        [bool]$Success,
        [string]$Message = "",
        [string]$Details = ""
    )
    
    if ($Success) {
        Write-Host "✅ $TestName" -ForegroundColor Green
        if ($Message) { Write-Host "   $Message" -ForegroundColor Cyan }
    } else {
        Write-Host "❌ $TestName" -ForegroundColor Red
        if ($Message) { Write-Host "   $Message" -ForegroundColor Red }
        if ($Details) { Write-Host "   Détails: $Details" -ForegroundColor Gray }
    }
}

# Fonction pour tester un endpoint avec gestion d'erreur robuste
function Test-EndpointRobust {
    param(
        [string]$Url,
        [string]$Method = "GET",
        [hashtable]$Headers = @{},
        [string]$Body = $null,
        [string]$TestName
    )
    
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
        
        Write-TestResult -TestName $TestName -Success $true -Message "Succès - Données reçues"
        
        if ($response -is [array]) {
            Write-Host "   📊 Nombre d'éléments: $($response.Count)" -ForegroundColor Cyan
        } elseif ($response -is [object]) {
            $responseKeys = ($response | Get-Member -MemberType NoteProperty).Name
            Write-Host "   📋 Champs disponibles: $($responseKeys -join ', ')" -ForegroundColor Cyan
        }
        
        return $true
        
    } catch {
        $errorMessage = $_.Exception.Message
        $statusCode = ""
        
        if ($_.Exception.Response) {
            $statusCode = " (Status: $($_.Exception.Response.StatusCode))"
        }
        
        Write-TestResult -TestName $TestName -Success $false -Message "Erreur: $errorMessage$statusCode"
        return $false
    }
}

Write-Host "`n🚀 === DÉMARRAGE DES TESTS CORRIGÉS ===" -ForegroundColor Magenta

# Test 1: Vérification de la connectivité de base
Write-Host "`n🌐 Test de connectivité de base..." -ForegroundColor Yellow

try {
    $pingResult = Test-NetConnection -ComputerName "vegn-bio-backend.onrender.com" -Port 443 -WarningAction SilentlyContinue
    if ($pingResult.TcpTestSucceeded) {
        Write-TestResult -TestName "Connexion TCP vers l'API" -Success $true -Message "Port 443 accessible"
    } else {
        Write-TestResult -TestName "Connexion TCP vers l'API" -Success $false -Message "Port 443 inaccessible"
    }
} catch {
    Write-TestResult -TestName "Connexion TCP vers l'API" -Success $false -Message "Test de connectivité non disponible"
}

# Test 2: Accès au frontend Vercel
Write-Host "`n🌐 Test d'accès au frontend Vercel..." -ForegroundColor Yellow

try {
    $response = Invoke-WebRequest -Uri $FRONTEND_VERCEL -Method GET -TimeoutSec 30 -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
    Write-TestResult -TestName "Frontend Vercel accessible" -Success $true -Message "Status: $($response.StatusCode)"
    
    if ($response.Content -match "react|React|vite|Vite") {
        Write-Host "   ⚛️ Application React détectée" -ForegroundColor Green
    }
    
} catch {
    $errorMessage = $_.Exception.Message
    $statusCode = ""
    if ($_.Exception.Response) {
        $statusCode = " (Status: $($_.Exception.Response.StatusCode))"
    }
    Write-TestResult -TestName "Frontend Vercel accessible" -Success $false -Message "$errorMessage$statusCode"
}

# Test 3: Configuration CORS
Write-Host "`n🌐 Test de la configuration CORS..." -ForegroundColor Yellow

$corsHeaders = @{
    "Origin" = $FRONTEND_VERCEL
    "Access-Control-Request-Method" = "GET"
    "Access-Control-Request-Headers" = "Content-Type,Authorization"
}

try {
    $corsResponse = Invoke-WebRequest -Uri "$API_BASE_URL/restaurants" -Method "OPTIONS" -Headers $corsHeaders -TimeoutSec 30
    Write-TestResult -TestName "Configuration CORS" -Success $true -Message "Preflight request réussie"
    
    # Afficher les headers CORS importants
    $corsHeadersList = @(
        "Access-Control-Allow-Origin",
        "Access-Control-Allow-Methods",
        "Access-Control-Allow-Headers",
        "Access-Control-Allow-Credentials"
    )
    
    Write-Host "   📋 Headers CORS:" -ForegroundColor Cyan
    foreach ($header in $corsHeadersList) {
        if ($corsResponse.Headers[$header]) {
            Write-Host "     $header`: $($corsResponse.Headers[$header])" -ForegroundColor Cyan
        }
    }
    
} catch {
    $errorMessage = $_.Exception.Message
    Write-TestResult -TestName "Configuration CORS" -Success $false -Message "$errorMessage"
}

# Test 4: Endpoints API avec headers appropriés
Write-Host "`n🔗 Test des endpoints API..." -ForegroundColor Yellow

$apiHeaders = @{
    "Origin" = $FRONTEND_VERCEL
    "Referer" = "$FRONTEND_VERCEL/"
    "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
    "Accept" = "application/json, text/plain, */*"
    "Accept-Language" = "fr-FR,fr;q=0.9,en;q=0.8"
}

$endpoints = @(
    @{ Path = "/restaurants"; Name = "Restaurants" },
    @{ Path = "/allergens"; Name = "Allergènes" },
    @{ Path = "/menus"; Name = "Menus" },
    @{ Path = "/events"; Name = "Événements" }
)

$successfulEndpoints = 0
foreach ($endpoint in $endpoints) {
    $success = Test-EndpointRobust -Url "$API_BASE_URL$($endpoint.Path)" -Headers $apiHeaders -TestName "Endpoint $($endpoint.Name)"
    if ($success) { $successfulEndpoints++ }
}

Write-Host "`n📊 Résultat des endpoints: $successfulEndpoints/$($endpoints.Count) fonctionnels" -ForegroundColor Yellow

# Test 5: Authentification
Write-Host "`n🔐 Test d'authentification..." -ForegroundColor Yellow

$registerData = @{
    email = "test.fixed.$(Get-Date -Format 'yyyyMMddHHmmss')@example.com"
    password = "password123"
    fullName = "Test Fixed User"
    role = "CLIENT"
} | ConvertTo-Json

$authSuccess = Test-EndpointRobust -Url "$API_BASE_URL/auth/register" -Method "POST" -Headers $apiHeaders -Body $registerData -TestName "Registration utilisateur"

if ($authSuccess) {
    # Test de login avec les mêmes credentials
    $loginData = @{
        email = ($registerData | ConvertFrom-Json).email
        password = ($registerData | ConvertFrom-Json).password
    } | ConvertTo-Json
    
    $loginSuccess = Test-EndpointRobust -Url "$API_BASE_URL/auth/login" -Method "POST" -Headers $apiHeaders -Body $loginData -TestName "Login utilisateur"
    
    if ($loginSuccess) {
        Write-Host "   🎯 Authentification complète réussie !" -ForegroundColor Green
    }
}

# Test 6: Test de performance
Write-Host "`n⚡ Test de performance..." -ForegroundColor Yellow

$performanceEndpoints = @(
    "$API_BASE_URL/restaurants",
    "$API_BASE_URL/allergens"
)

foreach ($endpoint in $performanceEndpoints) {
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        $response = Invoke-RestMethod -Uri $endpoint -Method GET -Headers $apiHeaders -TimeoutSec 30
        $stopwatch.Stop()
        $responseTime = $stopwatch.ElapsedMilliseconds
        
        if ($responseTime -lt 2000) {
            Write-TestResult -TestName "Performance $($endpoint.Split('/')[-1])" -Success $true -Message "Temps de réponse: ${responseTime}ms"
        } else {
            Write-TestResult -TestName "Performance $($endpoint.Split('/')[-1])" -Success $false -Message "Temps de réponse lent: ${responseTime}ms"
        }
        
    } catch {
        Write-TestResult -TestName "Performance $($endpoint.Split('/')[-1])" -Success $false -Message "Erreur lors du test de performance"
    }
}

# Génération du rapport final
Write-Host "`n📊 === RAPPORT FINAL ===" -ForegroundColor Magenta

$reportData = @{
    timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    api_url = $API_BASE_URL
    frontend_url = $FRONTEND_VERCEL
    tests_performed = @(
        "Connectivité de base",
        "Accès frontend Vercel", 
        "Configuration CORS",
        "Endpoints API",
        "Authentification",
        "Performance"
    )
    successful_endpoints = $successfulEndpoints
    total_endpoints = $endpoints.Count
    success_rate = [math]::Round(($successfulEndpoints / $endpoints.Count) * 100, 2)
}

Write-Host "🎯 Résumé des tests:" -ForegroundColor Cyan
Write-Host "   API Backend: $API_BASE_URL" -ForegroundColor White
Write-Host "   Frontend Vercel: $FRONTEND_VERCEL" -ForegroundColor White
Write-Host "   Endpoints fonctionnels: $($reportData.successful_endpoints)/$($reportData.total_endpoints)" -ForegroundColor White
Write-Host "   Taux de réussite: $($reportData.success_rate)%" -ForegroundColor White

# Sauvegarde du rapport
$reportData | ConvertTo-Json -Depth 3 | Out-File -FilePath "test-production-fixed-report.json" -Encoding UTF8
Write-Host "`n📄 Rapport détaillé sauvegardé: test-production-fixed-report.json" -ForegroundColor Cyan

Write-Host "`n=== TESTS TERMINÉS ===" -ForegroundColor Green
