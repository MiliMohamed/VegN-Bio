#!/usr/bin/env pwsh
# Script simple pour initialiser les données en local

Write-Host "🚀 Initialisation des données VegN Bio (Local)" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green

$LOCAL_API_URL = "http://localhost:8080"
$ADMIN_USERNAME = "admin"
$ADMIN_PASSWORD = "admin123"

Write-Host "`n🌐 Configuration locale:" -ForegroundColor Yellow
Write-Host "URL API: $LOCAL_API_URL" -ForegroundColor Cyan
Write-Host "Utilisateur Admin: $ADMIN_USERNAME" -ForegroundColor Cyan

# Fonction pour tester la connexion
function Test-Connection {
    try {
        Write-Host "`n🔍 Test de connexion à l'API..." -ForegroundColor Yellow
        $response = Invoke-RestMethod -Uri "$LOCAL_API_URL/actuator/health" -Method "GET" -TimeoutSec 10
        Write-Host "✅ API accessible - Status: $($response.status)" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "❌ API non accessible: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "💡 Assurez-vous que le backend est démarré sur le port 8080" -ForegroundColor Yellow
        return $false
    }
}

# Fonction pour se connecter
function Connect-Admin {
    try {
        Write-Host "`n🔐 Connexion en tant qu'administrateur..." -ForegroundColor Yellow
        
        $loginData = @{
            username = $ADMIN_USERNAME
            password = $ADMIN_PASSWORD
        }
        
        $jsonBody = $loginData | ConvertTo-Json
        $response = Invoke-RestMethod -Uri "$LOCAL_API_URL/api/auth/login" -Method "POST" -Body $jsonBody -ContentType "application/json" -TimeoutSec 15
        
        if ($response -and $response.accessToken) {
            Write-Host "✅ Connexion réussie" -ForegroundColor Green
            return $response.accessToken
        } else {
            Write-Host "❌ Échec de la connexion" -ForegroundColor Red
            return $null
        }
    } catch {
        Write-Host "❌ Erreur de connexion: $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

# Fonction pour initialiser les données
function Initialize-Data {
    param([string]$Token)
    
    try {
        Write-Host "`n🚀 Initialisation des données..." -ForegroundColor Yellow
        
        $headers = @{
            "Authorization" = "Bearer $Token"
            "Content-Type" = "application/json"
        }
        
        $response = Invoke-RestMethod -Uri "$LOCAL_API_URL/api/v1/data/initialize" -Method "POST" -Headers $headers -TimeoutSec 60
        
        if ($response) {
            Write-Host "✅ Initialisation terminée" -ForegroundColor Green
            Write-Host "Succès: $($response.success)" -ForegroundColor Cyan
            Write-Host "Message: $($response.message)" -ForegroundColor Cyan
            return $true
        }
    } catch {
        Write-Host "❌ Erreur lors de l'initialisation: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Fonction pour vérifier le statut
function Check-Status {
    param([string]$Token)
    
    try {
        Write-Host "`n📊 Vérification du statut..." -ForegroundColor Yellow
        
        $headers = @{
            "Authorization" = "Bearer $Token"
            "Content-Type" = "application/json"
        }
        
        $response = Invoke-RestMethod -Uri "$LOCAL_API_URL/api/v1/data/status" -Method "GET" -Headers $headers -TimeoutSec 15
        
        if ($response) {
            Write-Host "✅ Statut récupéré" -ForegroundColor Green
            Write-Host "Initialisé: $($response.initialized)" -ForegroundColor Cyan
            Write-Host "Message: $($response.message)" -ForegroundColor Cyan
            return $response.initialized
        }
    } catch {
        Write-Host "❌ Erreur lors de la vérification: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Fonction principale
function Main {
    # 1. Tester la connexion
    if (-not (Test-Connection)) {
        Write-Host "`n❌ Impossible de se connecter à l'API. Arrêt du script." -ForegroundColor Red
        Write-Host "💡 Vérifiez que le backend est démarré avec: ./mvnw spring-boot:run" -ForegroundColor Yellow
        return
    }
    
    # 2. Se connecter
    $token = Connect-Admin
    if (-not $token) {
        Write-Host "`n❌ Impossible de se connecter. Arrêt du script." -ForegroundColor Red
        return
    }
    
    # 3. Vérifier le statut
    $isInitialized = Check-Status -Token $token
    
    if ($isInitialized) {
        Write-Host "`n⚠️  Les données sont déjà initialisées." -ForegroundColor Yellow
        $choice = Read-Host "Voulez-vous les réinitialiser ? (y/n)"
        
        if ($choice -eq "y" -or $choice -eq "Y") {
            Write-Host "`n🔄 Réinitialisation des données..." -ForegroundColor Yellow
            $headers = @{
                "Authorization" = "Bearer $token"
                "Content-Type" = "application/json"
            }
            
            try {
                $response = Invoke-RestMethod -Uri "$LOCAL_API_URL/api/v1/data/reset" -Method "POST" -Headers $headers -TimeoutSec 60
                Write-Host "✅ Réinitialisation terminée" -ForegroundColor Green
            } catch {
                Write-Host "❌ Erreur lors de la réinitialisation: $($_.Exception.Message)" -ForegroundColor Red
            }
        }
    } else {
        # 4. Initialiser les données
        $success = Initialize-Data -Token $token
        
        if ($success) {
            Write-Host "`n✅ Données initialisées avec succès !" -ForegroundColor Green
        } else {
            Write-Host "`n❌ Échec de l'initialisation." -ForegroundColor Red
        }
    }
    
    Write-Host "`n📊 Données créées:" -ForegroundColor Yellow
    Write-Host "- 👥 Utilisateurs: Admin, Restaurateurs, Clients, Fournisseurs" -ForegroundColor White
    Write-Host "- 🏪 Restaurants: 5 restaurants VegN Bio" -ForegroundColor White
    Write-Host "- 🍽️ Menus: Menus principaux, du jour et événementiels" -ForegroundColor White
    Write-Host "- 🥗 Plats: Plats végétariens variés" -ForegroundColor White
    Write-Host "- 📅 Événements: Ateliers, conférences, dégustations" -ForegroundColor White
    Write-Host "- 📋 Réservations: Réservations de tables et d'événements" -ForegroundColor White
    Write-Host "- 🚫 Allergènes: Liste complète des allergènes" -ForegroundColor White
    
    Write-Host "`n🎉 Processus terminé !" -ForegroundColor Green
    Write-Host "`n💡 Vous pouvez maintenant:" -ForegroundColor Yellow
    Write-Host "- Se connecter avec admin/admin123" -ForegroundColor White
    Write-Host "- Se connecter avec chef_bastille/chef123" -ForegroundColor White
    Write-Host "- Se connecter avec client1/client123" -ForegroundColor White
    Write-Host "- Tester l'application avec des données complètes" -ForegroundColor White
}

# Exécution du script
Main
