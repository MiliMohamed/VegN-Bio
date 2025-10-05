-- Données de démo (ajuste selon besoin)
INSERT INTO restaurants (name, code, address, city, phone) VALUES
 ('Veg''N Bio Bastille','BAS','Bastille, 11e','Paris','+33 1 23 45 67 01'),
 ('Veg''N Bio République','REP','République, 3e','Paris','+33 1 23 45 67 02'),
 ('Veg''N Bio Nation','NAT','Nation, 11e','Paris','+33 1 23 45 67 03'),
 ('Veg''N Bio Place d''Italie','ITA','Place d''Italie, 13e','Paris','+33 1 23 45 67 04'),
 ('Veg''N Bio Montparnasse','MON','Montparnasse, 14e','Paris','+33 1 23 45 67 05'),
 ('Veg''N Bio Ivry','IVR','Ivry, 94','Ivry-sur-Seine','+33 1 23 45 67 06'),
 ('Veg''N Bio Beaubourg','BOU','Beaubourg, 4e','Paris','+33 1 23 45 67 07');

INSERT INTO allergens (code,label) VALUES
 ('GLUTEN','Céréales contenant du gluten'),
 ('CRUST','Crustacés'),
 ('EGG','Œufs'),
 ('FISH','Poissons'),
 ('PEANUT','Arachides'),
 ('SOY','Soja'),
 ('MILK','Lait'),
 ('NUTS','Fruits à coque'),
 ('CELERY','Céleri'),
 ('MUSTARD','Moutarde'),
 ('SESAME','Sésame'),
 ('SULPHITES','Sulfites'),
 ('LUPIN','Lupin'),
 ('MOLLUSCS','Mollusques');

-- Menu d'exemple (Bastille)
INSERT INTO menus (restaurant_id, title, active_from, active_to)
VALUES ((SELECT id FROM restaurants WHERE code='BAS'),'Menu Automne', CURRENT_DATE, CURRENT_DATE + INTERVAL '30 days');

INSERT INTO menu_items (menu_id, name, description, price_cents, is_vegan)
VALUES (
  (SELECT id FROM menus WHERE title='Menu Automne' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')),
  'Burger tofu', 'Burger tofu grillé, salade croquante, sauce sésame', 1290, TRUE
),(
  (SELECT id FROM menus WHERE title='Menu Automne' AND restaurant_id=(SELECT id FROM restaurants WHERE code='BAS')),
  'Soupe courge', 'Velouté de courge bio, graines', 790, TRUE
);

-- Lier allergènes (ex: sésame)
INSERT INTO menu_item_allergens(menu_item_id, allergen_id)
SELECT mi.id, a.id FROM menu_items mi, allergens a
WHERE mi.name='Burger tofu' AND a.code='SESAME';



