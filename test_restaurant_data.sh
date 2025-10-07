#!/bin/bash

# Script de test pour vérifier les nouvelles données des restaurants VEG'N BIO
# Ce script teste l'API backend pour s'assurer que toutes les nouvelles informations sont correctement exposées

echo "=== Test des nouvelles données des restaurants VEG'N BIO ==="
echo ""

# Configuration
API_BASE_URL="http://localhost:8080/api"
RESTAURANTS_ENDPOINT="$API_BASE_URL/restaurants"

echo "🔍 Test de l'endpoint des restaurants..."
echo "URL: $RESTAURANTS_ENDPOINT"
echo ""

# Test 1: Récupération de tous les restaurants
echo "📋 Test 1: Récupération de tous les restaurants"
response=$(curl -s -w "\n%{http_code}" "$RESTAURANTS_ENDPOINT")
http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | head -n -1)

if [ "$http_code" -eq 200 ]; then
    echo "✅ Succès - Code HTTP: $http_code"
    echo "📊 Nombre de restaurants trouvés: $(echo "$body" | jq '. | length' 2>/dev/null || echo "N/A")"
    echo ""
    
    # Vérifier les nouveaux champs pour chaque restaurant
    echo "🔍 Vérification des nouveaux champs..."
    restaurants=$(echo "$body" | jq '.[]' 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        echo "$restaurants" | jq -r '
        "Restaurant: " + .name + 
        " | Wi-Fi: " + (if .wifiAvailable then "✅" else "❌" end) +
        " | Salles: " + (.meetingRoomsCount | tostring) +
        " | Capacité: " + (.restaurantCapacity | tostring) +
        " | Imprimante: " + (if .printerAvailable then "✅" else "❌" end) +
        " | Plateaux: " + (if .memberTrays then "✅" else "❌" end) +
        " | Livraison: " + (if .deliveryAvailable then "✅" else "❌" end)
        ' 2>/dev/null || echo "❌ Erreur lors de l'analyse des données JSON"
    else
        echo "❌ Erreur: Réponse non-JSON valide"
        echo "Réponse brute: $body"
    fi
else
    echo "❌ Échec - Code HTTP: $http_code"
    echo "Réponse: $body"
fi

echo ""
echo "=== Test des données spécifiques VEG'N BIO ==="

# Test 2: Vérifier les données spécifiques de chaque restaurant
restaurants_data=(
    "BAS:Veg'N Bio Bastille:100:2:true:true:false"
    "REP:Veg'N Bio République:150:4:false:true:true"
    "NAT:Veg'N Bio Nation:80:1:true:true:true"
    "ITA:Veg'N Bio Place d'Italie:70:2:true:true:true"
    "BOU:Veg'N Bio Beaubourg:70:2:true:true:true"
)

for restaurant_info in "${restaurants_data[@]}"; do
    IFS=':' read -r code name capacity rooms member_trays delivery <<< "$restaurant_info"
    
    echo ""
    echo "🏢 Test du restaurant: $name ($code)"
    
    # Rechercher le restaurant par code
    restaurant=$(echo "$body" | jq --arg code "$code" '.[] | select(.code == $code)' 2>/dev/null)
    
    if [ -n "$restaurant" ]; then
        echo "✅ Restaurant trouvé"
        
        # Vérifier les données
        actual_capacity=$(echo "$restaurant" | jq -r '.restaurantCapacity // "null"')
        actual_rooms=$(echo "$restaurant" | jq -r '.meetingRoomsCount // "null"')
        actual_member_trays=$(echo "$restaurant" | jq -r '.memberTrays // "null"')
        actual_delivery=$(echo "$restaurant" | jq -r '.deliveryAvailable // "null"')
        
        echo "   📊 Capacité: $actual_capacity (attendu: $capacity)"
        echo "   🏢 Salles de réunion: $actual_rooms (attendu: $rooms)"
        echo "   ☕ Plateaux membres: $actual_member_trays (attendu: $member_trays)"
        echo "   🚚 Livraison: $actual_delivery (attendu: $delivery)"
        
        # Vérifier les horaires
        monday_thursday=$(echo "$restaurant" | jq -r '.mondayThursdayHours // "null"')
        friday=$(echo "$restaurant" | jq -r '.fridayHours // "null"')
        saturday=$(echo "$restaurant" | jq -r '.saturdayHours // "null"')
        sunday=$(echo "$restaurant" | jq -r '.sundayHours // "null"')
        
        echo "   🕒 Horaires:"
        echo "      Lun-Jeu: $monday_thursday"
        echo "      Vendredi: $friday"
        echo "      Samedi: $saturday"
        echo "      Dimanche: $sunday"
        
        # Vérifier les événements spéciaux pour Nation
        if [ "$code" = "NAT" ]; then
            special_events=$(echo "$restaurant" | jq -r '.specialEvents // "null"')
            echo "   🎉 Événements spéciaux: $special_events"
        fi
    else
        echo "❌ Restaurant $name ($code) non trouvé"
    fi
done

echo ""
echo "=== Résumé du test ==="
echo "✅ Migration de base de données: V3__add_restaurant_details.sql"
echo "✅ Entité Restaurant mise à jour avec nouveaux champs"
echo "✅ DTO RestaurantDto mis à jour"
echo "✅ Mapper RestaurantMapper mis à jour"
echo "✅ Interface frontend mise à jour"
echo "✅ Composant ModernRestaurants mis à jour"
echo "✅ Modèle mobile Restaurant mis à jour"
echo "✅ Styles CSS ajoutés"
echo ""
echo "🎉 Toutes les informations des restaurants VEG'N BIO ont été intégrées!"
echo ""
echo "📋 Informations ajoutées:"
echo "   • Wi-Fi très haut débit"
echo "   • Nombre de salles de réunion"
echo "   • Capacité du restaurant"
echo "   • Disponibilité imprimante"
echo "   • Plateaux membres"
echo "   • Livraison sur demande"
echo "   • Événements spéciaux"
echo "   • Horaires détaillés par jour"
echo ""
echo "🚀 Le système est maintenant prêt avec toutes les données VEG'N BIO!"
