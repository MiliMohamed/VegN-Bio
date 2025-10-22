-- Migration V24: Ajouter des menus avec les vrais IDs de restaurants
-- Basé sur les restaurants existants : 68, 69, 70, 71, 72

-- Menu pour VEG'N BIO BASTILLE (ID: 68)
INSERT INTO menus (restaurant_id, title, active_from, active_to)
VALUES (68, 'Menu Automne 2024 - Bastille', '2024-10-01', '2024-12-31');

-- Menu pour VEG'N BIO REPUBLIQUE (ID: 69)
INSERT INTO menus (restaurant_id, title, active_from, active_to)
VALUES (69, 'Menu Automne 2024 - République', '2024-10-01', '2024-12-31');

-- Menu pour VEG'N BIO NATION (ID: 70)
INSERT INTO menus (restaurant_id, title, active_from, active_to)
VALUES (70, 'Menu Automne 2024 - Nation', '2024-10-01', '2024-12-31');

-- Menu pour VEG'N BIO PLACE D'ITALIE (ID: 71)
INSERT INTO menus (restaurant_id, title, active_from, active_to)
VALUES (71, 'Menu Automne 2024 - Place d''Italie', '2024-10-01', '2024-12-31');

-- Menu pour VEG'N BIO BEAUBOURG (ID: 72)
INSERT INTO menus (restaurant_id, title, active_from, active_to)
VALUES (72, 'Menu Automne 2024 - Beaubourg', '2024-10-01', '2024-12-31');

-- Ajouter des éléments de menu pour chaque restaurant
-- Bastille (ID: 68)
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
SELECT 
    m.id,
    'Burger Tofu Bio',
    'Burger au tofu grillé, salade croquante, tomates, sauce sésame, pain complet bio',
    1290,
    TRUE
FROM menus m 
WHERE m.restaurant_id = 68 AND m.title = 'Menu Automne 2024 - Bastille';

INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
SELECT 
    m.id,
    'Velouté de Courge',
    'Velouté de courge butternut bio, graines de courge, crème de coco',
    790,
    TRUE
FROM menus m 
WHERE m.restaurant_id = 68 AND m.title = 'Menu Automne 2024 - Bastille';

INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
SELECT 
    m.id,
    'Salade Quinoa',
    'Salade de quinoa bio, légumes de saison, noix, vinaigrette citron',
    1090,
    TRUE
FROM menus m 
WHERE m.restaurant_id = 68 AND m.title = 'Menu Automne 2024 - Bastille';

-- République (ID: 69)
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
SELECT 
    m.id,
    'Curry de Légumes',
    'Curry de légumes bio, lait de coco, riz basmati, coriandre fraîche',
    1190,
    TRUE
FROM menus m 
WHERE m.restaurant_id = 69 AND m.title = 'Menu Automne 2024 - République';

INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
SELECT 
    m.id,
    'Poke Bowl Végétal',
    'Bowl de quinoa, avocat, edamame, carottes, sauce tahini',
    1390,
    TRUE
FROM menus m 
WHERE m.restaurant_id = 69 AND m.title = 'Menu Automne 2024 - République';

-- Nation (ID: 70)
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
SELECT 
    m.id,
    'Tartine Avocat',
    'Tartine de pain complet, avocat, tomates cerises, graines, citron',
    890,
    TRUE
FROM menus m 
WHERE m.restaurant_id = 70 AND m.title = 'Menu Automne 2024 - Nation';

INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
SELECT 
    m.id,
    'Wrap Falafel',
    'Wrap de falafel maison, houmous, légumes croquants, sauce tahini',
    1090,
    TRUE
FROM menus m 
WHERE m.restaurant_id = 70 AND m.title = 'Menu Automne 2024 - Nation';

-- Place d'Italie (ID: 71)
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
SELECT 
    m.id,
    'Pâtes Carbonara Végétale',
    'Pâtes complètes, sauce crémeuse aux champignons, noix de cajou',
    1190,
    TRUE
FROM menus m 
WHERE m.restaurant_id = 71 AND m.title = 'Menu Automne 2024 - Place d''Italie';

INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
SELECT 
    m.id,
    'Risotto aux Champignons',
    'Risotto crémeux aux champignons de saison, parmesan végétal',
    1290,
    TRUE
FROM menus m 
WHERE m.restaurant_id = 71 AND m.title = 'Menu Automne 2024 - Place d''Italie';

-- Beaubourg (ID: 72)
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
SELECT 
    m.id,
    'Bowl Buddha',
    'Bowl de légumes rôtis, quinoa, avocat, sauce miso, graines',
    1390,
    TRUE
FROM menus m 
WHERE m.restaurant_id = 72 AND m.title = 'Menu Automne 2024 - Beaubourg';

INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
SELECT 
    m.id,
    'Soupe Miso',
    'Soupe miso traditionnelle, algues, tofu, légumes croquants',
    690,
    TRUE
FROM menus m 
WHERE m.restaurant_id = 72 AND m.title = 'Menu Automne 2024 - Beaubourg';
