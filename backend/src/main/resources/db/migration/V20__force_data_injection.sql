-- Migration V20 pour forcer l'injection des donnees VEG'N BIO
-- V20__force_data_injection.sql

-- Supprimer les donnees existantes pour repartir a zero
TRUNCATE TABLE error_reports CASCADE;
TRUNCATE TABLE bookings CASCADE;
TRUNCATE TABLE events CASCADE;
TRUNCATE TABLE menu_items CASCADE;
TRUNCATE TABLE menus CASCADE;
TRUNCATE TABLE users CASCADE;

-- Recreer les utilisateurs
INSERT INTO users (email, password_hash, role, full_name) VALUES
('admin@vegnbio.fr', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'ADMIN', 'Administrateur VEGN BIO'),
('restaurateur@vegnbio.fr', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'RESTAURATEUR', 'Gerant Restaurant'),
('client@vegnbio.fr', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'CLIENT', 'Client Test')
ON CONFLICT (email) DO NOTHING;

-- Creer des menus pour chaque restaurant
INSERT INTO menus (restaurant_id, title, active_from, active_to)
SELECT r.id, 'Menu Principal ' || r.name, CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days'
FROM restaurants r
WHERE r.code IN ('BAS', 'REP', 'NAT', 'PLI', 'BEA');

INSERT INTO menus (restaurant_id, title, active_from, active_to)
SELECT r.id, 'Menu Dejeuner ' || r.name, CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days'
FROM restaurants r
WHERE r.code IN ('BAS', 'REP', 'NAT', 'PLI', 'BEA');

-- Ajouter des plats aux menus
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
SELECT m.id, 'Burger Tofu Bio', 'Burger aux legumes grilles, tofu marine, salade croquante', 1590, true
FROM menus m
WHERE m.title LIKE 'Menu Principal%';

INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
SELECT m.id, 'Salade Quinoa', 'Quinoa bio, legumes de saison, noix, vinaigrette citron', 1290, true
FROM menus m
WHERE m.title LIKE 'Menu Principal%';

INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
SELECT m.id, 'Curry de Legumes', 'Curry aux legumes bio, riz complet, lait de coco', 1490, true
FROM menus m
WHERE m.title LIKE 'Menu Principal%';

INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
SELECT m.id, 'Pizza Margherita Vegetale', 'Pate fine, tomates, mozzarella vegetale, basilic', 1690, true
FROM menus m
WHERE m.title LIKE 'Menu Principal%';

INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
SELECT m.id, 'Lasagnes Vegetales', 'Lasagnes aux legumes, bechamel vegetale, parmesan vegetal', 1790, true
FROM menus m
WHERE m.title LIKE 'Menu Principal%';

-- Plats pour les menus dejeuner
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
SELECT m.id, 'Soupe Courge', 'Veloute de courge bio, graines de courge', 890, true
FROM menus m
WHERE m.title LIKE 'Menu Dejeuner%';

INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
SELECT m.id, 'Wrap Avocat', 'Wrap aux legumes, avocat, hummus, pousses', 1190, true
FROM menus m
WHERE m.title LIKE 'Menu Dejeuner%';

INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
SELECT m.id, 'Bowl Buddha', 'Riz brun, legumes grilles, avocat, graines, tahini', 1290, true
FROM menus m
WHERE m.title LIKE 'Menu Dejeuner%';

-- Creer des evenements pour chaque restaurant
INSERT INTO events (restaurant_id, title, type, date_start, date_end, capacity, description)
SELECT r.id, 'Conference Mardi', 'CONFERENCE', 
       CURRENT_TIMESTAMP + INTERVAL '7 days', 
       CURRENT_TIMESTAMP + INTERVAL '7 days' + INTERVAL '2 hours',
       30, 'Conference hebdomadaire du mardi apres-midi'
FROM restaurants r
WHERE r.code IN ('BAS', 'REP', 'NAT', 'PLI', 'BEA');

INSERT INTO events (restaurant_id, title, type, date_start, date_end, capacity, description)
SELECT r.id, 'Animation Culinaire', 'ANIMATION', 
       CURRENT_TIMESTAMP + INTERVAL '10 days', 
       CURRENT_TIMESTAMP + INTERVAL '10 days' + INTERVAL '3 hours',
       20, 'Animation culinaire bio'
FROM restaurants r
WHERE r.code IN ('BAS', 'REP', 'NAT', 'PLI', 'BEA');

INSERT INTO events (restaurant_id, title, type, date_start, date_end, capacity, description)
SELECT r.id, 'Reunion Equipe', 'REUNION', 
       CURRENT_TIMESTAMP + INTERVAL '14 days', 
       CURRENT_TIMESTAMP + INTERVAL '14 days' + INTERVAL '1 hour',
       15, 'Reunion d''equipe mensuelle'
FROM restaurants r
WHERE r.code IN ('BAS', 'REP', 'NAT', 'PLI', 'BEA');

-- Creer des reservations pour les evenements
INSERT INTO bookings (event_id, customer_name, customer_phone, pax, status)
SELECT e.id, 'Marie Dupont', '+33 6 12 34 56 78', 2, 'CONFIRMED'
FROM events e
WHERE e.title = 'Conference Mardi'
LIMIT 5;

INSERT INTO bookings (event_id, customer_name, customer_phone, pax, status)
SELECT e.id, 'Jean Martin', '+33 6 87 65 43 21', 1, 'PENDING'
FROM events e
WHERE e.title = 'Animation Culinaire'
LIMIT 5;

INSERT INTO bookings (event_id, customer_name, customer_phone, pax, status)
SELECT e.id, 'Sophie Bernard', '+33 6 11 22 33 44', 3, 'CONFIRMED'
FROM events e
WHERE e.title = 'Reunion Equipe'
LIMIT 5;

-- Creer des rapports d'exemple
INSERT INTO error_reports (error_type, description, user_id, created_at) VALUES
('Allergene', 'Le plat Burger Tofu Bio contient du sesame mais ce n''est pas mentionne clairement', 'client@vegnbio.fr', CURRENT_TIMESTAMP),
('Menu', 'Besoin d''ajouter plus d''options sans gluten au menu', 'restaurateur@vegnbio.fr', CURRENT_TIMESTAMP),
('Systeme', 'Amelioration de l''interface de reservation des salles', 'admin@vegnbio.fr', CURRENT_TIMESTAMP),
('Service', 'Le service etait excellent, merci pour l''experience', 'client@vegnbio.fr', CURRENT_TIMESTAMP),
('Produit', 'Les produits bio sont de tres bonne qualite', 'client@vegnbio.fr', CURRENT_TIMESTAMP);

-- Afficher un message de confirmation
DO $$
BEGIN
    RAISE NOTICE 'Migration V20: Donnees VEGN BIO injectees avec succes!';
    RAISE NOTICE 'Utilisateurs crees: 3 (Admin, Client, Restaurateur)';
    RAISE NOTICE 'Menus crees: %', (SELECT COUNT(*) FROM menus);
    RAISE NOTICE 'Plats crees: %', (SELECT COUNT(*) FROM menu_items);
    RAISE NOTICE 'Evenements crees: %', (SELECT COUNT(*) FROM events);
    RAISE NOTICE 'Reservations creees: %', (SELECT COUNT(*) FROM bookings);
    RAISE NOTICE 'Rapports crees: %', (SELECT COUNT(*) FROM error_reports);
END $$;
