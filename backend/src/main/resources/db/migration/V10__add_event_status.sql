-- Migration V10: Ajouter la colonne status à la table events
-- Cette migration ajoute la colonne status pour gérer l'état des événements

ALTER TABLE events ADD COLUMN IF NOT EXISTS status VARCHAR(32) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE','CANCELLED','COMPLETED'));
