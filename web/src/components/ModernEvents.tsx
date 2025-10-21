import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { 
  Calendar, 
  Clock, 
  Users, 
  MapPin,
  Plus,
  Edit,
  Trash2,
  Eye,
  CheckCircle,
  XCircle
} from 'lucide-react';
import { eventService } from '../services/api';
import EventForm from './EventForm';
import BookingForm from './BookingForm';

interface Event {
  id: number;
  title: string;
  type: string;
  dateStart: string;
  dateEnd: string;
  capacity: number;
  description: string;
  restaurantId: number;
}

const ModernEvents: React.FC = () => {
  const [events, setEvents] = React.useState<Event[]>([]);
  const [loading, setLoading] = React.useState(true);
  const [showEventForm, setShowEventForm] = useState(false);
  const [showBookingForm, setShowBookingForm] = useState(false);
  const [selectedEvent, setSelectedEvent] = useState<Event | null>(null);

  React.useEffect(() => {
    const fetchEvents = async () => {
      try {
        const response = await eventService.getAll();
        setEvents(response.data);
      } catch (error) {
        console.error('Erreur lors du chargement des événements:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchEvents();
  }, []);

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('fr-FR', {
      weekday: 'long',
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  const getEventTypeColor = (type: string) => {
    const colors: { [key: string]: string } = {
      'ÉVÉNEMENT': 'primary',
      'ATELIER': 'success',
      'CONFÉRENCE': 'info',
      'DÉGUSTATION': 'warning',
      'ANIMATION': 'secondary'
    };
    return colors[type] || 'primary';
  };

  const getRestaurantName = (restaurantId: number) => {
    const names: { [key: number]: string } = {
      1: 'Bastille',
      2: 'République',
      3: 'Nation',
      4: 'Place d\'Italie',
      5: 'Beaubourg'
    };
    return names[restaurantId] || 'Restaurant';
  };

  const handleCreateEvent = () => {
    setShowEventForm(true);
  };

  const handleEventSuccess = () => {
    // Recharger les événements
    const fetchEvents = async () => {
      try {
        const response = await eventService.getAll();
        setEvents(response.data);
      } catch (error) {
        console.error('Erreur lors du chargement des événements:', error);
      }
    };
    fetchEvents();
  };

  const handleBookEvent = (event: Event) => {
    setSelectedEvent(event);
    setShowBookingForm(true);
  };

  const handleBookingSuccess = () => {
    // Optionnel: recharger les données ou afficher un message de succès
  };

  if (loading) {
    return (
      <div className="modern-events">
        <div className="loading-container">
          <div className="loading-spinner"></div>
          <p>Chargement des événements...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="modern-events">
      <div className="events-header">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <h1 className="page-title">Événements & Animations</h1>
          <p className="page-subtitle">
            Découvrez nos événements, conférences et animations dans tous nos restaurants
          </p>
        </motion.div>
      </div>

      <div className="events-actions">
        <motion.button
          className="btn btn-primary"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.2 }}
          onClick={handleCreateEvent}
        >
          <Plus className="w-5 h-5" />
          Créer un événement
        </motion.button>
      </div>

      <div className="events-grid">
        {events.map((event, index) => (
          <motion.div
            key={event.id}
            className="event-card"
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: index * 0.1 }}
            whileHover={{ y: -5 }}
          >
            <div className="event-header">
              <div className="event-type">
                <span className={`badge badge-${getEventTypeColor(event.type)}`}>
                  {event.type}
                </span>
              </div>
              <h3 className="event-title">{event.title}</h3>
              <div className="event-location">
                <MapPin className="w-4 h-4" />
                <span>VegN Bio {getRestaurantName(event.restaurantId)}</span>
              </div>
            </div>

            <div className="event-details">
              <div className="detail-item">
                <Calendar className="w-4 h-4" />
                <div className="detail-content">
                  <div className="detail-label">Date de début</div>
                  <div className="detail-value">{formatDate(event.dateStart)}</div>
                </div>
              </div>
              
              {event.dateEnd && (
                <div className="detail-item">
                  <Clock className="w-4 h-4" />
                  <div className="detail-content">
                    <div className="detail-label">Date de fin</div>
                    <div className="detail-value">{formatDate(event.dateEnd)}</div>
                  </div>
                </div>
              )}

              {event.capacity && (
                <div className="detail-item">
                  <Users className="w-4 h-4" />
                  <div className="detail-content">
                    <div className="detail-label">Capacité</div>
                    <div className="detail-value">{event.capacity} personnes</div>
                  </div>
                </div>
              )}
            </div>

            <div className="event-description">
              <p>{event.description}</p>
            </div>

            <div className="event-actions">
              <button 
                className="btn btn-primary btn-sm"
                onClick={() => handleBookEvent(event)}
              >
                <Calendar className="w-4 h-4" />
                Réserver
              </button>
              <button className="btn btn-secondary btn-sm">
                <Eye className="w-4 h-4" />
                Voir détails
              </button>
              <button className="btn btn-secondary btn-sm">
                <Edit className="w-4 h-4" />
                Modifier
              </button>
            </div>
          </motion.div>
        ))}
      </div>

      {events.length === 0 && (
        <motion.div
          className="empty-state"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <Calendar className="w-16 h-16" />
          <h3>Aucun événement</h3>
          <p>Créez votre premier événement pour commencer</p>
          <button className="btn btn-primary" onClick={handleCreateEvent}>
            <Plus className="w-5 h-5" />
            Créer un événement
          </button>
        </motion.div>
      )}

      {/* Formulaires */}
      <EventForm
        isOpen={showEventForm}
        onClose={() => setShowEventForm(false)}
        onSuccess={handleEventSuccess}
      />

      {selectedEvent && (
        <BookingForm
          isOpen={showBookingForm}
          onClose={() => setShowBookingForm(false)}
          onSuccess={handleBookingSuccess}
          eventId={selectedEvent.id}
          eventTitle={selectedEvent.title}
        />
      )}
    </div>
  );
};

export default ModernEvents;