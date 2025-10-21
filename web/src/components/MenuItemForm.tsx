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
  Leaf
} from 'lucide-react';
import { menuService } from '../services/api';

interface MenuItemFormProps {
  isOpen: boolean;
  onClose: () => void;
  onSuccess: () => void;
  menuId: number;
}

const MenuItemForm: React.FC<MenuItemFormProps> = ({ isOpen, onClose, onSuccess, menuId }) => {
  const [formData, setFormData] = useState({
    name: '',
    description: '',
    priceCents: '',
    isVegan: false,
    menuId: menuId
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    const { name, value, type } = e.target;
    setFormData({
      ...formData,
      [name]: type === 'checkbox' ? (e.target as HTMLInputElement).checked : value
    });
    setError('');
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      const itemData = {
        ...formData,
        priceCents: Math.round(parseFloat(formData.priceCents) * 100)
      };

      await menuService.createMenuItem(itemData);
      onSuccess();
      onClose();
      setFormData({
        name: '',
        description: '',
        priceCents: '',
        isVegan: false,
        menuId: menuId
      });
    } catch (error: any) {
      setError(error.response?.data?.message || 'Erreur lors de la création du plat');
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
            Ajouter un plat
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
          <div className="form-group">
            <label htmlFor="name" className="form-label">
              <Type className="w-4 h-4" />
              Nom du plat
            </label>
            <input
              type="text"
              id="name"
              name="name"
              value={formData.name}
              onChange={handleChange}
              className="form-input"
              placeholder="Ex: Burger végétarien gourmet"
              required
            />
          </div>

          <div className="form-group">
            <label htmlFor="description" className="form-label">
              <FileText className="w-4 h-4" />
              Description
            </label>
            <textarea
              id="description"
              name="description"
              value={formData.description}
              onChange={handleChange}
              className="form-textarea"
              placeholder="Description détaillée du plat..."
              rows={3}
              required
            />
          </div>

          <div className="form-group">
            <label htmlFor="priceCents" className="form-label">
              <DollarSign className="w-4 h-4" />
              Prix (€)
            </label>
            <input
              type="number"
              id="priceCents"
              name="priceCents"
              value={formData.priceCents}
              onChange={handleChange}
              className="form-input"
              placeholder="15.90"
              step="0.01"
              min="0"
              required
            />
          </div>

          <div className="form-group">
            <label className="checkbox-label">
              <input
                type="checkbox"
                name="isVegan"
                checked={formData.isVegan}
                onChange={handleChange}
                className="checkbox-input"
              />
              <span className="checkbox-text">
                <Leaf className="w-4 h-4" />
                Plat végétalien
              </span>
            </label>
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
                  Ajouter le plat
                </>
              )}
            </button>
          </div>
        </form>
      </motion.div>
    </div>
  );
};

export default MenuItemForm;
