-- Flyway Migration: V4__add_marketplace_columns.sql
-- Ajouter les colonnes manquantes aux tables suppliers et offers

-- Ajouter les colonnes manquantes à la table suppliers
ALTER TABLE suppliers ADD COLUMN contact_phone VARCHAR(64);
ALTER TABLE suppliers ADD COLUMN address TEXT;
ALTER TABLE suppliers ADD COLUMN city VARCHAR(100);
ALTER TABLE suppliers ADD COLUMN description TEXT;
ALTER TABLE suppliers ADD COLUMN status VARCHAR(32) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE','INACTIVE','SUSPENDED'));
ALTER TABLE suppliers ADD COLUMN created_at TIMESTAMPTZ NOT NULL DEFAULT NOW();

-- Ajouter la colonne updated_at à la table offers
ALTER TABLE offers ADD COLUMN updated_at TIMESTAMPTZ;
