-- Flyway Migration: V1__init.sql
-- Schéma minimal conforme au MVP
CREATE TABLE IF NOT EXISTS users (
  id              BIGSERIAL PRIMARY KEY,
  email           VARCHAR(190) NOT NULL UNIQUE,
  password_hash   VARCHAR(255) NOT NULL,
  role            VARCHAR(32)  NOT NULL CHECK (role IN ('CLIENT','RESTAURATEUR','FOURNISSEUR','ADMIN')),
  full_name       VARCHAR(190),
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS restaurants (
  id         BIGSERIAL PRIMARY KEY,
  name       VARCHAR(190) NOT NULL,
  code       VARCHAR(32)  NOT NULL UNIQUE,
  address    TEXT,
  city       VARCHAR(120),
  phone      VARCHAR(64)
);

CREATE TABLE IF NOT EXISTS menus (
  id            BIGSERIAL PRIMARY KEY,
  restaurant_id BIGINT NOT NULL REFERENCES restaurants(id) ON DELETE CASCADE,
  title         VARCHAR(190) NOT NULL,
  active_from   DATE,
  active_to     DATE
);

CREATE TABLE IF NOT EXISTS menu_items (
  id            BIGSERIAL PRIMARY KEY,
  menu_id       BIGINT NOT NULL REFERENCES menus(id) ON DELETE CASCADE,
  name          VARCHAR(190) NOT NULL,
  description   TEXT,
  price_cents   INT NOT NULL CHECK (price_cents >= 0),
  is_vegan      BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS allergens (
  id    BIGSERIAL PRIMARY KEY,
  code  VARCHAR(32) NOT NULL UNIQUE,
  label VARCHAR(190) NOT NULL
);

CREATE TABLE IF NOT EXISTS menu_item_allergens (
  menu_item_id BIGINT NOT NULL REFERENCES menu_items(id) ON DELETE CASCADE,
  allergen_id  BIGINT NOT NULL REFERENCES allergens(id)   ON DELETE CASCADE,
  PRIMARY KEY(menu_item_id, allergen_id)
);

CREATE TABLE IF NOT EXISTS events (
  id            BIGSERIAL PRIMARY KEY,
  restaurant_id BIGINT NOT NULL REFERENCES restaurants(id) ON DELETE CASCADE,
  title         VARCHAR(190) NOT NULL,
  type          VARCHAR(80),
  date_start    TIMESTAMPTZ NOT NULL,
  date_end      TIMESTAMPTZ,
  capacity      INT CHECK (capacity IS NULL OR capacity >= 0),
  description   TEXT
);

CREATE TABLE IF NOT EXISTS bookings (
  id             BIGSERIAL PRIMARY KEY,
  event_id       BIGINT NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  customer_name  VARCHAR(190) NOT NULL,
  customer_phone VARCHAR(64),
  pax            INT NOT NULL CHECK (pax > 0),
  status         VARCHAR(32) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING','CONFIRMED','CANCELLED')),
  created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS suppliers (
  id            BIGSERIAL PRIMARY KEY,
  company_name  VARCHAR(190) NOT NULL,
  contact_email VARCHAR(190) NOT NULL
);

CREATE TABLE IF NOT EXISTS offers (
  id           BIGSERIAL PRIMARY KEY,
  supplier_id  BIGINT NOT NULL REFERENCES suppliers(id) ON DELETE CASCADE,
  title        VARCHAR(190) NOT NULL,
  description  TEXT,
  unit_price_cents INT NOT NULL CHECK (unit_price_cents >= 0),
  unit         VARCHAR(32) NOT NULL,
  status       VARCHAR(32) NOT NULL DEFAULT 'DRAFT' CHECK (status IN ('DRAFT','PUBLISHED','ARCHIVED')),
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS reviews (
  id            BIGSERIAL PRIMARY KEY,
  user_id       BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  restaurant_id BIGINT NOT NULL REFERENCES restaurants(id) ON DELETE CASCADE,
  rating        INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment       TEXT,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS reports (
  id         BIGSERIAL PRIMARY KEY,
  user_id    BIGINT REFERENCES users(id) ON DELETE SET NULL,
  context    VARCHAR(190),
  message    TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS tickets (
  id            BIGSERIAL PRIMARY KEY,
  restaurant_id BIGINT NOT NULL REFERENCES restaurants(id) ON DELETE CASCADE,
  opened_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  closed_at     TIMESTAMPTZ,
  total_cents   INT NOT NULL DEFAULT 0 CHECK (total_cents >= 0),
  status        VARCHAR(32) NOT NULL DEFAULT 'OPEN' CHECK (status IN ('OPEN','CLOSED'))
);

CREATE TABLE IF NOT EXISTS ticket_lines (
  id               BIGSERIAL PRIMARY KEY,
  ticket_id        BIGINT NOT NULL REFERENCES tickets(id) ON DELETE CASCADE,
  menu_item_id     BIGINT NOT NULL REFERENCES menu_items(id) ON DELETE RESTRICT,
  qty              INT NOT NULL CHECK (qty > 0),
  unit_price_cents INT NOT NULL CHECK (unit_price_cents >= 0),
  line_total_cents INT NOT NULL CHECK (line_total_cents >= 0)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_menu_items_name ON menu_items(name);
CREATE INDEX IF NOT EXISTS idx_reviews_restaurant ON reviews(restaurant_id);
CREATE INDEX IF NOT EXISTS idx_offers_supplier_status ON offers(supplier_id, status);



