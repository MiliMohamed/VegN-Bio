import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { X, Save, Calendar, Clock, Users, Settings, FileText } from 'lucide-react';
import { eventService } from '../services/api';
import { Event, CreateEventRequest } from '../types/events';
import '../styles/modern-theme-system.css';
import '../styles/event-form.css';

interface EventFormProps {
  isOpen: boolean;
  onClose: () => void;
  onSuccess: () => void;
  event?: Event | null;
  restaurantId: number;
  restaurantName?: string;
}

const EventForm: React.FC<EventFormProps> = ({
  isOpen,
  onClose,
  onSuccess,
  event,
  restaurantId,
  restaurantName
}) => {
  const [formData, setFormData] = useState<CreateEventRequest>({
    restaurantId,
    title: '',
    type: '',
    dateStart: '',
    dateEnd: '',
    capacity: undefined,
    description: ''
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (event) {
      setFormData({
        restaurantId: event.restaurantId,
        title: event.title,
        type: event.type || '',
        dateStart: event.dateStart,
        dateEnd: event.dateEnd || '',
        capacity: event.capacity || undefined,
        description: event.description || ''
      });
    } else {
      setFormData({
        restaurantId,
        title: '',
        type: '',
        dateStart: '',
        dateEnd: '',
        capacity: undefined,
        description: ''
      });
    }
  }, [event, restaurantId]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    try {
      if (event) {
        await eventService.update(event.id, formData);
      } else {
        await eventService.create(formData);
      }
      onSuccess();
      onClose();
    } catch (error) {
      console.error('Erreur lors de la sauvegarde de l\'événement:', error);
      setError('Erreur lors de la sauvegarde de l\'événement');
    } finally {
      setLoading(false);
    }
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: name === 'capacity' ? (value ? parseInt(value) : undefined) : value
    }));
  };

  if (!isOpen) return null;

  return (
    <div className="modal-overlay">
      <motion.div
        className="modal-content event-form-modal"
        initial={{ opacity: 0, scale: 0.9 }}
        animate={{ opacity: 1, scale: 1 }}
        exit={{ opacity: 0, scale: 0.9 }}
        transition={{ duration: 0.3 }}
      >
        <div className="modal-header">
          <h2 className="modal-title">
            {event ? 'Modifier l\'événement' : 'Nouvel événement'}
          </h2>
          <button 
            className="btn btn-ghost btn-sm"
            onClick={onClose}
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        <form onSubmit={handleSubmit} className="event-form">
          {error && (
            <div className="error-message">
              {error}
            </div>
          )}

          <div className="form-group">
            <label htmlFor="title" className="form-label">
              <FileText className="w-4 h-4" />
              Titre de l'événement *
            </label>
            <input
              type="text"
              id="title"
              name="title"
              value={formData.title}
              onChange={handleChange}
              className="form-input"
              placeholder="Ex: Soirée dégustation bio"
              required
            />
          </div>

          <div className="form-group">
            <label htmlFor="type" className="form-label">
              <Settings className="w-4 h-4" />
              Type d'événement
            </label>
            <select
              id="type"
              name="type"
              value={formData.type}
              onChange={handleChange}
              className="form-select"
            >
              <option value="">Sélectionner un type</option>
              <option value="DEGUSTATION">Dégustation</option>
              <option value="CONFERENCE">Conférence</option>
              <option value="ATELIER">Atelier</option>
              <option value="SOIREE">Soirée</option>
              <option value="FORMATION">Formation</option>
              <option value="AUTRE">Autre</option>
            </select>
          </div>

          <div className="form-row">
            <div className="form-group">
              <label htmlFor="dateStart" className="form-label">
                <Calendar className="w-4 h-4" />
                Date et heure de début *
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
                Date et heure de fin
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
              Capacité maximale
            </label>
            <input
              type="number"
              id="capacity"
              name="capacity"
              value={formData.capacity || ''}
              onChange={handleChange}
              className="form-input"
              placeholder="Ex: 50"
              min="1"
            />
            <small className="form-help">
              Laissez vide pour une capacité illimitée
            </small>
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
              placeholder="Décrivez votre événement..."
              rows={4}
            />
          </div>

          <div className="form-actions">
            <button 
              type="button"
              className="btn btn-secondary"
              onClick={onClose}
              disabled={loading}
            >
              Annuler
            </button>
            <button 
              type="submit"
              className="btn btn-primary"
              disabled={loading}
            >
              {loading ? (
                <div className="loading-spinner-small"></div>
              ) : (
                <Save className="w-4 h-4" />
              )}
              {event ? 'Modifier' : 'Créer'}
            </button>
          </div>
        </form>
      </motion.div>
    </div>
  );
};

export default EventForm;