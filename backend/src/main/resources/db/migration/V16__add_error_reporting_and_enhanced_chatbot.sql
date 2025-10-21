-- Migration pour ajouter les tables d'erreurs et améliorer le système de chatbot
-- V16__add_error_reporting_and_enhanced_chatbot.sql

-- Table pour les rapports d'erreurs
CREATE TABLE IF NOT EXISTS error_reports (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    error_type VARCHAR(100) NOT NULL,
    severity VARCHAR(20) NOT NULL CHECK (severity IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    status VARCHAR(20) NOT NULL DEFAULT 'OPEN' CHECK (status IN ('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED')),
    user_agent TEXT,
    url TEXT,
    stack_trace TEXT,
    user_id VARCHAR(100),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index pour améliorer les performances des requêtes
CREATE INDEX IF NOT EXISTS idx_error_reports_status ON error_reports(status);
CREATE INDEX IF NOT EXISTS idx_error_reports_severity ON error_reports(severity);
CREATE INDEX IF NOT EXISTS idx_error_reports_created_at ON error_reports(created_at);
CREATE INDEX IF NOT EXISTS idx_error_reports_user_id ON error_reports(user_id);

-- Table pour les statistiques d'apprentissage du chatbot
CREATE TABLE IF NOT EXISTS chatbot_learning_stats (
    id BIGSERIAL PRIMARY KEY,
    breed VARCHAR(100) NOT NULL,
    symptom VARCHAR(255) NOT NULL,
    diagnosis VARCHAR(500) NOT NULL,
    confidence_score DECIMAL(3,2) DEFAULT 0.0,
    usage_count INTEGER DEFAULT 1,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(breed, symptom, diagnosis)
);

-- Index pour les statistiques d'apprentissage
CREATE INDEX IF NOT EXISTS idx_chatbot_learning_breed ON chatbot_learning_stats(breed);
CREATE INDEX IF NOT EXISTS idx_chatbot_learning_symptom ON chatbot_learning_stats(symptom);
CREATE INDEX IF NOT EXISTS idx_chatbot_learning_confidence ON chatbot_learning_stats(confidence_score);

-- Table pour les recommandations préventives par race
CREATE TABLE IF NOT EXISTS preventive_recommendations (
    id BIGSERIAL PRIMARY KEY,
    breed VARCHAR(100) NOT NULL,
    recommendation TEXT NOT NULL,
    category VARCHAR(50) DEFAULT 'general',
    priority INTEGER DEFAULT 1,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index pour les recommandations préventives
CREATE INDEX IF NOT EXISTS idx_preventive_recommendations_breed ON preventive_recommendations(breed);
CREATE INDEX IF NOT EXISTS idx_preventive_recommendations_category ON preventive_recommendations(category);
CREATE INDEX IF NOT EXISTS idx_preventive_recommendations_active ON preventive_recommendations(is_active);

-- Table pour les symptômes communs par race
CREATE TABLE IF NOT EXISTS breed_symptoms (
    id BIGSERIAL PRIMARY KEY,
    breed VARCHAR(100) NOT NULL,
    symptom VARCHAR(255) NOT NULL,
    frequency INTEGER DEFAULT 1,
    severity VARCHAR(20) DEFAULT 'MEDIUM' CHECK (severity IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    is_emergency BOOLEAN DEFAULT false,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(breed, symptom)
);

-- Index pour les symptômes par race
CREATE INDEX IF NOT EXISTS idx_breed_symptoms_breed ON breed_symptoms(breed);
CREATE INDEX IF NOT EXISTS idx_breed_symptoms_emergency ON breed_symptoms(is_emergency);
CREATE INDEX IF NOT EXISTS idx_breed_symptoms_frequency ON breed_symptoms(frequency);

-- Table pour les diagnostics vétérinaires avec plus de détails
CREATE TABLE IF NOT EXISTS veterinary_diagnoses (
    id BIGSERIAL PRIMARY KEY,
    consultation_id BIGINT REFERENCES veterinary_consultations(id),
    breed VARCHAR(100) NOT NULL,
    symptoms TEXT[] NOT NULL,
    diagnosis TEXT NOT NULL,
    confidence DECIMAL(3,2) NOT NULL DEFAULT 0.0,
    treatment_suggestions TEXT,
    follow_up_instructions TEXT,
    emergency_level INTEGER DEFAULT 0 CHECK (emergency_level BETWEEN 0 AND 5),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index pour les diagnostics vétérinaires
CREATE INDEX IF NOT EXISTS idx_veterinary_diagnoses_breed ON veterinary_diagnoses(breed);
CREATE INDEX IF NOT EXISTS idx_veterinary_diagnoses_confidence ON veterinary_diagnoses(confidence);
CREATE INDEX IF NOT EXISTS idx_veterinary_diagnoses_emergency ON veterinary_diagnoses(emergency_level);

-- Table pour les feedbacks des utilisateurs sur les diagnostics
CREATE TABLE IF NOT EXISTS diagnosis_feedback (
    id BIGSERIAL PRIMARY KEY,
    diagnosis_id BIGINT REFERENCES veterinary_diagnoses(id),
    user_id VARCHAR(100),
    accuracy_rating INTEGER CHECK (accuracy_rating BETWEEN 1 AND 5),
    helpful_rating INTEGER CHECK (helpful_rating BETWEEN 1 AND 5),
    feedback_text TEXT,
    was_correct BOOLEAN,
    actual_diagnosis TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Index pour les feedbacks
CREATE INDEX IF NOT EXISTS idx_diagnosis_feedback_diagnosis ON diagnosis_feedback(diagnosis_id);
CREATE INDEX IF NOT EXISTS idx_diagnosis_feedback_user ON diagnosis_feedback(user_id);
CREATE INDEX IF NOT EXISTS idx_diagnosis_feedback_rating ON diagnosis_feedback(accuracy_rating);

-- Insérer des données de base pour les recommandations préventives
INSERT INTO preventive_recommendations (breed, recommendation, category, priority) VALUES
-- Chiens
('Chien', 'Vaccination annuelle contre la rage et les maladies courantes', 'vaccination', 1),
('Chien', 'Vermifugation régulière (tous les 3 mois)', 'parasites', 1),
('Chien', 'Brossage des dents quotidien pour éviter les problèmes dentaires', 'hygiene', 2),
('Chien', 'Exercice régulier pour maintenir un poids santé', 'exercice', 2),
('Chien', 'Surveillance des oreilles pour éviter les infections', 'surveillance', 2),

-- Chats
('Chat', 'Vaccination annuelle contre le typhus et le coryza', 'vaccination', 1),
('Chat', 'Vermifugation régulière (tous les 3 mois)', 'parasites', 1),
('Chat', 'Stérilisation recommandée pour éviter les problèmes de reproduction', 'sterilisation', 1),
('Chat', 'Surveillance des reins avec une alimentation adaptée', 'surveillance', 2),
('Chat', 'Brossage régulier pour éviter les boules de poils', 'hygiene', 2),

-- Lapins
('Lapin', 'Alimentation riche en foin pour l''usure des dents', 'alimentation', 1),
('Lapin', 'Surveillance des dents qui poussent continuellement', 'surveillance', 1),
('Lapin', 'Environnement propre pour éviter les problèmes respiratoires', 'environnement', 2),
('Lapin', 'Vaccination contre la myxomatose et la maladie hémorragique', 'vaccination', 1),
('Lapin', 'Surveillance du poids pour éviter l''obésité', 'surveillance', 2);

-- Insérer des symptômes communs par race
INSERT INTO breed_symptoms (breed, symptom, frequency, severity, is_emergency) VALUES
-- Chiens
('Chien', 'Fièvre', 5, 'MEDIUM', false),
('Chien', 'Perte d''appétit', 4, 'MEDIUM', false),
('Chien', 'Léthargie', 4, 'MEDIUM', false),
('Chien', 'Vomissements', 3, 'HIGH', false),
('Chien', 'Diarrhée', 3, 'HIGH', false),
('Chien', 'Toux', 2, 'MEDIUM', false),
('Chien', 'Difficultés respiratoires', 1, 'CRITICAL', true),
('Chien', 'Saignement', 1, 'CRITICAL', true),

-- Chats
('Chat', 'Fièvre', 4, 'HIGH', false),
('Chat', 'Perte d''appétit', 5, 'HIGH', false),
('Chat', 'Léthargie', 4, 'HIGH', false),
('Chat', 'Vomissements', 3, 'MEDIUM', false),
('Chat', 'Difficultés urinaires', 2, 'CRITICAL', true),
('Chat', 'Perte de poils', 3, 'LOW', false),
('Chat', 'Ronflement', 2, 'LOW', false),

-- Lapins
('Lapin', 'Perte d''appétit', 5, 'CRITICAL', true),
('Lapin', 'Léthargie', 4, 'HIGH', false),
('Lapin', 'Difficultés respiratoires', 2, 'CRITICAL', true),
('Lapin', 'Diarrhée', 3, 'CRITICAL', true),
('Lapin', 'Perte de poils', 2, 'MEDIUM', false),
('Lapin', 'Grincement de dents', 2, 'HIGH', false);

-- Fonction pour mettre à jour automatiquement le timestamp updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers pour mettre à jour automatiquement updated_at
CREATE TRIGGER update_error_reports_updated_at BEFORE UPDATE ON error_reports FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_chatbot_learning_stats_updated_at BEFORE UPDATE ON chatbot_learning_stats FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_preventive_recommendations_updated_at BEFORE UPDATE ON preventive_recommendations FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_breed_symptoms_updated_at BEFORE UPDATE ON breed_symptoms FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_veterinary_diagnoses_updated_at BEFORE UPDATE ON veterinary_diagnoses FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Vue pour les statistiques d'erreurs
CREATE OR REPLACE VIEW error_statistics AS
SELECT 
    COUNT(*) as total_errors,
    COUNT(CASE WHEN status = 'OPEN' THEN 1 END) as open_errors,
    COUNT(CASE WHEN status = 'RESOLVED' THEN 1 END) as resolved_errors,
    COUNT(CASE WHEN severity = 'CRITICAL' THEN 1 END) as critical_errors,
    COUNT(CASE WHEN severity = 'HIGH' THEN 1 END) as high_errors,
    COUNT(CASE WHEN severity = 'MEDIUM' THEN 1 END) as medium_errors,
    COUNT(CASE WHEN severity = 'LOW' THEN 1 END) as low_errors,
    ROUND(AVG(CASE WHEN status = 'RESOLVED' THEN 1.0 ELSE 0.0 END) * 100, 2) as resolution_rate,
    COUNT(CASE WHEN created_at > NOW() - INTERVAL '24 hours' THEN 1 END) as recent_errors_24h
FROM error_reports;

-- Vue pour les statistiques du chatbot
CREATE OR REPLACE VIEW chatbot_statistics AS
SELECT 
    COUNT(DISTINCT breed) as supported_breeds,
    COUNT(DISTINCT symptom) as known_symptoms,
    COUNT(*) as total_consultations,
    ROUND(AVG(confidence), 2) as average_confidence,
    COUNT(CASE WHEN created_at > NOW() - INTERVAL '7 days' THEN 1 END) as consultations_last_week,
    COUNT(CASE WHEN created_at > NOW() - INTERVAL '30 days' THEN 1 END) as consultations_last_month
FROM veterinary_consultations;

-- Commentaires sur les tables
COMMENT ON TABLE error_reports IS 'Table pour stocker les rapports d''erreurs de l''application';
COMMENT ON TABLE chatbot_learning_stats IS 'Statistiques d''apprentissage du système de chatbot vétérinaire';
COMMENT ON TABLE preventive_recommendations IS 'Recommandations préventives par race d''animal';
COMMENT ON TABLE breed_symptoms IS 'Symptômes communs par race d''animal';
COMMENT ON TABLE veterinary_diagnoses IS 'Diagnostics vétérinaires détaillés';
COMMENT ON TABLE diagnosis_feedback IS 'Feedbacks des utilisateurs sur les diagnostics';
