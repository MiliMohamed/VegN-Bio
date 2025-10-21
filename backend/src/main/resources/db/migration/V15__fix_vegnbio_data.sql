-- Migration V15: Correction et ajout de données VegN Bio
-- Suppression des anciennes données pour repartir à zéro
DELETE FROM menu_item_allergens;
DELETE FROM menu_items;
DELETE FROM menus;
DELETE FROM reviews;
DELETE FROM restaurants;

-- Insertion des restaurants Veg'N Bio avec informations complètes
INSERT INTO restaurants (name, code, address, city, phone) VALUES
('VEG''N BIO BASTILLE', 'BAS', 'Place de la Bastille, 75011 Paris', 'Paris', '+33 1 23 45 67 01'),
('VEG''N BIO REPUBLIQUE', 'REP', 'Place de la République, 75003 Paris', 'Paris', '+33 1 23 45 67 02'),
('VEG''N BIO NATION', 'NAT', 'Place de la Nation, 75011 Paris', 'Paris', '+33 1 23 45 67 03'),
('VEG''N BIO PLACE D''ITALIE', 'ITA', 'Place d''Italie, 75013 Paris', 'Paris', '+33 1 23 45 67 04'),
('VEG''N BIO BEAUBOURG', 'BOU', 'Centre Pompidou, 75004 Paris', 'Paris', '+33 1 23 45 67 05');

-- Menus végétariens et biologiques pour chaque restaurant
-- Menu Bastille
INSERT INTO menus (restaurant_id, title, active_from, active_to) VALUES
((SELECT id FROM restaurants WHERE code='BAS'), 'Menu Printemps Bio', CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days'),
((SELECT id FROM restaurants WHERE code='BAS'), 'Menu Été Bio', CURRENT_DATE + INTERVAL '90 days', CURRENT_DATE + INTERVAL '180 days'),
((SELECT id FROM restaurants WHERE code='BAS'), 'Menu Automne Bio', CURRENT_DATE + INTERVAL '180 days', CURRENT_DATE + INTERVAL '270 days'),
((SELECT id FROM restaurants WHERE code='BAS'), 'Menu Hiver Bio', CURRENT_DATE + INTERVAL '270 days', CURRENT_DATE + INTERVAL '365 days');

-- Menu République
INSERT INTO menus (restaurant_id, title, active_from, active_to) VALUES
((SELECT id FROM restaurants WHERE code='REP'), 'Menu Printemps Bio', CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days'),
((SELECT id FROM restaurants WHERE code='REP'), 'Menu Été Bio', CURRENT_DATE + INTERVAL '90 days', CURRENT_DATE + INTERVAL '180 days'),
((SELECT id FROM restaurants WHERE code='REP'), 'Menu Automne Bio', CURRENT_DATE + INTERVAL '180 days', CURRENT_DATE + INTERVAL '270 days'),
((SELECT id FROM restaurants WHERE code='REP'), 'Menu Hiver Bio', CURRENT_DATE + INTERVAL '270 days', CURRENT_DATE + INTERVAL '365 days');

-- Menu Nation
INSERT INTO menus (restaurant_id, title, active_from, active_to) VALUES
((SELECT id FROM restaurants WHERE code='NAT'), 'Menu Printemps Bio', CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days'),
((SELECT id FROM restaurants WHERE code='NAT'), 'Menu Été Bio', CURRENT_DATE + INTERVAL '90 days', CURRENT_DATE + INTERVAL '180 days'),
((SELECT id FROM restaurants WHERE code='NAT'), 'Menu Automne Bio', CURRENT_DATE + INTERVAL '180 days', CURRENT_DATE + INTERVAL '270 days'),
((SELECT id FROM restaurants WHERE code='NAT'), 'Menu Hiver Bio', CURRENT_DATE + INTERVAL '270 days', CURRENT_DATE + INTERVAL '365 days');

-- Menu Place d'Italie
INSERT INTO menus (restaurant_id, title, active_from, active_to) VALUES
((SELECT id FROM restaurants WHERE code='ITA'), 'Menu Printemps Bio', CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days'),
((SELECT id FROM restaurants WHERE code='ITA'), 'Menu Été Bio', CURRENT_DATE + INTERVAL '90 days', CURRENT_DATE + INTERVAL '180 days'),
((SELECT id FROM restaurants WHERE code='ITA'), 'Menu Automne Bio', CURRENT_DATE + INTERVAL '180 days', CURRENT_DATE + INTERVAL '270 days'),
((SELECT id FROM restaurants WHERE code='ITA'), 'Menu Hiver Bio', CURRENT_DATE + INTERVAL '270 days', CURRENT_DATE + INTERVAL '365 days');

-- Menu Beaubourg
INSERT INTO menus (restaurant_id, title, active_from, active_to) VALUES
((SELECT id FROM restaurants WHERE code='BOU'), 'Menu Printemps Bio', CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days'),
((SELECT id FROM restaurants WHERE code='BOU'), 'Menu Été Bio', CURRENT_DATE + INTERVAL '90 days', CURRENT_DATE + INTERVAL '180 days'),
((SELECT id FROM restaurants WHERE code='BOU'), 'Menu Automne Bio', CURRENT_DATE + INTERVAL '180 days', CURRENT_DATE + INTERVAL '270 days'),
((SELECT id FROM restaurants WHERE code='BOU'), 'Menu Hiver Bio', CURRENT_DATE + INTERVAL '270 days', CURRENT_DATE + INTERVAL '365 days');

-- Items de menu végétariens et biologiques
-- Items pour Bastille
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan) VALUES
-- Entrées
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')), 
 'Velouté de légumes de saison', 'Velouté bio aux légumes de printemps, crème végétale, herbes fraîches', 890, TRUE),
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')), 
 'Salade de jeunes pousses', 'Mélange de jeunes pousses bio, radis, vinaigrette aux agrumes', 1290, TRUE),
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')), 
 'Tartare d''avocat et betterave', 'Tartare d''avocat bio, betterave râpée, graines de chia', 1490, TRUE),

-- Plats principaux
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')), 
 'Burger végétarien gourmet', 'Steak de quinoa et légumes, salade croquante, sauce aux herbes', 1890, TRUE),
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')), 
 'Curry de légumes bio', 'Curry de légumes de saison, lait de coco, riz complet bio', 1690, TRUE),
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')), 
 'Pâtes aux légumes grillés', 'Pâtes complètes bio, légumes grillés, pesto de basilic', 1590, TRUE),

