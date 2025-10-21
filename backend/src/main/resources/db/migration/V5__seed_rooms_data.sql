-- Migration V5: Données de test pour les salles des restaurants Veg'N Bio
-- Ajout des salles selon les spécifications des restaurants

-- Salles pour VEG'N BIO BASTILLE (restaurant_id = 1)
INSERT INTO rooms (restaurant_id, name, description, capacity, hourly_rate_cents, has_wifi, has_printer, has_projector, has_whiteboard, status) VALUES
(1, 'Salle de Réunion A', 'Salle de réunion spacieuse avec vue sur la rue', 8, 1500, true, true, false, true, 'AVAILABLE'),
(1, 'Salle de Réunion B', 'Salle de réunion intime pour petits groupes', 6, 1200, true, true, false, true, 'AVAILABLE');

-- Salles pour VEG'N BIO REPUBLIQUE (restaurant_id = 2)
INSERT INTO rooms (restaurant_id, name, description, capacity, hourly_rate_cents, has_wifi, has_printer, has_projector, has_whiteboard, status) VALUES
(2, 'Salle de Réunion 1', 'Grande salle de réunion avec équipements complets', 12, 2000, true, true, true, true, 'AVAILABLE'),
(2, 'Salle de Réunion 2', 'Salle de réunion standard', 8, 1500, true, true, false, true, 'AVAILABLE'),
(2, 'Salle de Réunion 3', 'Salle de réunion compacte', 6, 1200, true, true, false, true, 'AVAILABLE'),
(2, 'Salle de Réunion 4', 'Salle de réunion avec vue panoramique', 10, 1800, true, true, true, true, 'AVAILABLE');

-- Salles pour VEG'N BIO NATION (restaurant_id = 3)
INSERT INTO rooms (restaurant_id, name, description, capacity, hourly_rate_cents, has_wifi, has_printer, has_projector, has_whiteboard, status) VALUES
(3, 'Salle de Conférence', 'Salle de conférence avec équipements audiovisuels', 15, 2500, true, true, true, true, 'AVAILABLE');

-- Salles pour VEG'N BIO PLACE D'ITALIE/MONTPARNASSE/IVRY (restaurant_id = 4)
INSERT INTO rooms (restaurant_id, name, description, capacity, hourly_rate_cents, has_wifi, has_printer, has_projector, has_whiteboard, status) VALUES
(4, 'Salle de Réunion Alpha', 'Salle de réunion moderne avec équipements', 8, 1500, true, true, true, true, 'AVAILABLE'),
(4, 'Salle de Réunion Beta', 'Salle de réunion cosy pour petits groupes', 6, 1200, true, true, false, true, 'AVAILABLE');

-- Salles pour VEG'N BIO BEAUBOURG (restaurant_id = 5)
INSERT INTO rooms (restaurant_id, name, description, capacity, hourly_rate_cents, has_wifi, has_printer, has_projector, has_whiteboard, status) VALUES
(5, 'Salle de Réunion Centre', 'Salle de réunion centrale avec équipements', 8, 1500, true, true, true, true, 'AVAILABLE'),
(5, 'Salle de Réunion Nord', 'Salle de réunion avec vue sur le centre Pompidou', 6, 1200, true, true, false, true, 'AVAILABLE');
