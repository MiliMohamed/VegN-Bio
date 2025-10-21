-- Migration V3: Ajout du module panier
-- Tables pour la gestion du panier d'achat

CREATE TABLE IF NOT EXISTS carts (
    id              BIGSERIAL PRIMARY KEY,
    user_id         BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ,
    status          VARCHAR(32) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE','ABANDONED','CONVERTED_TO_ORDER'))
);

CREATE TABLE IF NOT EXISTS cart_items (
    id                  BIGSERIAL PRIMARY KEY,
    cart_id             BIGINT NOT NULL REFERENCES carts(id) ON DELETE CASCADE,
    menu_item_id        BIGINT NOT NULL REFERENCES menu_items(id) ON DELETE CASCADE,
    quantity            INT NOT NULL CHECK (quantity > 0),
    unit_price_cents    BIGINT NOT NULL CHECK (unit_price_cents >= 0),
    special_instructions TEXT,
    added_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes pour optimiser les performances
CREATE INDEX IF NOT EXISTS idx_carts_user_status ON carts(user_id, status);
CREATE INDEX IF NOT EXISTS idx_cart_items_cart ON cart_items(cart_id);
CREATE INDEX IF NOT EXISTS idx_cart_items_menu_item ON cart_items(menu_item_id);

-- Contrainte pour s'assurer qu'un utilisateur n'a qu'un seul panier actif
CREATE UNIQUE INDEX IF NOT EXISTS idx_carts_user_active ON carts(user_id) WHERE status = 'ACTIVE';