-- Desserts
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')), 
 'Mousse au chocolat végétale', 'Mousse au chocolat noir bio, crème de coco', 890, TRUE),
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')), 
 'Tarte aux fruits de saison', 'Tarte aux fruits bio de saison, pâte sablée', 1090, TRUE);

-- Événements et animations pour chaque restaurant
-- Événements Bastille
INSERT INTO events (restaurant_id, title, type, date_start, date_end, capacity, description) VALUES
((SELECT id FROM restaurants WHERE code='BAS'), 'Rencontre Producteurs Bio', 'ÉVÉNEMENT', CURRENT_DATE + INTERVAL '7 days', CURRENT_DATE + INTERVAL '7 days' + INTERVAL '2 hours', 50, 'Rencontre avec nos producteurs partenaires franciliens'),
((SELECT id FROM restaurants WHERE code='BAS'), 'Atelier Cuisine Végétarienne', 'ATELIER', CURRENT_DATE + INTERVAL '14 days', CURRENT_DATE + INTERVAL '14 days' + INTERVAL '3 hours', 20, 'Apprenez à cuisiner des plats végétariens bio'),
((SELECT id FROM restaurants WHERE code='BAS'), 'Soirée Dégustation', 'DÉGUSTATION', CURRENT_DATE + INTERVAL '21 days', CURRENT_DATE + INTERVAL '21 days' + INTERVAL '2 hours', 30, 'Dégustation de nos nouveaux plats de saison');

-- Événements République
INSERT INTO events (restaurant_id, title, type, date_start, date_end, capacity, description) VALUES
((SELECT id FROM restaurants WHERE code='REP'), 'Conférence Alimentation Durable', 'CONFÉRENCE', CURRENT_DATE + INTERVAL '10 days', CURRENT_DATE + INTERVAL '10 days' + INTERVAL '2 hours', 80, 'Conférence sur l''alimentation durable et bio'),
((SELECT id FROM restaurants WHERE code='REP'), 'Atelier Zéro Déchet', 'ATELIER', CURRENT_DATE + INTERVAL '17 days', CURRENT_DATE + INTERVAL '17 days' + INTERVAL '2 hours', 25, 'Apprenez les techniques du zéro déchet en cuisine'),
((SELECT id FROM restaurants WHERE code='REP'), 'Soirée Producteurs', 'ÉVÉNEMENT', CURRENT_DATE + INTERVAL '24 days', CURRENT_DATE + INTERVAL '24 days' + INTERVAL '2 hours', 40, 'Rencontre avec nos producteurs locaux');

-- Événements Nation (avec animations tous les mardis)
INSERT INTO events (restaurant_id, title, type, date_start, date_end, capacity, description) VALUES
((SELECT id FROM restaurants WHERE code='NAT'), 'Animation Mardi - Découverte Bio', 'ANIMATION', CURRENT_DATE + INTERVAL '3 days', CURRENT_DATE + INTERVAL '3 days' + INTERVAL '2 hours', 60, 'Animation hebdomadaire du mardi après-midi'),
((SELECT id FROM restaurants WHERE code='NAT'), 'Conférence Nutrition Végétarienne', 'CONFÉRENCE', CURRENT_DATE + INTERVAL '10 days', CURRENT_DATE + INTERVAL '10 days' + INTERVAL '2 hours', 50, 'Conférence sur la nutrition végétarienne'),
((SELECT id FROM restaurants WHERE code='NAT'), 'Atelier Pâtisserie Végétale', 'ATELIER', CURRENT_DATE + INTERVAL '17 days', CURRENT_DATE + INTERVAL '17 days' + INTERVAL '3 hours', 15, 'Apprenez la pâtisserie végétale bio');

-- Avis clients (seulement si les utilisateurs existent)
INSERT INTO reviews (restaurant_id, customer_name, customer_email, rating, comment, status) VALUES
((SELECT id FROM restaurants WHERE code='BAS'), 'Client VegN Bio', 'client@vegnbio.fr', 5, 'Excellent restaurant végétarien ! Les plats sont délicieux et les ingrédients sont vraiment bio.', 'APPROVED'),
((SELECT id FROM restaurants WHERE code='REP'), 'Client VegN Bio', 'client@vegnbio.fr', 4, 'Très bon accueil et cuisine savoureuse. Je recommande !', 'APPROVED'),
((SELECT id FROM restaurants WHERE code='NAT'), 'Client VegN Bio', 'client@vegnbio.fr', 5, 'Parfait pour une pause déjeuner. Les animations du mardi sont super !', 'APPROVED'),
((SELECT id FROM restaurants WHERE code='ITA'), 'Client VegN Bio', 'client@vegnbio.fr', 4, 'Belle découverte de la cuisine italienne végétarienne.', 'APPROVED'),
((SELECT id FROM restaurants WHERE code='BOU'), 'Client VegN Bio', 'client@vegnbio.fr', 5, 'Ambiance culturelle unique, parfait après une visite au Centre Pompidou !', 'APPROVED');
