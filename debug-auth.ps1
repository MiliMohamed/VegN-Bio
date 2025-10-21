# Test simple pour déboguer l'authentification
$BaseUrl = "https://vegn-bio-backend.onrender.com/api/v1"

Write-Host "Test d'authentification simple" -ForegroundColor Yellow

# Test 1: Vérifier que l'endpoint auth existe
Write-Host "`n1. Test de l'endpoint auth/login" -ForegroundColor Cyan
try {
    $loginBody = @{
        email = "admin@vegnbio.com"
        password = "AdminVegN2024!"
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "$BaseUrl/auth/login" -Method POST -ContentType "application/json" -Body $loginBody -ErrorAction Stop
    Write-Host "SUCCESS: Connexion réussie" -ForegroundColor Green
    Write-Host "Token: $($response.token)" -ForegroundColor Green
    Write-Host "User: $($response.user)" -ForegroundColor Green
}
catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        Write-Host "Status Code: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
        Write-Host "Status Description: $($_.Exception.Response.StatusDescription)" -ForegroundColor Red
    }
}

# Test 2: Vérifier les endpoints publics
Write-Host "`n2. Test des endpoints publics" -ForegroundColor Cyan
$publicEndpoints = @(
    "/restaurants",
    "/allergens", 
    "/events",
    "/suppliers",
    "/offers"
)

foreach ($endpoint in $publicEndpoints) {
    try {
        $response = Invoke-RestMethod -Uri "$BaseUrl$endpoint" -Method GET -ErrorAction Stop
        Write-Host "SUCCESS: $endpoint" -ForegroundColor Green
    }
    catch {
        Write-Host "ERROR: $endpoint - $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Test 3: Vérifier les endpoints qui devraient être protégés
Write-Host "`n3. Test des endpoints protégés" -ForegroundColor Cyan
$protectedEndpoints = @(
    "/menus",
    "/bookings", 
    "/reviews",
    "/restaurants/1",
    "/allergens/GLUTEN"
)

foreach ($endpoint in $protectedEndpoints) {
    try {
        $response = Invoke-RestMethod -Uri "$BaseUrl$endpoint" -Method GET -ErrorAction Stop
        Write-Host "SUCCESS: $endpoint" -ForegroundColor Green
    }
    catch {
        Write-Host "ERROR: $endpoint - Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    }
}

Write-Host "`nTest terminé" -ForegroundColor Yellow
