# Script PowerShell pour examiner le contenu de la base de données PostgreSQL en production (Render)
# VEG'N BIO - Inspection de la base de données Render

Write-Host "🔍 INSPECTION DE LA BASE DE DONNÉES POSTGRESQL PRODUCTION (RENDER)" -ForegroundColor Cyan
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host ""

# Configuration de la base de données Render
$DB_HOST = "dpg-d3i1psbe5dus73a55vp0-a.frankfurt-postgres.render.com"
$DB_PORT = "5432"
$DB_NAME = "vegn_bio_database"
$DB_USER = "vegn_bio_database_user"
$DB_PASSWORD = "N4qpSpMC0y1YlrpFP9VjqJZs64xbyIC6"

Write-Host "📊 Connexion à la base: $DB_NAME sur $DB_HOST`:$DB_PORT" -ForegroundColor Green
Write-Host "👤 Utilisateur: $DB_USER" -ForegroundColor Green
Write-Host "🌍 Région: Frankfurt (Render)" -ForegroundColor Green
Write-Host ""

# Fonction pour exécuter une requête SQL
function Execute-Query {
    param(
        [string]$Query,
        [string]$Description
    )
    
    Write-Host "🔍 $Description" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Gray
    
    try {
        $env:PGPASSWORD = $DB_PASSWORD
        $result = psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c $Query 2>$null
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host $result
            Write-Host "✅ Requête exécutée avec succès" -ForegroundColor Green
        } else {
            Write-Host "❌ Erreur lors de l'exécution de la requête" -ForegroundColor Red
        }
    } catch {
        Write-Host "❌ Erreur: $($_.Exception.Message)" -ForegroundColor Red
    }
    Write-Host ""
}

# Vérifier la connexion
Write-Host "🔌 Test de connexion..." -ForegroundColor Blue
try {
    $env:PGPASSWORD = $DB_PASSWORD
    $testResult = psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "SELECT version();" 2>$null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Connexion réussie à la base de données Render" -ForegroundColor Green
        Write-Host ""
    } else {
        Write-Host "❌ Impossible de se connecter à la base de données" -ForegroundColor Red
        Write-Host "💡 Vérifiez que PostgreSQL est installé et que la connexion est disponible" -ForegroundColor Yellow
        exit 1
    }
} catch {
    Write-Host "❌ Erreur de connexion: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "💡 Installez PostgreSQL ou utilisez un client PostgreSQL pour vous connecter" -ForegroundColor Yellow
    exit 1
}

# 1. Informations générales sur la base
Execute-Query "SELECT current_database() as database_name, current_user as current_user, version() as postgres_version;" "Informations générales"

# 2. Liste des tables
Execute-Query @"
SELECT 
    schemaname,
    tablename,
    tableowner,
    hasindexes,
    hasrules,
    hastriggers
FROM pg_tables 
WHERE schemaname = 'public'
ORDER BY tablename;
"@ "Liste des tables"

# 3. Statistiques des tables
Execute-Query @"
SELECT 
    schemaname,
    tablename,
    n_tup_ins as inserts,
    n_tup_upd as updates,
    n_tup_del as deletes,
    n_live_tup as live_tuples,
    n_dead_tup as dead_tuples
FROM pg_stat_user_tables 
ORDER BY n_live_tuples DESC;
"@ "Statistiques des tables"

# 4. Contenu de la table users
Execute-Query @"
SELECT 
    id,
    email,
    role,
    full_name,
    created_at
FROM users 
ORDER BY created_at DESC 
LIMIT 10;
"@ "Utilisateurs (10 derniers)"

# 5. Contenu de la table restaurants
Execute-Query @"
SELECT 
    id,
    name,
    code,
    city,
    phone,
    email
FROM restaurants 
ORDER BY id;
"@ "Restaurants"

# 6. Contenu de la table menus
Execute-Query @"
SELECT 
    m.id,
    m.title,
    r.name as restaurant_name,
    m.active_from,
    m.active_to
FROM menus m
JOIN restaurants r ON m.restaurant_id = r.id
ORDER BY m.id;
"@ "Menus"

# 7. Contenu de la table menu_items
Execute-Query @"
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
LIMIT 15;
"@ "Plats (15 premiers)"

# 8. Contenu de la table events
Execute-Query @"
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
LIMIT 10;
"@ "Événements (10 derniers)"

# 9. Contenu de la table allergens
Execute-Query @"
SELECT 
    id,
    code,
    label
FROM allergens 
ORDER BY code;
"@ "Allergènes"

# 10. Contenu de la table reservations (si elle existe)
Execute-Query @"
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
LIMIT 10;
"@ "Réservations (10 dernières)"

# 11. Contenu de la table room_reservations (si elle existe)
Execute-Query @"
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
LIMIT 10;
"@ "Réservations de salles (10 dernières)"

# 12. Contenu de la table bookings (si elle existe)
Execute-Query @"
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
LIMIT 10;
"@ "Réservations d'événements (10 dernières)"

# 13. Compteurs généraux
Execute-Query @"
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
    'bookings' as table_name, COUNT(*) as count FROM bookings;
"@ "Compteurs par table"

# 14. Informations sur les migrations Flyway
Execute-Query @"
SELECT 
    version,
    description,
    type,
    script,
    checksum,
    installed_on,
    execution_time
FROM flyway_schema_history 
ORDER BY installed_rank DESC
LIMIT 10;
"@ "Migrations Flyway (10 dernières)"

Write-Host "🏁 Inspection terminée !" -ForegroundColor Green
Write-Host ""
Write-Host "💡 Pour examiner une table spécifique, utilisez:" -ForegroundColor Cyan
Write-Host "   `$env:PGPASSWORD='$DB_PASSWORD'; psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c `"SELECT * FROM nom_table LIMIT 10;`"" -ForegroundColor Gray
Write-Host ""
Write-Host "🔗 URL de connexion complète:" -ForegroundColor Cyan
Write-Host "   postgresql://$DB_USER`:$DB_PASSWORD@$DB_HOST`:$DB_PORT/$DB_NAME" -ForegroundColor Gray
