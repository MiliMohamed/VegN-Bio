-- Migration V21: Remplissage complet des menus et plats pour chaque restaurant VEG'N BIO
-- V21__complete_menus_and_dishes.sql

-- Nettoyage des données existantes pour repartir à zéro
DELETE FROM menu_item_allergens;
DELETE FROM menu_items;
DELETE FROM menus;

-- Création des menus pour chaque restaurant VEG'N BIO
-- Chaque restaurant aura 3 menus : Menu Principal, Menu Déjeuner, Menu Soir

-- ===== VEG'N BIO BASTILLE =====
INSERT INTO menus (restaurant_id, title, active_from, active_to) VALUES
((SELECT id FROM restaurants WHERE code='BAS'), 'Menu Principal', CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days'),
((SELECT id FROM restaurants WHERE code='BAS'), 'Menu Déjeuner', CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days'),
((SELECT id FROM restaurants WHERE code='BAS'), 'Menu Soir', CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days');

-- Plats pour Menu Principal Bastille
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan) VALUES
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')), 
 'Burger Tofu Bio Bastille', 'Burger aux légumes grillés, tofu mariné, salade croquante, sauce sésame', 1590, TRUE),
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')), 
 'Salade Quinoa Complète', 'Quinoa bio, légumes de saison, noix, vinaigrette citron, avocat', 1390, TRUE),
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')), 
 'Curry de Légumes Bio', 'Curry aux légumes bio, riz complet, lait de coco, coriandre', 1490, TRUE),
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')), 
 'Pizza Margherita Végétale', 'Pâte fine, tomates, mozzarella végétale, basilic, huile d''olive', 1690, TRUE),
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')), 
 'Bowl Buddha Bastille', 'Riz brun, légumes grillés, avocat, graines, tahini, pousses', 1790, TRUE);

-- Plats pour Menu Déjeuner Bastille
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan) VALUES
((SELECT id FROM menus WHERE title='Menu Déjeuner' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')), 
 'Soupe Courge Bio', 'Velouté de courge bio, graines de courge, crème de coco', 890, TRUE),
((SELECT id FROM menus WHERE title='Menu Déjeuner' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')), 
 'Wrap Avocat & Hummus', 'Wrap aux légumes, avocat, hummus, pousses, tomates', 1190, TRUE),
((SELECT id FROM menus WHERE title='Menu Déjeuner' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')), 
 'Salade César Végétale', 'Salade romaine, parmesan végétal, croûtons, sauce césar vegan', 1290, TRUE),
((SELECT id FROM menus WHERE title='Menu Déjeuner' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')), 
 'Sandwich Falafel', 'Falafel maison, salade, tomates, sauce tahini', 1090, TRUE);

-- Plats pour Menu Soir Bastille
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan) VALUES
((SELECT id FROM menus WHERE title='Menu Soir' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')), 
 'Lasagnes Végétales', 'Lasagnes aux légumes, béchamel végétale, parmesan végétal', 1790, TRUE),
((SELECT id FROM menus WHERE title='Menu Soir' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')), 
 'Risotto aux Champignons', 'Risotto crémeux aux champignons, parmesan végétal, truffe', 1890, TRUE),
((SELECT id FROM menus WHERE title='Menu Soir' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')), 
 'Tartare d''Avocat', 'Tartare d''avocat, tomates, coriandre, chips de légumes', 1390, TRUE),
((SELECT id FROM menus WHERE title='Menu Soir' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')), 
 'Dahl de Lentilles', 'Dahl aux lentilles corail, riz basmati, épices indiennes', 1490, TRUE);

-- ===== VEG'N BIO RÉPUBLIQUE =====
INSERT INTO menus (restaurant_id, title, active_from, active_to) VALUES
((SELECT id FROM restaurants WHERE code='REP'), 'Menu Principal', CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days'),
((SELECT id FROM restaurants WHERE code='REP'), 'Menu Déjeuner', CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days'),
((SELECT id FROM restaurants WHERE code='REP'), 'Menu Soir', CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days');

-- Plats pour Menu Principal République
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan) VALUES
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='REP')), 
 'Bowl Buddha République', 'Riz brun, légumes grillés, avocat, graines, tahini, pousses', 1690, TRUE),
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='REP')), 
 'Burger Seitan Bio', 'Burger au seitan, légumes grillés, sauce barbecue vegan', 1590, TRUE),
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='REP')), 
 'Poke Bowl Végétal', 'Riz, légumes marinés, avocat, graines, sauce soja', 1490, TRUE),
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='REP')), 
 'Curry Thaï Végétal', 'Curry aux légumes, lait de coco, riz thaï, coriandre', 1590, TRUE);

