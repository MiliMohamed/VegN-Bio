#!/bin/bash
# Script pour examiner le contenu de la base de données PostgreSQL en production
# VEG'N BIO - Inspection de la base de données

echo "🔍 INSPECTION DE LA BASE DE DONNÉES POSTGRESQL PRODUCTION"
echo "=================================================="
echo ""

# Configuration de la base de données (à adapter selon votre environnement)
DB_HOST="localhost"
DB_PORT="5432"
DB_NAME="vegn_bio_prod"
DB_USER="vegn_bio_user"
DB_PASSWORD="vegn_bio_secure_2024!"

# Alternative pour la base locale de développement
if [ "$1" = "local" ]; then
    DB_NAME="vegnbiodb"
    DB_USER="postgres"
    DB_PASSWORD="postgres"
    echo "📋 Mode LOCAL activé"
fi

echo "📊 Connexion à la base: $DB_NAME sur $DB_HOST:$DB_PORT"
echo "👤 Utilisateur: $DB_USER"
echo ""

# Fonction pour exécuter une requête SQL
execute_query() {
    local query="$1"
    local description="$2"
    
    echo "🔍 $description"
    echo "----------------------------------------"
    
    PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c "$query" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "✅ Requête exécutée avec succès"
    else
        echo "❌ Erreur lors de l'exécution de la requête"
    fi
    echo ""
}

# Vérifier la connexion
echo "🔌 Test de connexion..."
PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c "SELECT version();" > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "✅ Connexion réussie à la base de données"
    echo ""
else
    echo "❌ Impossible de se connecter à la base de données"
    echo "💡 Essayez avec l'argument 'local' pour la base de développement"
    echo "   Exemple: ./inspect-db.sh local"
    exit 1
fi

# 1. Informations générales sur la base
execute_query "SELECT current_database() as database_name, current_user as current_user, version() as postgres_version;" "Informations générales"

# 2. Liste des tables
execute_query "
SELECT 
    schemaname,
    tablename,
    tableowner,
    hasindexes,
    hasrules,
    hastriggers
FROM pg_tables 
WHERE schemaname = 'public'
ORDER BY tablename;" "Liste des tables"

# 3. Statistiques des tables
execute_query "
SELECT 
    schemaname,
    tablename,
    n_tup_ins as inserts,
    n_tup_upd as updates,
    n_tup_del as deletes,
    n_live_tup as live_tuples,
    n_dead_tup as dead_tuples
FROM pg_stat_user_tables 
ORDER BY n_live_tup DESC;" "Statistiques des tables"

# 4. Contenu de la table users
execute_query "
SELECT 
    id,
    email,
    role,
    full_name,
    created_at
FROM users 
ORDER BY created_at DESC 
LIMIT 10;" "Utilisateurs (10 derniers)"

# 5. Contenu de la table restaurants
execute_query "
SELECT 
    id,
    name,
    code,
    city,
    phone
FROM restaurants 
ORDER BY id;" "Restaurants"

# 6. Contenu de la table menus
execute_query "
SELECT 
    m.id,
    m.title,
    r.name as restaurant_name,
    m.active_from,
    m.active_to
FROM menus m
JOIN restaurants r ON m.restaurant_id = r.id
ORDER BY m.id;" "Menus"

# 7. Contenu de la table menu_items
execute_query "
SELECT 
    mi.id,
    mi.name,
    mi.price_cents,
    mi.is_vegan,
    m.title as menu_title,
    r.name as restaurant_name
FROM menu_items mi
JOIN menus m ON mi.menu_id = m.id
JOIN restaurants r ON m.restaurant_id = r.id
ORDER BY mi.id
LIMIT 15;" "Plats (15 premiers)"

# 8. Contenu de la table events
execute_query "
SELECT 
    e.id,
    e.title,
    e.type,
    e.date_start,
    e.date_end,
    e.capacity,
    r.name as restaurant_name
FROM events e
JOIN restaurants r ON e.restaurant_id = r.id
ORDER BY e.date_start DESC
LIMIT 10;" "Événements (10 derniers)"

# 9. Contenu de la table allergens
execute_query "
SELECT 
    id,
    code,
    label
FROM allergens 
ORDER BY code;" "Allergènes"

# 10. Contenu de la table reservations (si elle existe)
execute_query "
SELECT 
    r.id,
    u.email as user_email,
    res.name as restaurant_name,
    r.reservation_date,
    r.reservation_time,
    r.number_of_people,
    r.status
FROM reservations r
JOIN users u ON r.user_id = u.id
JOIN restaurants res ON r.restaurant_id = res.id
ORDER BY r.reservation_date DESC
LIMIT 10;" "Réservations (10 dernières)"

# 11. Contenu de la table room_reservations (si elle existe)
execute_query "
SELECT 
    rr.id,
    u.email as user_email,
    rr.reservation_date,
    rr.start_time,
    rr.end_time,
    rr.status
FROM room_reservations rr
JOIN users u ON rr.user_id = u.id
ORDER BY rr.reservation_date DESC
LIMIT 10;" "Réservations de salles (10 dernières)"

# 12. Contenu de la table bookings (si elle existe)
execute_query "
SELECT 
    b.id,
    b.customer_name,
    b.customer_phone,
    b.pax,
    b.status,
    e.title as event_title,
    r.name as restaurant_name
FROM bookings b
JOIN events e ON b.event_id = e.id
JOIN restaurants r ON e.restaurant_id = r.id
ORDER BY b.created_at DESC
LIMIT 10;" "Réservations d'événements (10 dernières)"

# 13. Compteurs généraux
execute_query "
SELECT 
    'users' as table_name, COUNT(*) as count FROM users
UNION ALL
SELECT 
    'restaurants' as table_name, COUNT(*) as count FROM restaurants
UNION ALL
SELECT 
    'menus' as table_name, COUNT(*) as count FROM menus
UNION ALL
SELECT 
    'menu_items' as table_name, COUNT(*) as count FROM menu_items
UNION ALL
SELECT 
    'events' as table_name, COUNT(*) as count FROM events
UNION ALL
SELECT 
    'allergens' as table_name, COUNT(*) as count FROM allergens
UNION ALL
SELECT 
    'reservations' as table_name, COUNT(*) as count FROM reservations
UNION ALL
SELECT 
    'room_reservations' as table_name, COUNT(*) as count FROM room_reservations
UNION ALL
SELECT 
    'bookings' as table_name, COUNT(*) as count FROM bookings;" "Compteurs par table"

echo "🏁 Inspection terminée !"
echo ""
echo "💡 Pour examiner une table spécifique, utilisez:"
echo "   PGPASSWORD='$DB_PASSWORD' psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c \"SELECT * FROM nom_table LIMIT 10;\""
