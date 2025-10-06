#!/bin/bash

# Test script pour l'inscription d'un nouvel utilisateur
# Ce script teste l'endpoint /api/v1/auth/register

API_URL="http://localhost:8080/api/v1"
REGISTER_ENDPOINT="$API_URL/auth/register"

echo "🧪 Test de l'API d'inscription VegN-Bio"
echo "======================================"
echo ""

# Test 1: Inscription d'un nouveau client
echo "📝 Test 1: Inscription d'un nouveau client"
echo "----------------------------------------"

CLIENT_DATA='{
  "email": "test.client@vegnbio.com",
  "password": "password123",
  "fullName": "Test Client",
  "role": "CLIENT"
}'

echo "Données envoyées:"
echo "$CLIENT_DATA" | jq '.'
echo ""

RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$REGISTER_ENDPOINT" \
  -H "Content-Type: application/json" \
  -d "$CLIENT_DATA")

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
RESPONSE_BODY=$(echo "$RESPONSE" | head -n -1)

echo "Code de réponse HTTP: $HTTP_CODE"
echo "Réponse:"
echo "$RESPONSE_BODY" | jq '.' 2>/dev/null || echo "$RESPONSE_BODY"
echo ""

if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ Test 1 réussi: Client inscrit avec succès"
else
    echo "❌ Test 1 échoué: Erreur lors de l'inscription du client"
fi

echo ""
echo "======================================"
echo ""

# Test 2: Inscription d'un restaurateur
echo "📝 Test 2: Inscription d'un restaurateur"
echo "----------------------------------------"

RESTAURANT_DATA='{
  "email": "test.restaurateur@vegnbio.com",
  "password": "password123",
  "fullName": "Test Restaurateur",
  "role": "RESTAURATEUR"
}'

echo "Données envoyées:"
echo "$RESTAURANT_DATA" | jq '.'
echo ""

RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$REGISTER_ENDPOINT" \
  -H "Content-Type: application/json" \
  -d "$RESTAURANT_DATA")

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
RESPONSE_BODY=$(echo "$RESPONSE" | head -n -1)

echo "Code de réponse HTTP: $HTTP_CODE"
echo "Réponse:"
echo "$RESPONSE_BODY" | jq '.' 2>/dev/null || echo "$RESPONSE_BODY"
echo ""

if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ Test 2 réussi: Restaurateur inscrit avec succès"
else
    echo "❌ Test 2 échoué: Erreur lors de l'inscription du restaurateur"
fi

echo ""
echo "======================================"
echo ""

# Test 3: Tentative d'inscription avec un email déjà utilisé
echo "📝 Test 3: Tentative d'inscription avec un email déjà utilisé"
echo "------------------------------------------------------------"

DUPLICATE_DATA='{
  "email": "test.client@vegnbio.com",
  "password": "password123",
  "fullName": "Test Client Duplicate",
  "role": "CLIENT"
}'

echo "Données envoyées:"
echo "$DUPLICATE_DATA" | jq '.'
echo ""

RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$REGISTER_ENDPOINT" \
  -H "Content-Type: application/json" \
  -d "$DUPLICATE_DATA")

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
RESPONSE_BODY=$(echo "$RESPONSE" | head -n -1)

echo "Code de réponse HTTP: $HTTP_CODE"
echo "Réponse:"
echo "$RESPONSE_BODY" | jq '.' 2>/dev/null || echo "$RESPONSE_BODY"
echo ""

if [ "$HTTP_CODE" = "400" ] || [ "$HTTP_CODE" = "409" ]; then
    echo "✅ Test 3 réussi: Erreur correctement détectée pour email dupliqué"
else
    echo "❌ Test 3 échoué: L'erreur pour email dupliqué n'a pas été détectée"
fi

echo ""
echo "======================================"
echo ""

# Test 4: Tentative d'inscription avec des données invalides
echo "📝 Test 4: Tentative d'inscription avec des données invalides"
echo "------------------------------------------------------------"

INVALID_DATA='{
  "email": "email-invalide",
  "password": "123",
  "fullName": "",
  "role": "INVALID_ROLE"
}'

echo "Données envoyées:"
echo "$INVALID_DATA" | jq '.'
echo ""

RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$REGISTER_ENDPOINT" \
  -H "Content-Type: application/json" \
  -d "$INVALID_DATA")

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
RESPONSE_BODY=$(echo "$RESPONSE" | head -n -1)

echo "Code de réponse HTTP: $HTTP_CODE"
echo "Réponse:"
echo "$RESPONSE_BODY" | jq '.' 2>/dev/null || echo "$RESPONSE_BODY"
echo ""

if [ "$HTTP_CODE" = "400" ]; then
    echo "✅ Test 4 réussi: Erreur correctement détectée pour données invalides"
else
    echo "❌ Test 4 échoué: L'erreur pour données invalides n'a pas été détectée"
fi

echo ""
echo "======================================"
echo "🎉 Tests terminés!"
echo ""
echo "Pour tester l'interface web:"
echo "1. Ouvrez http://localhost:3000/register"
echo "2. Remplissez le formulaire d'inscription"
echo "3. Vérifiez que vous êtes redirigé vers le dashboard"
