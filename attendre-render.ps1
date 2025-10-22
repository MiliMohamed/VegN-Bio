# Script pour attendre que Render soit pret
Write-Host "Attente que Render soit pret..." -ForegroundColor Green

$baseUrl = "https://vegn-bio-backend.onrender.com/api"

# Fonction pour tester l'API
function Test-RenderAPI {
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/restaurants" -Method GET -TimeoutSec 10
        return $true
    } catch {
        return $false
    }
}

# Attendre que l'API soit accessible
$maxAttempts = 30
$attempt = 1

Write-Host "Test de l'API Render (max $maxAttempts tentatives)..." -ForegroundColor Yellow

while ($attempt -le $maxAttempts) {
    Write-Host "Tentative $attempt/$maxAttempts..." -ForegroundColor Cyan
    
    if (Test-RenderAPI) {
        Write-Host "API Render accessible !" -ForegroundColor Green
        break
    } else {
        Write-Host "API non accessible, attente 30 secondes..." -ForegroundColor Yellow
        Start-Sleep -Seconds 30
        $attempt++
    }
}

if ($attempt -gt $maxAttempts) {
    Write-Host "API Render non accessible apres $maxAttempts tentatives" -ForegroundColor Red
    Write-Host "La migration V20 peut prendre plus de temps" -ForegroundColor Yellow
    Write-Host "Verifiez les logs Render sur https://render.com" -ForegroundColor Yellow
} else {
    Write-Host "`nTest de l'authentification..." -ForegroundColor Yellow
    
    $loginData = @{
        email = "admin@vegnbio.fr"
        password = "TestVegN2024!"
    } | ConvertTo-Json
    
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/auth/login" -Method POST -Body $loginData -ContentType "application/json" -TimeoutSec 30
        Write-Host "Authentification reussie !" -ForegroundColor Green
        
        $token = $response.token
        $headers = @{ Authorization = "Bearer $token" }
        
        # Test des donnees
        Write-Host "`nVerification des donnees..." -ForegroundColor Yellow
        
        # Menus
        $menus = Invoke-RestMethod -Uri "$baseUrl/menus" -Method GET -Headers $headers -TimeoutSec 30
        Write-Host "Menus: $($menus.Count) trouves" -ForegroundColor Green
        
        # Evenements
        $events = Invoke-RestMethod -Uri "$baseUrl/events" -Method GET -Headers $headers -TimeoutSec 30
        Write-Host "Evenements: $($events.Count) trouves" -ForegroundColor Green
        
        # Reservations
        $bookings = Invoke-RestMethod -Uri "$baseUrl/bookings" -Method GET -Headers $headers -TimeoutSec 30
        Write-Host "Reservations: $($bookings.Count) trouves" -ForegroundColor Green
        
        # Rapports
        $reports = Invoke-RestMethod -Uri "$baseUrl/error-reports" -Method GET -Headers $headers -TimeoutSec 30
        Write-Host "Rapports: $($reports.Count) trouves" -ForegroundColor Green
        
        Write-Host "`nVOTRE APPLICATION VEGN BIO EST PRETE !" -ForegroundColor Green
        
    } catch {
        Write-Host "Erreur authentification: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`nScript termine !" -ForegroundColor Green
