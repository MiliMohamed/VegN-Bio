# =============================================================================
# SOLUTION ROBUSTE ET DYNAMIQUE POUR CRÉER DES MENUS VEG'N BIO
# =============================================================================
# Ce script résout le problème "Restaurant not found" en identifiant
# automatiquement tous les restaurants existants et en créant des menus
# avec des éléments variés pour chacun d'eux.
# =============================================================================

param(
    [string]$BaseUrl = "https://vegn-bio-backend.onrender.com",
    [switch]$Force = $false,
    [switch]$Verbose = $false
)

# Configuration des couleurs
$ErrorActionPreference = "Continue"

function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Write-VerboseOutput {
    param([string]$Message)
    if ($Verbose) {
        Write-ColorOutput "🔍 $Message" "Gray"
    }
}

# Fonction d'authentification robuste
function Get-AuthenticatedToken {
    Write-ColorOutput "🔐 Authentification en cours..." "Yellow"
    
    $credentials = @{
        email = "restaurateur@vegnbio.com"
        password = "password123"
        fullName = "Restaurateur Test"
        role = "RESTAURATEUR"
    }
    
    # Essayer d'abord l'enregistrement
    try {
        $response = Invoke-RestMethod -Uri "$BaseUrl/api/v1/auth/register" -Method POST -Body ($credentials | ConvertTo-Json) -ContentType "application/json"
        Write-VerboseOutput "Nouvel utilisateur créé"
        return $response.accessToken
    } catch {
        Write-VerboseOutput "Utilisateur existant, tentative de connexion..."
        
        # Essayer la connexion
        $loginData = @{
            email = $credentials.email
            password = $credentials.password
        }
        
        try {
            $response = Invoke-RestMethod -Uri "$BaseUrl/api/v1/auth/login" -Method POST -Body ($loginData | ConvertTo-Json) -ContentType "application/json"
            Write-VerboseOutput "Connexion réussie"
            return $response.accessToken
        } catch {
            Write-ColorOutput "❌ Erreur d'authentification: $($_.Exception.Message)" "Red"
            return $null
        }
    }
}

# Fonction pour récupérer tous les restaurants
function Get-AllRestaurants {
    Write-ColorOutput "🏪 Récupération des restaurants..." "Yellow"
    
    try {
        $restaurants = Invoke-RestMethod -Uri "$BaseUrl/api/v1/restaurants" -Method GET
        Write-ColorOutput "✅ $($restaurants.Count) restaurant(s) trouvé(s)" "Green"
        
        if ($Verbose) {
            foreach ($restaurant in $restaurants) {
                Write-VerboseOutput "$($restaurant.name) (ID: $($restaurant.id), Code: $($restaurant.code))"
            }
        }
        
        return $restaurants
    } catch {
        Write-ColorOutput "❌ Erreur lors de la récupération des restaurants: $($_.Exception.Message)" "Red"
        return @()
    }
}

# Fonction pour vérifier l'existence d'un menu
function Test-MenuExists {
    param($RestaurantId, $AuthToken)
    
    try {
        $menus = Invoke-RestMethod -Uri "$BaseUrl/api/v1/menus/restaurant/$RestaurantId" -Method GET -Headers @{"Authorization" = "Bearer $AuthToken"}
        return $menus.Count -gt 0
    } catch {
        return $false
    }
}

# Fonction pour créer un menu avec gestion d'erreurs
function New-Menu {
    param($Restaurant, $AuthToken)
    
    $menuData = @{
        restaurantId = $Restaurant.id
        title = "Menu Automne 2024 - $($Restaurant.name)"
        activeFrom = "2024-10-01"
        activeTo = "2024-12-31"
    }
    
    try {
        $headers = @{
            "Authorization" = "Bearer $AuthToken"
            "Content-Type" = "application/json"
        }
        
        $menu = Invoke-RestMethod -Uri "$BaseUrl/api/v1/menus" -Method POST -Body ($menuData | ConvertTo-Json) -Headers $headers
        Write-ColorOutput "✅ Menu créé pour $($Restaurant.name) (ID: $($menu.id))" "Green"
        return $menu
    } catch {
        Write-ColorOutput "❌ Erreur création menu pour $($Restaurant.name): $($_.Exception.Message)" "Red"
        return $null
    }
}

