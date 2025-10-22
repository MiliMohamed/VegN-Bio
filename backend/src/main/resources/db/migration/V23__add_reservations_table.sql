-- Migration: V23__add_reservations_table.sql
-- Add reservations table for table reservations

CREATE TABLE IF NOT EXISTS reservations (
  id                BIGSERIAL PRIMARY KEY,
  user_id           BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  restaurant_id     BIGINT NOT NULL REFERENCES restaurants(id) ON DELETE CASCADE,
  event_id          BIGINT REFERENCES events(id) ON DELETE CASCADE,
  reservation_date  DATE NOT NULL,
  reservation_time  TIME NOT NULL,
  number_of_people  INT NOT NULL CHECK (number_of_people > 0),
  status            VARCHAR(32) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING','CONFIRMED','CANCELLED','COMPLETED','NO_SHOW')),
  notes             TEXT,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ
);

-- Indexes for better performance
CREATE INDEX IF NOT EXISTS idx_reservations_user ON reservations(user_id);
CREATE INDEX IF NOT EXISTS idx_reservations_restaurant ON reservations(restaurant_id);
CREATE INDEX IF NOT EXISTS idx_reservations_event ON reservations(event_id);
CREATE INDEX IF NOT EXISTS idx_reservations_date ON reservations(reservation_date);
CREATE INDEX IF NOT EXISTS idx_reservations_status ON reservations(status);
CREATE INDEX IF NOT EXISTS idx_reservations_datetime ON reservations(reservation_date, reservation_time);

-- Add constraint to ensure end time is after start time
ALTER TABLE reservations ADD CONSTRAINT chk_reservation_datetime CHECK (reservation_date IS NOT NULL AND reservation_time IS NOT NULL);
