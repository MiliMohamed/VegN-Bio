-- Migration V12: Ajout du module gestion des salles et réservations
-- Tables pour la gestion des salles de réunion et leurs réservations

CREATE TABLE IF NOT EXISTS rooms (
    id                  BIGSERIAL PRIMARY KEY,
    restaurant_id       BIGINT NOT NULL REFERENCES restaurants(id) ON DELETE CASCADE,
    name                VARCHAR(190) NOT NULL,
    description         TEXT,
    capacity            INT NOT NULL CHECK (capacity > 0),
    hourly_rate_cents   BIGINT CHECK (hourly_rate_cents >= 0),
    has_wifi            BOOLEAN NOT NULL DEFAULT FALSE,
    has_printer         BOOLEAN NOT NULL DEFAULT FALSE,
    has_projector       BOOLEAN NOT NULL DEFAULT FALSE,
    has_whiteboard      BOOLEAN NOT NULL DEFAULT FALSE,
    status              VARCHAR(32) NOT NULL DEFAULT 'AVAILABLE' CHECK (status IN ('AVAILABLE','MAINTENANCE','OUT_OF_ORDER')),
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS room_reservations (
    id                      BIGSERIAL PRIMARY KEY,
    room_id                 BIGINT NOT NULL REFERENCES rooms(id) ON DELETE CASCADE,
    user_id                 BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    reservation_date        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    start_time              TIMESTAMPTZ NOT NULL,
    end_time                TIMESTAMPTZ NOT NULL,
    purpose                 VARCHAR(190),
    attendees_count         INT CHECK (attendees_count > 0),
    special_requirements    TEXT,
    status                  VARCHAR(32) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING','CONFIRMED','CANCELLED','COMPLETED','NO_SHOW')),
    total_price_cents       BIGINT CHECK (total_price_cents >= 0),
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ,
    notes                   TEXT
);

-- Indexes pour optimiser les performances
CREATE INDEX IF NOT EXISTS idx_rooms_restaurant ON rooms(restaurant_id);
CREATE INDEX IF NOT EXISTS idx_rooms_status ON rooms(status);
CREATE INDEX IF NOT EXISTS idx_rooms_capacity ON rooms(capacity);

CREATE INDEX IF NOT EXISTS idx_room_reservations_room ON room_reservations(room_id);
CREATE INDEX IF NOT EXISTS idx_room_reservations_user ON room_reservations(user_id);
CREATE INDEX IF NOT EXISTS idx_room_reservations_status ON room_reservations(status);
CREATE INDEX IF NOT EXISTS idx_room_reservations_time ON room_reservations(start_time, end_time);

-- Index composite pour vérifier les conflits de réservation
CREATE INDEX IF NOT EXISTS idx_room_reservations_conflict ON room_reservations(room_id, start_time, end_time, status) 
WHERE status IN ('PENDING', 'CONFIRMED');

-- Contrainte pour s'assurer que end_time > start_time
ALTER TABLE room_reservations ADD CONSTRAINT chk_reservation_time CHECK (end_time > start_time);

-- Contrainte pour s'assurer que la capacité de la salle est respectée
ALTER TABLE room_reservations ADD CONSTRAINT chk_attendees_capacity 
CHECK (attendees_count IS NULL OR attendees_count <= (
    SELECT capacity FROM rooms WHERE id = room_reservations.room_id
));
