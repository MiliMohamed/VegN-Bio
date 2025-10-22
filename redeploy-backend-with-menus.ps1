# Script pour redéployer le backend avec la nouvelle migration V3
Write-Host "Redéploiement du backend avec la migration V3..." -ForegroundColor Green

# Aller dans le dossier backend
Set-Location backend

# Construire le projet
Write-Host "Construction du projet..." -ForegroundColor Yellow
./mvnw clean package -DskipTests

# Vérifier que le build a réussi
if ($LASTEXITCODE -eq 0) {
    Write-Host "Build réussi!" -ForegroundColor Green
    
    # Redéployer sur Render (si configuré)
    Write-Host "Redéploiement en cours..." -ForegroundColor Yellow
    
    # Attendre un peu pour que le déploiement se fasse
    Start-Sleep -Seconds 30
    
    # Tester les endpoints
    Write-Host "Test des endpoints..." -ForegroundColor Yellow
    
    # Tester les restaurants
    Write-Host "Test des restaurants:" -ForegroundColor Cyan
    curl -X GET "https://vegn-bio-backend.onrender.com/api/v1/restaurants" | ConvertFrom-Json | Select-Object id, name | Format-Table
    
    # Tester les menus pour chaque restaurant
    $restaurantIds = @(68, 69, 70, 71, 72)
    foreach ($id in $restaurantIds) {
        Write-Host "Test des menus pour le restaurant $id" -ForegroundColor Cyan
        $menus = curl -X GET "https://vegn-bio-backend.onrender.com/api/v1/menus/restaurant/$id" | ConvertFrom-Json
        if ($menus.Count -gt 0) {
            Write-Host "✓ $($menus.Count) menu(s) trouvé(s)" -ForegroundColor Green
            $menus | Select-Object id, title | Format-Table
        } else {
            Write-Host "✗ Aucun menu trouvé" -ForegroundColor Red
        }
    }
    
} else {
    Write-Host "Erreur lors du build!" -ForegroundColor Red
}

# Retourner au dossier racine
Set-Location ..
