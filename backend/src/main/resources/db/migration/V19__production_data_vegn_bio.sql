-- Migration pour les données de production VEG'N BIO
-- Suppression des anciennes données et création des données spécifiques

-- Suppression des anciennes données
DELETE FROM menu_item_allergens;
DELETE FROM menu_items;
DELETE FROM menus;
DELETE FROM events;
DELETE FROM bookings;
DELETE FROM restaurants;

-- Insertion des 5 restaurants VEG'N BIO avec leurs informations spécifiques
INSERT INTO restaurants (name, code, address, city, phone) VALUES
('VEG''N BIO BASTILLE', 'BAS', 'Place de la Bastille, 11e arrondissement', 'Paris', '+33 1 42 00 00 01'),
('VEG''N BIO REPUBLIQUE', 'REP', 'Place de la République, 3e arrondissement', 'Paris', '+33 1 42 00 00 02'),
('VEG''N BIO NATION', 'NAT', 'Place de la Nation, 11e arrondissement', 'Paris', '+33 1 42 00 00 03'),
('VEG''N BIO PLACE D''ITALIE/MONTPARNASSE/IVRY', 'ITA', 'Place d''Italie/Montparnasse/Ivry, 13e/14e/94', 'Paris/Ivry-sur-Seine', '+33 1 42 00 00 04'),
('VEG''N BIO BEAUBOURG', 'BOU', 'Place Georges Pompidou, 4e arrondissement', 'Paris', '+33 1 42 00 00 05');

-- Création des comptes de test (mots de passe hashés avec BCrypt)
-- Mot de passe pour tous: "TestVegN2024!"
INSERT INTO users (email, password_hash, role, full_name) VALUES
('admin@vegnbio.fr', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'ADMIN', 'Administrateur VEGN BIO'),
('restaurateur@vegnbio.fr', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'RESTAURATEUR', 'Gérant Restaurant'),
('client@vegnbio.fr', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'CLIENT', 'Client Test')
ON CONFLICT (email) DO NOTHING;

-- Menus pour chaque restaurant avec des plats variés
-- VEG'N BIO BASTILLE
INSERT INTO menus (restaurant_id, title, active_from, active_to) VALUES
((SELECT id FROM restaurants WHERE code='BAS'), 'Menu Principal', CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days'),
((SELECT id FROM restaurants WHERE code='BAS'), 'Menu Déjeuner', CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days');

-- Plats pour Bastille
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan) VALUES
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')), 'Burger Tofu Bio', 'Burger aux légumes grillés, tofu mariné, salade croquante, sauce sésame', 1590, TRUE),
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')), 'Salade Quinoa', 'Quinoa bio, légumes de saison, noix, vinaigrette citron', 1290, TRUE),
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')), 'Curry de Légumes', 'Curry aux légumes bio, riz complet, lait de coco', 1490, TRUE),
((SELECT id FROM menus WHERE title='Menu Déjeuner' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')), 'Soupe Courge', 'Velouté de courge bio, graines de courge', 890, TRUE),
((SELECT id FROM menus WHERE title='Menu Déjeuner' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')), 'Wrap Avocat', 'Wrap aux légumes, avocat, hummus, pousses', 1190, TRUE);

-- VEG'N BIO REPUBLIQUE
INSERT INTO menus (restaurant_id, title, active_from, active_to) VALUES
((SELECT id FROM restaurants WHERE code='REP'), 'Menu Principal', CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days'),
((SELECT id FROM restaurants WHERE code='REP'), 'Menu Soir', CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days');

-- Plats pour République
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan) VALUES
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='REP')), 'Bowl Buddha', 'Riz brun, légumes grillés, avocat, graines, tahini', 1690, TRUE),
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='REP')), 'Lasagnes Végétales', 'Lasagnes aux légumes, béchamel végétale, parmesan végétal', 1790, TRUE),
((SELECT id FROM menus WHERE title='Menu Soir' AND restaurant_id=(SELECT id FROM restaurants WHERE code='REP')), 'Tartare d''Avocat', 'Tartare d''avocat, tomates, oignons rouges, citron vert', 1390, TRUE),
((SELECT id FROM menus WHERE title='Menu Soir' AND restaurant_id=(SELECT id FROM restaurants WHERE code='REP')), 'Pizza Margherita Végétale', 'Pâte fine, tomates, mozzarella végétale, basilic', 1590, TRUE);

