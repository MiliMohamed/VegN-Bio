import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { 
  Plus, 
  X, 
  Save, 
  Utensils,
  DollarSign,
  Type,
  FileText,
  Leaf,
  Calendar
} from 'lucide-react';
import { menuService } from '../services/api';
import '../styles/menu-improvements.css';

interface MenuFormProps {
  isOpen: boolean;
  onClose: () => void;
  onSuccess: () => void;
  restaurantId: number;
  restaurantName?: string;
}

const MenuForm: React.FC<MenuFormProps> = ({ isOpen, onClose, onSuccess, restaurantId, restaurantName }) => {
  const [formData, setFormData] = useState({
    title: '',
    activeFrom: '',
    activeTo: '',
    restaurantId: restaurantId
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  // Mettre à jour le restaurantId quand il change
  React.useEffect(() => {
    setFormData(prev => ({
      ...prev,
      restaurantId: restaurantId
    }));
  }, [restaurantId]);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    });
    setError('');
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    console.log('Données du menu à créer:', formData);
    console.log('Restaurant ID:', restaurantId);

    // Vérifier que le restaurantId est valide
    if (!restaurantId || restaurantId <= 0) {
      setError('Erreur: Aucun restaurant sélectionné. Veuillez sélectionner un restaurant.');
      setLoading(false);
      return;
    }

    try {
      const menuData = {
        ...formData,
        restaurantId: restaurantId, // S'assurer que le restaurantId est bien inclus
        activeFrom: formData.activeFrom || new Date().toISOString().split('T')[0],
        activeTo: formData.activeTo || new Date(Date.now() + 90 * 24 * 60 * 60 * 1000).toISOString().split('T')[0]
      };

      console.log('Données finales envoyées:', menuData);
      const response = await menuService.create(menuData);
      console.log('Réponse du serveur:', response);
      
      onSuccess();
      onClose();
      setFormData({
        title: '',
        activeFrom: '',
        activeTo: '',
        restaurantId: restaurantId
      });
    } catch (error: any) {
      console.error('Erreur lors de la création du menu:', error);
      console.error('Détails de l\'erreur:', error.response?.data);
      setError(error.response?.data?.message || 'Erreur lors de la création du menu');
    } finally {
      setLoading(false);
    }
  };

  if (!isOpen) return null;

  return (
    <div className="modal-overlay" onClick={onClose}>
      <motion.div 
        className="modal-content"
        initial={{ opacity: 0, scale: 0.9 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ duration: 0.3 }}
        onClick={(e) => e.stopPropagation()}
      >
        <div className="modal-header">
          <h2 className="modal-title">
            <Utensils className="w-6 h-6" />
            Créer un nouveau menu
          </h2>
          <button className="modal-close" onClick={onClose}>
            <X className="w-6 h-6" />
          </button>
        </div>

        {error && (
          <div className="alert alert-error">
            {error}
          </div>
        )}

        <form onSubmit={handleSubmit} className="modal-form">
          {/* Affichage du restaurant sélectionné */}
          <div className="form-group">
            <div className="restaurant-info">
              <label className="form-label">
                <Utensils className="w-4 h-4" />
                Restaurant sélectionné
              </label>
              <div className="restaurant-display">
                {restaurantName ? (
                  <div>
                    <strong>{restaurantName}</strong>
                    <br />
                    <small>ID: {restaurantId}</small>
                  </div>
                ) : (
                  <div>
                    Restaurant ID: {restaurantId}
                    {restaurantId <= 0 && (
                      <span className="error-text">⚠️ Aucun restaurant sélectionné</span>
                    )}
                  </div>
                )}
              </div>
            </div>
          </div>

          <div className="form-group">
            <label htmlFor="title" className="form-label">
              <Type className="w-4 h-4" />
              Titre du menu *
            </label>
            <input
              type="text"
              id="title"
              name="title"
              value={formData.title}
              onChange={handleChange}
              className="form-input"
              placeholder="Ex: Menu Printemps Bio 2024"
              required
              maxLength={100}
            />
            <small className="form-help">Maximum 100 caractères</small>
          </div>

          <div className="form-row">
            <div className="form-group">
              <label htmlFor="activeFrom" className="form-label">
                <Calendar className="w-4 h-4" />
                Date de début *
              </label>
              <input
                type="date"
                id="activeFrom"
                name="activeFrom"
                value={formData.activeFrom}
                onChange={handleChange}
                className="form-input"
                min={new Date().toISOString().split('T')[0]}
                required
              />
              <small className="form-help">Date de début de validité du menu</small>
            </div>

            <div className="form-group">
              <label htmlFor="activeTo" className="form-label">
                <Calendar className="w-4 h-4" />
                Date de fin *
              </label>
              <input
                type="date"
                id="activeTo"
                name="activeTo"
                value={formData.activeTo}
                onChange={handleChange}
                className="form-input"
                min={formData.activeFrom || new Date().toISOString().split('T')[0]}
                required
              />
              <small className="form-help">Date de fin de validité du menu</small>
            </div>
          </div>

          <div className="modal-actions">
            <button type="button" className="btn btn-secondary" onClick={onClose}>
              Annuler
            </button>
            <button 
              type="submit" 
              className={`btn btn-primary ${loading ? 'loading' : ''}`}
              disabled={loading}
            >
              {loading ? (
                <div className="loading-spinner"></div>
              ) : (
                <>
                  <Save className="w-4 h-4" />
                  Créer le menu
                </>
              )}
            </button>
          </div>
        </form>
      </motion.div>
    </div>
  );
};

export default MenuForm;