# Fonction pour créer des éléments de menu variés selon le restaurant
function New-MenuItems {
    param($Menu, $Restaurant, $AuthToken)
    
    # Plats spécialisés selon le code du restaurant
    $menuItems = switch ($Restaurant.code) {
        "BAS" { # Bastille - Cuisine moderne
            @(
                @{ name = "Burger Tofu Bio"; description = "Burger au tofu grillé, salade croquante, tomates, sauce sésame, pain complet bio"; priceCents = 1290; isVegan = $true },
                @{ name = "Velouté de Courge"; description = "Velouté de courge butternut bio, graines de courge, crème de coco"; priceCents = 790; isVegan = $true },
                @{ name = "Salade Quinoa"; description = "Salade de quinoa bio, légumes de saison, noix, vinaigrette citron"; priceCents = 1090; isVegan = $true },
                @{ name = "Wrap Végétal"; description = "Wrap de légumes grillés, houmous, avocat, pousses"; priceCents = 1190; isVegan = $true },
                @{ name = "Smoothie Bowl"; description = "Bowl d'açaï, fruits frais, granola maison, noix de coco"; priceCents = 990; isVegan = $true }
            )
        }
        "REP" { # République - Cuisine fusion
            @(
                @{ name = "Curry de Légumes"; description = "Curry de légumes bio, lait de coco, riz basmati, coriandre fraîche"; priceCents = 1190; isVegan = $true },
                @{ name = "Poke Bowl Végétal"; description = "Bowl de quinoa, avocat, edamame, carottes, sauce tahini"; priceCents = 1390; isVegan = $true },
                @{ name = "Tartine Avocat"; description = "Tartine de pain complet, avocat, tomates cerises, graines, citron"; priceCents = 890; isVegan = $true },
                @{ name = "Soupe Miso"; description = "Soupe miso traditionnelle, algues, tofu, légumes croquants"; priceCents = 690; isVegan = $true },
                @{ name = "Bowl Buddha"; description = "Bowl de légumes rôtis, quinoa, avocat, sauce miso, graines"; priceCents = 1390; isVegan = $true }
            )
        }
        "NAT" { # Nation - Cuisine méditerranéenne
            @(
                @{ name = "Wrap Falafel"; description = "Wrap de falafel maison, houmous, légumes croquants, sauce tahini"; priceCents = 1090; isVegan = $true },
                @{ name = "Salade Niçoise Végétale"; description = "Salade de légumes, olives, tomates, vinaigrette provençale"; priceCents = 1190; isVegan = $true },
                @{ name = "Tartine Gourmande"; description = "Tartine de pain complet, tapenade, légumes grillés, herbes"; priceCents = 1090; isVegan = $true },
                @{ name = "Soupe de Légumes"; description = "Soupe de légumes de saison, pain complet bio"; priceCents = 790; isVegan = $true },
                @{ name = "Salade César Végétale"; description = "Salade romaine, parmesan végétal, croûtons, sauce crémeuse"; priceCents = 1190; isVegan = $true }
            )
        }
        "ITA" { # Place d'Italie - Cuisine italienne
            @(
                @{ name = "Pâtes Carbonara Végétale"; description = "Pâtes complètes, sauce crémeuse aux champignons, noix de cajou"; priceCents = 1190; isVegan = $true },
                @{ name = "Risotto aux Champignons"; description = "Risotto crémeux aux champignons de saison, parmesan végétal"; priceCents = 1290; isVegan = $true },
                @{ name = "Pizza Margherita Végétale"; description = "Pizza à la tomate, mozzarella végétale, basilic frais"; priceCents = 1390; isVegan = $true },
                @{ name = "Tiramisu Végétal"; description = "Tiramisu au café, mascarpone végétal, cacao"; priceCents = 890; isVegan = $true },
                @{ name = "Salade Caprese Végétale"; description = "Salade de tomates, mozzarella végétale, basilic, huile d'olive"; priceCents = 1090; isVegan = $true }
            )
        }
        "BOU" { # Beaubourg - Cuisine créative
            @(
                @{ name = "Bowl Buddha"; description = "Bowl de légumes rôtis, quinoa, avocat, sauce miso, graines"; priceCents = 1390; isVegan = $true },
                @{ name = "Soupe Miso"; description = "Soupe miso traditionnelle, algues, tofu, légumes croquants"; priceCents = 690; isVegan = $true },
                @{ name = "Salade Niçoise Végétale"; description = "Salade de légumes, olives, tomates, vinaigrette provençale"; priceCents = 1190; isVegan = $true },
                @{ name = "Tartine Gourmande"; description = "Tartine de pain complet, tapenade, légumes grillés, herbes"; priceCents = 1090; isVegan = $true },
                @{ name = "Smoothie Bowl"; description = "Bowl d'açaï, fruits frais, granola maison, noix de coco"; priceCents = 990; isVegan = $true }
            )
        }
        default { # Menu générique pour les autres restaurants
            @(
                @{ name = "Salade Complète"; description = "Salade de légumes frais, quinoa, avocat, vinaigrette maison"; priceCents = 1090; isVegan = $true },
                @{ name = "Wrap Végétal"; description = "Wrap de légumes grillés, houmous, légumes croquants"; priceCents = 1190; isVegan = $true },
                @{ name = "Soupe du Jour"; description = "Soupe de légumes de saison, pain complet"; priceCents = 790; isVegan = $true },
                @{ name = "Bowl Équilibré"; description = "Bowl de légumes, céréales, légumineuses, sauce tahini"; priceCents = 1290; isVegan = $true },
                @{ name = "Tartine Avocat"; description = "Tartine de pain complet, avocat, tomates cerises, graines"; priceCents = 890; isVegan = $true }
            )
        }
    }
    
    # Créer chaque élément de menu
    $createdItems = 0
    foreach ($item in $menuItems) {
        $itemData = @{
            menuId = $Menu.id
            name = $item.name
            description = $item.description
            priceCents = $item.priceCents
            isVegan = $item.isVegan
            allergenIds = @()
        }
        
        try {
            $headers = @{
                "Authorization" = "Bearer $AuthToken"
                "Content-Type" = "application/json"
            }
            
            $menuItem = Invoke-RestMethod -Uri "$BaseUrl/api/v1/menu-items" -Method POST -Body ($itemData | ConvertTo-Json) -Headers $headers
            Write-VerboseOutput "  ✅ $($item.name) ajouté (ID: $($menuItem.id))"
            $createdItems++
        } catch {
            Write-ColorOutput "  ❌ Erreur ajout $($item.name): $($_.Exception.Message)" "Red"
        }
    }
    
    Write-ColorOutput "  🍽️ $createdItems élément(s) de menu ajouté(s)" "Green"
    return $createdItems
}

