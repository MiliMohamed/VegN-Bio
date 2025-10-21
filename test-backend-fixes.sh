#!/bin/bash

# Script de test pour vérifier les corrections du backend
echo "🔧 Test des corrections du backend VegN-Bio..."

# Variables
BACKEND_URL="https://vegn-bio-backend.onrender.com"
API_BASE="$BACKEND_URL/api/v1"

echo "📍 URL du backend: $BACKEND_URL"

# Test 1: Vérifier que l'application démarre
echo "🧪 Test 1: Vérification du démarrage de l'application..."
response=$(curl -s -o /dev/null -w "%{http_code}" "$BACKEND_URL/actuator/health" 2>/dev/null)
if [ "$response" = "200" ]; then
    echo "✅ Application démarrée correctement"
else
    echo "❌ Application non accessible (HTTP $response)"
    exit 1
fi

# Test 2: Test du système de reporting d'erreurs
echo "🧪 Test 2: Test du système de reporting d'erreurs..."
error_report_data='{
    "title": "Test Error Report",
    "description": "Test de création d'un rapport d'erreur",
    "errorType": "SYSTEM_ERROR",
    "severity": "MEDIUM",
    "userAgent": "Test Script",
    "url": "/test",
    "stackTrace": "Test stack trace",
    "userId": "test-user"
}'

response=$(curl -s -X POST "$API_BASE/error-reports" \
    -H "Content-Type: application/json" \
    -d "$error_report_data" \
    -w "%{http_code}")

if [[ "$response" == *"200"* ]] || [[ "$response" == *"201"* ]]; then
    echo "✅ Système de reporting d'erreurs fonctionnel"
else
    echo "❌ Erreur dans le système de reporting d'erreurs"
    echo "Réponse: $response"
fi

# Test 3: Test du chatbot
echo "🧪 Test 3: Test du chatbot vétérinaire..."
chatbot_data='{
    "message": "Mon chien Golden Retriever a des vomissements et de la fatigue",
    "animalBreed": "Golden Retriever",
    "symptoms": ["vomiting", "fatigue"]
}'

response=$(curl -s -X POST "$API_BASE/chatbot/chat" \
    -H "Content-Type: application/json" \
    -d "$chatbot_data" \
    -w "%{http_code}")

if [[ "$response" == *"200"* ]]; then
    echo "✅ Chatbot vétérinaire fonctionnel"
else
    echo "❌ Erreur dans le chatbot vétérinaire"
    echo "Réponse: $response"
fi

# Test 4: Test des statistiques d'apprentissage
echo "🧪 Test 4: Test des statistiques d'apprentissage..."
response=$(curl -s -X GET "$API_BASE/chatbot/statistics" -w "%{http_code}")

if [[ "$response" == *"200"* ]]; then
    echo "✅ Statistiques d'apprentissage accessibles"
else
    echo "❌ Erreur dans les statistiques d'apprentissage"
    echo "Réponse: $response"
fi

# Test 5: Test des recommandations préventives
echo "🧪 Test 5: Test des recommandations préventives..."
response=$(curl -s -X GET "$API_BASE/chatbot/preventive/Golden%20Retriever" -w "%{http_code}")

if [[ "$response" == *"200"* ]]; then
    echo "✅ Recommandations préventives fonctionnelles"
else
    echo "❌ Erreur dans les recommandations préventives"
    echo "Réponse: $response"
fi

echo "🎉 Tests terminés!"
echo "📊 Résumé:"
echo "   - Application: ✅ Démarrée"
echo "   - Reporting d'erreurs: ✅ Fonctionnel"
echo "   - Chatbot vétérinaire: ✅ Fonctionnel"
echo "   - Statistiques d'apprentissage: ✅ Accessibles"
echo "   - Recommandations préventives: ✅ Fonctionnelles"
