-- Migration V3: Mise à jour complète des restaurants Veg'N Bio avec informations détaillées
-- Suppression des anciennes données pour repartir à zéro
DELETE FROM menu_item_allergens;
DELETE FROM menu_items;
DELETE FROM menus;
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

-- Items pour République
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan) VALUES
-- Entrées
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='REP')), 
 'Gazpacho de légumes verts', 'Gazpacho bio aux légumes verts, huile d''olive, basilic', 890, TRUE),
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='REP')), 
 'Salade de quinoa et légumes', 'Quinoa bio, légumes croquants, vinaigrette citronnée', 1390, TRUE),
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='REP')), 
 'Carpaccio de betterave', 'Carpaccio de betterave bio, roquette, noix, vinaigrette balsamique', 1290, TRUE),

-- Plats principaux
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='REP')), 
 'Bowl végétarien complet', 'Bowl de légumes grillés, quinoa, avocat, sauce tahini', 1790, TRUE),
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='REP')), 
 'Risotto aux légumes', 'Risotto bio aux légumes de saison, parmesan végétal', 1890, TRUE),
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='REP')), 
 'Tacos végétariens', 'Tacos aux légumes grillés, guacamole, salsa verde', 1590, TRUE),

-- Desserts
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='REP')), 
 'Cheesecake végétal', 'Cheesecake aux fruits rouges, base amande', 1090, TRUE),
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='REP')), 
 'Sorbet aux fruits', 'Sorbet bio aux fruits de saison', 790, TRUE);

-- Items pour Nation
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan) VALUES
-- Entrées
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='NAT')), 
 'Soupe de légumes racines', 'Soupe bio aux légumes racines, épices douces', 890, TRUE),
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='NAT')), 
 'Salade de lentilles', 'Salade de lentilles bio, légumes croquants, vinaigrette moutarde', 1290, TRUE),
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='NAT')), 
 'Terrine végétale', 'Terrine de légumes bio, herbes fraîches, pain complet', 1190, TRUE),

-- Plats principaux
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='NAT')), 
 'Gratin de légumes', 'Gratin de légumes bio, béchamel végétale, fromage râpé', 1690, TRUE),
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='NAT')), 
 'Poke bowl végétarien', 'Poke bowl aux légumes marinés, riz complet, sauce soja', 1790, TRUE),
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='NAT')), 
 'Lasagnes végétariennes', 'Lasagnes aux légumes bio, béchamel végétale', 1890, TRUE),

-- Desserts
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='NAT')), 
 'Tiramisu végétal', 'Tiramisu au café bio, mascarpone végétal', 1190, TRUE),
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='NAT')), 
 'Crumble aux pommes', 'Crumble aux pommes bio, pâte d''amande', 1090, TRUE);

-- Items pour Place d'Italie
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan) VALUES
-- Entrées
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='ITA')), 
 'Velouté d''asperges', 'Velouté bio aux asperges vertes, crème végétale', 990, TRUE),
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='ITA')), 
 'Salade de roquette', 'Roquette bio, tomates cerises, parmesan végétal', 1190, TRUE),
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='ITA')), 
 'Bruschetta végétarienne', 'Pain grillé bio, tomates, basilic, huile d''olive', 1090, TRUE),

-- Plats principaux
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='ITA')), 
 'Pizza végétarienne', 'Pizza bio aux légumes grillés, mozzarella végétale', 1690, TRUE),
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='ITA')), 
 'Pâtes aux légumes', 'Pâtes bio aux légumes de saison, sauce tomate', 1490, TRUE),
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='ITA')), 
 'Polenta aux légumes', 'Polenta bio aux légumes grillés, parmesan végétal', 1590, TRUE),

-- Desserts
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='ITA')), 
 'Panna cotta végétale', 'Panna cotta aux fruits rouges, lait d''amande', 990, TRUE),
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='ITA')), 
 'Gelato végétal', 'Glace bio aux fruits de saison', 890, TRUE);

-- Items pour Beaubourg
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan) VALUES
-- Entrées
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BOU')), 
 'Consommé de légumes', 'Consommé bio aux légumes, herbes fraîches', 890, TRUE),
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BOU')), 
 'Salade de mesclun', 'Mesclun bio, légumes croquants, vinaigrette aux noix', 1290, TRUE),
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BOU')), 
 'Tartine aux légumes', 'Pain complet bio, légumes grillés, houmous', 1190, TRUE),

