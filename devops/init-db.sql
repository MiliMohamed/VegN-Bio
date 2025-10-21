-- Script d'initialisation de la base de données pour Docker
-- Ce fichier est exécuté automatiquement lors de la création du conteneur PostgreSQL

-- Créer la base de données si elle n'existe pas
SELECT 'CREATE DATABASE vegnbiodb'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'vegnbiodb')\gexec

-- Se connecter à la base vegnbiodb
\c vegnbiodb;

-- Créer un utilisateur si nécessaire (optionnel, postgres est déjà créé)
-- CREATE USER vegn_user WITH PASSWORD 'vegn_password';
-- GRANT ALL PRIVILEGES ON DATABASE vegnbiodb TO vegn_user;

-- Message de confirmation
DO $$
BEGIN
    RAISE NOTICE 'Base de données vegnbiodb initialisée avec succès!';
    RAISE NOTICE 'Les migrations Flyway seront exécutées automatiquement par Spring Boot.';
END $$;
