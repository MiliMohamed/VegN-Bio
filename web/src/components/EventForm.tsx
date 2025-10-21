import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { 
  Plus, 
  X, 
  Save, 
  Calendar,
  Clock,
  Users,
  MapPin,
  Type,
  DollarSign
} from 'lucide-react';
import { eventService } from '../services/api';

interface EventFormProps {
  isOpen: boolean;
  onClose: () => void;
  onSuccess: () => void;
  restaurantId?: number;
}

const EventForm: React.FC<EventFormProps> = ({ isOpen, onClose, onSuccess, restaurantId }) => {
  const [formData, setFormData] = useState({
    title: '',
    type: '',
    dateStart: '',
    dateEnd: '',
    capacity: '',
    description: '',
    restaurantId: restaurantId || 1
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement>) => {
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

    try {
      const eventData = {
        ...formData,
        capacity: formData.capacity ? parseInt(formData.capacity) : null,
        dateStart: new Date(formData.dateStart).toISOString(),
        dateEnd: formData.dateEnd ? new Date(formData.dateEnd).toISOString() : null
      };

      await eventService.create(eventData);
      onSuccess();
      onClose();
      setFormData({
        title: '',
        type: '',
        dateStart: '',
        dateEnd: '',
        capacity: '',
        description: '',
        restaurantId: restaurantId || 1
      });
    } catch (error: any) {
      setError(error.response?.data?.message || 'Erreur lors de la création de l\'événement');
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
            <Calendar className="w-6 h-6" />
            Créer un nouvel événement
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
            <label htmlFor="title" className="form-label">
              <Type className="w-4 h-4" />
              Titre de l'événement
            </label>
            <input
              type="text"
              id="title"
              name="title"
              value={formData.title}
              onChange={handleChange}
              className="form-input"
              placeholder="Ex: Conférence sur l'alimentation durable"
              required
            />
          </div>

          <div className="form-group">
            <label htmlFor="type" className="form-label">
              Type d'événement
            </label>
            <select
              id="type"
              name="type"
              value={formData.type}
              onChange={handleChange}
              className="form-select"
              required
            >
              <option value="">Sélectionner un type</option>
              <option value="ÉVÉNEMENT">Événement</option>
              <option value="ATELIER">Atelier</option>
              <option value="CONFÉRENCE">Conférence</option>
              <option value="DÉGUSTATION">Dégustation</option>
              <option value="ANIMATION">Animation</option>
            </select>
          </div>

          <div className="form-row">
            <div className="form-group">
              <label htmlFor="dateStart" className="form-label">
                <Clock className="w-4 h-4" />
                Date de début
              </label>
              <input
                type="datetime-local"
                id="dateStart"
                name="dateStart"
                value={formData.dateStart}
                onChange={handleChange}
                className="form-input"
                required
              />
            </div>

            <div className="form-group">
              <label htmlFor="dateEnd" className="form-label">
                <Clock className="w-4 h-4" />
                Date de fin (optionnel)
              </label>
              <input
                type="datetime-local"
                id="dateEnd"
                name="dateEnd"
                value={formData.dateEnd}
                onChange={handleChange}
                className="form-input"
              />
            </div>
          </div>

          <div className="form-group">
            <label htmlFor="capacity" className="form-label">
              <Users className="w-4 h-4" />
              Capacité (optionnel)
            </label>
            <input
              type="number"
              id="capacity"
              name="capacity"
              value={formData.capacity}
              onChange={handleChange}
              className="form-input"
              placeholder="Nombre de places disponibles"
              min="1"
            />
          </div>

          <div className="form-group">
            <label htmlFor="description" className="form-label">
              Description
            </label>
            <textarea
              id="description"
              name="description"
              value={formData.description}
              onChange={handleChange}
              className="form-textarea"
              placeholder="Description détaillée de l'événement..."
              rows={4}
              required
            />
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
                  Créer l'événement
                </>
              )}
            </button>
          </div>
        </form>
      </motion.div>
    </div>
  );
};

export default EventForm;
