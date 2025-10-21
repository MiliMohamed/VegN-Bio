#!/bin/bash

# Test rapide d'authentification en production
# Script simple pour vérifier rapidement les endpoints essentiels

set -e

# Configuration
BACKEND_URL="https://vegn-bio-backend.onrender.com"
TIMESTAMP=$(date +%s)

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}🚀 Test rapide d'authentification - VegN-Bio${NC}"
echo -e "${YELLOW}=========================================${NC}"

# Test 1: Connectivité
echo -n "Test connectivité... "
if curl -s --connect-timeout 5 "$BACKEND_URL" > /dev/null; then
    echo -e "${GREEN}✅ OK${NC}"
else
    echo -e "${RED}❌ ÉCHEC${NC}"
    exit 1
fi

# Test 2: Enregistrement
echo -n "Test enregistrement... "
REGISTER_DATA='{
    "username": "test_'$TIMESTAMP'",
    "email": "test'$TIMESTAMP'@example.com",
    "password": "Test123!",
    "firstName": "Test",
    "lastName": "User"
}'

REGISTER_RESPONSE=$(curl -s -X POST \
    -H "Content-Type: application/json" \
    -d "$REGISTER_DATA" \
    "$BACKEND_URL/api/auth/register" 2>/dev/null || echo "ERROR")

if echo "$REGISTER_RESPONSE" | grep -q "ERROR\|Failed"; then
    echo -e "${RED}❌ ÉCHEC${NC}"
else
    echo -e "${GREEN}✅ OK${NC}"
fi

# Test 3: Connexion
echo -n "Test connexion... "
LOGIN_DATA='{
    "username": "test_'$TIMESTAMP'",
    "password": "Test123!"
}'

LOGIN_RESPONSE=$(curl -s -X POST \
    -H "Content-Type: application/json" \
    -d "$LOGIN_DATA" \
    "$BACKEND_URL/api/auth/login" 2>/dev/null || echo "ERROR")

if echo "$LOGIN_RESPONSE" | grep -q "token"; then
    TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
    echo -e "${GREEN}✅ OK${NC}"
    
    # Test 4: Profil utilisateur
    echo -n "Test profil utilisateur... "
    PROFILE_RESPONSE=$(curl -s -X GET \
        -H "Authorization: Bearer $TOKEN" \
        "$BACKEND_URL/api/auth/me" 2>/dev/null || echo "ERROR")
    
    if echo "$PROFILE_RESPONSE" | grep -q "username\|email"; then
        echo -e "${GREEN}✅ OK${NC}"
    else
        echo -e "${RED}❌ ÉCHEC${NC}"
    fi
    
    # Test 5: Endpoints protégés
    echo -n "Test endpoints protégés... "
    RESTAURANTS_RESPONSE=$(curl -s -X GET \
        -H "Authorization: Bearer $TOKEN" \
        "$BACKEND_URL/api/restaurants" 2>/dev/null || echo "ERROR")
    
    if echo "$RESTAURANTS_RESPONSE" | grep -q "\[\|\{"; then
        echo -e "${GREEN}✅ OK${NC}"
    else
        echo -e "${RED}❌ ÉCHEC${NC}"
    fi
else
    echo -e "${RED}❌ ÉCHEC${NC}"
fi

# Test 6: Sécurité (accès sans token)
echo -n "Test sécurité... "
UNAUTHORIZED_RESPONSE=$(curl -s -X GET "$BACKEND_URL/api/restaurants" 2>/dev/null || echo "ERROR")

if echo "$UNAUTHORIZED_RESPONSE" | grep -q "403\|401\|Unauthorized"; then
    echo -e "${GREEN}✅ OK${NC}"
else
    echo -e "${RED}❌ ÉCHEC${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Test rapide terminé!${NC}"
echo -e "${YELLOW}Backend: $BACKEND_URL${NC}"
