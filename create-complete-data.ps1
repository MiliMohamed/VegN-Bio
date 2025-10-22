# Script complet pour creer 3 utilisateurs et remplir toutes les donnees VEG'N BIO
Write-Host "Creation complete des donnees VEG'N BIO" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

$baseUrl = "http://localhost:8080/api"

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
            $response = Invoke-RestMethod -Uri $Url -Method $Method -Headers $Headers -Body $Body -ContentType "application/json"
        } else {
            $response = Invoke-RestMethod -Uri $Url -Method $Method -Headers $headers
        }
        return $response
    } catch {
        Write-Host "Erreur API: $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

# Test de connexion
Write-Host "`nTest de connexion a l'API..." -ForegroundColor Yellow
$testResponse = Invoke-ApiRequest -Url "$baseUrl/restaurants"
if ($testResponse) {
    Write-Host "✅ API accessible - $($testResponse.Count) restaurants trouves" -ForegroundColor Green
} else {
    Write-Host "❌ API non accessible" -ForegroundColor Red
    exit 1
}

# Authentification admin
Write-Host "`nAuthentification admin..." -ForegroundColor Yellow
$loginData = @{
    email = "admin@vegnbio.fr"
    password = "TestVegN2024!"
} | ConvertTo-Json

$authResponse = Invoke-ApiRequest -Url "$baseUrl/auth/login" -Method "POST" -Body $loginData
if ($authResponse) {
    $token = $authResponse.token
    $headers = @{ Authorization = "Bearer $token" }
    Write-Host "✅ Authentification admin reussie" -ForegroundColor Green
} else {
    Write-Host "❌ Erreur authentification admin" -ForegroundColor Red
    exit 1
}

# 1. CREATION DES UTILISATEURS
Write-Host "`n1. Creation des utilisateurs..." -ForegroundColor Yellow

$users = @(
    @{
        email = "admin@vegnbio.fr"
        password = "TestVegN2024!"
        fullName = "Administrateur VEGN BIO"
        role = "ADMIN"
    },
    @{
        email = "client@vegnbio.fr"
        password = "TestVegN2024!"
        fullName = "Client Test VEGN BIO"
        role = "CLIENT"
    },
    @{
        email = "restaurateur@vegnbio.fr"
        password = "TestVegN2024!"
        fullName = "Restaurateur VEGN BIO"
        role = "RESTAURATEUR"
    }
)

foreach ($user in $users) {
    $userData = @{
        email = $user.email
        password = $user.password
        fullName = $user.fullName
        role = $user.role
    } | ConvertTo-Json
    
    $userResponse = Invoke-ApiRequest -Url "$baseUrl/auth/register" -Method "POST" -Body $userData
    if ($userResponse) {
        Write-Host "✅ Utilisateur $($user.role) cree: $($user.email)" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Utilisateur $($user.role) peut-etre deja existant: $($user.email)" -ForegroundColor Yellow
    }
}

# 2. REMPLISSAGE DES MENUS ET PLATS
Write-Host "`n2. Creation des menus et plats..." -ForegroundColor Yellow

$restaurants = Invoke-ApiRequest -Url "$baseUrl/restaurants" -Headers $headers
if ($restaurants) {
    foreach ($restaurant in $restaurants) {
        Write-Host "`nRestaurant: $($restaurant.name)" -ForegroundColor Cyan
        
        # Menu Principal
        $menuData = @{
            title = "Menu Principal $($restaurant.name)"
            activeFrom = (Get-Date).ToString("yyyy-MM-dd")
            activeTo = (Get-Date).AddDays(90).ToString("yyyy-MM-dd")
        } | ConvertTo-Json
        
        $menuResponse = Invoke-ApiRequest -Url "$baseUrl/menus/restaurant/$($restaurant.id)" -Method "POST" -Headers $headers -Body $menuData
        if ($menuResponse) {
            Write-Host "  ✅ Menu Principal cree" -ForegroundColor Green
            
            # Plats pour le menu principal
            $plats = @(
                @{ name = "Burger Tofu Bio"; description = "Burger aux legumes grilles, tofu marine, salade croquante"; priceCents = 1590; isVegan = $true },
                @{ name = "Salade Quinoa"; description = "Quinoa bio, legumes de saison, noix, vinaigrette citron"; priceCents = 1290; isVegan = $true },
                @{ name = "Curry de Legumes"; description = "Curry aux legumes bio, riz complet, lait de coco"; priceCents = 1490; isVegan = $true },
                @{ name = "Pizza Margherita Vegetale"; description = "Pate fine, tomates, mozzarella vegetale, basilic"; priceCents = 1690; isVegan = $true },
                @{ name = "Lasagnes Vegetales"; description = "Lasagnes aux legumes, bechamel vegetale, parmesan vegetal"; priceCents = 1790; isVegan = $true }
            )
            
            foreach ($plat in $plats) {
                $platData = $plat | ConvertTo-Json
                $platResponse = Invoke-ApiRequest -Url "$baseUrl/menu-items/menu/$($menuResponse.id)" -Method "POST" -Headers $headers -Body $platData
                if ($platResponse) {
                    Write-Host "    • $($plat.name) - $($plat.priceCents/100)€" -ForegroundColor White
                }
            }
        }
        
        # Menu Dejeuner
        $menuDejeunerData = @{
            title = "Menu Dejeuner $($restaurant.name)"
            activeFrom = (Get-Date).ToString("yyyy-MM-dd")
            activeTo = (Get-Date).AddDays(90).ToString("yyyy-MM-dd")
        } | ConvertTo-Json
        
        $menuDejeunerResponse = Invoke-ApiRequest -Url "$baseUrl/menus/restaurant/$($restaurant.id)" -Method "POST" -Headers $headers -Body $menuDejeunerData
        if ($menuDejeunerResponse) {
            Write-Host "  ✅ Menu Dejeuner cree" -ForegroundColor Green
            
            # Plats pour le menu dejeuner
            $platsDejeuner = @(
                @{ name = "Soupe Courge"; description = "Veloute de courge bio, graines de courge"; priceCents = 890; isVegan = $true },
                @{ name = "Wrap Avocat"; description = "Wrap aux legumes, avocat, hummus, pousses"; priceCents = 1190; isVegan = $true },
                @{ name = "Bowl Buddha"; description = "Riz brun, legumes grilles, avocat, graines, tahini"; priceCents = 1290; isVegan = $true }
            )
            
            foreach ($plat in $platsDejeuner) {
                $platData = $plat | ConvertTo-Json
                $platResponse = Invoke-ApiRequest -Url "$baseUrl/menu-items/menu/$($menuDejeunerResponse.id)" -Method "POST" -Headers $headers -Body $platData
                if ($platResponse) {
                    Write-Host "    • $($plat.name) - $($plat.priceCents/100)€" -ForegroundColor White
                }
            }
        }
    }
}

# 3. CREATION DES EVENEMENTS
Write-Host "`n3. Creation des evenements..." -ForegroundColor Yellow

foreach ($restaurant in $restaurants) {
    Write-Host "`nEvenements pour: $($restaurant.name)" -ForegroundColor Cyan
    
    # Evenements par restaurant
    $evenements = @(
        @{ title = "Conference Mardi"; type = "CONFERENCE"; description = "Conference hebdomadaire du mardi apres-midi"; capacity = 30 },
        @{ title = "Animation Culinaire"; type = "ANIMATION"; description = "Animation culinaire bio"; capacity = 20 },
        @{ title = "Reunion Equipe"; type = "REUNION"; description = "Reunion d'equipe mensuelle"; capacity = 15 },
        @{ title = "Formation Produits Bio"; type = "FORMATION"; description = "Formation sur les produits bio"; capacity = 25 },
        @{ title = "Atelier Cuisine"; type = "ATELIER"; description = "Atelier de cuisine vegetarienne"; capacity = 12 }
    )
    
    foreach ($evenement in $evenements) {
        $eventData = @{
            title = $evenement.title
            type = $evenement.type
            dateStart = (Get-Date).AddDays(7).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
            dateEnd = (Get-Date).AddDays(7).AddHours(2).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
            capacity = $evenement.capacity
            description = $evenement.description
        } | ConvertTo-Json
        
        $eventResponse = Invoke-ApiRequest -Url "$baseUrl/events/restaurant/$($restaurant.id)" -Method "POST" -Headers $headers -Body $eventData
        if ($eventResponse) {
            Write-Host "  ✅ $($evenement.title) - $($evenement.type)" -ForegroundColor Green
        }
    }
}

# 4. CREATION DES RESERVATIONS
Write-Host "`n4. Creation des reservations..." -ForegroundColor Yellow

# Recuperer les evenements crees
$events = Invoke-ApiRequest -Url "$baseUrl/events" -Headers $headers
if ($events) {
    $reservations = @(
        @{ customerName = "Marie Dupont"; customerPhone = "+33 6 12 34 56 78"; pax = 2; status = "CONFIRMED" },
        @{ customerName = "Jean Martin"; customerPhone = "+33 6 87 65 43 21"; pax = 1; status = "PENDING" },
        @{ customerName = "Sophie Bernard"; customerPhone = "+33 6 11 22 33 44"; pax = 3; status = "CONFIRMED" },
        @{ customerName = "Pierre Durand"; customerPhone = "+33 6 55 66 77 88"; pax = 4; status = "PENDING" },
        @{ customerName = "Claire Moreau"; customerPhone = "+33 6 99 88 77 66"; pax = 2; status = "CONFIRMED" }
    )
    
    for ($i = 0; $i -lt [Math]::Min($events.Count, $reservations.Count); $i++) {
        $reservation = $reservations[$i]
        $event = $events[$i]
        
        $bookingData = @{
            customerName = $reservation.customerName
            customerPhone = $reservation.customerPhone
            pax = $reservation.pax
            status = $reservation.status
        } | ConvertTo-Json
        
        $bookingResponse = Invoke-ApiRequest -Url "$baseUrl/bookings/event/$($event.id)" -Method "POST" -Headers $headers -Body $bookingData
        if ($bookingResponse) {
            Write-Host "  ✅ Reservation: $($reservation.customerName) - $($reservation.pax) personnes" -ForegroundColor Green
        }
    }
}

# 5. CREATION DES RAPPORTS
Write-Host "`n5. Creation des rapports..." -ForegroundColor Yellow

$reports = @(
    @{ errorType = "Allergene"; description = "Le plat Burger Tofu Bio contient du sesame mais ce n'est pas mentionne clairement"; userId = "client@vegnbio.fr" },
    @{ errorType = "Menu"; description = "Besoin d'ajouter plus d'options sans gluten au menu"; userId = "restaurateur@vegnbio.fr" },
    @{ errorType = "Systeme"; description = "Amelioration de l'interface de reservation des salles"; userId = "admin@vegnbio.fr" },
    @{ errorType = "Service"; description = "Le service etait excellent, merci pour l'experience"; userId = "client@vegnbio.fr" },
    @{ errorType = "Produit"; description = "Les produits bio sont de tres bonne qualite"; userId = "client@vegnbio.fr" }
)

foreach ($report in $reports) {
    $reportData = $report | ConvertTo-Json
    $reportResponse = Invoke-ApiRequest -Url "$baseUrl/error-reports" -Method "POST" -Headers $headers -Body $reportData
    if ($reportResponse) {
        Write-Host "  ✅ Rapport: $($report.errorType) - $($report.userId)" -ForegroundColor Green
    }
}

# 6. VERIFICATION FINALE
Write-Host "`n6. Verification finale des donnees..." -ForegroundColor Yellow

# Menus
$menus = Invoke-ApiRequest -Url "$baseUrl/menus" -Headers $headers
Write-Host "✅ Menus crees: $($menus.Count)" -ForegroundColor Green

# Evenements
$events = Invoke-ApiRequest -Url "$baseUrl/events" -Headers $headers
Write-Host "✅ Evenements crees: $($events.Count)" -ForegroundColor Green

# Reservations
$bookings = Invoke-ApiRequest -Url "$baseUrl/bookings" -Headers $headers
Write-Host "✅ Reservations creees: $($bookings.Count)" -ForegroundColor Green

# Rapports
$reports = Invoke-ApiRequest -Url "$baseUrl/error-reports" -Headers $headers
Write-Host "✅ Rapports crees: $($reports.Count)" -ForegroundColor Green

Write-Host "`n🎉 CREATION COMPLETE TERMINEE !" -ForegroundColor Green
Write-Host "===============================" -ForegroundColor Green

Write-Host "`n📊 Donnees creees:" -ForegroundColor Cyan
Write-Host "- 3 utilisateurs (Admin, Client, Restaurateur)" -ForegroundColor White
Write-Host "- Menus et plats pour chaque restaurant" -ForegroundColor White
Write-Host "- Evenements et conferences" -ForegroundColor White
Write-Host "- Reservations de salles" -ForegroundColor White
Write-Host "- Rapports et signalements" -ForegroundColor White

Write-Host "`n👥 Comptes de test:" -ForegroundColor Cyan
Write-Host "- Admin: admin@vegnbio.fr / TestVegN2024!" -ForegroundColor White
Write-Host "- Client: client@vegnbio.fr / TestVegN2024!" -ForegroundColor White
Write-Host "- Restaurateur: restaurateur@vegnbio.fr / TestVegN2024!" -ForegroundColor White

Write-Host "`n🌐 Acces aux applications:" -ForegroundColor Cyan
Write-Host "- Frontend: http://localhost:3000" -ForegroundColor White
Write-Host "- Backend API: http://localhost:8080/api" -ForegroundColor White
Write-Host "- Documentation: http://localhost:8080/swagger-ui.html" -ForegroundColor White

Write-Host "`n🚀 VOTRE APPLICATION VEG'N BIO EST COMPLETE !" -ForegroundColor Green

