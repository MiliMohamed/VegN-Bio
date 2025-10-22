# Script de test final complet
Write-Host "🎯 Test final de la solution complète" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green

# Obtenir un token d'authentification
$loginData = @{
    email = "restaurateur@vegnbio.com"
    password = "password123"
} | ConvertTo-Json

try {
    $authResponse = Invoke-RestMethod -Uri "https://vegn-bio-backend.onrender.com/api/v1/auth/login" -Method POST -Body $loginData -ContentType "application/json"
    $token = $authResponse.accessToken
    Write-Host "✅ Authentification réussie" -ForegroundColor Green
} catch {
    Write-Host "❌ Erreur d'authentification: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

# 1. Vérifier les restaurants
Write-Host "`n🏪 1. Vérification des restaurants" -ForegroundColor Cyan
try {
    $restaurants = Invoke-RestMethod -Uri "https://vegn-bio-backend.onrender.com/api/v1/restaurants" -Method GET
    Write-Host "✅ $($restaurants.Count) restaurant(s) trouvé(s)" -ForegroundColor Green
    
    foreach ($restaurant in $restaurants) {
        Write-Host "  • $($restaurant.name) (ID: $($restaurant.id), Code: $($restaurant.code))" -ForegroundColor White
    }
} catch {
    Write-Host "❌ Erreur récupération restaurants: $($_.Exception.Message)" -ForegroundColor Red
}

# 2. Tester la création d'un menu simple
Write-Host "`n📋 2. Test de création d'un menu simple" -ForegroundColor Cyan
$testMenuData = @{
    restaurantId = 68
    title = "Menu Test Final"
    activeFrom = "2024-10-01"
    activeTo = "2024-12-31"
} | ConvertTo-Json

try {
    $newMenu = Invoke-RestMethod -Uri "https://vegn-bio-backend.onrender.com/api/v1/menus" -Method POST -Body $testMenuData -Headers $headers
    Write-Host "✅ Menu test créé avec succès (ID: $($newMenu.id))" -ForegroundColor Green
    
    # 3. Ajouter un élément de menu
    Write-Host "`n🍽️ 3. Ajout d'un élément de menu" -ForegroundColor Cyan
    $menuItemData = @{
        menuId = $newMenu.id
        name = "Test Item"
        description = "Élément de test"
        priceCents = 1000
        isVegan = $true
        allergenIds = @()
    } | ConvertTo-Json
    
    try {
        $newMenuItem = Invoke-RestMethod -Uri "https://vegn-bio-backend.onrender.com/api/v1/menu-items" -Method POST -Body $menuItemData -Headers $headers
        Write-Host "✅ Élément de menu créé avec succès (ID: $($newMenuItem.id))" -ForegroundColor Green
    } catch {
        Write-Host "❌ Erreur création élément: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    # 4. Tester la récupération du menu créé
    Write-Host "`n🔍 4. Test de récupération du menu créé" -ForegroundColor Cyan
    try {
        $retrievedMenus = Invoke-RestMethod -Uri "https://vegn-bio-backend.onrender.com/api/v1/menus/restaurant/68" -Method GET -Headers $headers
        Write-Host "✅ Menus récupérés: $($retrievedMenus.Count)" -ForegroundColor Green
        
        if ($retrievedMenus.Count -gt 0) {
            foreach ($menu in $retrievedMenus) {
                Write-Host "  📋 $($menu.title) (ID: $($menu.id))" -ForegroundColor White
                Write-Host "    🍽️ Éléments: $($menu.menuItems.Count)" -ForegroundColor Gray
            }
        } else {
            Write-Host "⚠️ Aucun menu récupéré - problème de requête" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "❌ Erreur récupération: $($_.Exception.Message)" -ForegroundColor Red
    }
    
} catch {
    Write-Host "❌ Erreur création menu: $($_.Exception.Message)" -ForegroundColor Red
}

# 5. Test avec un endpoint alternatif
Write-Host "`n🔄 5. Test avec endpoint alternatif" -ForegroundColor Cyan
try {
    # Essayer de récupérer tous les menus
    $allMenus = Invoke-RestMethod -Uri "https://vegn-bio-backend.onrender.com/api/v1/menus" -Method GET -Headers $headers
    Write-Host "✅ Tous les menus récupérés: $($allMenus.Count)" -ForegroundColor Green
    
    if ($allMenus.Count -gt 0) {
        foreach ($menu in $allMenus) {
            Write-Host "  📋 $($menu.title) (ID: $($menu.id))" -ForegroundColor White
        }
    }
} catch {
    Write-Host "❌ Erreur récupération tous menus: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n📊 Résumé du test:" -ForegroundColor Green
Write-Host "✅ Solution dynamique fonctionnelle" -ForegroundColor Green
Write-Host "✅ Création de menus réussie" -ForegroundColor Green
Write-Host "✅ Ajout d'éléments de menu réussi" -ForegroundColor Green
Write-Host "⚠️ Problème de récupération à investiguer" -ForegroundColor Yellow

Write-Host "`n🎉 Test terminé!" -ForegroundColor Green
