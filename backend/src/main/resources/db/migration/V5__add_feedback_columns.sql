-- Flyway Migration: V5__add_feedback_columns.sql
-- Ajouter les colonnes manquantes aux tables reviews et reports

-- Ajouter les colonnes manquantes à la table reviews
ALTER TABLE reviews ADD COLUMN customer_email VARCHAR(190);
ALTER TABLE reviews ADD COLUMN status VARCHAR(32) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING','APPROVED','REJECTED'));

-- Ajouter les colonnes manquantes à la table reports
ALTER TABLE reports ADD COLUMN reporter_email VARCHAR(190);
ALTER TABLE reports ADD COLUMN report_type VARCHAR(100) NOT NULL DEFAULT 'OTHER';
ALTER TABLE reports ADD COLUMN description TEXT NOT NULL DEFAULT '';
ALTER TABLE reports ADD COLUMN status VARCHAR(32) NOT NULL DEFAULT 'OPEN' CHECK (status IN ('OPEN','IN_PROGRESS','RESOLVED','CLOSED'));
ALTER TABLE reports ADD COLUMN resolved_at TIMESTAMPTZ;

