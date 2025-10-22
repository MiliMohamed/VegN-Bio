-- Injection de donnees de test VEG'N BIO

-- Verifier les restaurants existants
SELECT 'Restaurants existants:' as info;
SELECT id, name, code FROM restaurants;

-- Ajouter des menus de test si ils n'existent pas
INSERT INTO menus (restaurant_id, title, active_from, active_to)
SELECT r.id, 'Menu Test PowerShell', CURRENT_DATE, CURRENT_DATE + INTERVAL '30 days'
FROM restaurants r
WHERE NOT EXISTS (
    SELECT 1 FROM menus m WHERE m.restaurant_id = r.id AND m.title = 'Menu Test PowerShell'
);

-- Ajouter des plats aux menus
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
SELECT m.id, 'Burger Tofu Test', 'Burger aux legumes grilles, tofu marine', 1590, true
FROM menus m
WHERE m.title = 'Menu Test PowerShell'
AND NOT EXISTS (
    SELECT 1 FROM menu_items mi WHERE mi.menu_id = m.id AND mi.name = 'Burger Tofu Test'
);

INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
SELECT m.id, 'Salade Quinoa Test', 'Quinoa bio, legumes de saison, noix', 1290, true
FROM menus m
WHERE m.title = 'Menu Test PowerShell'
AND NOT EXISTS (
    SELECT 1 FROM menu_items mi WHERE mi.menu_id = m.id AND mi.name = 'Salade Quinoa Test'
);

INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
SELECT m.id, 'Curry Legumes Test', 'Curry aux legumes bio, riz complet', 1490, true
FROM menus m
WHERE m.title = 'Menu Test PowerShell'
AND NOT EXISTS (
    SELECT 1 FROM menu_items mi WHERE mi.menu_id = m.id AND mi.name = 'Curry Legumes Test'
);

-- Ajouter des evenements de test
INSERT INTO events (restaurant_id, title, type, date_start, date_end, capacity, description)
SELECT r.id, 'Conference Test PowerShell', 'CONFERENCE', 
       CURRENT_TIMESTAMP + INTERVAL '7 days', 
       CURRENT_TIMESTAMP + INTERVAL '7 days' + INTERVAL '2 hours',
       20, 'Conference de test creee via PowerShell'
FROM restaurants r
WHERE NOT EXISTS (
    SELECT 1 FROM events e WHERE e.restaurant_id = r.id AND e.title = 'Conference Test PowerShell'
);

-- Verifier les donnees ajoutees
SELECT 'Menus crees:' as info;
SELECT m.title, r.name as restaurant, COUNT(mi.id) as nb_plats
FROM menus m
JOIN restaurants r ON m.restaurant_id = r.id
WHERE m.title = 'Menu Test PowerShell'
GROUP BY m.title, r.name;

SELECT 'Plats ajoutes:' as info;
SELECT mi.name, mi.description, mi.price_cents, m.title as menu
FROM menu_items mi
JOIN menus m ON mi.menu_id = m.id
WHERE m.title = 'Menu Test PowerShell';

SELECT 'Evenements crees:' as info;
SELECT e.title, e.type, r.name as restaurant
FROM events e
JOIN restaurants r ON e.restaurant_id = r.id
WHERE e.title = 'Conference Test PowerShell';
