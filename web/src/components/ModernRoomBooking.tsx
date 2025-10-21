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
  Search,
  Filter
} from 'lucide-react';
import '../styles/room-booking-styles.css';

interface Room {
  id: number;
  name: string;
  capacity: number;
  location: string;
  amenities: string[];
  hourlyRate: number;
  image: string;
  available: boolean;
}

const ModernRoomBooking: React.FC = () => {
  const [selectedDate, setSelectedDate] = useState('');
  const [selectedTime, setSelectedTime] = useState('');
  const [selectedRoom, setSelectedRoom] = useState<Room | null>(null);
  const [showBookingModal, setShowBookingModal] = useState(false);
  const [bookingForm, setBookingForm] = useState({
    name: '',
    email: '',
    phone: '',
    duration: 2,
    specialRequests: ''
  });

  // Données de test pour les salles
  const rooms: Room[] = [
    {
      id: 1,
      name: 'Salle République',
      capacity: 20,
      location: 'Restaurant République',
      amenities: ['Projecteur', 'Tableau blanc', 'Climatisation', 'WiFi'],
      hourlyRate: 50,
      image: '/api/placeholder/300/200',
      available: true
    },
    {
      id: 2,
      name: 'Salle Nation',
      capacity: 15,
      location: 'Restaurant Nation',
      amenities: ['Écran TV', 'Son', 'Climatisation', 'WiFi'],
      hourlyRate: 40,
      image: '/api/placeholder/300/200',
      available: true
    },
    {
      id: 3,
      name: 'Salle Place d\'Italie',
      capacity: 30,
      location: 'Restaurant Place d\'Italie',
      amenities: ['Projecteur', 'Micro', 'Climatisation', 'WiFi', 'Cuisine'],
      hourlyRate: 75,
      image: '/api/placeholder/300/200',
      available: false
    },
    {
      id: 4,
      name: 'Salle Beaubourg',
      capacity: 12,
      location: 'Restaurant Beaubourg',
      amenities: ['Tableau blanc', 'Climatisation', 'WiFi'],
      hourlyRate: 35,
      image: '/api/placeholder/300/200',
      available: true
    }
  ];

  const handleRoomSelect = (room: Room) => {
    if (!room.available) return;
    setSelectedRoom(room);
    setShowBookingModal(true);
  };

  const handleBookingSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    // TODO: Implémenter la logique de réservation
    console.log('Réservation:', {
      room: selectedRoom,
      date: selectedDate,
      time: selectedTime,
      form: bookingForm
    });
    alert('Réservation effectuée avec succès !');
    setShowBookingModal(false);
    setBookingForm({
      name: '',
      email: '',
      phone: '',
      duration: 2,
      specialRequests: ''
    });
  };

  const formatPrice = (price: number) => {
    return `${price}€/heure`;
  };

  return (
    <div className="modern-room-booking">
      <div className="page-header">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <h1 className="page-title">Réservation de Salles</h1>
          <p className="page-subtitle">
            Organisez vos événements professionnels dans nos espaces dédiés
          </p>
        </motion.div>
      </div>

      {/* Filtres de recherche */}
      <motion.div 
        className="search-filters"
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.2 }}
      >
        <div className="filters-container">
          <div className="filter-group">
            <label htmlFor="date-select">
              <Calendar className="w-4 h-4" />
              Date :
            </label>
            <input
              type="date"
              id="date-select"
              value={selectedDate}
              onChange={(e) => setSelectedDate(e.target.value)}
              className="filter-input"
            />
          </div>

          <div className="filter-group">
            <label htmlFor="time-select">
              <Clock className="w-4 h-4" />
              Heure :
            </label>
            <select
              id="time-select"
              value={selectedTime}
              onChange={(e) => setSelectedTime(e.target.value)}
              className="filter-input"
            >
              <option value="">Sélectionner une heure</option>
              <option value="09:00">09:00</option>
              <option value="10:00">10:00</option>
              <option value="11:00">11:00</option>
              <option value="14:00">14:00</option>
              <option value="15:00">15:00</option>
              <option value="16:00">16:00</option>
              <option value="17:00">17:00</option>
            </select>
          </div>

          <button className="btn btn-primary">
            <Search className="w-4 h-4" />
            Rechercher
          </button>
        </div>
      </motion.div>

      {/* Liste des salles */}
      <div className="rooms-grid">
        {rooms.map((room, index) => (
          <motion.div
            key={room.id}
            className={`room-card ${!room.available ? 'unavailable' : ''}`}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.4, delay: index * 0.1 }}
            onClick={() => handleRoomSelect(room)}
          >
            <div className="room-image">
              <img src={room.image} alt={room.name} />
              {!room.available && (
                <div className="unavailable-overlay">
                  <span>Indisponible</span>
                </div>
              )}
            </div>

            <div className="room-content">
              <div className="room-header">
                <h3 className="room-name">{room.name}</h3>
                <div className="room-price">{formatPrice(room.hourlyRate)}</div>
              </div>

              <div className="room-location">
                <MapPin className="w-4 h-4" />
                {room.location}
              </div>

              <div className="room-capacity">
                <Users className="w-4 h-4" />
                {room.capacity} personnes
              </div>

              <div className="room-amenities">
                <h4>Équipements :</h4>
                <div className="amenities-list">
                  {room.amenities.map((amenity, idx) => (
                    <span key={idx} className="amenity-badge">
                      {amenity}
                    </span>
                  ))}
                </div>
              </div>

              <div className="room-actions">
                <button 
                  className={`btn ${room.available ? 'btn-primary' : 'btn-disabled'}`}
                  disabled={!room.available}
                >
                  {room.available ? 'Réserver' : 'Indisponible'}
                </button>
              </div>
            </div>
          </motion.div>
        ))}
      </div>

      {/* Modal de réservation */}
      {showBookingModal && selectedRoom && (
        <div className="modal-overlay" onClick={() => setShowBookingModal(false)}>
          <div className="booking-modal" onClick={(e) => e.stopPropagation()}>
            <div className="modal-header">
              <h3>Réserver : {selectedRoom.name}</h3>
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
                  <label htmlFor="booking-name">Nom complet *</label>
                  <input
                    type="text"
                    id="booking-name"
                    value={bookingForm.name}
                    onChange={(e) => setBookingForm({...bookingForm, name: e.target.value})}
                    required
                    className="form-input"
                  />
                </div>
                <div className="form-group">
                  <label htmlFor="booking-email">Email *</label>
                  <input
                    type="email"
                    id="booking-email"
                    value={bookingForm.email}
                    onChange={(e) => setBookingForm({...bookingForm, email: e.target.value})}
                    required
                    className="form-input"
                  />
                </div>
              </div>

              <div className="form-row">
                <div className="form-group">
                  <label htmlFor="booking-phone">Téléphone *</label>
                  <input
                    type="tel"
                    id="booking-phone"
                    value={bookingForm.phone}
                    onChange={(e) => setBookingForm({...bookingForm, phone: e.target.value})}
                    required
                    className="form-input"
                  />
                </div>
                <div className="form-group">
                  <label htmlFor="booking-duration">Durée (heures) *</label>
                  <select
                    id="booking-duration"
                    value={bookingForm.duration}
                    onChange={(e) => setBookingForm({...bookingForm, duration: parseInt(e.target.value)})}
                    className="form-input"
                  >
                    <option value={1}>1 heure</option>
                    <option value={2}>2 heures</option>
                    <option value={3}>3 heures</option>
                    <option value={4}>4 heures</option>
                    <option value={6}>6 heures</option>
                    <option value={8}>8 heures</option>
                  </select>
                </div>
              </div>

              <div className="form-group">
                <label htmlFor="booking-requests">Demandes spéciales</label>
                <textarea
                  id="booking-requests"
                  value={bookingForm.specialRequests}
                  onChange={(e) => setBookingForm({...bookingForm, specialRequests: e.target.value})}
                  className="form-input"
                  rows={3}
                  placeholder="Catering, équipements supplémentaires, etc."
                />
              </div>

              <div className="booking-summary">
                <h4>Résumé de la réservation</h4>
                <div className="summary-line">
                  <span>Salle :</span>
                  <span>{selectedRoom.name}</span>
                </div>
                <div className="summary-line">
                  <span>Date :</span>
                  <span>{selectedDate || 'À définir'}</span>
                </div>
                <div className="summary-line">
                  <span>Heure :</span>
                  <span>{selectedTime || 'À définir'}</span>
                </div>
                <div className="summary-line">
                  <span>Durée :</span>
                  <span>{bookingForm.duration} heure(s)</span>
                </div>
                <div className="summary-line total">
                  <span>Total :</span>
                  <span>{selectedRoom.hourlyRate * bookingForm.duration}€</span>
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

export default ModernRoomBooking;
