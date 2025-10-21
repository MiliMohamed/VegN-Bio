# Test de la base de données de production VegN-Bio
Write-Host "Test de la base de données de production" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Heure: $(Get-Date)" -ForegroundColor Gray
Write-Host ""

$BaseUrl = "https://vegn-bio-backend.onrender.com/api/v1"

# Test 1: Vérifier la connectivité générale
Write-Host "1. Test de connectivité générale" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$BaseUrl/restaurants" -Method GET -ErrorAction Stop
    Write-Host "SUCCESS - Backend accessible" -ForegroundColor Green
    Write-Host "Restaurants trouvés: $($response.Count)" -ForegroundColor Gray
} catch {
    Write-Host "ERROR - Backend inaccessible: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 2: Vérifier les données des restaurants
Write-Host "`n2. Test des données restaurants" -ForegroundColor Yellow
try {
    $restaurants = Invoke-RestMethod -Uri "$BaseUrl/restaurants" -Method GET -ErrorAction Stop
    
    Write-Host "Restaurants en base:" -ForegroundColor White
    foreach ($restaurant in $restaurants) {
        Write-Host "  - $($restaurant.name) ($($restaurant.code)) - $($restaurant.city)" -ForegroundColor Gray
    }
    
    Write-Host "`nDétails du premier restaurant:" -ForegroundColor White
    $firstRestaurant = $restaurants[0]
    Write-Host "  ID: $($firstRestaurant.id)" -ForegroundColor Gray
    Write-Host "  Nom: $($firstRestaurant.name)" -ForegroundColor Gray
    Write-Host "  Code: $($firstRestaurant.code)" -ForegroundColor Gray
    Write-Host "  Adresse: $($firstRestaurant.address)" -ForegroundColor Gray
    Write-Host "  Ville: $($firstRestaurant.city)" -ForegroundColor Gray
    Write-Host "  Téléphone: $($firstRestaurant.phone)" -ForegroundColor Gray
    Write-Host "  Email: $($firstRestaurant.email)" -ForegroundColor Gray
    
} catch {
    Write-Host "ERROR - Impossible de récupérer les restaurants: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: Vérifier les allergènes
Write-Host "`n3. Test des données allergènes" -ForegroundColor Yellow
try {
    $allergens = Invoke-RestMethod -Uri "$BaseUrl/allergens" -Method GET -ErrorAction Stop
    
    Write-Host "Allergènes en base:" -ForegroundColor White
    foreach ($allergen in $allergens) {
        Write-Host "  - $($allergen.code): $($allergen.label)" -ForegroundColor Gray
    }
    
} catch {
    Write-Host "ERROR - Impossible de récupérer les allergènes: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 4: Vérifier les événements
Write-Host "`n4. Test des données événements" -ForegroundColor Yellow
try {
    $events = Invoke-RestMethod -Uri "$BaseUrl/events" -Method GET -ErrorAction Stop
    
    Write-Host "Événements en base: $($events.Count)" -ForegroundColor White
    if ($events.Count -gt 0) {
        foreach ($event in $events) {
            Write-Host "  - $($event.title) - $($event.startTime)" -ForegroundColor Gray
        }
    } else {
        Write-Host "  Aucun événement trouvé" -ForegroundColor Gray
    }
    
} catch {
    Write-Host "ERROR - Impossible de récupérer les événements: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 5: Vérifier les fournisseurs
Write-Host "`n5. Test des données fournisseurs" -ForegroundColor Yellow
try {
    $suppliers = Invoke-RestMethod -Uri "$BaseUrl/suppliers" -Method GET -ErrorAction Stop
    
    Write-Host "Fournisseurs en base: $($suppliers.Count)" -ForegroundColor White
    foreach ($supplier in $suppliers) {
        Write-Host "  - $($supplier.name) - $($supplier.specialty)" -ForegroundColor Gray
    }
    
} catch {
    Write-Host "ERROR - Impossible de récupérer les fournisseurs: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 6: Vérifier les offres
Write-Host "`n6. Test des données offres" -ForegroundColor Yellow
try {
    $offers = Invoke-RestMethod -Uri "$BaseUrl/offers" -Method GET -ErrorAction Stop
    
    Write-Host "Offres en base: $($offers.Count)" -ForegroundColor White
    foreach ($offer in $offers) {
        Write-Host "  - $($offer.title) - $($offer.priceCents) centimes" -ForegroundColor Gray
    }
    
} catch {
    Write-Host "ERROR - Impossible de récupérer les offres: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 7: Vérifier les menus
Write-Host "`n7. Test des données menus" -ForegroundColor Yellow
try {
    $menus = Invoke-RestMethod -Uri "$BaseUrl/menus" -Method GET -ErrorAction Stop
    
    Write-Host "Menus en base: $($menus.Count)" -ForegroundColor White
    foreach ($menu in $menus) {
        Write-Host "  - $($menu.title) - Du $($menu.activeFrom) au $($menu.activeTo)" -ForegroundColor Gray
        if ($menu.menuItems) {
            Write-Host "    Items: $($menu.menuItems.Count)" -ForegroundColor Gray
        }
    }
    
} catch {
    Write-Host "ERROR - Impossible de récupérer les menus: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 8: Vérifier les réservations
Write-Host "`n8. Test des données réservations" -ForegroundColor Yellow
try {
    $bookings = Invoke-RestMethod -Uri "$BaseUrl/bookings" -Method GET -ErrorAction Stop
    
    Write-Host "Réservations en base: $($bookings.Count)" -ForegroundColor White
    foreach ($booking in $bookings) {
        Write-Host "  - Réservation $($booking.id) - $($booking.status)" -ForegroundColor Gray
    }
    
} catch {
    Write-Host "ERROR - Impossible de récupérer les réservations: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 9: Vérifier les avis
Write-Host "`n9. Test des données avis" -ForegroundColor Yellow
try {
    $reviews = Invoke-RestMethod -Uri "$BaseUrl/reviews" -Method GET -ErrorAction Stop
    
    Write-Host "Avis en base: $($reviews.Count)" -ForegroundColor White
    foreach ($review in $reviews) {
        Write-Host "  - Avis $($review.id) - Note: $($review.rating)/5" -ForegroundColor Gray
    }
    
} catch {
    Write-Host "ERROR - Impossible de récupérer les avis: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 10: Test d'authentification (après correction CORS)
Write-Host "`n10. Test d'authentification" -ForegroundColor Yellow
try {
    $loginBody = @{
        email = "admin@vegnbio.com"
        password = "AdminVegN2024!"
    } | ConvertTo-Json
    
    $authResponse = Invoke-RestMethod -Uri "$BaseUrl/auth/login" -Method POST -ContentType "application/json" -Body $loginBody -ErrorAction Stop
    
    if ($authResponse.token) {
        Write-Host "SUCCESS - Authentification fonctionne!" -ForegroundColor Green
        Write-Host "Token obtenu: $($authResponse.token.Substring(0,30))..." -ForegroundColor Gray
        
        # Test endpoint protégé
        try {
            $headers = @{ "Authorization" = "Bearer $($authResponse.token)" }
            $meResponse = Invoke-RestMethod -Uri "$BaseUrl/auth/me" -Method GET -Headers $headers -ErrorAction Stop
            Write-Host "Utilisateur connecté: $($meResponse.fullName) ($($meResponse.role))" -ForegroundColor Gray
        } catch {
            Write-Host "ERROR - Endpoint protégé échoué: $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        Write-Host "WARNING - Pas de token dans la réponse" -ForegroundColor Yellow
    }
} catch {
    Write-Host "ERROR - Authentification échouée: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nRésumé de l'état de la base de données" -ForegroundColor Magenta
Write-Host "=====================================" -ForegroundColor Magenta
Write-Host "La base de données vegn-bio-database semble être:" -ForegroundColor White
Write-Host "- Accessible via l'API backend" -ForegroundColor Gray
Write-Host "- Contient des données de test/seed" -ForegroundColor Gray
Write-Host "- Prête pour les tests et le développement" -ForegroundColor Gray
