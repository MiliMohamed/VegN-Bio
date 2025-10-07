-- Migration pour corriger le type de colonne confidence
-- V9__fix_confidence_column_type.sql

-- Modifier le type de colonne confidence de DECIMAL vers DOUBLE PRECISION
ALTER TABLE veterinary_consultations 
ALTER COLUMN confidence TYPE DOUBLE PRECISION USING confidence::DOUBLE PRECISION;
