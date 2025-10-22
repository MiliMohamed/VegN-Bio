#!/usr/bin/env pwsh
# Script simple pour tester la migration des menus et plats VEG'N BIO

Write-Host "🍽️  Test de la migration V21 - Menus et plats VEG'N BIO" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green

# Vérifier si Docker est en cours d'exécution
Write-Host "`n📋 Vérification de l'environnement..." -ForegroundColor Yellow

try {
    $dockerStatus = docker info 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "Docker n'est pas en cours d'exécution"
    }
    Write-Host "✅ Docker est en cours d'exécution" -ForegroundColor Green
} catch {
    Write-Host "❌ Erreur: Docker n'est pas en cours d'exécution" -ForegroundColor Red
    Write-Host "Veuillez démarrer Docker Desktop et réessayer." -ForegroundColor Yellow
    exit 1
}

# Aller dans le dossier devops
Write-Host "`n📁 Changement vers le dossier devops..." -ForegroundColor Yellow
cd devops

# Arrêter les conteneurs existants
Write-Host "`n🛑 Arrêt des conteneurs existants..." -ForegroundColor Yellow
docker-compose down

# Démarrer PostgreSQL
Write-Host "`n🚀 Démarrage de PostgreSQL..." -ForegroundColor Yellow
docker-compose up -d db

# Attendre que PostgreSQL soit prêt
Write-Host "⏳ Attente de PostgreSQL..." -ForegroundColor Yellow
Start-Sleep -Seconds 15

# Vérifier la connexion à la base de données
Write-Host "`n🔍 Test de connexion à la base de données..." -ForegroundColor Yellow
$dbCheck = docker exec vegn_db psql -U postgres -d vegnbiodb -c "SELECT version();" 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Impossible de se connecter à la base de données" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Connexion à la base de données réussie" -ForegroundColor Green

# Compiler et démarrer l'application backend
Write-Host "`n🔨 Compilation du backend..." -ForegroundColor Yellow
cd ../backend
./mvnw clean compile -DskipTests
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Erreur lors de la compilation" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Compilation réussie" -ForegroundColor Green

# Démarrer l'application backend avec le profil dev
Write-Host "`n🚀 Démarrage de l'application backend..." -ForegroundColor Yellow
$env:SPRING_DATASOURCE_URL = "jdbc:postgresql://localhost:5432/vegnbiodb"
$env:SPRING_DATASOURCE_USERNAME = "postgres"
$env:SPRING_DATASOURCE_PASSWORD = "postgres"
$env:SPRING_PROFILES_ACTIVE = "dev"

./mvnw spring-boot:run -DskipTests &
$backendPID = $!

# Attendre que l'application démarre
Write-Host "⏳ Attente du démarrage de l'application..." -ForegroundColor Yellow
Start-Sleep -Seconds 45

# Test de l'API
Write-Host "`n🧪 Test de l'API des restaurants..." -ForegroundColor Yellow
try {
    $restaurantsResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/restaurants" -Method GET -ContentType "application/json"
    Write-Host "✅ API des restaurants accessible" -ForegroundColor Green
    Write-Host "📊 Nombre de restaurants: $($restaurantsResponse.Count)" -ForegroundColor Cyan
    
    # Afficher les restaurants
    foreach ($restaurant in $restaurantsResponse) {
        Write-Host "  - $($restaurant.name) ($($restaurant.code))" -ForegroundColor White
    }
} catch {
    Write-Host "❌ Erreur lors du test de l'API des restaurants" -ForegroundColor Red
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

# Test de l'API des menus
Write-Host "`n🧪 Test de l'API des menus..." -ForegroundColor Yellow
try {
    $menusResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/menus" -Method GET -ContentType "application/json"
    Write-Host "✅ API des menus accessible" -ForegroundColor Green
    Write-Host "📊 Nombre de menus: $($menusResponse.Count)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Erreur lors du test de l'API des menus" -ForegroundColor Red
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

# Test de l'API des plats
Write-Host "`n🧪 Test de l'API des plats..." -ForegroundColor Yellow
try {
    $menuItemsResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/menu-items" -Method GET -ContentType "application/json"
    Write-Host "✅ API des plats accessible" -ForegroundColor Green
    Write-Host "📊 Nombre de plats: $($menuItemsResponse.Count)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Erreur lors du test de l'API des plats" -ForegroundColor Red
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

# Test spécifique pour chaque restaurant
Write-Host "`n🏪 Test des menus par restaurant..." -ForegroundColor Yellow
$restaurantCodes = @('BAS', 'REP', 'NAT', 'ITA', 'BOU')
foreach ($code in $restaurantCodes) {
    try {
        $menuResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/restaurants/$code/menus" -Method GET -ContentType "application/json"
        Write-Host "✅ Restaurant $code : $($menuResponse.Count) menu(s)" -ForegroundColor Green
    } catch {
        Write-Host "❌ Erreur pour le restaurant $code" -ForegroundColor Red
    }
}

# Vérification directe en base de données
Write-Host "`n🔍 Vérification en base de données..." -ForegroundColor Yellow
$dbQuery = @"
SELECT 
    r.name as restaurant,
    r.code,
    COUNT(DISTINCT m.id) as nb_menus,
    COUNT(mi.id) as nb_plats
FROM restaurants r
LEFT JOIN menus m ON r.id = m.restaurant_id
LEFT JOIN menu_items mi ON m.id = mi.menu_id
WHERE r.code IN ('BAS', 'REP', 'NAT', 'ITA', 'BOU')
GROUP BY r.id, r.name, r.code
ORDER BY r.code;
"@

$dbResult = docker exec vegn_db psql -U postgres -d vegnbiodb -c "$dbQuery" -t
Write-Host "📊 Résultats en base de données:" -ForegroundColor Cyan
Write-Host $dbResult -ForegroundColor White

# Arrêter l'application backend
Write-Host "`n🛑 Arrêt de l'application backend..." -ForegroundColor Yellow
Stop-Process -Id $backendPID -Force -ErrorAction SilentlyContinue

# Arrêter les conteneurs
Write-Host "`n🛑 Arrêt des conteneurs..." -ForegroundColor Yellow
cd ../devops
docker-compose down

Write-Host "`n✅ Test de la migration terminé !" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green