-- Plats pour Menu Déjeuner République
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan) VALUES
((SELECT id FROM menus WHERE title='Menu Déjeuner' AND restaurant_id=(SELECT id FROM restaurants WHERE code='REP')), 
 'Soupe Miso Légumes', 'Soupe miso, légumes de saison, algues, tofu', 890, TRUE),
((SELECT id FROM menus WHERE title='Menu Déjeuner' AND restaurant_id=(SELECT id FROM restaurants WHERE code='REP')), 
 'Salade de Quinoa & Lentilles', 'Quinoa, lentilles, légumes, vinaigrette balsamique', 1190, TRUE),
((SELECT id FROM menus WHERE title='Menu Déjeuner' AND restaurant_id=(SELECT id FROM restaurants WHERE code='REP')), 
 'Wrap Méditerranéen', 'Wrap aux légumes grillés, hummus, olives, tomates', 1090, TRUE);

-- Plats pour Menu Soir République
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan) VALUES
((SELECT id FROM menus WHERE title='Menu Soir' AND restaurant_id=(SELECT id FROM restaurants WHERE code='REP')), 
 'Pasta Carbonara Végétale', 'Pâtes, crème végétale, champignons, parmesan végétal', 1690, TRUE),
((SELECT id FROM menus WHERE title='Menu Soir' AND restaurant_id=(SELECT id FROM restaurants WHERE code='REP')), 
 'Gratin de Légumes', 'Gratin aux légumes de saison, béchamel végétale', 1590, TRUE),
((SELECT id FROM menus WHERE title='Menu Soir' AND restaurant_id=(SELECT id FROM restaurants WHERE code='REP')), 
 'Tartiflette Végétale', 'Pommes de terre, fromage végétal, oignons, crème végétale', 1790, TRUE);

-- ===== VEG'N BIO NATION =====
INSERT INTO menus (restaurant_id, title, active_from, active_to) VALUES
((SELECT id FROM restaurants WHERE code='NAT'), 'Menu Principal', CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days'),
((SELECT id FROM restaurants WHERE code='NAT'), 'Menu Déjeuner', CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days'),
((SELECT id FROM restaurants WHERE code='NAT'), 'Menu Soir', CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days');

-- Plats pour Menu Principal Nation
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan) VALUES
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='NAT')), 
 'Burger Jackfruit', 'Burger au jackfruit, légumes grillés, sauce BBQ vegan', 1590, TRUE),
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='NAT')), 
 'Bowl Mexicain', 'Riz, haricots noirs, avocat, maïs, sauce piquante', 1490, TRUE),
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='NAT')), 
 'Salade de Choux & Quinoa', 'Choux colorés, quinoa, noix, vinaigrette moutarde', 1290, TRUE),
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='NAT')), 
 'Curry Vert Thaï', 'Curry vert aux légumes, lait de coco, riz thaï', 1590, TRUE);

-- Plats pour Menu Déjeuner Nation
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan) VALUES
((SELECT id FROM menus WHERE title='Menu Déjeuner' AND restaurant_id=(SELECT id FROM restaurants WHERE code='NAT')), 
 'Soupe Tomate & Basilic', 'Velouté de tomates bio, basilic, crème de coco', 890, TRUE),
((SELECT id FROM menus WHERE title='Menu Déjeuner' AND restaurant_id=(SELECT id FROM restaurants WHERE code='NAT')), 
 'Sandwich Végétarien', 'Pain complet, légumes grillés, fromage végétal', 1090, TRUE),
((SELECT id FROM menus WHERE title='Menu Déjeuner' AND restaurant_id=(SELECT id FROM restaurants WHERE code='NAT')), 
 'Salade de Betterave', 'Betteraves, quinoa, noix, vinaigrette balsamique', 1190, TRUE);

