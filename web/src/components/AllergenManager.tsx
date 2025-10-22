import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { 
  AlertTriangle, 
  Shield, 
  Filter, 
  X, 
  Check,
  Info,
  Settings,
  Eye,
  EyeOff
} from 'lucide-react';
import { allergenService } from '../services/api';
import '../styles/allergen-manager.css';

interface Allergen {
  id: number;
  code: string;
  label: string;
}

interface AllergenPreferences {
  [allergenId: number]: boolean; // true = allergie, false = pas d'allergie
}

interface AllergenManagerProps {
  onPreferencesChange?: (preferences: AllergenPreferences) => void;
  showFilter?: boolean;
  className?: string;
}

const AllergenManager: React.FC<AllergenManagerProps> = ({ 
  onPreferencesChange, 
  showFilter = true,
  className = ''
}) => {
  const [allergens, setAllergens] = useState<Allergen[]>([]);
  const [preferences, setPreferences] = useState<AllergenPreferences>({});
  const [showSettings, setShowSettings] = useState(false);
  const [showInfo, setShowInfo] = useState(false);
  const [loading, setLoading] = useState(true);

  // Charger les allergènes depuis l'API
  useEffect(() => {
    const fetchAllergens = async () => {
      try {
        const response = await allergenService.getAll();
        setAllergens(response.data);
        
        // Initialiser les préférences depuis le localStorage
        const savedPreferences = localStorage.getItem('allergenPreferences');
        if (savedPreferences) {
          setPreferences(JSON.parse(savedPreferences));
        }
      } catch (error) {
        console.error('Erreur lors du chargement des allergènes:', error);
        // Fallback sur les données mock en cas d'erreur
        const mockAllergens: Allergen[] = [
          { id: 1, code: 'GLUTEN', label: 'Céréales contenant du gluten' },
          { id: 2, code: 'CRUST', label: 'Crustacés' },
          { id: 3, code: 'EGG', label: 'Œufs' },
          { id: 4, code: 'FISH', label: 'Poissons' },
          { id: 5, code: 'PEANUT', label: 'Arachides' },
          { id: 6, code: 'SOY', label: 'Soja' },
          { id: 7, code: 'MILK', label: 'Lait' },
          { id: 8, code: 'NUTS', label: 'Fruits à coque' },
          { id: 9, code: 'CELERY', label: 'Céleri' },
          { id: 10, code: 'MUSTARD', label: 'Moutarde' },
          { id: 11, code: 'SESAME', label: 'Sésame' },
          { id: 12, code: 'SULPHITES', label: 'Sulfites' },
          { id: 13, code: 'LUPIN', label: 'Lupin' },
          { id: 14, code: 'MOLLUSCS', label: 'Mollusques' }
        ];
        setAllergens(mockAllergens);
      } finally {
        setLoading(false);
      }
    };

    fetchAllergens();
  }, []);

  // Sauvegarder les préférences dans le localStorage
  useEffect(() => {
    if (Object.keys(preferences).length > 0) {
      localStorage.setItem('allergenPreferences', JSON.stringify(preferences));
      onPreferencesChange?.(preferences);
    }
  }, [preferences, onPreferencesChange]);

  const handleAllergenToggle = (allergenId: number) => {
    setPreferences(prev => ({
      ...prev,
      [allergenId]: !prev[allergenId]
    }));
  };

  const getSelectedAllergensCount = () => {
    return Object.values(preferences).filter(Boolean).length;
  };

  const getSelectedAllergens = () => {
    return allergens.filter(allergen => preferences[allergen.id]);
  };

  const clearAllPreferences = () => {
    setPreferences({});
  };

  const getAllergenIcon = (code: string) => {
    const icons: { [key: string]: string } = {
      'GLUTEN': '🌾',
      'CRUST': '🦐',
      'EGG': '🥚',
      'FISH': '🐟',
      'PEANUT': '🥜',
      'SOY': '🫘',
      'MILK': '🥛',
      'NUTS': '🌰',
      'CELERY': '🥬',
      'MUSTARD': '🟡',
      'SESAME': '🟤',
      'SULPHITES': '⚗️',
      'LUPIN': '🟣',
      'MOLLUSCS': '🐚'
    };
    return icons[code] || '⚠️';
  };

  if (loading) {
    return (
      <div className={`allergen-manager ${className}`}>
        <div className="loading-container">
          <div className="loading-spinner"></div>
          <p>Chargement des allergènes...</p>
        </div>
      </div>
    );
  }

  return (
    <div className={`allergen-manager ${className}`}>
      {/* Bouton principal avec indicateur */}
      <motion.button
        className={`allergen-toggle-btn ${getSelectedAllergensCount() > 0 ? 'has-preferences' : ''}`}
        onClick={() => setShowSettings(!showSettings)}
        whileHover={{ scale: 1.05 }}
        whileTap={{ scale: 0.95 }}
      >
        <Shield className="w-4 h-4" />
        <span>Allergènes</span>
        {getSelectedAllergensCount() > 0 && (
          <span className="allergen-count">{getSelectedAllergensCount()}</span>
        )}
        {showSettings ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
      </motion.button>

      {/* Panel de gestion des allergènes */}
      <AnimatePresence>
        {showSettings && (
          <motion.div
            className="allergen-panel"
            initial={{ opacity: 0, y: -20, scale: 0.95 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: -20, scale: 0.95 }}
            transition={{ duration: 0.3 }}
          >
            <div className="panel-header">
              <h3>
                <AlertTriangle className="w-5 h-5" />
                Gestion des Allergènes
              </h3>
              <button 
                className="close-btn"
                onClick={() => setShowSettings(false)}
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            <div className="panel-content">
              <div className="info-section">
                <p className="info-text">
                  Sélectionnez les allergènes auxquels vous êtes allergique pour filtrer automatiquement les plats.
                </p>
                {getSelectedAllergensCount() > 0 && (
                  <button 
                    className="clear-btn"
                    onClick={clearAllPreferences}
                  >
                    Effacer toutes les sélections
                  </button>
                )}
              </div>

              <div className="allergens-grid">
                {allergens.map((allergen) => (
                  <motion.div
                    key={allergen.id}
                    className={`allergen-item ${preferences[allergen.id] ? 'selected' : ''}`}
                    onClick={() => handleAllergenToggle(allergen.id)}
                    whileHover={{ scale: 1.02 }}
                    whileTap={{ scale: 0.98 }}
                  >
                    <div className="allergen-icon">
                      {getAllergenIcon(allergen.code)}
                    </div>
                    <div className="allergen-info">
                      <span className="allergen-label">{allergen.label}</span>
                      <span className="allergen-code">{allergen.code}</span>
                    </div>
                    <div className="allergen-checkbox">
                      {preferences[allergen.id] && <Check className="w-4 h-4" />}
                    </div>
                  </motion.div>
                ))}
              </div>

              {/* Affichage des allergènes sélectionnés */}
              {getSelectedAllergensCount() > 0 && (
                <div className="selected-allergens">
                  <h4>Allergènes sélectionnés :</h4>
                  <div className="selected-list">
                    {getSelectedAllergens().map((allergen) => (
                      <span key={allergen.id} className="selected-allergen">
                        {getAllergenIcon(allergen.code)} {allergen.label}
                      </span>
                    ))}
                  </div>
                </div>
              )}
            </div>

            <div className="panel-footer">
              <button 
                className="btn btn-secondary btn-sm"
                onClick={() => setShowInfo(!showInfo)}
              >
                <Info className="w-4 h-4" />
                Informations
              </button>
              <button 
                className="btn btn-primary btn-sm"
                onClick={() => setShowSettings(false)}
              >
                Terminé
              </button>
            </div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Modal d'informations */}
      <AnimatePresence>
        {showInfo && (
          <motion.div
            className="info-modal-overlay"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            onClick={() => setShowInfo(false)}
          >
            <motion.div
              className="info-modal"
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              exit={{ opacity: 0, scale: 0.9 }}
              onClick={(e) => e.stopPropagation()}
            >
              <div className="modal-header">
                <h3>Informations sur les Allergènes</h3>
                <button onClick={() => setShowInfo(false)}>
                  <X className="w-4 h-4" />
                </button>
              </div>
              <div className="modal-content">
                <p>
                  <strong>Attention :</strong> Cette fonctionnalité vous aide à identifier les allergènes potentiels, 
                  mais ne remplace pas une consultation médicale. En cas de doute, consultez toujours votre médecin.
                </p>
                <p>
                  Les informations sur les allergènes sont fournies par les restaurants et peuvent ne pas être exhaustives. 
                  N'hésitez pas à demander des précisions au personnel du restaurant.
                </p>
                <div className="allergen-legend">
                  <h4>Légende des codes :</h4>
                  <ul>
                    {allergens.map((allergen) => (
                      <li key={allergen.id}>
                        <span className="legend-icon">{getAllergenIcon(allergen.code)}</span>
                        <strong>{allergen.code}:</strong> {allergen.label}
                      </li>
                    ))}
                  </ul>
                </div>
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
};

export default AllergenManager;