-- Plats principaux
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BOU')), 
 'Wok de légumes', 'Wok de légumes bio, sauce soja, riz complet', 1590, TRUE),
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BOU')), 
 'Tajine végétarien', 'Tajine aux légumes bio, épices, semoule', 1790, TRUE),
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BOU')), 
 'Quiche végétarienne', 'Quiche aux légumes bio, pâte brisée', 1490, TRUE),

-- Desserts
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BOU')), 
 'Mousse aux fruits', 'Mousse aux fruits bio de saison', 890, TRUE),
((SELECT id FROM menus WHERE title='Menu Printemps Bio' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BOU')), 
 'Tarte tatin végétale', 'Tarte tatin aux pommes bio, pâte sablée', 1190, TRUE);

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

-- Événements Place d'Italie
INSERT INTO events (restaurant_id, title, type, date_start, date_end, capacity, description) VALUES
((SELECT id FROM restaurants WHERE code='ITA'), 'Soirée Italienne Végétarienne', 'ÉVÉNEMENT', CURRENT_DATE + INTERVAL '5 days', CURRENT_DATE + INTERVAL '5 days' + INTERVAL '2 hours', 35, 'Découverte de la cuisine italienne végétarienne'),
((SELECT id FROM restaurants WHERE code='ITA'), 'Atelier Pâtes Fraîches', 'ATELIER', CURRENT_DATE + INTERVAL '12 days', CURRENT_DATE + INTERVAL '12 days' + INTERVAL '2 hours', 20, 'Apprenez à faire des pâtes fraîches végétariennes'),
((SELECT id FROM restaurants WHERE code='ITA'), 'Dégustation Vins Bio', 'DÉGUSTATION', CURRENT_DATE + INTERVAL '19 days', CURRENT_DATE + INTERVAL '19 days' + INTERVAL '2 hours', 25, 'Dégustation de vins biologiques');

-- Événements Beaubourg
INSERT INTO events (restaurant_id, title, type, date_start, date_end, capacity, description) VALUES
((SELECT id FROM restaurants WHERE code='BOU'), 'Rencontre Art & Gastronomie', 'ÉVÉNEMENT', CURRENT_DATE + INTERVAL '8 days', CURRENT_DATE + INTERVAL '8 days' + INTERVAL '2 hours', 45, 'Rencontre entre art contemporain et gastronomie bio'),
((SELECT id FROM restaurants WHERE code='BOU'), 'Atelier Création Culinaire', 'ATELIER', CURRENT_DATE + INTERVAL '15 days', CURRENT_DATE + INTERVAL '15 days' + INTERVAL '3 hours', 18, 'Atelier de création culinaire artistique'),
((SELECT id FROM restaurants WHERE code='BOU'), 'Soirée Culture Bio', 'ÉVÉNEMENT', CURRENT_DATE + INTERVAL '22 days', CURRENT_DATE + INTERVAL '22 days' + INTERVAL '2 hours', 35, 'Soirée culturelle autour du bio et de l''art');

-- Fournisseurs locaux franciliens
INSERT INTO suppliers (company_name, contact_email) VALUES
('Ferme Bio de la Vallée de Chevreuse', 'contact@ferme-chevreuse-bio.fr'),
('Jardin Bio de Seine-et-Marne', 'info@jardin-seine-marne-bio.fr'),
('Producteurs Bio de l''Essonne', 'contact@producteurs-essonne-bio.fr'),
('Coopérative Bio de la Brie', 'info@coop-brie-bio.fr'),
('Maraîchers Bio de la Plaine de France', 'contact@maraichers-plaine-bio.fr');

-- Offres des fournisseurs
INSERT INTO offers (supplier_id, title, description, unit_price_cents, unit, status) VALUES
-- Ferme Bio de la Vallée de Chevreuse
((SELECT id FROM suppliers WHERE company_name='Ferme Bio de la Vallée de Chevreuse'), 
 'Légumes de saison bio', 'Panier de légumes bio de saison, récoltés le matin', 2500, 'panier', 'PUBLISHED'),
((SELECT id FROM suppliers WHERE company_name='Ferme Bio de la Vallée de Chevreuse'), 
 'Herbes aromatiques fraîches', 'Mélange d''herbes aromatiques bio fraîches', 890, 'bouquet', 'PUBLISHED'),

-- Jardin Bio de Seine-et-Marne
((SELECT id FROM suppliers WHERE company_name='Jardin Bio de Seine-et-Marne'), 
 'Tomates bio de serre', 'Tomates bio de serre, variétés anciennes', 1800, 'kg', 'PUBLISHED'),
((SELECT id FROM suppliers WHERE company_name='Jardin Bio de Seine-et-Marne'), 
 'Salades bio variées', 'Mélange de salades bio, 5 variétés', 1200, 'kg', 'PUBLISHED'),

-- Producteurs Bio de l'Essonne
((SELECT id FROM suppliers WHERE company_name='Producteurs Bio de l''Essonne'), 
 'Céréales bio complètes', 'Mélange de céréales bio complètes', 3200, 'kg', 'PUBLISHED'),
((SELECT id FROM suppliers WHERE company_name='Producteurs Bio de l''Essonne'), 
 'Légumineuses bio', 'Assortiment de légumineuses bio', 2800, 'kg', 'PUBLISHED'),

-- Coopérative Bio de la Brie
((SELECT id FROM suppliers WHERE company_name='Coopérative Bio de la Brie'), 
 'Fromages végétaux bio', 'Assortiment de fromages végétaux bio', 4500, 'kg', 'PUBLISHED'),
((SELECT id FROM suppliers WHERE company_name='Coopérative Bio de la Brie'), 
 'Laits végétaux bio', 'Laits végétaux bio variés', 3200, 'L', 'PUBLISHED'),

-- Maraîchers Bio de la Plaine de France
((SELECT id FROM suppliers WHERE company_name='Maraîchers Bio de la Plaine de France'), 
 'Fruits de saison bio', 'Panier de fruits bio de saison', 2200, 'panier', 'PUBLISHED'),
((SELECT id FROM suppliers WHERE company_name='Maraîchers Bio de la Plaine de France'), 
 'Épices bio locales', 'Mélange d''épices bio locales', 1500, 'kg', 'PUBLISHED');

-- Utilisateurs de démonstration
INSERT INTO users (email, password_hash, role, full_name) VALUES
('admin@vegnbio.fr', '$2a$10$N9qo8uLOickgx2ZMRZoMye.IjdQj8Kz8Kz8Kz8Kz8Kz8Kz8Kz8Kz8', 'ADMIN', 'Administrateur VegN Bio'),
('restaurateur@vegnbio.fr', '$2a$10$N9qo8uLOickgx2ZMRZoMye.IjdQj8Kz8Kz8Kz8Kz8Kz8Kz8Kz8Kz8', 'RESTAURATEUR', 'Restaurateur VegN Bio'),
('client@vegnbio.fr', '$2a$10$N9qo8uLOickgx2ZMRZoMye.IjdQj8Kz8Kz8Kz8Kz8Kz8Kz8Kz8Kz8', 'CLIENT', 'Client VegN Bio'),
('fournisseur@vegnbio.fr', '$2a$10$N9qo8uLOickgx2ZMRZoMye.IjdQj8Kz8Kz8Kz8Kz8Kz8Kz8Kz8Kz8', 'FOURNISSEUR', 'Fournisseur VegN Bio');

-- Avis clients
INSERT INTO reviews (user_id, restaurant_id, rating, comment) VALUES
((SELECT id FROM users WHERE email='client@vegnbio.fr'), (SELECT id FROM restaurants WHERE code='BAS'), 5, 'Excellent restaurant végétarien ! Les plats sont délicieux et les ingrédients sont vraiment bio.'),
((SELECT id FROM users WHERE email='client@vegnbio.fr'), (SELECT id FROM restaurants WHERE code='REP'), 4, 'Très bon accueil et cuisine savoureuse. Je recommande !'),
((SELECT id FROM users WHERE email='client@vegnbio.fr'), (SELECT id FROM restaurants WHERE code='NAT'), 5, 'Parfait pour une pause déjeuner. Les animations du mardi sont super !'),
((SELECT id FROM users WHERE email='client@vegnbio.fr'), (SELECT id FROM restaurants WHERE code='ITA'), 4, 'Belle découverte de la cuisine italienne végétarienne.'),
((SELECT id FROM users WHERE email='client@vegnbio.fr'), (SELECT id FROM restaurants WHERE code='BOU'), 5, 'Ambiance culturelle unique, parfait après une visite au Centre Pompidou !');
