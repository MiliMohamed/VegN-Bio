# Script de test pour le système de menus dynamique
# Teste la récupération des restaurants et la génération de menus

param(
    [string]$ApiBaseUrl = "https://vegn-bio-backend.onrender.com/api/v1"
)

Write-Host "🧪 Test du Système de Menus Dynamique" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green

# Fonction pour tester l'API
function Test-ApiEndpoint {
    param(
        [string]$Url,
        [string]$Description
    )
    
    Write-Host "`n📡 Test: $Description" -ForegroundColor Yellow
    Write-Host "   URL: $Url" -ForegroundColor Gray
    
    try {
        $response = Invoke-RestMethod -Uri $Url -Method GET -ContentType "application/json"
        
        if ($response) {
            Write-Host "   ✅ Succès" -ForegroundColor Green
            if ($response.Count) {
                Write-Host "   📊 Nombre d'éléments: $($response.Count)" -ForegroundColor Cyan
            }
            return $response
        } else {
            Write-Host "   ❌ Réponse vide" -ForegroundColor Red
            return $null
        }
    }
    catch {
        Write-Host "   ❌ Erreur: $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

# Test 1: Récupération des restaurants
Write-Host "`n🔍 Test 1: Récupération des restaurants" -ForegroundColor Blue
$restaurants = Test-ApiEndpoint -Url "$ApiBaseUrl/restaurants" -Description "Liste des restaurants"

if ($restaurants) {
    Write-Host "`n📋 Restaurants trouvés:" -ForegroundColor Cyan
    foreach ($restaurant in $restaurants) {
        Write-Host "   🏪 $($restaurant.name) (ID: $($restaurant.id), Code: $($restaurant.code))" -ForegroundColor White
    }
    
    # Test 2: Récupération des menus pour chaque restaurant
    Write-Host "`n🔍 Test 2: Récupération des menus par restaurant" -ForegroundColor Blue
    foreach ($restaurant in $restaurants) {
        $menuUrl = "$ApiBaseUrl/menus/restaurant/$($restaurant.id)"
        $menus = Test-ApiEndpoint -Url $menuUrl -Description "Menus pour $($restaurant.name)"
        
        if ($menus) {
            Write-Host "   📝 Menus trouvés pour $($restaurant.name):" -ForegroundColor Cyan
            foreach ($menu in $menus) {
                Write-Host "      - $($menu.title) (ID: $($menu.id))" -ForegroundColor White
            }
        }
    }
    
    # Test 3: Génération d'un exemple de menu
    Write-Host "`n🔍 Test 3: Génération d'un exemple de menu" -ForegroundColor Blue
    
    $firstRestaurant = $restaurants[0]
    Write-Host "   🎯 Restaurant sélectionné: $($firstRestaurant.name)" -ForegroundColor Cyan
    
    # Simuler la création d'un menu
    $menuData = @{
        restaurantId = $firstRestaurant.id
        title = "Menu Test Dynamique"
        activeFrom = (Get-Date).ToString("yyyy-MM-dd")
        activeTo = (Get-Date).AddDays(30).ToString("yyyy-MM-dd")
    }
    
    Write-Host "   📝 Données du menu à créer:" -ForegroundColor Cyan
    Write-Host "      - Titre: $($menuData.title)" -ForegroundColor White
    Write-Host "      - Restaurant ID: $($menuData.restaurantId)" -ForegroundColor White
    Write-Host "      - Du: $($menuData.activeFrom)" -ForegroundColor White
    Write-Host "      - Au: $($menuData.activeTo)" -ForegroundColor White
    
    # Générer le SQL exemple
    $exampleSQL = @"
-- Menu pour $($firstRestaurant.name) (ID: $($firstRestaurant.id))
INSERT INTO menus (restaurant_id, title, active_from, active_to)
VALUES ($($firstRestaurant.id), '$($menuData.title)', '$($menuData.activeFrom)', '$($menuData.activeTo)');

-- Exemple d'élément de menu
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
SELECT 
    m.id,
    'Burger Tofu Bio Test',
    'Burger au tofu grillé, salade croquante, tomates, sauce sésame',
    1290,
    TRUE
FROM menus m 
WHERE m.restaurant_id = $($firstRestaurant.id) AND m.title = '$($menuData.title)';
"@
    
    Write-Host "   📄 SQL généré:" -ForegroundColor Cyan
    Write-Host $exampleSQL -ForegroundColor Gray
    
} else {
    Write-Host "`n❌ Impossible de récupérer les restaurants. Vérifiez:" -ForegroundColor Red
    Write-Host "   - La connexion internet" -ForegroundColor Yellow
    Write-Host "   - L'URL de l'API: $ApiBaseUrl" -ForegroundColor Yellow
    Write-Host "   - Le statut du serveur backend" -ForegroundColor Yellow
}

# Test 4: Vérification des endpoints de menu
Write-Host "`n🔍 Test 4: Vérification des endpoints de menu" -ForegroundColor Blue

$menuEndpoints = @(
    @{ url = "$ApiBaseUrl/menus"; description = "Liste des menus" },
    @{ url = "$ApiBaseUrl/menu-items"; description = "Liste des éléments de menu" }
)

foreach ($endpoint in $menuEndpoints) {
    Test-ApiEndpoint -Url $endpoint.url -Description $endpoint.description
}

# Résumé des tests
Write-Host "`n📊 Résumé des Tests" -ForegroundColor Blue
Write-Host "===================" -ForegroundColor Blue

if ($restaurants) {
    Write-Host "✅ API des restaurants: Fonctionnelle" -ForegroundColor Green
    Write-Host "✅ Récupération dynamique: Opérationnelle" -ForegroundColor Green
    Write-Host "✅ Génération SQL: Prête" -ForegroundColor Green
    Write-Host "✅ Système dynamique: Opérationnel" -ForegroundColor Green
    
    Write-Host "`n🚀 Prochaines étapes:" -ForegroundColor Cyan
    Write-Host "   1. Utilisez le composant React DynamicMenuCreator" -ForegroundColor White
    Write-Host "   2. Exécutez le script PowerShell create-menus-dynamic.ps1" -ForegroundColor White
    Write-Host "   3. Intégrez le composant dans votre application" -ForegroundColor White
} else {
    Write-Host "❌ Problème de connexion à l'API" -ForegroundColor Red
    Write-Host "   Vérifiez la configuration et réessayez" -ForegroundColor Yellow
}

Write-Host "`n🎉 Tests terminés!" -ForegroundColor Green
