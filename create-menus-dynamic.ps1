# Script PowerShell pour créer des menus dynamiquement
# Récupère automatiquement les IDs des restaurants depuis l'API

param(
    [string]$ApiBaseUrl = "https://vegn-bio-backend.onrender.com/api/v1",
    [string]$MenuTitle = "Menu Automne 2024",
    [string]$ActiveFrom = "2024-10-01",
    [string]$ActiveTo = "2024-12-31",
    [string]$OutputFile = "create-menus-dynamic.sql"
)

Write-Host "🚀 Créateur de Menus Dynamique VegN Bio" -ForegroundColor Green
Write-Host "=======================================" -ForegroundColor Green

# Fonction pour faire des appels API
function Invoke-ApiRequest {
    param(
        [string]$Url,
        [string]$Method = "GET",
        [hashtable]$Headers = @{}
    )
    
    try {
        $response = Invoke-RestMethod -Uri $Url -Method $Method -Headers $Headers -ContentType "application/json"
        return $response
    }
    catch {
        Write-Error "Erreur API: $($_.Exception.Message)"
        return $null
    }
}

# Récupérer la liste des restaurants
Write-Host "📡 Récupération des restaurants depuis l'API..." -ForegroundColor Yellow
$restaurantsUrl = "$ApiBaseUrl/restaurants"
$restaurants = Invoke-ApiRequest -Url $restaurantsUrl

if (-not $restaurants) {
    Write-Error "❌ Impossible de récupérer les restaurants depuis l'API"
    exit 1
}

Write-Host "✅ $($restaurants.Count) restaurants récupérés" -ForegroundColor Green

# Templates de plats par code de restaurant
$menuTemplates = @{
    'BAS' = @(
        @{ name = 'Burger Tofu Bio'; description = 'Burger au tofu grillé, salade croquante, tomates, sauce sésame, pain complet bio'; price_cents = 1290; is_vegan = $true },
        @{ name = 'Velouté de Courge'; description = 'Velouté de courge butternut bio, graines de courge, crème de coco'; price_cents = 790; is_vegan = $true },
        @{ name = 'Salade Quinoa'; description = 'Salade de quinoa bio, légumes de saison, noix, vinaigrette citron'; price_cents = 1090; is_vegan = $true }
    )
    'REP' = @(
        @{ name = 'Curry de Légumes'; description = 'Curry de légumes bio, lait de coco, riz basmati, coriandre fraîche'; price_cents = 1190; is_vegan = $true },
        @{ name = 'Poke Bowl Végétal'; description = 'Bowl de quinoa, avocat, edamame, carottes, sauce tahini'; price_cents = 1390; is_vegan = $true },
        @{ name = 'Wrap Falafel'; description = 'Wrap de falafel maison, houmous, légumes croquants, sauce tahini'; price_cents = 1090; is_vegan = $true }
    )
    'NAT' = @(
        @{ name = 'Tartine Avocat'; description = 'Tartine de pain complet, avocat, tomates cerises, graines, citron'; price_cents = 890; is_vegan = $true },
        @{ name = 'Wrap Falafel'; description = 'Wrap de falafel maison, houmous, légumes croquants, sauce tahini'; price_cents = 1090; is_vegan = $true },
        @{ name = 'Bowl Buddha'; description = 'Bowl de légumes rôtis, quinoa, avocat, sauce miso, graines'; price_cents = 1390; is_vegan = $true }
    )
    'ITA' = @(
        @{ name = 'Pâtes Carbonara Végétale'; description = 'Pâtes complètes, sauce crémeuse aux champignons, noix de cajou'; price_cents = 1190; is_vegan = $true },
        @{ name = 'Risotto aux Champignons'; description = 'Risotto crémeux aux champignons de saison, parmesan végétal'; price_cents = 1290; is_vegan = $true },
        @{ name = 'Pizza Margherita Végétale'; description = 'Pizza à la tomate, mozzarella végétale, basilic frais'; price_cents = 1190; is_vegan = $true }
    )
    'BOU' = @(
        @{ name = 'Bowl Buddha'; description = 'Bowl de légumes rôtis, quinoa, avocat, sauce miso, graines'; price_cents = 1390; is_vegan = $true },
        @{ name = 'Soupe Miso'; description = 'Soupe miso traditionnelle, algues, tofu, légumes croquants'; price_cents = 690; is_vegan = $true },
        @{ name = 'Salade César Végétale'; description = 'Salade romaine, croûtons, sauce césar végétale, parmesan végétal'; price_cents = 1090; is_vegan = $true }
    )
}

