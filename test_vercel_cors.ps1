# Test specifique pour le domaine Vercel
$BaseUrl = "https://vegn-bio-backend.onrender.com/api/v1"
Write-Host "TEST CORS POUR DOMAINE VERCEL" -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan
Write-Host "Heure: $(Get-Date)" -ForegroundColor Gray
Write-Host ""

Write-Host "DOMAINES VERCEL IDENTIFIES:" -ForegroundColor Yellow
Write-Host "===========================" -ForegroundColor Yellow
Write-Host "1. veg-n-bio-front-dujcso1tk-milimohameds-projects.vercel.app" -ForegroundColor White
Write-Host "2. veg-n-bio-front-pi.vercel.app" -ForegroundColor White
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

Write-Host "`nTEST 2: SIMULATION REQUETE DEPUIS VERCEL" -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Yellow

# Simuler une requête depuis votre domaine Vercel
$vercelHeaders = @{
    "Content-Type" = "application/json"
    "Origin" = "https://veg-n-bio-front-dujcso1tk-milimohameds-projects.vercel.app"
    "Referer" = "https://veg-n-bio-front-dujcso1tk-milimohameds-projects.vercel.app/"
    "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
}

try {
    $loginBody = @{
        email = "admin20251021130828@vegnbio.com"
        password = "AdminVegN2024!"
    } | ConvertTo-Json

    Write-Host "Envoi de la requete depuis Vercel..." -ForegroundColor Yellow
    $response = Invoke-RestMethod -Uri "$BaseUrl/auth/login" -Method POST -ContentType "application/json" -Body $loginBody -Headers $vercelHeaders -ErrorAction Stop
    
    if ($response.accessToken) {
        Write-Host "SUCCESS: Connexion reussie depuis Vercel!" -ForegroundColor Green
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

Write-Host "`nTEST 3: TEST AVEC LES DEUX DOMAINES VERCEL" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow

$vercelDomains = @(
    "https://veg-n-bio-front-dujcso1tk-milimohameds-projects.vercel.app",
    "https://veg-n-bio-front-pi.vercel.app"
)

foreach ($domain in $vercelDomains) {
    Write-Host "`nTest avec domaine: $domain" -ForegroundColor White
    try {
        $testHeaders = @{
            "Content-Type" = "application/json"
            "Origin" = $domain
        }
        
        $response = Invoke-RestMethod -Uri "$BaseUrl/auth/login" -Method POST -ContentType "application/json" -Body $loginBody -Headers $testHeaders -ErrorAction Stop
        
        if ($response.accessToken) {
            Write-Host "SUCCESS: Connexion reussie avec $domain" -ForegroundColor Green
        }
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        Write-Host "FAILED: $domain - Status: $statusCode" -ForegroundColor Red
    }
}

Write-Host "`nINSTRUCTIONS POUR DEPLOYER:" -ForegroundColor Magenta
Write-Host "===========================" -ForegroundColor Magenta
Write-Host "1. COMMIT ET PUSH LES CHANGEMENTS:" -ForegroundColor White
Write-Host "   git add backend/src/main/java/com/vegnbio/api/config/CorsConfig.java" -ForegroundColor Gray
Write-Host "   git commit -m 'Add Vercel domains to CORS configuration'" -ForegroundColor Gray
Write-Host "   git push origin main" -ForegroundColor Gray
Write-Host ""
Write-Host "2. ATTENDRE LE DEPLOYMENT:" -ForegroundColor White
Write-Host "   - Render va automatiquement deployer les changements" -ForegroundColor Gray
Write-Host "   - Attendez 5-10 minutes" -ForegroundColor Gray
Write-Host ""
Write-Host "3. TESTER LE FRONTEND:" -ForegroundColor White
Write-Host "   - Allez sur votre site Vercel" -ForegroundColor Gray
Write-Host "   - Essayez de vous connecter" -ForegroundColor Gray
Write-Host "   - L'erreur 403 devrait etre resolue" -ForegroundColor Gray
Write-Host ""

Write-Host "DOMAINES AJOUTES A LA CONFIGURATION CORS:" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host "✓ https://veg-n-bio-front-dujcso1tk-milimohameds-projects.vercel.app" -ForegroundColor White
Write-Host "✓ https://veg-n-bio-front-pi.vercel.app" -ForegroundColor White
Write-Host "✓ https://*.vercel.app (pattern general)" -ForegroundColor White
Write-Host ""
Write-Host "Apres le deployment, votre frontend Vercel devrait pouvoir se connecter!" -ForegroundColor Green
