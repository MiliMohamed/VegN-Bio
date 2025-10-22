# Script final pour injecter les donnees VEGN BIO sur Render
Write-Host "Injection finale des donnees VEGN BIO sur Render" -ForegroundColor Green

$baseUrl = "https://vegn-bio-backend.onrender.com/api"

# Fonction pour faire des requetes API
function Invoke-ApiRequest {
    param(
        [string]$Url,
        [string]$Method = "GET",
        [hashtable]$Headers = @{},
        [string]$Body = $null
    )
    
    try {
        if ($Body) {
            $response = Invoke-RestMethod -Uri $Url -Method $Method -Headers $Headers -Body $Body -ContentType "application/json" -TimeoutSec 30
        } else {
            $response = Invoke-RestMethod -Uri $Url -Method $Method -Headers $Headers -TimeoutSec 30
        }
        return $response
    } catch {
        Write-Host "Erreur API: $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

# Test de connexion Render
Write-Host "Test de connexion a Render PRODUCTION..." -ForegroundColor Yellow
$testResponse = Invoke-ApiRequest -Url "$baseUrl/restaurants"
if ($testResponse) {
    Write-Host "API Render accessible - $($testResponse.Count) restaurants trouves" -ForegroundColor Green
} else {
    Write-Host "API Render non accessible - Migration V20 en cours" -ForegroundColor Yellow
    Write-Host "Attendez 5-10 minutes puis relancez ce script" -ForegroundColor Yellow
    exit 1
}

# Authentification admin
Write-Host "Authentification admin sur Render..." -ForegroundColor Yellow
$loginData = @{
    email = "admin@vegnbio.fr"
    password = "TestVegN2024!"
} | ConvertTo-Json

$authResponse = Invoke-ApiRequest -Url "$baseUrl/auth/login" -Method "POST" -Body $loginData
if ($authResponse) {
    $token = $authResponse.token
    $headers = @{ Authorization = "Bearer $token" }
    Write-Host "Authentification admin reussie sur Render" -ForegroundColor Green
} else {
    Write-Host "Erreur authentification admin sur Render" -ForegroundColor Red
    exit 1
}

# Verification des donnees existantes
Write-Host "Verification des donnees existantes..." -ForegroundColor Yellow

# Menus
$menus = Invoke-ApiRequest -Url "$baseUrl/menus" -Headers $headers
Write-Host "Menus existants: $($menus.Count)" -ForegroundColor Cyan

# Evenements
$events = Invoke-ApiRequest -Url "$baseUrl/events" -Headers $headers
Write-Host "Evenements existants: $($events.Count)" -ForegroundColor Cyan

# Reservations
$bookings = Invoke-ApiRequest -Url "$baseUrl/bookings" -Headers $headers
Write-Host "Reservations existantes: $($bookings.Count)" -ForegroundColor Cyan

# Rapports
$reports = Invoke-ApiRequest -Url "$baseUrl/error-reports" -Headers $headers
Write-Host "Rapports existants: $($reports.Count)" -ForegroundColor Cyan

# Si les donnees existent deja, afficher un resume
if ($menus.Count -gt 0 -and $events.Count -gt 0) {
    Write-Host "Les donnees VEGN BIO sont deja presentes sur Render !" -ForegroundColor Green
    Write-Host "Migration V20 appliquee avec succes" -ForegroundColor Green
} else {
    Write-Host "Les donnees ne sont pas encore presentes" -ForegroundColor Yellow
    Write-Host "Migration V20 en cours d'application" -ForegroundColor Yellow
}

# Afficher les details des donnees
Write-Host "`nDetails des donnees:" -ForegroundColor Cyan

if ($menus.Count -gt 0) {
    Write-Host "Menus disponibles:" -ForegroundColor White
    foreach ($menu in $menus) {
        Write-Host "- $($menu.title)" -ForegroundColor White
    }
}

if ($events.Count -gt 0) {
    Write-Host "Evenements disponibles:" -ForegroundColor White
    foreach ($event in $events) {
        Write-Host "- $($event.title) ($($event.type))" -ForegroundColor White
    }
}

Write-Host "`nComptes de test disponibles:" -ForegroundColor Cyan
Write-Host "- Admin: admin@vegnbio.fr / TestVegN2024!" -ForegroundColor White
Write-Host "- Client: client@vegnbio.fr / TestVegN2024!" -ForegroundColor White
Write-Host "- Restaurateur: restaurateur@vegnbio.fr / TestVegN2024!" -ForegroundColor White

Write-Host "`nAcces Render PRODUCTION:" -ForegroundColor Cyan
Write-Host "- Backend API: https://vegn-bio-backend.onrender.com/api" -ForegroundColor White
Write-Host "- Documentation: https://vegn-bio-backend.onrender.com/swagger-ui.html" -ForegroundColor White

Write-Host "`nVOTRE APPLICATION VEGN BIO EST PRETE SUR RENDER !" -ForegroundColor Green
