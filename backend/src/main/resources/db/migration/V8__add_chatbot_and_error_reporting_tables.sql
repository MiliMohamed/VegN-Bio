-- Migration pour les tables du chatbot vétérinaire et du reporting d'erreurs
-- V8__add_chatbot_and_error_reporting_tables.sql

-- Table pour les consultations vétérinaires
CREATE TABLE veterinary_consultations (
    id BIGSERIAL PRIMARY KEY,
    animal_breed VARCHAR(100) NOT NULL,
    diagnosis TEXT,
    recommendation TEXT,
    confidence DECIMAL(3,2) NOT NULL DEFAULT 0.80,
    user_id VARCHAR(100),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Table pour les symptômes des consultations
CREATE TABLE consultation_symptoms (
    consultation_id BIGINT NOT NULL,
    symptom VARCHAR(200) NOT NULL,
    PRIMARY KEY (consultation_id, symptom),
    FOREIGN KEY (consultation_id) REFERENCES veterinary_consultations(id) ON DELETE CASCADE
);

-- Table pour les rapports d'erreurs
CREATE TABLE error_reports (
    id BIGSERIAL PRIMARY KEY,
    error_type VARCHAR(100) NOT NULL,
    error_message TEXT NOT NULL,
    stack_trace TEXT,
    user_id VARCHAR(100),
    device_info VARCHAR(500),
    app_version VARCHAR(50),
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Table pour les données supplémentaires des rapports d'erreurs
CREATE TABLE error_report_additional_data (
    error_report_id BIGINT NOT NULL,
    data_key VARCHAR(100) NOT NULL,
    data_value TEXT,
    PRIMARY KEY (error_report_id, data_key),
    FOREIGN KEY (error_report_id) REFERENCES error_reports(id) ON DELETE CASCADE
);

-- Index pour améliorer les performances
CREATE INDEX idx_veterinary_consultations_breed ON veterinary_consultations(animal_breed);
CREATE INDEX idx_veterinary_consultations_user ON veterinary_consultations(user_id);
CREATE INDEX idx_veterinary_consultations_created_at ON veterinary_consultations(created_at);

CREATE INDEX idx_error_reports_type ON error_reports(error_type);
CREATE INDEX idx_error_reports_user ON error_reports(user_id);
CREATE INDEX idx_error_reports_timestamp ON error_reports(timestamp);

-- Données de base pour les races d'animaux communes
INSERT INTO veterinary_consultations (animal_breed, diagnosis, recommendation, confidence, user_id) VALUES
('Chien', 'Exemple de diagnostic', 'Exemple de recommandation', 0.80, 'system'),
('Chat', 'Exemple de diagnostic', 'Exemple de recommandation', 0.80, 'system'),
('Lapin', 'Exemple de diagnostic', 'Exemple de recommandation', 0.80, 'system'),
('Hamster', 'Exemple de diagnostic', 'Exemple de recommandation', 0.80, 'system'),
('Cochon d''Inde', 'Exemple de diagnostic', 'Exemple de recommandation', 0.80, 'system'),
('Oiseau', 'Exemple de diagnostic', 'Exemple de recommandation', 0.80, 'system'),
('Poisson', 'Exemple de diagnostic', 'Exemple de recommandation', 0.80, 'system'),
('Tortue', 'Exemple de diagnostic', 'Exemple de recommandation', 0.80, 'system'),
('Lézard', 'Exemple de diagnostic', 'Exemple de recommandation', 0.80, 'system'),
('Serpent', 'Exemple de diagnostic', 'Exemple de recommandation', 0.80, 'system');

-- Données de base pour les symptômes communs
INSERT INTO consultation_symptoms (consultation_id, symptom) VALUES
(1, 'Fièvre'),
(1, 'Perte d''appétit'),
(1, 'Léthargie'),
(2, 'Fièvre'),
(2, 'Perte d''appétit'),
(2, 'Léthargie'),
(3, 'Fièvre'),
(3, 'Perte d''appétit'),
(3, 'Léthargie');