# Générer le SQL
Write-Host "📝 Génération du SQL dynamique..." -ForegroundColor Yellow

$sqlContent = @"
-- Script généré dynamiquement le $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
-- Basé sur les restaurants récupérés depuis l'API: $ApiBaseUrl
-- Menu: $MenuTitle ($ActiveFrom - $ActiveTo)

"@

foreach ($restaurant in $restaurants) {
    $restaurantId = $restaurant.id
    $restaurantName = $restaurant.name
    $restaurantCode = $restaurant.code
    
    Write-Host "  🏪 Traitement: $restaurantName (ID: $restaurantId, Code: $restaurantCode)" -ForegroundColor Cyan
    
    # Ajouter le menu principal
    $sqlContent += @"

-- Menu pour $restaurantName (ID: $restaurantId)
INSERT INTO menus (restaurant_id, title, active_from, active_to)
VALUES ($restaurantId, '$MenuTitle - $restaurantCode', '$ActiveFrom', '$ActiveTo');
"@
    
    # Ajouter les éléments de menu
    $templates = $menuTemplates[$restaurantCode]
    if ($templates) {
        $sqlContent += @"

-- Ajouter des éléments de menu pour $restaurantName (ID: $restaurantId)
"@
        
        foreach ($template in $templates) {
            $name = $template.name -replace "'", "''"  # Échapper les apostrophes
            $description = $template.description -replace "'", "''"
            $priceCents = $template.price_cents
            $isVegan = if ($template.is_vegan) { "TRUE" } else { "FALSE" }
            
            $sqlContent += @"
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
SELECT 
    m.id,
    '$name',
    '$description',
    $priceCents,
    $isVegan
FROM menus m 
WHERE m.restaurant_id = $restaurantId AND m.title = '$MenuTitle - $restaurantCode';

"@
        }
    } else {
        Write-Warning "⚠️  Aucun template trouvé pour le restaurant $restaurantCode"
    }
}

# Sauvegarder le fichier SQL
Write-Host "💾 Sauvegarde du fichier SQL..." -ForegroundColor Yellow
$sqlContent | Out-File -FilePath $OutputFile -Encoding UTF8

Write-Host "✅ Fichier SQL généré: $OutputFile" -ForegroundColor Green
Write-Host "📊 Résumé:" -ForegroundColor Blue
Write-Host "   - Restaurants traités: $($restaurants.Count)" -ForegroundColor White
Write-Host "   - Titre du menu: $MenuTitle" -ForegroundColor White
Write-Host "   - Période: $ActiveFrom → $ActiveTo" -ForegroundColor White
Write-Host "   - Fichier de sortie: $OutputFile" -ForegroundColor White

# Optionnel: Exécuter le SQL directement
$execute = Read-Host "`n🚀 Voulez-vous exécuter le SQL directement sur la base de données? (y/N)"
if ($execute -eq 'y' -or $execute -eq 'Y') {
    Write-Host "⚠️  Fonctionnalité d'exécution directe non implémentée dans ce script" -ForegroundColor Yellow
    Write-Host "   Utilisez le fichier SQL généré avec votre outil de base de données préféré" -ForegroundColor Yellow
}

Write-Host "`n🎉 Script terminé avec succès!" -ForegroundColor Green