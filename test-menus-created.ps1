# Script de test pour vérifier les menus créés
Write-Host "🔍 Vérification des menus créés..." -ForegroundColor Cyan

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

# Tester chaque restaurant
$restaurantIds = @(68, 69, 70, 71, 72)
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

foreach ($id in $restaurantIds) {
    Write-Host "`n🏪 Test du restaurant ID: $id" -ForegroundColor Yellow
    
    # Tester l'endpoint de récupération des menus
    try {
        $menus = Invoke-RestMethod -Uri "https://vegn-bio-backend.onrender.com/api/v1/menus/restaurant/$id" -Method GET -Headers $headers
        Write-Host "✅ Menus récupérés: $($menus.Count)" -ForegroundColor Green
        
        if ($menus.Count -gt 0) {
            foreach ($menu in $menus) {
                Write-Host "  📋 Menu: $($menu.title) (ID: $($menu.id))" -ForegroundColor White
                Write-Host "    📅 Actif du: $($menu.activeFrom) au: $($menu.activeTo)" -ForegroundColor Gray
                Write-Host "    🍽️ Éléments: $($menu.menuItems.Count)" -ForegroundColor Gray
                
                if ($menu.menuItems.Count -gt 0) {
                    foreach ($item in $menu.menuItems) {
                        Write-Host "      • $($item.name) - $($item.priceCents/100)€" -ForegroundColor Cyan
                    }
                }
            }
        }
    } catch {
        Write-Host "❌ Erreur récupération menus: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    # Tester l'endpoint de récupération des éléments de menu
    try {
        $menuItems = Invoke-RestMethod -Uri "https://vegn-bio-backend.onrender.com/api/v1/menu-items/restaurant/$id" -Method GET -Headers $headers
        Write-Host "✅ Éléments de menu récupérés: $($menuItems.Count)" -ForegroundColor Green
        
        if ($menuItems.Count -gt 0) {
            foreach ($item in $menuItems) {
                Write-Host "  🍽️ $($item.name) - $($item.priceCents/100)€" -ForegroundColor Cyan
            }
        }
    } catch {
        Write-Host "❌ Erreur récupération éléments: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n🎯 Test terminé!" -ForegroundColor Green
