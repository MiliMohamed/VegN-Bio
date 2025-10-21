#!/bin/bash

# Script pour tester les comptes utilisateurs de production
# Vérifie que tous les utilisateurs peuvent se connecter

echo "🧪 Test des comptes utilisateurs de production VegN-Bio"
echo "======================================================"

# Configuration de l'API
API_BASE_URL="https://vegn-bio-backend.onrender.com/api"

# Fonction pour tester une connexion
test_login() {
    local email=$1
    local password=$2
    local name=$3
    
    echo -n "Test de connexion pour $name ($email)... "
    
    local response=$(curl -s -X POST "$API_BASE_URL/auth/login" \
        -H "Content-Type: application/json" \
        -d "{\"email\":\"$email\",\"password\":\"$password\"}")
    
    if echo "$response" | grep -q '"token"'; then
        echo "✅ OK"
        return 0
    else
        echo "❌ ÉCHEC"
        echo "   Réponse: $response"
        return 1
    fi
}

# Fonction pour obtenir les informations d'un utilisateur
get_user_info() {
    local email=$1
    local password=$2
    
    local token=$(curl -s -X POST "$API_BASE_URL/auth/login" \
        -H "Content-Type: application/json" \
        -d "{\"email\":\"$email\",\"password\":\"$password\"}" | \
        grep -o '"token":"[^"]*"' | cut -d'"' -f4)
    
    if [ -n "$token" ]; then
        curl -s -X GET "$API_BASE_URL/users" \
            -H "Authorization: Bearer $token" | \
            jq -r '.[] | select(.email=="'$email'") | "\(.fullName) (\(.role))"'
    fi
}

echo "📋 Test des comptes administrateurs..."
test_login "admin@vegnbio.com" "AdminVegN2024!" "Admin Principal"
test_login "manager@vegnbio.com" "ManagerVegN2024!" "Manager Opérationnel"
test_login "support@vegnbio.com" "SupportVegN2024!" "Support Technique"

echo ""
echo "🏪 Test des comptes restaurateurs..."
test_login "bastille@vegnbio.com" "Bastille2024!" "Marie Dubois - Bastille"
test_login "republique@vegnbio.com" "Republique2024!" "Jean Martin - République"
test_login "nation@vegnbio.com" "Nation2024!" "Sophie Bernard - Nation"
test_login "italie@vegnbio.com" "Italie2024!" "Pierre Leroy - Place d'Italie"
test_login "montparnasse@vegnbio.com" "Montparnasse2024!" "Claire Moreau - Montparnasse"
test_login "ivry@vegnbio.com" "Ivry2024!" "Thomas Petit - Ivry"
test_login "beaubourg@vegnbio.com" "Beaubourg2024!" "Isabelle Rousseau - Beaubourg"

echo ""
echo "🚚 Test des comptes fournisseurs..."
test_login "biofrance@supplier.com" "BioFrance2024!" "BioFrance - Fournisseur Bio"
test_login "terroir@supplier.com" "Terroir2024!" "Terroir Vert - Légumes Locaux"
test_login "grains@supplier.com" "Grains2024!" "Grains d'Or - Céréales Bio"
test_login "epices@supplier.com" "Epices2024!" "Epices du Monde - Épices Bio"
test_login "proteines@supplier.com" "Proteines2024!" "Protéines Végétales - Alternatives"
test_login "boissons@supplier.com" "Boissons2024!" "Boissons Nature - Jus et Thés"

echo ""
echo "👥 Test des comptes clients..."
test_login "client1@example.com" "Client12024!" "Alice Dupont"
test_login "client2@example.com" "Client22024!" "Bob Martin"
test_login "client3@example.com" "Client32024!" "Claire Dubois"
test_login "client4@example.com" "Client42024!" "David Bernard"
test_login "client5@example.com" "Client52024!" "Emma Leroy"
test_login "client6@example.com" "Client62024!" "François Moreau"
test_login "client7@example.com" "Client72024!" "Gabrielle Petit"
test_login "client8@example.com" "Client82024!" "Henri Rousseau"

echo ""
echo "📊 Statistiques des utilisateurs..."
echo "Vérification des informations utilisateur..."

# Test avec un compte admin pour récupérer les statistiques
ADMIN_TOKEN=$(curl -s -X POST "$API_BASE_URL/auth/login" \
    -H "Content-Type: application/json" \
    -d '{"email":"admin@vegnbio.com","password":"AdminVegN2024!"}' | \
    grep -o '"token":"[^"]*"' | cut -d'"' -f4)

if [ -n "$ADMIN_TOKEN" ]; then
    echo "✅ Connexion admin réussie"
    
    # Compter les utilisateurs par rôle
    TOTAL_USERS=$(curl -s -X GET "$API_BASE_URL/users" \
        -H "Authorization: Bearer $ADMIN_TOKEN" | jq length)
    
    ADMIN_COUNT=$(curl -s -X GET "$API_BASE_URL/users" \
        -H "Authorization: Bearer $ADMIN_TOKEN" | \
        jq '[.[] | select(.role=="ADMIN")] | length')
    
    RESTAURATEUR_COUNT=$(curl -s -X GET "$API_BASE_URL/users" \
        -H "Authorization: Bearer $ADMIN_TOKEN" | \
        jq '[.[] | select(.role=="RESTAURATEUR")] | length')
    
    FOURNISSEUR_COUNT=$(curl -s -X GET "$API_BASE_URL/users" \
        -H "Authorization: Bearer $ADMIN_TOKEN" | \
        jq '[.[] | select(.role=="FOURNISSEUR")] | length')
    
    CLIENT_COUNT=$(curl -s -X GET "$API_BASE_URL/users" \
        -H "Authorization: Bearer $ADMIN_TOKEN" | \
        jq '[.[] | select(.role=="CLIENT")] | length')
    
    echo ""
    echo "📈 Résumé des utilisateurs en base:"
    echo "- Total: $TOTAL_USERS utilisateurs"
    echo "- Administrateurs: $ADMIN_COUNT"
    echo "- Restaurateurs: $RESTAURATEUR_COUNT"
    echo "- Fournisseurs: $FOURNISSEUR_COUNT"
    echo "- Clients: $CLIENT_COUNT"
else
    echo "❌ Impossible de se connecter avec le compte admin"
fi

echo ""
echo "🎉 Tests terminés !"
echo ""
echo "💡 Pour utiliser ces comptes dans l'application web:"
echo "   1. Démarrez le frontend: cd web && npm start"
echo "   2. Allez sur http://localhost:3000"
echo "   3. Utilisez les identifiants ci-dessus pour vous connecter"
echo ""
echo "🔐 Rappel: Tous les mots de passe suivent le format [Nom/Rôle]2024!"
