import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { X, Save, User, Phone, Users, Calendar, Search } from 'lucide-react';
import { bookingService } from '../services/api';
import { usePersonalBookings } from '../contexts/PersonalBookingsContext';
import { CreateBookingRequest, Event } from '../types/events';
import '../styles/modern-theme-system.css';
import '../styles/booking-form.css';

interface BookingFormProps {
  isOpen: boolean;
  onClose: () => void;
  onSuccess: () => void;
  event?: Event | null;
  restaurantId: number;
  events?: Event[];
}

const BookingForm: React.FC<BookingFormProps> = ({
  isOpen,
  onClose,
  onSuccess,
  event,
  restaurantId,
  events = []
}) => {
  const { addBooking } = usePersonalBookings();
  const [formData, setFormData] = useState<CreateBookingRequest>({
    eventId: event?.id || 0,
    customerName: '',
    customerPhone: '',
    pax: 1
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [selectedEvent, setSelectedEvent] = useState<Event | null>(event || null);

  useEffect(() => {
    if (event) {
      setFormData({
        eventId: event.id,
        customerName: '',
        customerPhone: '',
        pax: 1
      });
      setSelectedEvent(event);
    } else {
      setFormData({
        eventId: 0,
        customerName: '',
        customerPhone: '',
        pax: 1
      });
      setSelectedEvent(null);
    }
  }, [event]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    try {
      // Créer la réservation dans le backend
      const response = await bookingService.createBooking(formData);
      
      // Ajouter aussi dans le contexte local pour l'affichage immédiat
      addBooking({
        ...response.data,
        event: selectedEvent || undefined
      });
      
      onSuccess();
      onClose();
    } catch (error) {
      console.error('Erreur lors de la création de la réservation:', error);
      setError('Erreur lors de la création de la réservation');
    } finally {
      setLoading(false);
    }
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: name === 'pax' ? parseInt(value) : value
    }));

    if (name === 'eventId') {
      const eventId = parseInt(value);
      const selectedEventData = events.find(e => e.id === eventId);
      setSelectedEvent(selectedEventData || null);
    }
  };

  const formatDateTime = (dateTime: string) => {
    return new Date(dateTime).toLocaleString('fr-FR', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  if (!isOpen) return null;

  return (
    <div className="modal-overlay">
      <motion.div
        className="modal-content booking-form-modal"
        initial={{ opacity: 0, scale: 0.9 }}
        animate={{ opacity: 1, scale: 1 }}
        exit={{ opacity: 0, scale: 0.9 }}
        transition={{ duration: 0.3 }}
      >
        <div className="modal-header">
          <h2 className="modal-title">
            {event ? 'Réserver cet événement' : 'Nouvelle réservation'}
          </h2>
          <button 
            className="btn btn-ghost btn-sm"
            onClick={onClose}
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        <form onSubmit={handleSubmit} className="booking-form">
          {error && (
            <div className="error-message">
              {error}
            </div>
          )}

          {!event && (
            <div className="form-group">
              <label htmlFor="eventId" className="form-label">
                <Calendar className="w-4 h-4" />
                Événement *
              </label>
              <select
                id="eventId"
                name="eventId"
                value={formData.eventId}
                onChange={handleChange}
                className="form-select"
                required
              >
                <option value={0}>Sélectionner un événement</option>
                {events
                  .filter(e => e.status === 'ACTIVE')
                  .map(event => (
                    <option key={event.id} value={event.id}>
                      {event.title} - {formatDateTime(event.dateStart)}
                    </option>
                  ))}
              </select>
            </div>
          )}

          {selectedEvent && (
            <div className="event-info-card">
              <h3 className="event-info-title">{selectedEvent.title}</h3>
              <div className="event-info-details">
                <div className="info-item">
                  <Calendar className="w-4 h-4" />
                  <span>{formatDateTime(selectedEvent.dateStart)}</span>
                </div>
                {selectedEvent.capacity && (
                  <div className="info-item">
                    <Users className="w-4 h-4" />
                    <span>
                      Places disponibles: {selectedEvent.availableSpots || 0} / {selectedEvent.capacity}
                    </span>
                  </div>
                )}
                {selectedEvent.type && (
                  <div className="info-item">
                    <span>Type: {selectedEvent.type}</span>
                  </div>
                )}
              </div>
            </div>
          )}

          <div className="form-group">
            <label htmlFor="customerName" className="form-label">
              <User className="w-4 h-4" />
              Nom du client *
            </label>
            <input
              type="text"
              id="customerName"
              name="customerName"
              value={formData.customerName}
              onChange={handleChange}
              className="form-input"
              placeholder="Ex: Jean Dupont"
              required
            />
          </div>

          <div className="form-group">
            <label htmlFor="customerPhone" className="form-label">
              <Phone className="w-4 h-4" />
              Téléphone
            </label>
            <input
              type="tel"
              id="customerPhone"
              name="customerPhone"
              value={formData.customerPhone}
              onChange={handleChange}
              className="form-input"
              placeholder="Ex: 01 23 45 67 89"
            />
          </div>

          <div className="form-group">
            <label htmlFor="pax" className="form-label">
              <Users className="w-4 h-4" />
              Nombre de personnes *
            </label>
            <input
              type="number"
              id="pax"
              name="pax"
              value={formData.pax}
              onChange={handleChange}
              className="form-input"
              min="1"
              max={selectedEvent?.capacity || undefined}
              required
            />
            {selectedEvent?.capacity && (
              <small className="form-help">
                Maximum {selectedEvent.capacity} personnes pour cet événement
              </small>
            )}
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
              disabled={loading || !formData.eventId}
            >
              {loading ? (
                <div className="loading-spinner-small"></div>
              ) : (
                <Save className="w-4 h-4" />
              )}
              Réserver
            </button>
          </div>
        </form>
      </motion.div>
    </div>
  );
};

export default BookingForm;