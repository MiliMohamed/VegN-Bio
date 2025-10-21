-- Migration V13: Données de test pour les salles des restaurants Veg'N Bio
-- Ajout des salles selon les spécifications des restaurants

-- Salles pour VEG'N BIO BASTILLE
INSERT INTO rooms (restaurant_id, name, description, capacity, hourly_rate_cents, has_wifi, has_printer, has_projector, has_whiteboard, status) VALUES
((SELECT id FROM restaurants WHERE code='BAS'), 'Salle de Réunion A', 'Salle de réunion spacieuse avec vue sur la rue', 8, 1500, true, true, false, true, 'AVAILABLE'),
((SELECT id FROM restaurants WHERE code='BAS'), 'Salle de Réunion B', 'Salle de réunion intime pour petits groupes', 6, 1200, true, true, false, true, 'AVAILABLE');

-- Salles pour VEG'N BIO REPUBLIQUE
INSERT INTO rooms (restaurant_id, name, description, capacity, hourly_rate_cents, has_wifi, has_printer, has_projector, has_whiteboard, status) VALUES
((SELECT id FROM restaurants WHERE code='REP'), 'Salle de Réunion 1', 'Grande salle de réunion avec équipements complets', 12, 2000, true, true, true, true, 'AVAILABLE'),
((SELECT id FROM restaurants WHERE code='REP'), 'Salle de Réunion 2', 'Salle de réunion standard', 8, 1500, true, true, false, true, 'AVAILABLE'),
((SELECT id FROM restaurants WHERE code='REP'), 'Salle de Réunion 3', 'Salle de réunion compacte', 6, 1200, true, true, false, true, 'AVAILABLE'),
((SELECT id FROM restaurants WHERE code='REP'), 'Salle de Réunion 4', 'Salle de réunion avec vue panoramique', 10, 1800, true, true, true, true, 'AVAILABLE');

-- Salles pour VEG'N BIO NATION
INSERT INTO rooms (restaurant_id, name, description, capacity, hourly_rate_cents, has_wifi, has_printer, has_projector, has_whiteboard, status) VALUES
((SELECT id FROM restaurants WHERE code='NAT'), 'Salle de Conférence', 'Salle de conférence avec équipements audiovisuels', 15, 2500, true, true, true, true, 'AVAILABLE');

-- Salles pour VEG'N BIO PLACE D'ITALIE/MONTPARNASSE/IVRY
INSERT INTO rooms (restaurant_id, name, description, capacity, hourly_rate_cents, has_wifi, has_printer, has_projector, has_whiteboard, status) VALUES
((SELECT id FROM restaurants WHERE code='ITA'), 'Salle de Réunion Alpha', 'Salle de réunion moderne avec équipements', 8, 1500, true, true, true, true, 'AVAILABLE'),
((SELECT id FROM restaurants WHERE code='ITA'), 'Salle de Réunion Beta', 'Salle de réunion cosy pour petits groupes', 6, 1200, true, true, false, true, 'AVAILABLE');

-- Salles pour VEG'N BIO BEAUBOURG
INSERT INTO rooms (restaurant_id, name, description, capacity, hourly_rate_cents, has_wifi, has_printer, has_projector, has_whiteboard, status) VALUES
((SELECT id FROM restaurants WHERE code='BOU'), 'Salle de Réunion Centre', 'Salle de réunion centrale avec équipements', 8, 1500, true, true, true, true, 'AVAILABLE'),
((SELECT id FROM restaurants WHERE code='BOU'), 'Salle de Réunion Nord', 'Salle de réunion avec vue sur le centre Pompidou', 6, 1200, true, true, false, true, 'AVAILABLE');
