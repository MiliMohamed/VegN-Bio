import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { 
  Plus, 
  X, 
  Save, 
  Calendar,
  Users,
  Clock,
  MapPin,
  Type,
  FileText
} from 'lucide-react';
import { bookingService } from '../services/api';

interface BookingFormProps {
  isOpen: boolean;
  onClose: () => void;
  onSuccess: () => void;
  eventId: number;
  eventTitle: string;
}

const BookingForm: React.FC<BookingFormProps> = ({ isOpen, onClose, onSuccess, eventId, eventTitle }) => {
  const [formData, setFormData] = useState({
    customerName: '',
    customerPhone: '',
    pax: 1,
    eventId: eventId
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

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

    try {
      const bookingData = {
        ...formData,
        pax: parseInt(formData.pax.toString())
      };

      await bookingService.createBooking(bookingData);
      onSuccess();
      onClose();
      setFormData({
        customerName: '',
        customerPhone: '',
        pax: 1,
        eventId: eventId
      });
    } catch (error: any) {
      setError(error.response?.data?.message || 'Erreur lors de la réservation');
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
            Réserver : {eventTitle}
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
            <label htmlFor="customerName" className="form-label">
              <Type className="w-4 h-4" />
              Nom complet
            </label>
            <input
              type="text"
              id="customerName"
              name="customerName"
              value={formData.customerName}
              onChange={handleChange}
              className="form-input"
              placeholder="Votre nom complet"
              required
            />
          </div>

          <div className="form-group">
            <label htmlFor="customerPhone" className="form-label">
              <Clock className="w-4 h-4" />
              Téléphone
            </label>
            <input
              type="tel"
              id="customerPhone"
              name="customerPhone"
              value={formData.customerPhone}
              onChange={handleChange}
              className="form-input"
              placeholder="+33 1 23 45 67 89"
            />
          </div>

          <div className="form-group">
            <label htmlFor="pax" className="form-label">
              <Users className="w-4 h-4" />
              Nombre de personnes
            </label>
            <input
              type="number"
              id="pax"
              name="pax"
              value={formData.pax}
              onChange={handleChange}
              className="form-input"
              min="1"
              max="20"
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
                  Confirmer la réservation
                </>
              )}
            </button>
          </div>
        </form>
      </motion.div>
    </div>
  );
};

export default BookingForm;
