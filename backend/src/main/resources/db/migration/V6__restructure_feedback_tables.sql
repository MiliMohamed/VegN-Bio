-- Flyway Migration: V6__restructure_feedback_tables.sql
-- Restructurer les tables reviews et reports pour correspondre aux entités

-- Supprimer les anciennes tables et les recréer avec la nouvelle structure
DROP TABLE IF EXISTS reviews CASCADE;
DROP TABLE IF EXISTS reports CASCADE;

-- Recréer la table reviews avec la nouvelle structure
CREATE TABLE reviews (
  id            BIGSERIAL PRIMARY KEY,
  restaurant_id BIGINT NOT NULL REFERENCES restaurants(id) ON DELETE CASCADE,
  customer_name VARCHAR(190) NOT NULL,
  customer_email VARCHAR(190),
  rating        INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment       TEXT,
  status        VARCHAR(32) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING','APPROVED','REJECTED')),
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Recréer la table reports avec la nouvelle structure
CREATE TABLE reports (
  id            BIGSERIAL PRIMARY KEY,
  restaurant_id BIGINT NOT NULL REFERENCES restaurants(id) ON DELETE CASCADE,
  reporter_name VARCHAR(190) NOT NULL,
  reporter_email VARCHAR(190),
  report_type   VARCHAR(100) NOT NULL,
  description   TEXT NOT NULL,
  status        VARCHAR(32) NOT NULL DEFAULT 'OPEN' CHECK (status IN ('OPEN','IN_PROGRESS','RESOLVED','CLOSED')),
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  resolved_at   TIMESTAMPTZ
);