-- VEG'N BIO NATION
INSERT INTO menus (restaurant_id, title, active_from, active_to) VALUES
((SELECT id FROM restaurants WHERE code='NAT'), 'Menu Principal', CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days'),
((SELECT id FROM restaurants WHERE code='NAT'), 'Menu Conférences', CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days');

-- Plats pour Nation
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan) VALUES
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='NAT')), 'Plateau Membre', 'Sélection de plats chauds et froids, légumes de saison', 1890, TRUE),
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='NAT')), 'Risotto aux Champignons', 'Risotto crémeux aux champignons, parmesan végétal', 1690, TRUE),
((SELECT id FROM menus WHERE title='Menu Conférences' AND restaurant_id=(SELECT id FROM restaurants WHERE code='NAT')), 'Assiette Dégustation', 'Petites portions variées pour les événements', 1290, TRUE);

-- VEG'N BIO PLACE D'ITALIE/MONTPARNASSE/IVRY
INSERT INTO menus (restaurant_id, title, active_from, active_to) VALUES
((SELECT id FROM restaurants WHERE code='ITA'), 'Menu Principal', CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days'),
((SELECT id FROM restaurants WHERE code='ITA'), 'Menu Livraison', CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days');

-- Plats pour Place d'Italie/Montparnasse/Ivry
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan) VALUES
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='ITA')), 'Pad Thaï Végétarien', 'Nouilles de riz, légumes croquants, sauce tamarin', 1590, TRUE),
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='ITA')), 'Gratin de Légumes', 'Gratin de légumes de saison, béchamel végétale', 1490, TRUE),
((SELECT id FROM menus WHERE title='Menu Livraison' AND restaurant_id=(SELECT id FROM restaurants WHERE code='ITA')), 'Plateau Repas Livré', 'Repas complet pour livraison', 1990, TRUE);