-- Plats pour Menu Soir Nation
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan) VALUES
((SELECT id FROM menus WHERE title='Menu Soir' AND restaurant_id=(SELECT id FROM restaurants WHERE code='NAT')), 
 'Pizza Quatre Saisons Végétale', 'Pâte fine, légumes de saison, mozzarella végétale', 1690, TRUE),
((SELECT id FROM menus WHERE title='Menu Soir' AND restaurant_id=(SELECT id FROM restaurants WHERE code='NAT')), 
 'Risotto aux Asperges', 'Risotto crémeux aux asperges, parmesan végétal', 1790, TRUE),
((SELECT id FROM menus WHERE title='Menu Soir' AND restaurant_id=(SELECT id FROM restaurants WHERE code='NAT')), 
 'Tajine de Légumes', 'Tajine aux légumes, fruits secs, épices marocaines', 1590, TRUE);

-- ===== VEG'N BIO PLACE D'ITALIE/MONTPARNASSE/IVRY =====
INSERT INTO menus (restaurant_id, title, active_from, active_to) VALUES
((SELECT id FROM restaurants WHERE code='ITA'), 'Menu Principal', CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days'),
((SELECT id FROM restaurants WHERE code='ITA'), 'Menu Déjeuner', CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days'),
((SELECT id FROM restaurants WHERE code='ITA'), 'Menu Soir', CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days');

-- Plats pour Menu Principal Place d'Italie
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan) VALUES
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='ITA')), 
 'Pasta Arrabiata Végétale', 'Pâtes, tomates, piments, ail, persil', 1490, TRUE),
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='ITA')), 
 'Burger Portobello', 'Burger aux champignons portobello, légumes, sauce italienne', 1590, TRUE),
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='ITA')), 
 'Salade Caprese Végétale', 'Tomates, mozzarella végétale, basilic, huile d''olive', 1290, TRUE),
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='ITA')), 
 'Risotto aux Champignons', 'Risotto crémeux aux champignons, parmesan végétal', 1690, TRUE);

-- Plats pour Menu Déjeuner Place d'Italie
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan) VALUES
((SELECT id FROM menus WHERE title='Menu Déjeuner' AND restaurant_id=(SELECT id FROM restaurants WHERE code='ITA')), 
 'Soupe Minestrone', 'Soupe aux légumes, pâtes, haricots, basilic', 890, TRUE),
((SELECT id FROM menus WHERE title='Menu Déjeuner' AND restaurant_id=(SELECT id FROM restaurants WHERE code='ITA')), 
 'Panini Végétarien', 'Pain italien, légumes grillés, fromage in the hole végétal', 1090, TRUE),
((SELECT id FROM menus WHERE title='Menu Déjeuner' AND restaurant_id=(SELECT id FROM restaurants WHERE code='ITA')), 
 'Salade Niçoise Végétale', 'Salade, tomates, olives, artichauts, vinaigrette', 1190, TRUE);

-- Plats pour Menu Soir Place d'Italie
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan) VALUES
((SELECT id FROM menus WHERE title='Menu Soir' AND restaurant_id=(SELECT id FROM restaurants WHERE code='ITA')), 
 'Lasagnes Végétales Italiennes', 'Lasagnes aux légumes, béchamel végétale, parmesan végétal', 1790, TRUE),
((SELECT id FROM menus WHERE title='Menu Soir' AND restaurant_id=(SELECT id FROM restaurants WHERE code='ITA')), 
 'Pizza Margherita Végétale', 'Pâte fine, tomates, mozzarella végétale, basilic', 1690, TRUE),
((SELECT id FROM menus WHERE title='Menu Soir' AND restaurant_id=(SELECT id FROM restaurants WHERE code='ITA')), 
 'Osso Buco Végétal', 'Seitan aux légumes, risotto milanais, gremolata', 1890, TRUE);

