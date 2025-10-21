# Script PowerShell pour créer des comptes utilisateurs de production dans VegN-Bio
# Ce script utilise l'API backend pour créer des utilisateurs réalistes

Write-Host "🚀 Création des comptes utilisateurs de production VegN-Bio" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green

# Configuration de l'API
$API_BASE_URL = "https://vegn-bio-backend.onrender.com/api"
$ADMIN_EMAIL = "admin@vegnbio.com"
$ADMIN_PASSWORD = "AdminVegN2024!"

# Fonction pour obtenir un token JWT
function Get-JwtToken {
    $body = @{
        email = $ADMIN_EMAIL
        password = $ADMIN_PASSWORD
    } | ConvertTo-Json

    try {
        $response = Invoke-RestMethod -Uri "$API_BASE_URL/auth/login" -Method POST -Body $body -ContentType "application/json"
        return $response.token
    } catch {
        Write-Host "❌ Erreur lors de l'obtention du token JWT: $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

# Fonction pour créer un utilisateur
function Create-User {
    param(
        [string]$email,
        [string]$password,
        [string]$fullName,
        [string]$role
    )

    $token = Get-JwtToken
    
    if (-not $token) {
        Write-Host "❌ Erreur: Impossible d'obtenir le token JWT" -ForegroundColor Red
        return
    }

    $body = @{
        email = $email
        password = $password
        fullName = $fullName
        role = $role
    } | ConvertTo-Json

    $headers = @{
        "Content-Type" = "application/json"
        "Authorization" = "Bearer $token"
    }

    try {
        $response = Invoke-RestMethod -Uri "$API_BASE_URL/auth/register" -Method POST -Body $body -Headers $headers
        Write-Host "✅ Utilisateur créé: $fullName ($role)" -ForegroundColor Green
    } catch {
        if ($_.Exception.Response.StatusCode -eq 409) {
            Write-Host "⚠️  Utilisateur déjà existant: $email" -ForegroundColor Yellow
        } else {
            Write-Host "❌ Erreur lors de la création de $email : $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

Write-Host "📝 Création des comptes administrateurs..." -ForegroundColor Cyan
Create-User "admin@vegnbio.com" "AdminVegN2024!" "Administrateur Principal" "ADMIN"
Create-User "manager@vegnbio.com" "ManagerVegN2024!" "Manager Opérationnel" "ADMIN"
Create-User "support@vegnbio.com" "SupportVegN2024!" "Support Technique" "ADMIN"

Write-Host ""
Write-Host "🏪 Création des comptes restaurateurs..." -ForegroundColor Cyan
Create-User "bastille@vegnbio.com" "Bastille2024!" "Marie Dubois - Bastille" "RESTAURATEUR"
Create-User "republique@vegnbio.com" "Republique2024!" "Jean Martin - République" "RESTAURATEUR"
Create-User "nation@vegnbio.com" "Nation2024!" "Sophie Bernard - Nation" "RESTAURATEUR"
Create-User "italie@vegnbio.com" "Italie2024!" "Pierre Leroy - Place d'Italie" "RESTAURATEUR"
Create-User "montparnasse@vegnbio.com" "Montparnasse2024!" "Claire Moreau - Montparnasse" "RESTAURATEUR"
Create-User "ivry@vegnbio.com" "Ivry2024!" "Thomas Petit - Ivry" "RESTAURATEUR"
Create-User "beaubourg@vegnbio.com" "Beaubourg2024!" "Isabelle Rousseau - Beaubourg" "RESTAURATEUR"

Write-Host ""
Write-Host "🚚 Création des comptes fournisseurs..." -ForegroundColor Cyan
Create-User "biofrance@supplier.com" "BioFrance2024!" "BioFrance - Fournisseur Bio" "FOURNISSEUR"
Create-User "terroir@supplier.com" "Terroir2024!" "Terroir Vert - Légumes Locaux" "FOURNISSEUR"
Create-User "grains@supplier.com" "Grains2024!" "Grains d'Or - Céréales Bio" "FOURNISSEUR"
Create-User "epices@supplier.com" "Epices2024!" "Epices du Monde - Épices Bio" "FOURNISSEUR"
Create-User "proteines@supplier.com" "Proteines2024!" "Protéines Végétales - Alternatives" "FOURNISSEUR"
Create-User "boissons@supplier.com" "Boissons2024!" "Boissons Nature - Jus et Thés" "FOURNISSEUR"

Write-Host ""
Write-Host "👥 Création des comptes clients VIP..." -ForegroundColor Cyan
Create-User "client1@example.com" "Client12024!" "Alice Dupont" "CLIENT"
Create-User "client2@example.com" "Client22024!" "Bob Martin" "CLIENT"
Create-User "client3@example.com" "Client32024!" "Claire Dubois" "CLIENT"
Create-User "client4@example.com" "Client42024!" "David Bernard" "CLIENT"
Create-User "client5@example.com" "Client52024!" "Emma Leroy" "CLIENT"
Create-User "client6@example.com" "Client62024!" "François Moreau" "CLIENT"
Create-User "client7@example.com" "Client72024!" "Gabrielle Petit" "CLIENT"
Create-User "client8@example.com" "Client82024!" "Henri Rousseau" "CLIENT"

Write-Host ""
Write-Host "🎉 Création des comptes terminée !" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Résumé des comptes créés:" -ForegroundColor Yellow
Write-Host "- 3 Administrateurs" -ForegroundColor White
Write-Host "- 7 Restaurateurs (un par restaurant)" -ForegroundColor White
Write-Host "- 6 Fournisseurs spécialisés" -ForegroundColor White
Write-Host "- 8 Clients VIP" -ForegroundColor White
Write-Host ""
Write-Host "🔐 Tous les mots de passe suivent le format: [Nom/Rôle]2024!" -ForegroundColor Cyan
Write-Host "📧 Les emails sont basés sur les rôles et noms des utilisateurs" -ForegroundColor Cyan
Write-Host ""
Write-Host "✨ La base de données est maintenant prête pour la production !" -ForegroundColor Magenta
