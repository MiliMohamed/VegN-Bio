# Test simple et direct des endpoints
Write-Host "Test des endpoints VegN-Bio Backend" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green

# Test 1: Endpoints publics
Write-Host "`n1. Test des endpoints publics:" -ForegroundColor Yellow

# Restaurants
try {
    $restaurants = Invoke-RestMethod -Uri "https://vegn-bio-backend.onrender.com/api/v1/restaurants" -Method GET
    Write-Host "✅ Restaurants: $($restaurants.Count) trouvés" -ForegroundColor Green
} catch {
    Write-Host "❌ Restaurants: Erreur" -ForegroundColor Red
}

# Allergènes
try {
    $allergens = Invoke-RestMethod -Uri "https://vegn-bio-backend.onrender.com/api/v1/allergens" -Method GET
    Write-Host "✅ Allergènes: $($allergens.Count) trouvés" -ForegroundColor Green
} catch {
    Write-Host "❌ Allergènes: Erreur" -ForegroundColor Red
}

# Événements
try {
    $events = Invoke-RestMethod -Uri "https://vegn-bio-backend.onrender.com/api/v1/events" -Method GET
    Write-Host "✅ Événements: $($events.Count) trouvés" -ForegroundColor Green
} catch {
    Write-Host "❌ Événements: Erreur" -ForegroundColor Red
}

# Test 2: Authentification
Write-Host "`n2. Test de l'authentification:" -ForegroundColor Yellow

try {
    $loginData = @{
        email = "admin@vegnbio.com"
        password = "AdminVegN2024!"
    } | ConvertTo-Json
    
    $authResponse = Invoke-RestMethod -Uri "https://vegn-bio-backend.onrender.com/api/v1/auth/login" -Method POST -ContentType "application/json" -Body $loginData
    
    if ($authResponse.token) {
        Write-Host "✅ Authentification réussie!" -ForegroundColor Green
        Write-Host "Token: $($authResponse.token.Substring(0,20))..." -ForegroundColor Gray
        
        # Test endpoint protégé
        try {
            $headers = @{ "Authorization" = "Bearer $($authResponse.token)" }
            $meResponse = Invoke-RestMethod -Uri "https://vegn-bio-backend.onrender.com/api/v1/auth/me" -Method GET -Headers $headers
            Write-Host "✅ Endpoint protégé /auth/me fonctionne" -ForegroundColor Green
        } catch {
            Write-Host "❌ Endpoint protégé /auth/me échoué" -ForegroundColor Red
        }
    } else {
        Write-Host "❌ Pas de token dans la réponse" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Authentification échouée: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: Endpoints précédemment bloqués
Write-Host "`n3. Test des endpoints précédemment bloqués:" -ForegroundColor Yellow

# Menus
try {
    $menus = Invoke-RestMethod -Uri "https://vegn-bio-backend.onrender.com/api/v1/menus" -Method GET
    Write-Host "✅ Menus: $($menus.Count) trouvés" -ForegroundColor Green
} catch {
    Write-Host "❌ Menus: Erreur" -ForegroundColor Red
}

# Réservations
try {
    $bookings = Invoke-RestMethod -Uri "https://vegn-bio-backend.onrender.com/api/v1/bookings" -Method GET
    Write-Host "✅ Réservations: $($bookings.Count) trouvées" -ForegroundColor Green
} catch {
    Write-Host "❌ Réservations: Erreur" -ForegroundColor Red
}

# Restaurant par ID
try {
    $restaurant = Invoke-RestMethod -Uri "https://vegn-bio-backend.onrender.com/api/v1/restaurants/1" -Method GET
    Write-Host "✅ Restaurant ID 1: $($restaurant.name)" -ForegroundColor Green
} catch {
    Write-Host "❌ Restaurant ID 1: Erreur" -ForegroundColor Red
}

Write-Host "`nTest terminé!" -ForegroundColor Green
