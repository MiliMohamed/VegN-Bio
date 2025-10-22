#!/usr/bin/env pwsh
# Script pour initialiser les données de l'application VegN Bio

Write-Host "🚀 Script d'initialisation des données VegN Bio" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green

$API_URL = "https://vegn-bio-backend.onrender.com"
$ADMIN_USERNAME = "admin"
$ADMIN_PASSWORD = "admin123"

Write-Host "`n🌐 Configuration:" -ForegroundColor Yellow
Write-Host "URL API: $API_URL" -ForegroundColor Cyan
Write-Host "Utilisateur Admin: $ADMIN_USERNAME" -ForegroundColor Cyan

# Fonction pour faire une requête avec authentification
function Invoke-AuthenticatedRequest {
    param(
        [string]$Uri,
        [string]$Method = "GET",
        [hashtable]$Body = $null,
        [string]$ContentType = "application/json"
    )
    
    try {
        $headers = @{
            "Content-Type" = $ContentType
        }
        
        if ($Body) {
            $jsonBody = $Body | ConvertTo-Json -Depth 10
            return Invoke-RestMethod -Uri $Uri -Method $Method -Body $jsonBody -Headers $headers -TimeoutSec 30
        } else {
            return Invoke-RestMethod -Uri $Uri -Method $Method -Headers $headers -TimeoutSec 30
        }
    } catch {
        Write-Host "❌ Erreur lors de la requête: $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

# Fonction pour se connecter et obtenir le token
function Get-AuthToken {
    try {
        Write-Host "`n🔐 Connexion en tant qu'administrateur..." -ForegroundColor Yellow
        
        $loginData = @{
            username = $ADMIN_USERNAME
            password = $ADMIN_PASSWORD
        }
        
        $response = Invoke-AuthenticatedRequest -Uri "$API_URL/api/auth/login" -Method "POST" -Body $loginData
        
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

# Fonction pour vérifier le statut des données
function Get-DataStatus {
    param([string]$Token)
    
    try {
        Write-Host "`n📊 Vérification du statut des données..." -ForegroundColor Yellow
        
        $headers = @{
            "Authorization" = "Bearer $Token"
            "Content-Type" = "application/json"
        }
        
        $response = Invoke-RestMethod -Uri "$API_URL/api/v1/data/status" -Method "GET" -Headers $headers -TimeoutSec 15
        
        if ($response) {
            Write-Host "✅ Statut récupéré" -ForegroundColor Green
            Write-Host "Initialisé: $($response.initialized)" -ForegroundColor Cyan
            Write-Host "Message: $($response.message)" -ForegroundColor Cyan
            return $response.initialized
        }
    } catch {
        Write-Host "❌ Erreur lors de la vérification du statut: $($_.Exception.Message)" -ForegroundColor Red
        return $false
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
        
        $response = Invoke-RestMethod -Uri "$API_URL/api/v1/data/initialize" -Method "POST" -Headers $headers -TimeoutSec 60
        
        if ($response) {
            Write-Host "✅ Initialisation terminée" -ForegroundColor Green
            Write-Host "Succès: $($response.success)" -ForegroundColor Cyan
            Write-Host "Message: $($response.message)" -ForegroundColor Cyan
            
            if ($response.details) {
                Write-Host "`n📋 Détails de l'initialisation:" -ForegroundColor Yellow
                foreach ($detail in $response.details.PSObject.Properties) {
                    Write-Host "  - $($detail.Name): $($detail.Value)" -ForegroundColor White
                }
            }
            
            return $response.success
        }
    } catch {
        Write-Host "❌ Erreur lors de l'initialisation: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Fonction pour réinitialiser les données
function Reset-Data {
    param([string]$Token)
    
    try {
        Write-Host "`n🔄 Réinitialisation des données..." -ForegroundColor Yellow
        
        $headers = @{
            "Authorization" = "Bearer $Token"
            "Content-Type" = "application/json"
        }
        
        $response = Invoke-RestMethod -Uri "$API_URL/api/v1/data/reset" -Method "POST" -Headers $headers -TimeoutSec 60
        
        if ($response) {
            Write-Host "✅ Réinitialisation terminée" -ForegroundColor Green
            Write-Host "Succès: $($response.success)" -ForegroundColor Cyan
            Write-Host "Message: $($response.message)" -ForegroundColor Cyan
            return $response.success
        }
    } catch {
        Write-Host "❌ Erreur lors de la réinitialisation: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Fonction pour nettoyer les données
function Clean-Data {
    param([string]$Token)
    
    try {
        Write-Host "`n🧹 Nettoyage des données..." -ForegroundColor Yellow
        
        $headers = @{
            "Authorization" = "Bearer $Token"
            "Content-Type" = "application/json"
        }
        
        $response = Invoke-RestMethod -Uri "$API_URL/api/v1/data/clean" -Method "DELETE" -Headers $headers -TimeoutSec 30
        
        if ($response) {
            Write-Host "✅ Nettoyage terminé" -ForegroundColor Green
            Write-Host "Succès: $($response.success)" -ForegroundColor Cyan
            Write-Host "Message: $($response.message)" -ForegroundColor Cyan
            return $response.success
        }
    } catch {
        Write-Host "❌ Erreur lors du nettoyage: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Fonction principale
function Main {
    Write-Host "`n🎯 Début du processus d'initialisation..." -ForegroundColor Green
    
    # 1. Obtenir le token d'authentification
    $token = Get-AuthToken
    if (-not $token) {
        Write-Host "❌ Impossible de se connecter. Arrêt du script." -ForegroundColor Red
        return
    }
    
    # 2. Vérifier le statut des données
    $isInitialized = Get-DataStatus -Token $token
    
    if ($isInitialized) {
        Write-Host "`n⚠️  Les données sont déjà initialisées." -ForegroundColor Yellow
        $choice = Read-Host "Voulez-vous les réinitialiser ? (y/n)"
        
        if ($choice -eq "y" -or $choice -eq "Y") {
            $success = Reset-Data -Token $token
            if ($success) {
                Write-Host "`n✅ Données réinitialisées avec succès !" -ForegroundColor Green
            } else {
                Write-Host "`n❌ Échec de la réinitialisation." -ForegroundColor Red
            }
        } else {
            Write-Host "`n✅ Données déjà initialisées. Aucune action nécessaire." -ForegroundColor Green
        }
    } else {
        Write-Host "`n🚀 Initialisation des données..." -ForegroundColor Yellow
        $success = Initialize-Data -Token $token
        
        if ($success) {
            Write-Host "`n✅ Données initialisées avec succès !" -ForegroundColor Green
        } else {
            Write-Host "`n❌ Échec de l'initialisation." -ForegroundColor Red
        }
    }
    
    Write-Host "`n📊 Résumé des données créées:" -ForegroundColor Yellow
    Write-Host "- 👥 Utilisateurs: Admin, Restaurateurs, Clients, Fournisseurs" -ForegroundColor White
    Write-Host "- 🏪 Restaurants: 5 restaurants VegN Bio" -ForegroundColor White
    Write-Host "- 🍽️ Menus: Menus principaux, du jour et événementiels" -ForegroundColor White
    Write-Host "- 🥗 Plats: Plats végétariens variés" -ForegroundColor White
    Write-Host "- 📅 Événements: Ateliers, conférences, dégustations" -ForegroundColor White
    Write-Host "- 📋 Réservations: Réservations de tables et d'événements" -ForegroundColor White
    Write-Host "- 🚫 Allergènes: Liste complète des allergènes" -ForegroundColor White
    
    Write-Host "`n🎉 Processus terminé !" -ForegroundColor Green
}

# Exécution du script
Main
