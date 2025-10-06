#!/bin/bash

echo "=== Test de connexion et récupération des menus ==="

# 1. Connexion
echo "1. Connexion en tant qu'admin..."
LOGIN_RESPONSE=$(curl -s -X POST "http://localhost:8080/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email": "admin@vegnbio.com", "password": "admin123"}')

echo "Réponse de connexion: $LOGIN_RESPONSE"

# Extraire le token
TOKEN=$(echo $LOGIN_RESPONSE | grep -o '"accessToken":"[^"]*"' | cut -d'"' -f4)
echo "Token extrait: $TOKEN"

if [ -z "$TOKEN" ]; then
  echo "❌ Échec de la connexion"
  exit 1
fi

echo "✅ Connexion réussie"

# 2. Récupération des restaurants
echo ""
echo "2. Récupération des restaurants..."
RESTAURANTS_RESPONSE=$(curl -s -X GET "http://localhost:8080/api/v1/restaurants" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN")

echo "Restaurants: $RESTAURANTS_RESPONSE"

# 3. Récupération des menus du premier restaurant
echo ""
echo "3. Récupération des menus du restaurant 1..."
MENUS_RESPONSE=$(curl -s -X GET "http://localhost:8080/api/v1/menus/restaurant/1" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN")

echo "Menus du restaurant 1: $MENUS_RESPONSE"

echo ""
echo "=== Test terminé ==="
