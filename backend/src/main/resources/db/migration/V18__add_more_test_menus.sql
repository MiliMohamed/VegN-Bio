-- Ajouter des menus de test pour tous les restaurants

-- Menu pour République (ID 2)
INSERT INTO menus (restaurant_id, title, active_from, active_to)
VALUES (2, 'Menu Printemps Bio', CURRENT_DATE, CURRENT_DATE + INTERVAL '30 days');

INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
VALUES 
  ((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=2), 'Salade de quinoa', 'Quinoa bio, légumes de saison, vinaigrette citron', 1250, TRUE),
  ((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=2), 'Tartine avocat', 'Pain complet, avocat, tomates cerises, graines', 950, TRUE);

-- Menu pour Nation (ID 3)
INSERT INTO menus (restaurant_id, title, active_from, active_to)
VALUES (3, 'Menu Été Légumes', CURRENT_DATE, CURRENT_DATE + INTERVAL '30 days');

INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
VALUES 
  ((SELECT id FROM menus WHERE title='Menu Été Légumes' AND restaurant_id=3), 'Bowl végétarien', 'Riz complet, légumes grillés, sauce tahini', 1450, TRUE),
  ((SELECT id FROM menus WHERE title='Menu Été Légumes' AND restaurant_id=3), 'Gazpacho', 'Soupe froide tomates, concombre, basilic', 890, TRUE);

-- Menu pour Place d'Italie (ID 4)
INSERT INTO menus (restaurant_id, title, active_from, active_to)
VALUES (4, 'Menu Méditerranéen', CURRENT_DATE, CURRENT_DATE + INTERVAL '30 days');

INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
VALUES 
  ((SELECT id FROM menus WHERE title='Menu Méditerranéen' AND restaurant_id=4), 'Pâtes aux légumes', 'Pâtes complètes, courgettes, tomates, basilic', 1350, TRUE),
  ((SELECT id FROM menus WHERE title='Menu Méditerranéen' AND restaurant_id=4), 'Ratatouille', 'Légumes provençaux mijotés, herbes', 1150, TRUE);

-- Menu pour Beaubourg (ID 7)
INSERT INTO menus (restaurant_id, title, active_from, active_to)
VALUES (7, 'Menu Gourmet Bio', CURRENT_DATE, CURRENT_DATE + INTERVAL '30 days');

INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
VALUES 
  ((SELECT id FROM menus WHERE title='Menu Gourmet Bio' AND restaurant_id=7), 'Risotto aux champignons', 'Riz bio, champignons de saison, parmesan végétal', 1650, TRUE),
  ((SELECT id FROM menus WHERE title='Menu Gourmet Bio' AND restaurant_id=7), 'Tartare d\'avocat', 'Avocat, tomates, oignons, coriandre', 1200, TRUE);

-- Ajouter un menu pour le restaurant ID 1 (Bastille) en plus de celui existant
INSERT INTO menus (restaurant_id, title, active_from, active_to)
VALUES (1, 'Menu Hiver Réconfortant', CURRENT_DATE, CURRENT_DATE + INTERVAL '30 days');

INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
VALUES 
  ((SELECT id FROM menus WHERE title='Menu Hiver Réconfortant' AND restaurant_id=1), 'Curry de légumes', 'Légumes de saison, lait de coco, riz basmati', 1550, TRUE),
  ((SELECT id FROM menus WHERE title='Menu Hiver Réconfortant' AND restaurant_id=1), 'Soupe de lentilles', 'Lentilles corail, légumes, épices', 1050, TRUE);