-- VEG'N BIO BEAUBOURG
INSERT INTO menus (restaurant_id, title, active_from, active_to) VALUES
((SELECT id FROM restaurants WHERE code='BOU'), 'Menu Principal', CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days'),
((SELECT id FROM restaurants WHERE code='BOU'), 'Menu Livraison', CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days');

-- Plats pour Beaubourg
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan) VALUES
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BOU')), 'Salade César Végétale', 'Salade romaine, croûtons, parmesan végétal, dressing', 1390, TRUE),
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BOU')), 'Tacos aux Légumes', 'Tacos aux légumes grillés, guacamole, salsa', 1490, TRUE),
((SELECT id FROM menus WHERE title='Menu Livraison' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BOU')), 'Plateau Repas Livré', 'Repas complet pour livraison', 1990, TRUE);

-- Association des allergènes aux plats
-- Burger Tofu Bio - contient du sésame
INSERT INTO menu_item_allergens (menu_item_id, allergen_id)
SELECT mi.id, a.id FROM menu_items mi, allergens a
WHERE mi.name='Burger Tofu Bio' AND a.code='SESAME';

-- Salade Quinoa - contient des fruits à coque
INSERT INTO menu_item_allergens (menu_item_id, allergen_id)
SELECT mi.id, a.id FROM menu_items mi, allergens a
WHERE mi.name='Salade Quinoa' AND a.code='NUTS';

-- Lasagnes Végétales - contient du gluten
INSERT INTO menu_item_allergens (menu_item_id, allergen_id)
SELECT mi.id, a.id FROM menu_items mi, allergens a
WHERE mi.name='Lasagnes Végétales' AND a.code='GLUTEN';

-- Pizza Margherita - contient du gluten
INSERT INTO menu_item_allergens (menu_item_id, allergen_id)
SELECT mi.id, a.id FROM menu_items mi, allergens a
WHERE mi.name='Pizza Margherita Végétale' AND a.code='GLUTEN';

-- Pad Thaï - contient du soja
INSERT INTO menu_item_allergens (menu_item_id, allergen_id)
SELECT mi.id, a.id FROM menu_items mi, allergens a
WHERE mi.name='Pad Thaï Végétarien' AND a.code='SOY';

-- Événements pour chaque restaurant
-- Bastille - Salles de réunion
INSERT INTO events (restaurant_id, title, type, date_start, date_end, capacity, description) VALUES
((SELECT id FROM restaurants WHERE code='BAS'), 'Réunion Salle 1', 'REUNION', CURRENT_DATE + INTERVAL '1 day', CURRENT_DATE + INTERVAL '1 day' + INTERVAL '2 hours', 8, 'Salle de réunion équipée - 2h'),
((SELECT id FROM restaurants WHERE code='BAS'), 'Réunion Salle 2', 'REUNION', CURRENT_DATE + INTERVAL '2 days', CURRENT_DATE + INTERVAL '2 days' + INTERVAL '3 hours', 12, 'Salle de réunion équipée - 3h');

-- République - Salles de réunion
INSERT INTO events (restaurant_id, title, type, date_start, date_end, capacity, description) VALUES
((SELECT id FROM restaurants WHERE code='REP'), 'Conférence Salle A', 'CONFERENCE', CURRENT_DATE + INTERVAL '3 days', CURRENT_DATE + INTERVAL '3 days' + INTERVAL '4 hours', 20, 'Salle de conférence - 4h'),
((SELECT id FROM restaurants WHERE code='REP'), 'Formation Salle B', 'FORMATION', CURRENT_DATE + INTERVAL '5 days', CURRENT_DATE + INTERVAL '5 days' + INTERVAL '6 hours', 15, 'Formation - 6h'),
((SELECT id FROM restaurants WHERE code='REP'), 'Atelier Salle C', 'ATELIER', CURRENT_DATE + INTERVAL '7 days', CURRENT_DATE + INTERVAL '7 days' + INTERVAL '2 hours', 10, 'Atelier - 2h'),
((SELECT id FROM restaurants WHERE code='REP'), 'Séminaire Salle D', 'SEMINAIRE', CURRENT_DATE + INTERVAL '10 days', CURRENT_DATE + INTERVAL '10 days' + INTERVAL '8 hours', 25, 'Séminaire - 8h');

-- Nation - Conférences et animations
INSERT INTO events (restaurant_id, title, type, date_start, date_end, capacity, description) VALUES
((SELECT id FROM restaurants WHERE code='NAT'), 'Conférence Mardi', 'CONFERENCE', CURRENT_DATE + INTERVAL '1 week', CURRENT_DATE + INTERVAL '1 week' + INTERVAL '2 hours', 30, 'Conférence hebdomadaire du mardi après-midi'),
((SELECT id FROM restaurants WHERE code='NAT'), 'Animation Culinaire', 'ANIMATION', CURRENT_DATE + INTERVAL '1 week' + INTERVAL '1 day', CURRENT_DATE + INTERVAL '1 week' + INTERVAL '1 day' + INTERVAL '3 hours', 20, 'Animation culinaire bio'),
((SELECT id FROM restaurants WHERE code='NAT'), 'Réunion Salle Unique', 'REUNION', CURRENT_DATE + INTERVAL '2 weeks', CURRENT_DATE + INTERVAL '2 weeks' + INTERVAL '4 hours', 15, 'Salle de réunion unique - 4h');

-- Place d'Italie/Montparnasse/Ivry - Salles de réunion
INSERT INTO events (restaurant_id, title, type, date_start, date_end, capacity, description) VALUES
((SELECT id FROM restaurants WHERE code='ITA'), 'Réunion Salle 1', 'REUNION', CURRENT_DATE + INTERVAL '3 days', CURRENT_DATE + INTERVAL '3 days' + INTERVAL '2 hours', 10, 'Salle de réunion - 2h'),
((SELECT id FROM restaurants WHERE code='ITA'), 'Réunion Salle 2', 'REUNION', CURRENT_DATE + INTERVAL '5 days', CURRENT_DATE + INTERVAL '5 days' + INTERVAL '3 hours', 12, 'Salle de réunion - 3h');

-- Beaubourg - Salles de réunion
INSERT INTO events (restaurant_id, title, type, date_start, date_end, capacity, description) VALUES
((SELECT id FROM restaurants WHERE code='BOU'), 'Réunion Salle 1', 'REUNION', CURRENT_DATE + INTERVAL '4 days', CURRENT_DATE + INTERVAL '4 days' + INTERVAL '2 hours', 8, 'Salle de réunion - 2h'),
((SELECT id FROM restaurants WHERE code='BOU'), 'Réunion Salle 2', 'REUNION', CURRENT_DATE + INTERVAL '6 days', CURRENT_DATE + INTERVAL '6 days' + INTERVAL '3 hours', 10, 'Salle de réunion - 3h');

-- Réservations d'exemple
INSERT INTO bookings (event_id, customer_name, customer_phone, pax, status) VALUES
((SELECT id FROM events WHERE title='Conférence Mardi'), 'Marie Dupont', '+33 6 12 34 56 78', 2, 'CONFIRMED'),
((SELECT id FROM events WHERE title='Animation Culinaire'), 'Jean Martin', '+33 6 87 65 43 21', 1, 'PENDING'),
((SELECT id FROM events WHERE title='Réunion Salle 1' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')), 'Sophie Bernard', '+33 6 11 22 33 44', 3, 'CONFIRMED');

-- Rapports d'exemple (utiliser la table error_reports qui existe en production)
INSERT INTO error_reports (error_type, description, user_id, created_at) VALUES
('Allergène', 'Le plat Burger Tofu Bio contient du sésame mais ce n''est pas mentionné clairement', 'client@vegnbio.fr', CURRENT_TIMESTAMP),
('Menu', 'Besoin d''ajouter plus d''options sans gluten au menu', 'restaurateur@vegnbio.fr', CURRENT_TIMESTAMP),
('Système', 'Amélioration de l''interface de réservation des salles', 'admin@vegnbio.fr', CURRENT_TIMESTAMP);
