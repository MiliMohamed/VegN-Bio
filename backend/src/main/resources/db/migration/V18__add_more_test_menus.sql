-- Ajouter des menus de test pour tous les restaurants

-- Menu pour République
INSERT INTO menus (restaurant_id, title, active_from, active_to)
VALUES ((SELECT id FROM restaurants WHERE code='REP'), 'Menu Printemps Bio', CURRENT_DATE, CURRENT_DATE + INTERVAL '30 days');

INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
VALUES 
  ((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='REP')), 'Salade de quinoa', 'Quinoa bio, légumes de saison, vinaigrette citron', 1250, TRUE),
  ((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='REP')), 'Tartine avocat', 'Pain complet, avocat, tomates cerises, graines', 950, TRUE);

-- Menu pour Nation
INSERT INTO menus (restaurant_id, title, active_from, active_to)
VALUES ((SELECT id FROM restaurants WHERE code='NAT'), 'Menu Été Légumes', CURRENT_DATE, CURRENT_DATE + INTERVAL '30 days');

INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
VALUES 
  ((SELECT id FROM menus WHERE title='Menu Été Légumes' AND restaurant_id=(SELECT id FROM restaurants WHERE code='NAT')), 'Bowl végétarien', 'Riz complet, légumes grillés, sauce tahini', 1450, TRUE),
  ((SELECT id FROM menus WHERE title='Menu Été Légumes' AND restaurant_id=(SELECT id FROM restaurants WHERE code='NAT')), 'Gazpacho', 'Soupe froide tomates, concombre, basilic', 890, TRUE);

-- Menu pour Place d'Italie
INSERT INTO menus (restaurant_id, title, active_from, active_to)
VALUES ((SELECT id FROM restaurants WHERE code='ITA'), 'Menu Méditerranéen', CURRENT_DATE, CURRENT_DATE + INTERVAL '30 days');

INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
VALUES 
  ((SELECT id FROM menus WHERE title='Menu Méditerranéen' AND restaurant_id=(SELECT id FROM restaurants WHERE code='ITA')), 'Pâtes aux légumes', 'Pâtes complètes, courgettes, tomates, basilic', 1350, TRUE),
  ((SELECT id FROM menus WHERE title='Menu Méditerranéen' AND restaurant_id=(SELECT id FROM restaurants WHERE code='ITA')), 'Ratatouille', 'Légumes provençaux mijotés, herbes', 1150, TRUE);

-- Menu pour Beaubourg
INSERT INTO menus (restaurant_id, title, active_from, active_to)
VALUES ((SELECT id FROM restaurants WHERE code='BOU'), 'Menu Gourmet Bio', CURRENT_DATE, CURRENT_DATE + INTERVAL '30 days');

INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
VALUES 
  ((SELECT id FROM menus WHERE title='Menu Gourmet Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BOU')), 'Risotto aux champignons', 'Riz bio, champignons de saison, parmesan végétal', 1650, TRUE),
  ((SELECT id FROM menus WHERE title='Menu Gourmet Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BOU')), 'Tartare d\'avocat', 'Avocat, tomates, oignons, coriandre', 1200, TRUE);

-- Ajouter un menu pour Bastille en plus de celui existant
INSERT INTO menus (restaurant_id, title, active_from, active_to)
VALUES ((SELECT id FROM restaurants WHERE code='BAS'), 'Menu Hiver Réconfortant', CURRENT_DATE, CURRENT_DATE + INTERVAL '30 days');

INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
VALUES 
  ((SELECT id FROM menus WHERE title='Menu Hiver Réconfortant' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')), 'Curry de légumes', 'Légumes de saison, lait de coco, riz basmati', 1550, TRUE),
  ((SELECT id FROM menus WHERE title='Menu Hiver Réconfortant' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')), 'Soupe de lentilles', 'Lentilles corail, légumes, épices', 1050, TRUE);
