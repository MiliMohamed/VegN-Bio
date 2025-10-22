# Script pour verifier les donnees VEGN BIO sur Render
Write-Host "Verification des donnees VEGN BIO sur Render" -ForegroundColor Green

$baseUrl = "https://vegn-bio-backend.onrender.com"

# Test 1: Health check
Write-Host "`n1. Test Health Check..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/actuator/health" -Method GET -TimeoutSec 30
    Write-Host "Health Check: $($response.status)" -ForegroundColor Green
} catch {
    Write-Host "Health Check: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 2: API Restaurants
Write-Host "`n2. Test API Restaurants..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/restaurants" -Method GET -TimeoutSec 30
    Write-Host "Restaurants: $($response.Count) trouves" -ForegroundColor Green
    foreach ($r in $response) {
        Write-Host "  - $($r.name) ($($r.code))" -ForegroundColor White
    }
} catch {
    Write-Host "Restaurants: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: Authentification
Write-Host "`n3. Test Authentification..." -ForegroundColor Yellow
$loginData = @{
    email = "admin@vegnbio.fr"
    password = "TestVegN2024!"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/auth/login" -Method POST -Body $loginData -ContentType "application/json" -TimeoutSec 30
    Write-Host "Authentification: Reussie" -ForegroundColor Green
    $token = $response.token
    $headers = @{ Authorization = "Bearer $token" }
    
    # Test 4: Menus avec authentification
    Write-Host "`n4. Test Menus..." -ForegroundColor Yellow
    try {
        $menus = Invoke-$RestMethod -Uri "$baseUrl/api/menus" -Method GET -Headers $headers -TimeoutSec 30
        Write-Host "Menus: $($menus.Count) trouves" -ForegroundColor Green
        foreach ($m in $menus) {
            Write-Host "  - $($m.title)" -ForegroundColor White
        }
    } catch {
        Write-Host "Menus: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    # Test 5: Evenements
    Write-Host "`n5. Test Evenements..." -ForegroundColor Yellow
    try {
        $events = Invoke-RestMethod -Uri "$baseUrl/api/events" -Method GET -Headers $headers -TimeoutSec 30
        Write-Host "Evenements: $($events.Count) trouves" -ForegroundColor Green
        foreach ($e in $events) {
            Write-Host "  - $($e.title) ($($e.type))" -ForegroundColor White
        }
    } catch {
        Write-Host "Evenements: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    # Test 6: Reservations
    Write-Host "`n6. Test Reservations..." -ForegroundColor Yellow
    try {
        $bookings = Invoke-RestMethod -Uri "$baseUrl/api/bookings" -Method GET -Headers $headers -TimeoutSec 30
        Write-Host "Reservations: $($bookings.Count) trouves" -ForegroundColor Green
        foreach ($b in $bookings) {
            Write-Host "  - $($b.customerName) ($($b.pax) personnes)" -ForegroundColor White
        }
    } catch {
        Write-Host "Reservations: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    # Test 7: Rapports
    Write-Host "`n7. Test Rapports..." -ForegroundColor Yellow
    try {
        $reports = Invoke-RestMethod -Uri "$baseUrl/api/error-reports" -Method GET -Headers $headers -TimeoutSec 30
        Write-Host "Rapports: $($reports.Count) trouves" -ForegroundColor Green
        foreach ($r in $reports) {
            Write-Host "  - $($r.errorType): $($r.description)" -ForegroundColor White
        }
    } catch {
        Write-Host "Rapports: $($_.Exception.Message)" -ForegroundColor Red
    }
    
} catch {
    Write-Host "Authentification: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nVerification terminee !" -ForegroundColor Green
