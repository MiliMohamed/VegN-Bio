# Script pour tester le statut de Render
Write-Host "Test du statut Render PRODUCTION" -ForegroundColor Green

$baseUrl = "https://vegn-bio-backend.onrender.com"

# Test 1: Health check
Write-Host "Test 1: Health check..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/actuator/health" -Method GET -TimeoutSec 30
    Write-Host "Health check: $($response.status)" -ForegroundColor Green
} catch {
    Write-Host "Health check failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 2: API endpoints
Write-Host "Test 2: API endpoints..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/restaurants" -Method GET -TimeoutSec 30
    Write-Host "Restaurants endpoint accessible: $($response.Count) restaurants" -ForegroundColor Green
} catch {
    Write-Host "Restaurants endpoint failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: Swagger UI
Write-Host "Test 3: Swagger UI..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/swagger-ui.html" -Method GET -TimeoutSec 30
    if ($response.StatusCode -eq 200) {
        Write-Host "Swagger UI accessible" -ForegroundColor Green
    }
} catch {
    Write-Host "Swagger UI failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 4: Authentication
Write-Host "Test 4: Authentication..." -ForegroundColor Yellow
$loginData = @{
    email = "admin@vegnbio.fr"
    password = "TestVegN2024!"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/auth/login" -Method POST -Body $loginData -ContentType "application/json" -TimeoutSec 30
    Write-Host "Authentication successful: Token received" -ForegroundColor Green
} catch {
    Write-Host "Authentication failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Test termine !" -ForegroundColor Green
