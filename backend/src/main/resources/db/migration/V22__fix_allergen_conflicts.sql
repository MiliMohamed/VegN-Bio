-- Migration V22: Correction de la migration V21 - Gestion des conflits d'allergènes
-- V22__fix_allergen_conflicts.sql

-- Cette migration corrige les problèmes de conflits dans V21
-- en utilisant une approche plus robuste pour l'insertion des allergènes

-- Supprimer les allergènes existants pour les nouveaux plats créés par V21
-- (au cas où V21 aurait partiellement réussi)
DELETE FROM menu_item_allergens 
WHERE menu_item_id IN (
    SELECT mi.id 
    FROM menu_items mi 
    JOIN menus m ON mi.menu_id = m.id 
    WHERE m.title IN ('Menu Principal', 'Menu Déjeuner', 'Menu Soir')
    AND m.restaurant_id IN (
        SELECT id FROM restaurants WHERE code IN ('BAS', 'REP', 'NAT', 'ITA', 'BOU')
    )
);

-- Réinsérer les allergènes avec gestion des conflits
-- Allergènes pour les plats contenant du sésame
INSERT INTO menu_item_allergens (menu_item_id, allergen_id)
SELECT DISTINCT mi.id, a.id 
FROM menu_items mi, allergens a
WHERE (mi.name LIKE '%sésame%' OR mi.description LIKE '%sésame%')
AND a.code = 'SESAME'
AND NOT EXISTS (
    SELECT 1 FROM menu_item_allergens mia 
    WHERE mia.menu_item_id = mi.id AND mia.allergen_id = a.id
);

-- Allergènes pour les plats contenant du gluten
INSERT INTO menu_item_allergens (menu_item_id, allergen_id)
SELECT DISTINCT mi.id, a.id 
FROM menu_items mi, allergens a
WHERE (mi.name LIKE '%Pain%' OR mi.name LIKE '%Wrap%' OR mi.name LIKE '%Burger%' 
   OR mi.name LIKE '%Pizza%' OR mi.name LIKE '%Pasta%' OR mi.name LIKE '%Risotto%'
   OR mi.name LIKE '%Sandwich%' OR mi.name LIKE '%Panini%')
AND a.code = 'GLUTEN'
AND NOT EXISTS (
    SELECT 1 FROM menu_item_allergens mia 
    WHERE mia.menu_item_id = mi.id AND mia.allergen_id = a.id
);

-- Allergènes pour les plats contenant du soja
INSERT INTO menu_item_allergens (menu_item_id, allergen_id)
SELECT DISTINCT mi.id, a.id 
FROM menu_items mi, allergens a
WHERE (mi.name LIKE '%Tofu%' OR mi.name LIKE '%Seitan%' OR mi.description LIKE '%soja%')
AND a.code = 'SOY'
AND NOT EXISTS (
    SELECT 1 FROM menu_item_allergens mia 
    WHERE mia.menu_item_id = mi.id AND mia.allergen_id = a.id
);

-- Allergènes pour les plats contenant des fruits à coque
INSERT INTO menu_item_allergens (menu_item_id, allergen_id)
SELECT DISTINCT mi.id, a.id 
FROM menu_items mi, allergens a
WHERE (mi.description LIKE '%noix%' OR mi.description LIKE '%amandes%' OR mi.description LIKE '%pistaches%')
AND a.code = 'NUTS'
AND NOT EXISTS (
    SELECT 1 FROM menu_item_allergens mia 
    WHERE mia.menu_item_id = mi.id AND mia.allergen_id = a.id
);

-- Message de confirmation
DO $$
DECLARE
    allergen_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO allergen_count FROM menu_item_allergens;
    RAISE NOTICE 'Migration V22 terminée avec succès !';
    RAISE NOTICE 'Total des associations allergènes-plats: %', allergen_count;
END $$;
