-- V16__fix_transaction_and_error_reporting.sql

-- Correction des problèmes de transaction et ajout du système de reporting d'erreurs

-- Table pour les rapports d'erreurs
CREATE TABLE IF NOT EXISTS error_reports (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    error_type VARCHAR(100) NOT NULL,
    severity VARCHAR(20) NOT NULL CHECK (severity IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    status VARCHAR(20) NOT NULL DEFAULT 'OPEN' CHECK (status IN ('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED')),
    user_agent TEXT,
    url TEXT,
    stack_trace TEXT,
    user_id VARCHAR(255),
    assigned_to VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index pour améliorer les performances de recherche
CREATE INDEX IF NOT EXISTS idx_error_reports_status ON error_reports (status);
CREATE INDEX IF NOT EXISTS idx_error_reports_timestamp ON error_reports (created_at);
CREATE INDEX IF NOT EXISTS idx_error_reports_severity ON error_reports (severity);
CREATE INDEX IF NOT EXISTS idx_error_reports_user_id ON error_reports (user_id);

-- Trigger pour mettre à jour updated_at automatiquement
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_error_reports_updated_at 
    BEFORE UPDATE ON error_reports 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Vues pour les statistiques d'erreurs
CREATE OR REPLACE VIEW error_report_statistics AS
SELECT 
    COUNT(*) as total_reports,
    COUNT(CASE WHEN status = 'OPEN' THEN 1 END) as open_reports,
    COUNT(CASE WHEN status = 'IN_PROGRESS' THEN 1 END) as in_progress_reports,
    COUNT(CASE WHEN status = 'RESOLVED' THEN 1 END) as resolved_reports,
    COUNT(CASE WHEN status = 'CLOSED' THEN 1 END) as closed_reports,
    COUNT(CASE WHEN severity = 'CRITICAL' THEN 1 END) as critical_reports,
    COUNT(CASE WHEN severity = 'HIGH' THEN 1 END) as high_reports,
    COUNT(CASE WHEN severity = 'MEDIUM' THEN 1 END) as medium_reports,
    COUNT(CASE WHEN severity = 'LOW' THEN 1 END) as low_reports
FROM error_reports;

-- Vue pour les erreurs récentes
CREATE OR REPLACE VIEW recent_error_reports AS
SELECT 
    id,
    title,
    description,
    error_type,
    severity,
    status,
    user_agent,
    url,
    stack_trace,
    user_id,
    assigned_to,
    created_at,
    updated_at
FROM error_reports 
WHERE created_at >= CURRENT_TIMESTAMP - INTERVAL '24 hours'
ORDER BY created_at DESC;

-- Données de test pour le système d'apprentissage du chatbot
INSERT INTO veterinary_consultations (animal_breed, symptoms, diagnosis, recommendation, confidence, created_at, updated_at)
VALUES 
    ('Golden Retriever', '["fatigue", "loss of appetite", "vomiting"]', 'Gastroenteritis', 'Rest, bland diet, monitor hydration', 0.85, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Persian Cat', '["sneezing", "runny nose", "eye discharge"]', 'Upper Respiratory Infection', 'Antibiotics, humidifier, rest', 0.90, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Labrador', '["limping", "swelling", "pain"]', 'Sprained Joint', 'Rest, ice, anti-inflammatory medication', 0.80, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Siamese Cat', '["excessive grooming", "hair loss", "skin irritation"]', 'Allergic Dermatitis', 'Identify allergen, antihistamines, topical treatment', 0.75, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('German Shepherd', '["coughing", "difficulty breathing", "lethargy"]', 'Respiratory Infection', 'Antibiotics, rest, monitor breathing', 0.88, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT DO NOTHING;

-- Mise à jour des contraintes de transaction
-- Assurer que les transactions sont correctement gérées
ALTER TABLE error_reports SET (autovacuum_enabled = true);
ALTER TABLE veterinary_consultations SET (autovacuum_enabled = true);

-- Commentaires pour la documentation
COMMENT ON TABLE error_reports IS 'Table pour stocker les rapports d''erreurs de l''application';
COMMENT ON COLUMN error_reports.severity IS 'Niveau de gravité de l''erreur: LOW, MEDIUM, HIGH, CRITICAL';
COMMENT ON COLUMN error_reports.status IS 'Statut du rapport: OPEN, IN_PROGRESS, RESOLVED, CLOSED';
COMMENT ON COLUMN error_reports.stack_trace IS 'Stack trace complète de l''erreur pour le debugging';
COMMENT ON COLUMN error_reports.assigned_to IS 'Utilisateur ou équipe assignée pour résoudre l''erreur';