-- ===== VEG'N BIO BEAUBOURG =====
INSERT INTO menus (restaurant_id, title, active_from, active_to) VALUES
((SELECT id FROM restaurants WHERE code='BOU'), 'Menu Principal', CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days'),
((SELECT id FROM restaurants WHERE code='BOU'), 'Menu Déjeuner', CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days'),
((SELECT id FROM restaurants WHERE code='BOU'), 'Menu Soir', CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days');

-- Plats pour Menu Principal Beaubourg
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan) VALUES
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BOU')), 
 'Bowl Créatif Beaubourg', 'Riz noir, légumes colorés, avocat, graines, sauce créative', 1690, TRUE),
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BOU')), 
 'Burger Artisanal', 'Burger aux légumes, fromage artisanal végétal, sauce spéciale', 1590, TRUE),
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BOU')), 
 'Salade Artistique', 'Salade composée, légumes de saison, vinaigrette créative', 1390, TRUE),
((SELECT id FROM menus WHERE title='Menu Principal' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BOU')), 
 'Curry Créatif', 'Curry aux légumes, lait de coco, riz, épices créatives', 1590, TRUE);

-- Plats pour Menu Déjeuner Beaubourg
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan) VALUES
((SELECT id FROM menus WHERE title='Menu Déjeuner' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BOU')), 
 'Soupe du Jour', 'Soupe de légumes de saison, crémeuse et savoureuse', 890, TRUE),
((SELECT id FROM menus WHERE title='Menu Déjeuner' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BOU')), 
 'Wrap Créatif', 'Wrap aux légumes, fromage végétal, sauce créative', 1190, TRUE),
((SELECT id FROM menus WHERE title='Menu Déjeuner' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BOU')), 
 'Salade Légère', 'Salade fraîche, légumes croquants, vinaigrette légère', 1090, TRUE);

-- Plats pour Menu Soir Beaubourg
INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan) VALUES
((SELECT id FROM menus WHERE title='Menu Soir' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BOU')), 
 'Pasta Créative', 'Pâtes aux légumes, sauce créative, parmesan végétal', 1690, TRUE),
((SELECT id FROM menus WHERE title='Menu Soir' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BOU')), 
 'Gratin Artistique', 'Gratin aux légumes, béchamel créative, fromage végétal', 1590, TRUE),
((SELECT id FROM menus WHERE title='Menu Soir' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BOU')), 
 'Risotto Créatif', 'Risotto aux légumes, crème végétale, épices créatives', 1790, TRUE);

-- Ajout des allergènes pour certains plats
-- Allergènes pour les plats contenant du sésame
INSERT INTO menu_item_allergens (menu_item_id, allergen_id)
SELECT mi.id, a.id 
FROM menu_items mi, allergens a
WHERE mi.name LIKE '%sésame%' OR mi.description LIKE '%sésame%'
AND a.code = 'SESAME';

-- Allergènes pour les plats contenant du gluten
INSERT INTO menu_item_allergens (menu_item_id, allergen_id)
SELECT mi.id, a.id 
FROM menu_items mi, allergens a
WHERE mi.name LIKE '%Pain%' OR mi.name LIKE '%Wrap%' OR mi.name LIKE '%Burger%' 
   OR mi.name LIKE '%Pizza%' OR mi.name LIKE '%Pasta%' OR mi.name LIKE '%Risotto%'
   OR mi.name LIKE '%Sandwich%' OR mi.name LIKE '%Panini%'
AND a.code = 'GLUTEN';

-- Allergènes pour les plats contenant du soja
INSERT INTO menu_item_allergens (menu_item_id, allergen_id)
SELECT mi.id, a.id 
FROM menu_items mi, allergens a
WHERE mi.name LIKE '%Tofu%' OR mi.name LIKE '%Seitan%' OR mi.description LIKE '%soja%'
AND a.code = 'SOY';

-- Allergènes pour les plats contenant des fruits à coque
INSERT INTO menu_item_allergens (menu_item_id, allergen_id)
SELECT mi.id, a.id 
FROM menu_items mi, allergens a
WHERE mi.description LIKE '%noix%' OR mi.description LIKE '%amandes%' OR mi.description LIKE '%pistaches%'
AND a.code = 'NUTS';

-- Message de confirmation
DO $$
BEGIN
    RAISE NOTICE 'Migration V21 terminée avec succès !';
    RAISE NOTICE 'Menus et plats créés pour tous les restaurants VEG''N BIO';
    RAISE NOTICE 'Total des plats créés: %', (SELECT COUNT(*) FROM menu_items);
    RAISE NOTICE 'Total des menus créés: %', (SELECT COUNT(*) FROM menus);
END $$;
