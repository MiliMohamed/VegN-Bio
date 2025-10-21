#!/bin/bash

# Script pour créer des comptes utilisateurs de production dans VegN-Bio
# Ce script utilise l'API backend pour créer des utilisateurs réalistes

echo "🚀 Création des comptes utilisateurs de production VegN-Bio"
echo "========================================================"

# Configuration de l'API
API_BASE_URL="https://vegn-bio-backend.onrender.com/api"
ADMIN_EMAIL="admin@vegnbio.com"
ADMIN_PASSWORD="AdminVegN2024!"

# Fonction pour obtenir un token JWT
get_jwt_token() {
    local response=$(curl -s -X POST "$API_BASE_URL/auth/login" \
        -H "Content-Type: application/json" \
        -d "{\"email\":\"$ADMIN_EMAIL\",\"password\":\"$ADMIN_PASSWORD\"}")
    
    echo $response | grep -o '"token":"[^"]*"' | cut -d'"' -f4
}

# Fonction pour créer un utilisateur
create_user() {
    local email=$1
    local password=$2
    local fullName=$3
    local role=$4
    
    local token=$(get_jwt_token)
    
    if [ -z "$token" ]; then
        echo "❌ Erreur: Impossible d'obtenir le token JWT"
        return 1
    fi
    
    local response=$(curl -s -X POST "$API_BASE_URL/auth/register" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $token" \
        -d "{
            \"email\":\"$email\",
            \"password\":\"$password\",
            \"fullName\":\"$fullName\",
            \"role\":\"$role\"
        }")
    
    if echo "$response" | grep -q "error\|Error"; then
        echo "❌ Erreur lors de la création de $email: $response"
    else
        echo "✅ Utilisateur créé: $fullName ($role)"
    fi
}

echo "📝 Création des comptes administrateurs..."
create_user "admin@vegnbio.com" "AdminVegN2024!" "Administrateur Principal" "ADMIN"
create_user "manager@vegnbio.com" "ManagerVegN2024!" "Manager Opérationnel" "ADMIN"
create_user "support@vegnbio.com" "SupportVegN2024!" "Support Technique" "ADMIN"

echo ""
echo "🏪 Création des comptes restaurateurs..."
create_user "bastille@vegnbio.com" "Bastille2024!" "Marie Dubois - Bastille" "RESTAURATEUR"
create_user "republique@vegnbio.com" "Republique2024!" "Jean Martin - République" "RESTAURATEUR"
create_user "nation@vegnbio.com" "Nation2024!" "Sophie Bernard - Nation" "RESTAURATEUR"
create_user "italie@vegnbio.com" "Italie2024!" "Pierre Leroy - Place d'Italie" "RESTAURATEUR"
create_user "montparnasse@vegnbio.com" "Montparnasse2024!" "Claire Moreau - Montparnasse" "RESTAURATEUR"
create_user "ivry@vegnbio.com" "Ivry2024!" "Thomas Petit - Ivry" "RESTAURATEUR"
create_user "beaubourg@vegnbio.com" "Beaubourg2024!" "Isabelle Rousseau - Beaubourg" "RESTAURATEUR"

echo ""
echo "🚚 Création des comptes fournisseurs..."
create_user "biofrance@supplier.com" "BioFrance2024!" "BioFrance - Fournisseur Bio" "FOURNISSEUR"
create_user "terroir@supplier.com" "Terroir2024!" "Terroir Vert - Légumes Locaux" "FOURNISSEUR"
create_user "grains@supplier.com" "Grains2024!" "Grains d'Or - Céréales Bio" "FOURNISSEUR"
create_user "epices@supplier.com" "Epices2024!" "Epices du Monde - Épices Bio" "FOURNISSEUR"
create_user "proteines@supplier.com" "Proteines2024!" "Protéines Végétales - Alternatives" "FOURNISSEUR"
create_user "boissons@supplier.com" "Boissons2024!" "Boissons Nature - Jus et Thés" "FOURNISSEUR"

echo ""
echo "👥 Création des comptes clients VIP..."
create_user "client1@example.com" "Client12024!" "Alice Dupont" "CLIENT"
create_user "client2@example.com" "Client22024!" "Bob Martin" "CLIENT"
create_user "client3@example.com" "Client32024!" "Claire Dubois" "CLIENT"
create_user "client4@example.com" "Client42024!" "David Bernard" "CLIENT"
create_user "client5@example.com" "Client52024!" "Emma Leroy" "CLIENT"
create_user "client6@example.com" "Client62024!" "François Moreau" "CLIENT"
create_user "client7@example.com" "Client72024!" "Gabrielle Petit" "CLIENT"
create_user "client8@example.com" "Client82024!" "Henri Rousseau" "CLIENT"

echo ""
echo "🎉 Création des comptes terminée !"
echo ""
echo "📋 Résumé des comptes créés:"
echo "- 3 Administrateurs"
echo "- 7 Restaurateurs (un par restaurant)"
echo "- 6 Fournisseurs spécialisés"
echo "- 8 Clients VIP"
echo ""
echo "🔐 Tous les mots de passe suivent le format: [Nom/Rôle]2024!"
echo "📧 Les emails sont basés sur les rôles et noms des utilisateurs"
echo ""
echo "✨ La base de données est maintenant prête pour la production !"