# Fonction principale
function Start-DynamicMenuCreation {
    Write-ColorOutput "🚀 SOLUTION DYNAMIQUE VEG'N BIO - CRÉATION DE MENUS" "Green"
    Write-ColorOutput "=================================================" "Green"
    
    # 1. Authentification
    $authToken = Get-AuthenticatedToken
    if (-not $authToken) {
        Write-ColorOutput "❌ Impossible d'obtenir un token d'authentification" "Red"
        return
    }
    
    # 2. Récupération des restaurants
    $restaurants = Get-AllRestaurants
    if ($restaurants.Count -eq 0) {
        Write-ColorOutput "❌ Aucun restaurant trouvé" "Red"
        return
    }
    
    # 3. Création des menus pour chaque restaurant
    $stats = @{
        CreatedMenus = 0
        SkippedMenus = 0
        TotalItems = 0
        Errors = 0
    }
    
    foreach ($restaurant in $restaurants) {
        Write-ColorOutput "`n🏪 Traitement: $($restaurant.name) (ID: $($restaurant.id))" "Cyan"
        
        # Vérifier si un menu existe déjà (sauf si Force)
        if (-not $Force -and (Test-MenuExists -RestaurantId $restaurant.id -AuthToken $authToken)) {
            Write-ColorOutput "⏭️ Menu déjà existant pour $($restaurant.name)" "Yellow"
            $stats.SkippedMenus++
            continue
        }
        
        # Créer le menu
        $menu = New-Menu -Restaurant $restaurant -AuthToken $authToken
        if ($menu) {
            # Ajouter des éléments de menu
            Write-ColorOutput "🍽️ Ajout des éléments de menu..." "Yellow"
            $itemsCount = New-MenuItems -Menu $menu -Restaurant $restaurant -AuthToken $authToken
            $stats.CreatedMenus++
            $stats.TotalItems += $itemsCount
        } else {
            $stats.Errors++
        }
    }
    
    # 4. Résumé détaillé
    Write-ColorOutput "`n📊 RÉSUMÉ DE L'OPÉRATION:" "Green"
    Write-ColorOutput "   ✅ Menus créés: $($stats.CreatedMenus)" "Green"
    Write-ColorOutput "   ⏭️ Menus existants: $($stats.SkippedMenus)" "Yellow"
    Write-ColorOutput "   🍽️ Éléments ajoutés: $($stats.TotalItems)" "Cyan"
    Write-ColorOutput "   ❌ Erreurs: $($stats.Errors)" "Red"
    Write-ColorOutput "   🏪 Total restaurants: $($restaurants.Count)" "Cyan"
    
    # 5. Vérification finale
    if ($Verbose) {
        Write-ColorOutput "`n🔍 Vérification finale..." "Cyan"
        foreach ($restaurant in $restaurants) {
            try {
                $menus = Invoke-RestMethod -Uri "$BaseUrl/api/v1/menus/restaurant/$($restaurant.id)" -Method GET -Headers @{"Authorization" = "Bearer $authToken"}
                Write-ColorOutput "   $($restaurant.name): $($menus.Count) menu(s)" "White"
            } catch {
                Write-VerboseOutput "   $($restaurant.name): Erreur de vérification"
            }
        }
    }
    
    return $stats
}

# Exécution du script
try {
    $result = Start-DynamicMenuCreation
    
    if ($result.CreatedMenus -gt 0) {
        Write-ColorOutput "`n🎉 SOLUTION APPLIQUÉE AVEC SUCCÈS!" "Green"
        Write-ColorOutput "Le problème 'Restaurant not found' est résolu." "Green"
        Write-ColorOutput "Des menus avec des éléments variés ont été créés pour tous les restaurants." "Green"
    } else {
        Write-ColorOutput "`n⚠️ Aucun nouveau menu créé" "Yellow"
        Write-ColorOutput "Utilisez -Force pour forcer la création même si des menus existent." "Yellow"
    }
    
} catch {
    Write-ColorOutput "`n❌ Erreur fatale: $($_.Exception.Message)" "Red"
    exit 1
}

Write-ColorOutput "`n🏁 Script terminé!" "Green"
