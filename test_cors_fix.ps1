# Script pour tester les corrections CORS apres deployment
$BaseUrl = "https://vegn-bio-backend.onrender.com/api/v1"
Write-Host "TEST DES CORRECTIONS CORS" -ForegroundColor Cyan
Write-Host "=========================" -ForegroundColor Cyan
Write-Host "Heure: $(Get-Date)" -ForegroundColor Gray
Write-Host ""

Write-Host "TEST 1: VERIFICATION CORS HEADERS" -ForegroundColor Yellow
Write-Host "================================" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$BaseUrl/auth/login" -Method OPTIONS -ErrorAction Stop
    Write-Host "SUCCESS: OPTIONS request reussie" -ForegroundColor Green
    Write-Host "Status Code: $($response.StatusCode)" -ForegroundColor Gray
    
    Write-Host "Headers CORS:" -ForegroundColor White
    $corsHeaders = @("Access-Control-Allow-Origin", "Access-Control-Allow-Methods", "Access-Control-Allow-Headers", "Access-Control-Allow-Credentials", "Access-Control-Max-Age")
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
        Write-Host "Role: $($response.role)" -ForegroundColor Gray
    } else {
        Write-Host "WARNING: Pas de token dans la reponse" -ForegroundColor Yellow
    }
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    Write-Host "FAILED: Connexion echouee - Status: $statusCode" -ForegroundColor Red
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nTEST 3: TEST AVEC DIFFERENTS ORIGINS" -ForegroundColor Yellow
Write-Host "====================================" -ForegroundColor Yellow

$testOrigins = @(
    "https://vegn-bio-frontend.onrender.com",
    "http://localhost:3000",
    "http://localhost:5173",
    "http://localhost:8080"
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

Write-Host "`nTEST 4: TEST PREFLIGHT CACHE" -ForegroundColor Yellow
Write-Host "============================" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$BaseUrl/auth/login" -Method OPTIONS -ErrorAction Stop
    if ($response.Headers["Access-Control-Max-Age"]) {
        Write-Host "SUCCESS: Cache preflight configure - $($response.Headers['Access-Control-Max-Age']) secondes" -ForegroundColor Green
    } else {
        Write-Host "WARNING: Cache preflight non configure" -ForegroundColor Yellow
    }
} catch {
    Write-Host "FAILED: Impossible de tester le cache preflight" -ForegroundColor Red
}

Write-Host "`nRESUME DES TESTS" -ForegroundColor Magenta
Write-Host "================" -ForegroundColor Magenta
Write-Host "Si tous les tests reussissent:" -ForegroundColor White
Write-Host "- Le frontend devrait maintenant pouvoir se connecter" -ForegroundColor Green
Write-Host "- Les headers CORS sont correctement configures" -ForegroundColor Green
Write-Host "- Le cache preflight ameliore les performances" -ForegroundColor Green
Write-Host ""
Write-Host "Si certains tests echouent encore:" -ForegroundColor White
Write-Host "- Verifiez que le deployment est termine" -ForegroundColor Gray
Write-Host "- Attendez quelques minutes pour la propagation" -ForegroundColor Gray
Write-Host "- Contactez le support si le probleme persiste" -ForegroundColor Gray
