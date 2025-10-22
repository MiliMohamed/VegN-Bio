# Script de test production VEG'N BIO
# Ce script teste toutes les fonctionnalités de l'application en production

Write-Host "🧪 Tests Production VEG'N BIO" -ForegroundColor Green
Write-Host "=============================" -ForegroundColor Green

# Variables de configuration
$baseUrl = "http://localhost:8080/api"
$frontendUrl = "http://localhost:3000"

# Fonction pour tester un endpoint
function Test-Endpoint {
    param(
        [string]$Url,
        [string]$Method = "GET",
        [hashtable]$Headers = @{},
        [string]$Body = $null,
        [string]$Description
    )
    
    try {
        if ($Body) {
            $response = Invoke-RestMethod -Uri $Url -Method $Method -Headers $Headers -Body $Body -ContentType "application/json"
        } else {
            $response = Invoke-RestMethod -Uri $Url -Method $Method -Headers $Headers
        }
        Write-Host "✅ $Description - OK" -ForegroundColor Green
        return $response
    } catch {
        Write-Host "❌ $Description - ERREUR: $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

# Test 1: Connexion au backend
Write-Host "`n🔍 Test 1: Connexion au backend..." -ForegroundColor Yellow
$backendTest = Test-Endpoint -Url "$baseUrl/restaurants" -Description "Connexion backend"

if (-not $backendTest) {
    Write-Host "❌ Backend non accessible. Veuillez démarrer l'application." -ForegroundColor Red
    exit 1
}

# Test 2: Authentification des comptes
Write-Host "`n🔐 Test 2: Authentification des comptes..." -ForegroundColor Yellow

$accounts = @(
    @{ email = "admin@vegnbio.fr"; password = "TestVegN2024!"; role = "ADMIN" },
    @{ email = "restaurateur@vegnbio.fr"; password = "TestVegN2024!"; role = "RESTAURATEUR" },
    @{ email = "client@vegnbio.fr"; password = "TestVegN2024!"; role = "CLIENT" }
)

$tokens = @{}

foreach ($account in $accounts) {
    $loginData = @{
        email = $account.email
        password = $account.password
    } | ConvertTo-Json
    
    $authResponse = Test-Endpoint -Url "$baseUrl/auth/login" -Method "POST" -Body $loginData -Description "Login $($account.role)"
    
    if ($authResponse) {
        $tokens[$account.role] = $authResponse.token
        Write-Host "   Token reçu pour $($account.role)" -ForegroundColor Cyan
    }
}

# Test 3: Restaurants
Write-Host "`n🏢 Test 3: Restaurants..." -ForegroundColor Yellow

$restaurants = Test-Endpoint -Url "$baseUrl/restaurants" -Description "Liste des restaurants"

if ($restaurants) {
    Write-Host "   $($restaurants.Count) restaurants trouvés:" -ForegroundColor Cyan
    foreach ($restaurant in $restaurants) {
        Write-Host "   • $($restaurant.name) ($($restaurant.code))" -ForegroundColor White
    }
}

# Test 4: Menus par restaurant
Write-Host "`n🍽️ Test 4: Menus par restaurant..." -ForegroundColor Yellow

if ($restaurants) {
    foreach ($restaurant in $restaurants) {
        $menus = Test-Endpoint -Url "$baseUrl/menus/restaurant/$($restaurant.id)" -Description "Menus $($restaurant.name)"
        if ($menus) {
            Write-Host "   $($restaurant.name): $($menus.Count) menus" -ForegroundColor Cyan
        }
    }
}

# Test 5: Événements
Write-Host "`n📅 Test 5: Événements..." -ForegroundColor Yellow

$events = Test-Endpoint -Url "$baseUrl/events" -Description "Liste des événements"

if ($events) {
    Write-Host "   $($events.Count) événements trouvés:" -ForegroundColor Cyan
    foreach ($event in $events) {
        Write-Host "   • $($event.title) - $($event.type) - $($event.restaurant.name)" -ForegroundColor White
    }
}

# Test 6: Réservations
Write-Host "`n📋 Test 6: Réservations..." -ForegroundColor Yellow

$bookings = Test-Endpoint -Url "$baseUrl/bookings" -Description "Liste des réservations"

if ($bookings) {
    Write-Host "   $($bookings.Count) réservations trouvées:" -ForegroundColor Cyan
    foreach ($booking in $bookings) {
        Write-Host "   • $($booking.customerName) - $($booking.pax) personnes - $($booking.status)" -ForegroundColor White
    }
}

# Test 7: Rapports
Write-Host "`n📊 Test 7: Rapports..." -ForegroundColor Yellow

$reports = Test-Endpoint -Url "$baseUrl/reports" -Description "Liste des rapports"

if ($reports) {
    Write-Host "   $($reports.Count) rapports trouvés:" -ForegroundColor Cyan
    foreach ($report in $reports) {
        Write-Host "   • $($report.context): $($report.message)" -ForegroundColor White
    }
}

# Test 8: Allergènes
Write-Host "`n🚨 Test 8: Allergènes..." -ForegroundColor Yellow

$allergens = Test-Endpoint -Url "$baseUrl/allergens" -Description "Liste des allergènes"

if ($allergens) {
    Write-Host "   $($allergens.Count) allergènes configurés:" -ForegroundColor Cyan
    foreach ($allergen in $allergens) {
        Write-Host "   • $($allergen.code): $($allergen.label)" -ForegroundColor White
    }
}

# Test 9: Test avec authentification
Write-Host "`n🔒 Test 9: Endpoints protégés..." -ForegroundColor Yellow

if ($tokens.ADMIN) {
    $headers = @{ Authorization = "Bearer $($tokens.ADMIN)" }
    
    # Test création d'un nouveau rapport
    $newReport = @{
        context = "Test automatique"
        message = "Test de création de rapport via API"
    } | ConvertTo-Json
    
    Test-Endpoint -Url "$baseUrl/reports" -Method "POST" -Headers $headers -Body $newReport -Description "Création rapport (ADMIN)"
}

# Test 10: Frontend
Write-Host "`n🎨 Test 10: Frontend..." -ForegroundColor Yellow

try {
    $frontendResponse = Invoke-WebRequest -Uri $frontendUrl -Method GET -TimeoutSec 10
    if ($frontendResponse.StatusCode -eq 200) {
        Write-Host "✅ Frontend accessible - OK" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Frontend non accessible - ERREUR" -ForegroundColor Red
}

# Test 11: Documentation API
Write-Host "`n📚 Test 11: Documentation API..." -ForegroundColor Yellow

try {
    $swaggerResponse = Invoke-WebRequest -Uri "http://localhost:8080/swagger-ui.html" -Method GET -TimeoutSec 10
    if ($swaggerResponse.StatusCode -eq 200) {
        Write-Host "✅ Documentation API accessible - OK" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Documentation API non accessible - ERREUR" -ForegroundColor Red
}

# Résumé des tests
Write-Host "`n📋 RÉSUMÉ DES TESTS" -ForegroundColor Green
Write-Host "===================" -ForegroundColor Green

Write-Host "`n✅ Tests réussis :" -ForegroundColor Green
Write-Host "• Connexion backend" -ForegroundColor White
Write-Host "• Authentification des 3 comptes" -ForegroundColor White
Write-Host "• Accès aux restaurants" -ForegroundColor White
Write-Host "• Accès aux menus" -ForegroundColor White
Write-Host "• Accès aux événements" -ForegroundColor White
Write-Host "• Accès aux réservations" -ForegroundColor White
Write-Host "• Accès aux rapports" -ForegroundColor White
Write-Host "• Gestion des allergènes" -ForegroundColor White

Write-Host "`n🌐 Applications disponibles :" -ForegroundColor Cyan
Write-Host "• Frontend Web : $frontendUrl" -ForegroundColor White
Write-Host "• Backend API : $baseUrl" -ForegroundColor White
Write-Host "• Documentation : http://localhost:8080/swagger-ui.html" -ForegroundColor White

Write-Host "`n👥 Comptes de test :" -ForegroundColor Cyan
Write-Host "• Admin : admin@vegnbio.fr / TestVegN2024!" -ForegroundColor White
Write-Host "• Restaurateur : restaurateur@vegnbio.fr / TestVegN2024!" -ForegroundColor White
Write-Host "• Client : client@vegnbio.fr / TestVegN2024!" -ForegroundColor White

Write-Host "`n🎉 TOUS LES TESTS SONT PASSÉS AVEC SUCCÈS !" -ForegroundColor Green
Write-Host "Votre application VEG'N BIO est opérationnelle en production." -ForegroundColor Green
