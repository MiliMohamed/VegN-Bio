import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { 
  Calendar, 
  Clock, 
  Users, 
  MapPin, 
  CheckCircle,
  X,
  Plus,
  Star,
  Utensils,
  Music,
  Camera
} from 'lucide-react';
import '../styles/event-booking-styles.css';

interface EventType {
  id: string;
  name: string;
  icon: React.ReactNode;
  description: string;
  basePrice: number;
  duration: number;
  minGuests: number;
  maxGuests: number;
}

const ModernEventBooking: React.FC = () => {
  const [selectedEventType, setSelectedEventType] = useState<EventType | null>(null);
  const [showBookingModal, setShowBookingModal] = useState(false);
  const [bookingForm, setBookingForm] = useState({
    eventName: '',
    date: '',
    time: '',
    guests: 10,
    contactName: '',
    contactEmail: '',
    contactPhone: '',
    specialRequests: ''
  });

  const eventTypes: EventType[] = [
    {
      id: 'workshop',
      name: 'Atelier Culinaire',
      icon: <Utensils className="w-8 h-8" />,
      description: 'Apprenez à cuisiner végétarien avec nos chefs experts',
      basePrice: 45,
      duration: 3,
      minGuests: 8,
      maxGuests: 20
    },
    {
      id: 'conference',
      name: 'Conférence Nutrition',
      icon: <Users className="w-8 h-8" />,
      description: 'Découvrez les bienfaits de l\'alimentation végétale',
      basePrice: 25,
      duration: 2,
      minGuests: 15,
      maxGuests: 50
    },
    {
      id: 'concert',
      name: 'Concert Acoustique',
      icon: <Music className="w-8 h-8" />,
      description: 'Soirée musicale dans une ambiance chaleureuse',
      basePrice: 35,
      duration: 2,
      minGuests: 20,
      maxGuests: 80
    },
    {
      id: 'photo',
      name: 'Session Photo',
      icon: <Camera className="w-8 h-8" />,
      description: 'Séance photo professionnelle dans nos espaces',
      basePrice: 120,
      duration: 2,
      minGuests: 2,
      maxGuests: 10
    },
    {
      id: 'degustation',
      name: 'Dégustation Bio',
      icon: <Star className="w-8 h-8" />,
      description: 'Découverte de produits biologiques locaux',
      basePrice: 30,
      duration: 1.5,
      minGuests: 6,
      maxGuests: 25
    },
    {
      id: 'custom',
      name: 'Événement Sur Mesure',
      icon: <Plus className="w-8 h-8" />,
      description: 'Créez votre événement personnalisé',
      basePrice: 80,
      duration: 3,
      minGuests: 10,
      maxGuests: 100
    }
  ];

  const handleEventSelect = (eventType: EventType) => {
    setSelectedEventType(eventType);
    setShowBookingModal(true);
  };

  const handleBookingSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    // TODO: Implémenter la logique de réservation d'événement
    console.log('Réservation événement:', {
      eventType: selectedEventType,
      form: bookingForm
    });
    alert('Réservation d\'événement effectuée avec succès !');
    setShowBookingModal(false);
    setBookingForm({
      eventName: '',
      date: '',
      time: '',
      guests: 10,
      contactName: '',
      contactEmail: '',
      contactPhone: '',
      specialRequests: ''
    });
  };

  const calculatePrice = () => {
    if (!selectedEventType) return 0;
    const basePrice = selectedEventType.basePrice;
    const guestMultiplier = Math.max(1, bookingForm.guests / selectedEventType.minGuests);
    return Math.round(basePrice * guestMultiplier);
  };

  return (
    <div className="modern-event-booking">
      <div className="page-header">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <h1 className="page-title">Réservation d'Événements</h1>
          <p className="page-subtitle">
            Organisez des événements uniques dans nos restaurants bio
          </p>
        </motion.div>
      </div>

      {/* Types d'événements */}
      <div className="event-types-grid">
        {eventTypes.map((eventType, index) => (
          <motion.div
            key={eventType.id}
            className="event-type-card"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.4, delay: index * 0.1 }}
            onClick={() => handleEventSelect(eventType)}
          >
            <div className="event-icon">
              {eventType.icon}
            </div>
            
            <div className="event-content">
              <h3 className="event-name">{eventType.name}</h3>
              <p className="event-description">{eventType.description}</p>
              
              <div className="event-details">
                <div className="detail-item">
                  <Clock className="w-4 h-4" />
                  <span>{eventType.duration}h</span>
                </div>
                <div className="detail-item">
                  <Users className="w-4 h-4" />
                  <span>{eventType.minGuests}-{eventType.maxGuests} pers.</span>
                </div>
                <div className="detail-item price">
                  <span>À partir de {eventType.basePrice}€</span>
                </div>
              </div>
            </div>

            <div className="event-actions">
              <button className="btn btn-primary">
                Réserver
              </button>
            </div>
          </motion.div>
        ))}
      </div>

      {/* Modal de réservation */}
      {showBookingModal && selectedEventType && (
        <div className="modal-overlay" onClick={() => setShowBookingModal(false)}>
          <div className="booking-modal" onClick={(e) => e.stopPropagation()}>
            <div className="modal-header">
              <h3>Réserver : {selectedEventType.name}</h3>
              <button 
                className="modal-close"
                onClick={() => setShowBookingModal(false)}
              >
                <X className="w-6 h-6" />
              </button>
            </div>

            <form onSubmit={handleBookingSubmit} className="booking-form">
              <div className="form-row">
                <div className="form-group">
                  <label htmlFor="event-name">Nom de l'événement *</label>
                  <input
                    type="text"
                    id="event-name"
                    value={bookingForm.eventName}
                    onChange={(e) => setBookingForm({...bookingForm, eventName: e.target.value})}
                    required
                    className="form-input"
                    placeholder="ex: Anniversaire de Marie"
                  />
                </div>
                <div className="form-group">
                  <label htmlFor="contact-name">Nom du contact *</label>
                  <input
                    type="text"
                    id="contact-name"
                    value={bookingForm.contactName}
                    onChange={(e) => setBookingForm({...bookingForm, contactName: e.target.value})}
                    required
                    className="form-input"
                  />
                </div>
              </div>

              <div className="form-row">
                <div className="form-group">
                  <label htmlFor="event-date">Date *</label>
                  <input
                    type="date"
                    id="event-date"
                    value={bookingForm.date}
                    onChange={(e) => setBookingForm({...bookingForm, date: e.target.value})}
                    required
                    className="form-input"
                  />
                </div>
                <div className="form-group">
                  <label htmlFor="event-time">Heure *</label>
                  <select
                    id="event-time"
                    value={bookingForm.time}
                    onChange={(e) => setBookingForm({...bookingForm, time: e.target.value})}
                    required
                    className="form-input"
                  >
                    <option value="">Sélectionner une heure</option>
                    <option value="10:00">10:00</option>
                    <option value="14:00">14:00</option>
                    <option value="18:00">18:00</option>
                    <option value="19:00">19:00</option>
                    <option value="20:00">20:00</option>
                  </select>
                </div>
              </div>

              <div className="form-row">
                <div className="form-group">
                  <label htmlFor="guests-count">Nombre de participants *</label>
                  <input
                    type="number"
                    id="guests-count"
                    value={bookingForm.guests}
                    onChange={(e) => setBookingForm({...bookingForm, guests: parseInt(e.target.value)})}
                    min={selectedEventType.minGuests}
                    max={selectedEventType.maxGuests}
                    required
                    className="form-input"
                  />
                  <small className="form-help">
                    Entre {selectedEventType.minGuests} et {selectedEventType.maxGuests} participants
                  </small>
                </div>
                <div className="form-group">
                  <label htmlFor="contact-email">Email *</label>
                  <input
                    type="email"
                    id="contact-email"
                    value={bookingForm.contactEmail}
                    onChange={(e) => setBookingForm({...bookingForm, contactEmail: e.target.value})}
                    required
                    className="form-input"
                  />
                </div>
              </div>

              <div className="form-group">
                <label htmlFor="contact-phone">Téléphone *</label>
                <input
                  type="tel"
                  id="contact-phone"
                  value={bookingForm.contactPhone}
                  onChange={(e) => setBookingForm({...bookingForm, contactPhone: e.target.value})}
                  required
                  className="form-input"
                />
              </div>

              <div className="form-group">
                <label htmlFor="special-requests">Demandes spéciales</label>
                <textarea
                  id="special-requests"
                  value={bookingForm.specialRequests}
                  onChange={(e) => setBookingForm({...bookingForm, specialRequests: e.target.value})}
                  className="form-input"
                  rows={3}
                  placeholder="Menu spécial, décoration, équipements, etc."
                />
              </div>

              <div className="booking-summary">
                <h4>Résumé de la réservation</h4>
                <div className="summary-line">
                  <span>Type d'événement :</span>
                  <span>{selectedEventType.name}</span>
                </div>
                <div className="summary-line">
                  <span>Nom :</span>
                  <span>{bookingForm.eventName || 'À définir'}</span>
                </div>
                <div className="summary-line">
                  <span>Date :</span>
                  <span>{bookingForm.date || 'À définir'}</span>
                </div>
                <div className="summary-line">
                  <span>Heure :</span>
                  <span>{bookingForm.time || 'À définir'}</span>
                </div>
                <div className="summary-line">
                  <span>Participants :</span>
                  <span>{bookingForm.guests} personnes</span>
                </div>
                <div className="summary-line">
                  <span>Durée :</span>
                  <span>{selectedEventType.duration} heure(s)</span>
                </div>
                <div className="summary-line total">
                  <span>Total estimé :</span>
                  <span>{calculatePrice()}€</span>
                </div>
              </div>

              <div className="modal-actions">
                <button 
                  type="button" 
                  className="btn btn-secondary"
                  onClick={() => setShowBookingModal(false)}
                >
                  Annuler
                </button>
                <button 
                  type="submit" 
                  className="btn btn-primary"
                >
                  <CheckCircle className="w-4 h-4" />
                  Confirmer la réservation
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default ModernEventBooking;
