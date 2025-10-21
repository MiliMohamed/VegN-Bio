# Script pour diagnostiquer le problème 403 du frontend
$BaseUrl = "https://vegn-bio-backend.onrender.com/api/v1"
Write-Host "DIAGNOSTIC DU PROBLEME 403 FRONTEND" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan
Write-Host "Heure: $(Get-Date)" -ForegroundColor Gray
Write-Host ""

Write-Host "TEST 1: VERIFICATION CORS HEADERS" -ForegroundColor Yellow
Write-Host "================================" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$BaseUrl/auth/login" -Method OPTIONS -ErrorAction Stop
    Write-Host "SUCCESS: OPTIONS request reussie" -ForegroundColor Green
    Write-Host "Status Code: $($response.StatusCode)" -ForegroundColor Gray
    
    Write-Host "Headers CORS:" -ForegroundColor White
    $corsHeaders = @("Access-Control-Allow-Origin", "Access-Control-Allow-Methods", "Access-Control-Allow-Headers", "Access-Control-Allow-Credentials")
    foreach ($header in $corsHeaders) {
        if ($response.Headers[$header]) {
            Write-Host "  $header : $($response.Headers[$header])" -ForegroundColor Green
        } else {
            Write-Host "  $header : MANQUANT" -ForegroundColor Red
        }
    }
} catch {
    Write-Host "FAILED: OPTIONS request echouee" -ForegroundColor Red
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nTEST 2: SIMULATION REQUETE FRONTEND" -ForegroundColor Yellow
Write-Host "===================================" -ForegroundColor Yellow

# Simuler une requête comme le ferait le frontend
$frontendHeaders = @{
    "Content-Type" = "application/json"
    "Origin" = "https://vegn-bio-frontend.onrender.com"
    "Referer" = "https://vegn-bio-frontend.onrender.com/"
    "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
}

try {
    $loginBody = @{
        email = "admin20251021130828@vegnbio.com"
        password = "AdminVegN2024!"
    } | ConvertTo-Json

    Write-Host "Envoi de la requete avec headers frontend..." -ForegroundColor Yellow
    $response = Invoke-RestMethod -Uri "$BaseUrl/auth/login" -Method POST -ContentType "application/json" -Body $loginBody -Headers $frontendHeaders -ErrorAction Stop
    
    if ($response.accessToken) {
        Write-Host "SUCCESS: Connexion reussie avec headers frontend" -ForegroundColor Green
        Write-Host "Token: $($response.accessToken.Substring(0,30))..." -ForegroundColor Gray
    } else {
        Write-Host "WARNING: Pas de token dans la reponse" -ForegroundColor Yellow
    }
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    Write-Host "FAILED: Connexion echouee - Status: $statusCode" -ForegroundColor Red
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
    
    # Essayer de lire le body d'erreur
    try {
        if ($_.Exception.Response) {
            $errorStream = $_.Exception.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($errorStream)
            $errorBody = $reader.ReadToEnd()
            if ($errorBody) {
                Write-Host "Corps d'erreur: $errorBody" -ForegroundColor Gray
            }
        }
    } catch {
        Write-Host "Impossible de lire le corps d'erreur" -ForegroundColor Gray
    }
}

Write-Host "`nTEST 3: TEST AVEC DIFFERENTS ORIGINS" -ForegroundColor Yellow
Write-Host "====================================" -ForegroundColor Yellow

$testOrigins = @(
    "https://vegn-bio-frontend.onrender.com",
    "http://localhost:3000",
    "http://localhost:5173",
    "https://localhost:3000"
)

foreach ($origin in $testOrigins) {
    Write-Host "`nTest avec origin: $origin" -ForegroundColor White
    try {
        $testHeaders = @{
            "Content-Type" = "application/json"
            "Origin" = $origin
        }
        
        $response = Invoke-RestMethod -Uri "$BaseUrl/auth/login" -Method POST -ContentType "application/json" -Body $loginBody -Headers $testHeaders -ErrorAction Stop
        
        if ($response.accessToken) {
            Write-Host "SUCCESS: Connexion reussie avec $origin" -ForegroundColor Green
        }
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        Write-Host "FAILED: $origin - Status: $statusCode" -ForegroundColor Red
    }
}

Write-Host "`nTEST 4: VERIFICATION ENDPOINT AUTH" -ForegroundColor Yellow
Write-Host "===================================" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$BaseUrl/auth/login" -Method GET -ErrorAction Stop
    Write-Host "GET request sur /auth/login: $($response.StatusCode)" -ForegroundColor Gray
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    Write-Host "GET request sur /auth/login: $statusCode" -ForegroundColor Gray
}

Write-Host "`nDIAGNOSTIC TERMINE" -ForegroundColor Magenta
Write-Host "==================" -ForegroundColor Magenta
Write-Host "Si tous les tests echouent avec 403, le probleme est probablement:" -ForegroundColor White
Write-Host "- Configuration CORS non deployee" -ForegroundColor Gray
Write-Host "- Problème de configuration de sécurité" -ForegroundColor Gray
Write-Host "- Backend en cours de redémarrage" -ForegroundColor Gray
Write-Host "- Headers manquants dans la requête frontend" -ForegroundColor Gray
