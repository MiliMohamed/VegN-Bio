-- Migration V11: Ajouter les détails des restaurants VEG'N BIO
-- Ajouter les colonnes pour les informations détaillées des restaurants

ALTER TABLE restaurants ADD COLUMN IF NOT EXISTS wifi_available BOOLEAN DEFAULT FALSE;
ALTER TABLE restaurants ADD COLUMN IF NOT EXISTS meeting_rooms_count INTEGER DEFAULT 0;
ALTER TABLE restaurants ADD COLUMN IF NOT EXISTS restaurant_capacity INTEGER DEFAULT 0;
ALTER TABLE restaurants ADD COLUMN IF NOT EXISTS printer_available BOOLEAN DEFAULT FALSE;
ALTER TABLE restaurants ADD COLUMN IF NOT EXISTS member_trays BOOLEAN DEFAULT FALSE;
ALTER TABLE restaurants ADD COLUMN IF NOT EXISTS delivery_available BOOLEAN DEFAULT FALSE;
ALTER TABLE restaurants ADD COLUMN IF NOT EXISTS special_events TEXT;
ALTER TABLE restaurants ADD COLUMN IF NOT EXISTS monday_thursday_hours VARCHAR(50);
ALTER TABLE restaurants ADD COLUMN IF NOT EXISTS friday_hours VARCHAR(50);
ALTER TABLE restaurants ADD COLUMN IF NOT EXISTS saturday_hours VARCHAR(50);
ALTER TABLE restaurants ADD COLUMN IF NOT EXISTS sunday_hours VARCHAR(50);

-- Mettre à jour les données des restaurants existants avec les nouvelles informations
UPDATE restaurants SET 
  wifi_available = TRUE,
  meeting_rooms_count = 2,
  restaurant_capacity = 100,
  printer_available = TRUE,
  member_trays = TRUE,
  delivery_available = FALSE,
  special_events = NULL,
  monday_thursday_hours = '9h à 24h',
  friday_hours = '9h à 1h du matin',
  saturday_hours = '9h à 5h du matin',
  sunday_hours = '11h à 24h'
WHERE code = 'BAS';

UPDATE restaurants SET 
  wifi_available = TRUE,
  meeting_rooms_count = 4,
  restaurant_capacity = 150,
  printer_available = TRUE,
  member_trays = FALSE,
  delivery_available = TRUE,
  special_events = NULL,
  monday_thursday_hours = '9h à 24h',
  friday_hours = '9h à 1h du matin',
  saturday_hours = '9h à 5h du matin',
  sunday_hours = '11h à 24h'
WHERE code = 'REP';

UPDATE restaurants SET 
  wifi_available = TRUE,
  meeting_rooms_count = 1,
  restaurant_capacity = 80,
  printer_available = TRUE,
  member_trays = TRUE,
  delivery_available = TRUE,
  special_events = 'Conférences et animations tous les mardi après-midi',
  monday_thursday_hours = '9h à 24h',
  friday_hours = '9h à 1h du matin',
  saturday_hours = '9h à 5h du matin',
  sunday_hours = '11h à 24h'
WHERE code = 'NAT';

-- Mettre à jour Place d'Italie (fusionner avec Montparnasse et Ivry selon les données)
UPDATE restaurants SET 
  wifi_available = TRUE,
  meeting_rooms_count = 2,
  restaurant_capacity = 70,
  printer_available = TRUE,
  member_trays = TRUE,
  delivery_available = TRUE,
  special_events = NULL,
  monday_thursday_hours = '9h à 23h',
  friday_hours = '9h à 1h du matin',
  saturday_hours = '9h à 5h du matin',
  sunday_hours = '11h à 23h'
WHERE code = 'ITA';

-- Supprimer les restaurants Montparnasse et Ivry car ils sont fusionnés avec Place d'Italie
DELETE FROM restaurants WHERE code IN ('MON', 'IVR');

-- Mettre à jour Beaubourg
UPDATE restaurants SET 
  wifi_available = TRUE,
  meeting_rooms_count = 2,
  restaurant_capacity = 70,
  printer_available = TRUE,
  member_trays = TRUE,
  delivery_available = TRUE,
  special_events = NULL,
  monday_thursday_hours = '9h à 23h',
  friday_hours = '9h à 1h du matin',
  saturday_hours = '9h à 5h du matin',
  sunday_hours = '11h à 23h'
WHERE code = 'BOU';
