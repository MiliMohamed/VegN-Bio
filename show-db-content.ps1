# Script pour afficher le contenu détaillé de la base de données
# VEG'N BIO - Affichage du contenu de la base

Write-Host "🔍 CONTENU DÉTAILLÉ DE LA BASE DE DONNÉES" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration de l'API
$BaseUrl = "https://vegn-bio-backend.onrender.com"

Write-Host "📊 Connexion à l'API: $BaseUrl" -ForegroundColor Green
Write-Host ""

# Fonction pour afficher les données de manière détaillée
function Show-DetailedData {
    param(
        [string]$Endpoint,
        [string]$Title,
        [string]$Icon
    )
    
    Write-Host "$Icon $Title" -ForegroundColor Yellow
    Write-Host ("=" * ($Title.Length + 3)) -ForegroundColor Yellow
    
    try {
        $url = "$BaseUrl$Endpoint"
        $response = Invoke-RestMethod -Uri $url -Method Get -ContentType "application/json" -ErrorAction Stop
        
        if ($response) {
            if ($response -is [array]) {
                Write-Host "📋 Nombre total: $($response.Count)" -ForegroundColor Green
                Write-Host ""
                
                foreach ($item in $response) {
                    Write-Host "📄 Élément:" -ForegroundColor Blue
                    $item | ConvertTo-Json -Depth 3
                    Write-Host ""
                }
            } else {
                Write-Host "📄 Données:" -ForegroundColor Blue
                $response | ConvertTo-Json -Depth 3
            }
        } else {
            Write-Host "⚠️ Aucune donnée" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "❌ Erreur: $($_.Exception.Message)" -ForegroundColor Red
        if ($_.Exception.Response) {
            Write-Host "   Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
        }
    }
    Write-Host ""
    Write-Host ("-" * 50) -ForegroundColor Gray
    Write-Host ""
}

# 1. Restaurants
Show-DetailedData "/api/v1/restaurants" "RESTAURANTS VEG'N BIO" "🏪"

# 2. Événements
Show-DetailedData "/api/v1/events" "ÉVÉNEMENTS" "📅"

# 3. Allergènes
Show-DetailedData "/api/v1/allergens" "ALLERGÈNES" "🚫"

Write-Host "🔒 DONNÉES PROTÉGÉES (nécessitent une authentification):" -ForegroundColor Red
Write-Host "=======================================================" -ForegroundColor Red
Write-Host ""

# Tentative d'accès aux données protégées
$ProtectedEndpoints = @(
    @{Endpoint="/api/v1/menus"; Title="MENUS"; Icon="🍽️"},
    @{Endpoint="/api/v1/menu-items"; Title="PLATS"; Icon="🥗"},
    @{Endpoint="/api/v1/users"; Title="UTILISATEURS"; Icon="👥"},
    @{Endpoint="/api/v1/reservations"; Title="RÉSERVATIONS"; Icon="📋"},
    @{Endpoint="/api/v1/room-reservations"; Title="RÉSERVATIONS DE SALLES"; Icon="🏠"},
    @{Endpoint="/api/v1/bookings"; Title="RÉSERVATIONS D'ÉVÉNEMENTS"; Icon="📝"}
)

foreach ($endpoint in $ProtectedEndpoints) {
    Write-Host "$($endpoint.Icon) $($endpoint.Title)" -ForegroundColor Yellow
    Write-Host ("=" * ($endpoint.Title.Length + 3)) -ForegroundColor Yellow
    
    try {
        $url = "$BaseUrl$($endpoint.Endpoint)"
        $response = Invoke-RestMethod -Uri $url -Method Get -ContentType "application/json" -ErrorAction Stop
        
        if ($response) {
            Write-Host "📋 Données disponibles:" -ForegroundColor Green
            if ($response -is [array]) {
                Write-Host "   Nombre: $($response.Count)" -ForegroundColor Green
                if ($response.Count -gt 0) {
                    Write-Host "   Premier élément:" -ForegroundColor Blue
                    $response[0] | ConvertTo-Json -Depth 2
                }
            } else {
                $response | ConvertTo-Json -Depth 2
            }
        }
    } catch {
        Write-Host "🔐 Accès refusé - Authentification requise" -ForegroundColor Red
        Write-Host "   Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host ("-" * 50) -ForegroundColor Gray
    Write-Host ""
}

Write-Host "📊 RÉSUMÉ GÉNÉRAL:" -ForegroundColor Cyan
Write-Host "=================" -ForegroundColor Cyan
Write-Host ""

Write-Host "✅ Données publiques accessibles:" -ForegroundColor Green
Write-Host "   • Restaurants: Disponibles" -ForegroundColor Gray
Write-Host "   • Événements: Disponibles" -ForegroundColor Gray
Write-Host "   • Allergènes: Disponibles" -ForegroundColor Gray
Write-Host ""

Write-Host "🔒 Données protégées:" -ForegroundColor Red
Write-Host "   • Menus: Authentification requise" -ForegroundColor Gray
Write-Host "   • Plats: Authentification requise" -ForegroundColor Gray
Write-Host "   • Utilisateurs: Authentification requise" -ForegroundColor Gray
Write-Host "   • Réservations: Authentification requise" -ForegroundColor Gray
Write-Host "   • Réservations de salles: Authentification requise" -ForegroundColor Gray
Write-Host "   • Réservations d'événements: Authentification requise" -ForegroundColor Gray
Write-Host ""

Write-Host "💡 Pour accéder aux données protégées:" -ForegroundColor Yellow
Write-Host "   1. Créer un compte: POST $BaseUrl/api/v1/auth/register" -ForegroundColor Gray
Write-Host "   2. Se connecter: POST $BaseUrl/api/v1/auth/login" -ForegroundColor Gray
Write-Host "   3. Utiliser le token JWT dans l'en-tête Authorization" -ForegroundColor Gray
Write-Host ""

Write-Host "🏁 Affichage terminé !" -ForegroundColor Green
