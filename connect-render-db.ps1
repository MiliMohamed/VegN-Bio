# Script PowerShell pour se connecter directement à PostgreSQL Render
# VEG'N BIO - Connexion directe à la base de données

Write-Host "🔍 CONNEXION DIRECTE À LA BASE POSTGRESQL RENDER" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

# Configuration de la base de données Render
$DB_HOST = "dpg-d3i1psbe5dus73a55vp0-a.frankfurt-postgres.render.com"
$DB_PORT = "5432"
$DB_NAME = "vegn_bio_database"
$DB_USER = "vegn_bio_database_user"
$DB_PASSWORD = "N4qpSpMC0y1YlrpFP9VjqJZs64xbyIC6"

Write-Host "📊 Informations de connexion:" -ForegroundColor Green
Write-Host "   Host: $DB_HOST" -ForegroundColor Gray
Write-Host "   Port: $DB_PORT" -ForegroundColor Gray
Write-Host "   Database: $DB_NAME" -ForegroundColor Gray
Write-Host "   User: $DB_USER" -ForegroundColor Gray
Write-Host "   Password: $($DB_PASSWORD.Substring(0,8))..." -ForegroundColor Gray
Write-Host ""

# URL de connexion complète
$ConnectionString = "postgresql://$DB_USER`:$DB_PASSWORD@$DB_HOST`:$DB_PORT/$DB_NAME"
Write-Host "🔗 URL de connexion complète:" -ForegroundColor Cyan
Write-Host "   $ConnectionString" -ForegroundColor Gray
Write-Host ""

# Instructions pour différents clients PostgreSQL
Write-Host "💻 Instructions pour différents clients PostgreSQL:" -ForegroundColor Yellow
Write-Host ""

Write-Host "📱 1. psql (ligne de commande):" -ForegroundColor Blue
Write-Host "   `$env:PGPASSWORD='$DB_PASSWORD'; psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME" -ForegroundColor Gray
Write-Host ""

Write-Host "🖥️ 2. pgAdmin (interface graphique):" -ForegroundColor Blue
Write-Host "   - Créer une nouvelle connexion" -ForegroundColor Gray
Write-Host "   - Host: $DB_HOST" -ForegroundColor Gray
Write-Host "   - Port: $DB_PORT" -ForegroundColor Gray
Write-Host "   - Database: $DB_NAME" -ForegroundColor Gray
Write-Host "   - Username: $DB_USER" -ForegroundColor Gray
Write-Host "   - Password: $DB_PASSWORD" -ForegroundColor Gray
Write-Host ""

Write-Host "🌐 3. DBeaver (interface graphique):" -ForegroundColor Blue
Write-Host "   - Nouvelle connexion PostgreSQL" -ForegroundColor Gray
Write-Host "   - Server Host: $DB_HOST" -ForegroundColor Gray
Write-Host "   - Port: $DB_PORT" -ForegroundColor Gray
Write-Host "   - Database: $DB_NAME" -ForegroundColor Gray
Write-Host "   - Username: $DB_USER" -ForegroundColor Gray
Write-Host "   - Password: $DB_PASSWORD" -ForegroundColor Gray
Write-Host ""

Write-Host "📊 4. Requêtes utiles à exécuter:" -ForegroundColor Blue
Write-Host ""

Write-Host "   📋 Lister toutes les tables:" -ForegroundColor Green
Write-Host "   SELECT tablename FROM pg_tables WHERE schemaname = 'public';" -ForegroundColor Gray
Write-Host ""

Write-Host "   👥 Compter les utilisateurs:" -ForegroundColor Green
Write-Host "   SELECT COUNT(*) FROM users;" -ForegroundColor Gray
Write-Host ""

Write-Host "   🏪 Compter les restaurants:" -ForegroundColor Green
Write-Host "   SELECT COUNT(*) FROM restaurants;" -ForegroundColor Gray
Write-Host ""

Write-Host "   🍽️ Compter les menus:" -ForegroundColor Green
Write-Host "   SELECT COUNT(*) FROM menus;" -ForegroundColor Gray
Write-Host ""

Write-Host "   🥗 Compter les plats:" -ForegroundColor Green
Write-Host "   SELECT COUNT(*) FROM menu_items;" -ForegroundColor Gray
Write-Host ""

Write-Host "   📅 Compter les événements:" -ForegroundColor Green
Write-Host "   SELECT COUNT(*) FROM events;" -ForegroundColor Gray
Write-Host ""

Write-Host "   🚫 Compter les allergènes:" -ForegroundColor Green
Write-Host "   SELECT COUNT(*) FROM allergens;" -ForegroundColor Gray
Write-Host ""

Write-Host "   📋 Compter les réservations:" -ForegroundColor Green
Write-Host "   SELECT COUNT(*) FROM reservations;" -ForegroundColor Gray
Write-Host ""

Write-Host "   🏠 Compter les réservations de salles:" -ForegroundColor Green
Write-Host "   SELECT COUNT(*) FROM room_reservations;" -ForegroundColor Gray
Write-Host ""

Write-Host "   📝 Compter les réservations d'événements:" -ForegroundColor Green
Write-Host "   SELECT COUNT(*) FROM bookings;" -ForegroundColor Gray
Write-Host ""

Write-Host "   🔄 Voir les migrations Flyway:" -ForegroundColor Green
Write-Host "   SELECT version, description, installed_on FROM flyway_schema_history ORDER BY installed_rank DESC;" -ForegroundColor Gray
Write-Host ""

Write-Host "   📊 Statistiques des tables:" -ForegroundColor Green
Write-Host "   SELECT schemaname, tablename, n_live_tup FROM pg_stat_user_tables ORDER BY n_live_tup DESC;" -ForegroundColor Gray
Write-Host ""

Write-Host "🎯 Résumé des données disponibles (via API):" -ForegroundColor Cyan
Write-Host "   ✅ Restaurants: 5 restaurants" -ForegroundColor Green
Write-Host "   ✅ Événements: 9 événements" -ForegroundColor Green
Write-Host "   ✅ Allergènes: 14 allergènes" -ForegroundColor Green
Write-Host "   🔒 Menus: Protégé par authentification" -ForegroundColor Yellow
Write-Host "   🔒 Plats: Protégé par authentification" -ForegroundColor Yellow
Write-Host "   🔒 Utilisateurs: Protégé par authentification" -ForegroundColor Yellow
Write-Host "   🔒 Réservations: Protégé par authentification" -ForegroundColor Yellow
Write-Host ""

Write-Host "💡 Pour une inspection complète, utilisez un client PostgreSQL avec les informations ci-dessus" -ForegroundColor Cyan
