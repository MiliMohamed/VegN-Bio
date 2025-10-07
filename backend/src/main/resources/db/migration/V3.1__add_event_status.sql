-- Flyway Migration: V3.1__add_event_status.sql
-- Ajouter la colonne status à la table events

ALTER TABLE events ADD COLUMN status VARCHAR(32) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE','CANCELLED','COMPLETED'));
