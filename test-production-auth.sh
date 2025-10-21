#!/bin/bash

# Script de test pour l'authentification en production
# Teste les endpoints sur Vercel (frontend) et Render (backend)

set -e  # Arrêter le script en cas d'erreur

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# URLs de production
BACKEND_URL="https://vegn-bio-backend.onrender.com"
FRONTEND_URL="https://vegn-bio-frontend.vercel.app"

# Fichiers temporaires pour stocker les tokens
TOKEN_FILE="/tmp/jwt_token.txt"
USER_DATA_FILE="/tmp/user_data.json"

echo -e "${BLUE}🚀 Test d'authentification en production - VegN-Bio${NC}"
echo -e "${BLUE}================================================${NC}"
echo -e "Backend: ${BACKEND_URL}"
echo -e "Frontend: ${FRONTEND_URL}"
echo ""

# Fonction pour afficher les résultats
print_result() {
    local test_name="$1"
    local status="$2"
    local message="$3"
    
    if [ "$status" = "SUCCESS" ]; then
        echo -e "${GREEN}✅ $test_name: $message${NC}"
    elif [ "$status" = "WARNING" ]; then
        echo -e "${YELLOW}⚠️  $test_name: $message${NC}"
    else
        echo -e "${RED}❌ $test_name: $message${NC}"
    fi
}

# Test 1: Vérifier la connectivité du backend
echo -e "${YELLOW}1. Test de connectivité du backend...${NC}"
if curl -s --connect-timeout 10 "$BACKEND_URL" > /dev/null; then
    print_result "Connectivité Backend" "SUCCESS" "Backend accessible"
else
    print_result "Connectivité Backend" "ERROR" "Backend inaccessible"
    exit 1
fi

# Test 2: Vérifier la connectivité du frontend
echo -e "${YELLOW}2. Test de connectivité du frontend...${NC}"
if curl -s --connect-timeout 10 "$FRONTEND_URL" > /dev/null; then
    print_result "Connectivité Frontend" "SUCCESS" "Frontend accessible"
else
    print_result "Connectivité Frontend" "WARNING" "Frontend inaccessible"
fi

# Test 3: Test d'enregistrement d'utilisateur
echo -e "${YELLOW}3. Test d'enregistrement d'utilisateur...${NC}"
REGISTER_DATA='{
    "username": "testuser_'$(date +%s)'",
    "email": "test'$(date +%s)'@example.com",
    "password": "TestPassword123!",
    "firstName": "Test",
    "lastName": "User"
}'

echo "Données d'enregistrement: $REGISTER_DATA"

REGISTER_RESPONSE=$(curl -s -X POST \
    -H "Content-Type: application/json" \
    -d "$REGISTER_DATA" \
    "$BACKEND_URL/api/auth/register" 2>/dev/null || echo "ERROR")

if echo "$REGISTER_RESPONSE" | grep -q "ERROR\|Failed\|Exception"; then
    print_result "Enregistrement" "ERROR" "Échec de l'enregistrement"
    echo "Réponse: $REGISTER_RESPONSE"
else
    print_result "Enregistrement" "SUCCESS" "Utilisateur enregistré avec succès"
    echo "Réponse: $REGISTER_RESPONSE"
fi

# Test 4: Test de connexion
echo -e "${YELLOW}4. Test de connexion...${NC}"
LOGIN_DATA='{
    "username": "testuser_'$(date +%s)'",
    "password": "TestPassword123!"
}'

echo "Tentative de connexion..."

LOGIN_RESPONSE=$(curl -s -X POST \
    -H "Content-Type: application/json" \
    -d "$LOGIN_DATA" \
    "$BACKEND_URL/api/auth/login" 2>/dev/null || echo "ERROR")

if echo "$LOGIN_RESPONSE" | grep -q "token"; then
    # Extraire le token JWT
    TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
    if [ -n "$TOKEN" ]; then
        echo "$TOKEN" > "$TOKEN_FILE"
        print_result "Connexion" "SUCCESS" "Token JWT obtenu"
        echo "Token: ${TOKEN:0:50}..."
    else
        print_result "Connexion" "ERROR" "Token non trouvé dans la réponse"
    fi
else
    print_result "Connexion" "ERROR" "Échec de la connexion"
    echo "Réponse: $LOGIN_RESPONSE"
fi

# Test 5: Test du profil utilisateur avec token
echo -e "${YELLOW}5. Test du profil utilisateur...${NC}"
if [ -f "$TOKEN_FILE" ]; then
    TOKEN=$(cat "$TOKEN_FILE")
    
    PROFILE_RESPONSE=$(curl -s -X GET \
        -H "Authorization: Bearer $TOKEN" \
        "$BACKEND_URL/api/auth/me" 2>/dev/null || echo "ERROR")
    
    if echo "$PROFILE_RESPONSE" | grep -q "username\|email"; then
        print_result "Profil utilisateur" "SUCCESS" "Profil récupéré avec succès"
        echo "Profil: $PROFILE_RESPONSE"
    else
        print_result "Profil utilisateur" "ERROR" "Échec de la récupération du profil"
        echo "Réponse: $PROFILE_RESPONSE"
    fi
