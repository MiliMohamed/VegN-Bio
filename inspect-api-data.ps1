# Script PowerShell pour examiner les données via l'API REST
# VEG'N BIO - Inspection des données via API

param(
    [string]$BaseUrl = "https://vegn-bio-backend.onrender.com"
)

Write-Host "🔍 INSPECTION DES DONNÉES VIA API REST" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "📊 URL de l'API: $BaseUrl" -ForegroundColor Green
Write-Host ""

# Fonction pour faire une requête API
function Invoke-ApiRequest {
    param(
        [string]$Endpoint,
        [string]$Description
    )
    
    Write-Host "🔍 $Description" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    try {
        $url = "$BaseUrl$Endpoint"
        $response = Invoke-RestMethod -Uri $url -Method Get -ContentType "application/json" -ErrorAction Stop
        
        if ($response) {
            if ($response -is [array]) {
                Write-Host "📋 Nombre d'éléments: $($response.Count)" -ForegroundColor Green
                if ($response.Count -gt 0) {
                    Write-Host "📄 Premier élément:" -ForegroundColor Blue
                    $response[0] | ConvertTo-Json -Depth 2
                }
            } else {
                Write-Host "📄 Réponse:" -ForegroundColor Blue
                $response | ConvertTo-Json -Depth 2
            }
            Write-Host "✅ Requête exécutée avec succès" -ForegroundColor Green
        } else {
            Write-Host "⚠️ Aucune donnée retournée" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "❌ Erreur: $($_.Exception.Message)" -ForegroundColor Red
        if ($_.Exception.Response) {
            Write-Host "   Status Code: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
        }
    }
    Write-Host ""
}

# Test de connexion
Write-Host "🔌 Test de connexion à l'API..." -ForegroundColor Blue
try {
    $healthUrl = "$BaseUrl/actuator/health"
    $healthResponse = Invoke-RestMethod -Uri $healthUrl -Method Get -ErrorAction Stop
    Write-Host "✅ API accessible - Status: $($healthResponse.status)" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "⚠️ Endpoint de santé non disponible, continuons avec les autres endpoints..." -ForegroundColor Yellow
    Write-Host ""
}

# 1. Restaurants
Invoke-ApiRequest "/api/v1/restaurants" "Restaurants"

# 2. Menus
Invoke-ApiRequest "/api/v1/menus" "Menus"

# 3. Plats (Menu Items)
Invoke-ApiRequest "/api/v1/menu-items" "Plats (Menu Items)"

# 4. Événements
Invoke-ApiRequest "/api/v1/events" "Événements"

# 5. Allergènes
Invoke-ApiRequest "/api/v1/allergens" "Allergènes"

# 6. Utilisateurs (peut nécessiter une authentification)
try {
    Invoke-ApiRequest "/api/v1/users" "Utilisateurs"
} catch {
    Write-Host "🔒 Endpoint utilisateurs protégé par authentification" -ForegroundColor Yellow
    Write-Host ""
}

# 7. Réservations (peut nécessiter une authentification)
try {
    Invoke-ApiRequest "/api/v1/reservations" "Réservations"
} catch {
    Write-Host "🔒 Endpoint réservations protégé par authentification" -ForegroundColor Yellow
    Write-Host ""
}

# 8. Réservations de salles (peut nécessiter une authentification)
try {
    Invoke-ApiRequest "/api/v1/room-reservations" "Réservations de salles"
} catch {
    Write-Host "🔒 Endpoint réservations de salles protégé par authentification" -ForegroundColor Yellow
    Write-Host ""
}

# 9. Réservations d'événements (peut nécessiter une authentification)
try {
    Invoke-ApiRequest "/api/v1/bookings" "Réservations d'événements"
} catch {
    Write-Host "🔒 Endpoint réservations d'événements protégé par authentification" -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "🏁 Inspection terminée !" -ForegroundColor Green
Write-Host ""
Write-Host "💡 Pour examiner des endpoints spécifiques, utilisez:" -ForegroundColor Cyan
Write-Host "   Invoke-RestMethod -Uri `"$BaseUrl/api/v1/endpoint`" -Method Get" -ForegroundColor Gray
Write-Host ""
Write-Host "🔐 Pour les endpoints protégés, vous devrez d'abord vous authentifier:" -ForegroundColor Cyan
Write-Host "   1. POST $BaseUrl/api/v1/auth/login" -ForegroundColor Gray
Write-Host "   2. Utiliser le token JWT dans l'en-tête Authorization" -ForegroundColor Gray