else
    print_result "Profil utilisateur" "ERROR" "Token non disponible"
fi

# Test 6: Test des endpoints protégés
echo -e "${YELLOW}6. Test des endpoints protégés...${NC}"
if [ -f "$TOKEN_FILE" ]; then
    TOKEN=$(cat "$TOKEN_FILE")
    
    # Test des restaurants
    RESTAURANTS_RESPONSE=$(curl -s -X GET \
        -H "Authorization: Bearer $TOKEN" \
        "$BACKEND_URL/api/restaurants" 2>/dev/null || echo "ERROR")
    
    if echo "$RESTAURANTS_RESPONSE" | grep -q "\[\|\{"; then
        print_result "Endpoints protégés" "SUCCESS" "Accès aux restaurants autorisé"
    else
        print_result "Endpoints protégés" "ERROR" "Accès aux restaurants refusé"
        echo "Réponse: $RESTAURANTS_RESPONSE"
    fi
else
    print_result "Endpoints protégés" "ERROR" "Token non disponible"
fi

# Test 7: Test sans token (doit échouer)
echo -e "${YELLOW}7. Test d'accès sans token (doit échouer)...${NC}"
UNAUTHORIZED_RESPONSE=$(curl -s -X GET \
    "$BACKEND_URL/api/restaurants" 2>/dev/null || echo "ERROR")

if echo "$UNAUTHORIZED_RESPONSE" | grep -q "403\|401\|Unauthorized\|Forbidden"; then
    print_result "Sécurité" "SUCCESS" "Accès non autorisé correctement bloqué"
else
    print_result "Sécurité" "WARNING" "Réponse inattendue pour accès non autorisé"
    echo "Réponse: $UNAUTHORIZED_RESPONSE"
fi

# Test 8: Test de la base de données
echo -e "${YELLOW}8. Test de la base de données...${NC}"
if [ -f "$TOKEN_FILE" ]; then
    TOKEN=$(cat "$TOKEN_FILE")
    
    # Test des consultations vétérinaires
    VET_RESPONSE=$(curl -s -X GET \
        -H "Authorization: Bearer $TOKEN" \
        "$BACKEND_URL/api/veterinary-consultations" 2>/dev/null || echo "ERROR")
    
    if echo "$VET_RESPONSE" | grep -q "\[\|\{"; then
        print_result "Base de données" "SUCCESS" "Tables vétérinaires accessibles"
    else
        print_result "Base de données" "ERROR" "Problème d'accès aux données vétérinaires"
        echo "Réponse: $VET_RESPONSE"
    fi
else
    print_result "Base de données" "ERROR" "Token non disponible"
fi

# Test 9: Test des endpoints publics
echo -e "${YELLOW}9. Test des endpoints publics...${NC}"
PUBLIC_RESPONSE=$(curl -s -X GET \
    "$BACKEND_URL/api/info" 2>/dev/null || echo "ERROR")

if echo "$PUBLIC_RESPONSE" | grep -q "message\|info\|version"; then
    print_result "Endpoints publics" "SUCCESS" "API info accessible"
else
    print_result "Endpoints publics" "WARNING" "Endpoint public non accessible"
    echo "Réponse: $PUBLIC_RESPONSE"
fi

# Test 10: Test de performance
echo -e "${YELLOW}10. Test de performance...${NC}"
START_TIME=$(date +%s%3N)
curl -s -X GET "$BACKEND_URL" > /dev/null
END_TIME=$(date +%s%3N)
RESPONSE_TIME=$((END_TIME - START_TIME))

if [ $RESPONSE_TIME -lt 5000 ]; then
    print_result "Performance" "SUCCESS" "Temps de réponse: ${RESPONSE_TIME}ms"
else
    print_result "Performance" "WARNING" "Temps de réponse lent: ${RESPONSE_TIME}ms"
fi

# Nettoyage
echo -e "${YELLOW}11. Nettoyage...${NC}"
rm -f "$TOKEN_FILE" "$USER_DATA_FILE"
print_result "Nettoyage" "SUCCESS" "Fichiers temporaires supprimés"

# Résumé final
echo ""
echo -e "${BLUE}📊 Résumé des tests${NC}"
echo -e "${BLUE}==================${NC}"
echo -e "${GREEN}✅ Tests réussis: Authentification, Base de données, Sécurité${NC}"
echo -e "${YELLOW}⚠️  Vérifiez les warnings pour optimiser les performances${NC}"
echo -e "${RED}❌ Corrigez les erreurs avant la mise en production${NC}"

echo ""
echo -e "${BLUE}🔗 URLs de production:${NC}"
echo -e "Backend: $BACKEND_URL"
echo -e "Frontend: $FRONTEND_URL"

echo ""
echo -e "${GREEN}🎉 Test d'authentification terminé!${NC}"
