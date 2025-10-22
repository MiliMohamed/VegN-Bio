import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { useAuth } from '../contexts/AuthContext';
import { useTheme } from '../contexts/ThemeContext';
import { 
  Calendar,
  Plus,
  Edit,
  Trash2,
  Eye,
  Clock,
  Users,
  MapPin,
  Filter,
  Search,
  AlertCircle,
  CheckCircle,
  XCircle,
  CalendarDays,
  UserPlus,
  Settings
} from 'lucide-react';
import { eventService, restaurantService } from '../services/api';
import { Event, EventFilters } from '../types/events';
import EventForm from './EventForm';
import EventDetails from './EventDetails';
import BookingForm from './BookingForm';
import '../styles/modern-theme-system.css';
import '../styles/events.css';

const EventsManager: React.FC = () => {
  const { user } = useAuth();
  const { actualTheme } = useTheme();
  const [events, setEvents] = useState<Event[]>([]);
  const [filteredEvents, setFilteredEvents] = useState<Event[]>([]);
  const [loading, setLoading] = useState(true);
  const [loadingEvents, setLoadingEvents] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [selectedRestaurant, setSelectedRestaurant] = useState<number>(1);
  const [restaurants, setRestaurants] = useState<any[]>([]);
  const [showEventForm, setShowEventForm] = useState(false);
  const [showBookingForm, setShowBookingForm] = useState(false);
  const [selectedEvent, setSelectedEvent] = useState<Event | null>(null);
  const [showEventDetails, setShowEventDetails] = useState(false);
  const [filters, setFilters] = useState<EventFilters>({});

  // Fonctions de vérification des permissions
  const canCreateEvent = () => {
    return user?.role === 'ADMIN' || user?.role === 'RESTAURATEUR';
  };

  const canEditEvent = () => {
    return user?.role === 'ADMIN' || user?.role === 'RESTAURATEUR';
  };

  const canDeleteEvent = () => {
    return user?.role === 'ADMIN' || user?.role === 'RESTAURATEUR';
  };

  // Charger les restaurants au montage du composant
  useEffect(() => {
    const fetchRestaurants = async () => {
      try {
        setError(null);
        const restaurantsRes = await restaurantService.getAll();
        setRestaurants(restaurantsRes.data);
        
        if (restaurantsRes.data.length > 0) {
          setSelectedRestaurant(restaurantsRes.data[0].id);
        }
      } catch (error) {
        console.error('Erreur lors du chargement des restaurants:', error);
        setError('Erreur lors du chargement des restaurants');
        setLoading(false);
      }
    };

    fetchRestaurants();
  }, []);

  // Charger les événements quand un restaurant est sélectionné
  useEffect(() => {
    const fetchEvents = async () => {
      if (!selectedRestaurant) return;
      
      try {
        setLoadingEvents(true);
        setError(null);
        const response = await eventService.getByRestaurant(selectedRestaurant);
        setEvents(response.data);
        setFilteredEvents(response.data);
      } catch (error) {
        console.error('Erreur lors du chargement des événements:', error);
        setError('Erreur lors du chargement des événements');
        setEvents([]);
        setFilteredEvents([]);
      } finally {
        setLoadingEvents(false);
        setLoading(false);
      }
    };

    fetchEvents();
  }, [selectedRestaurant]);

  // Appliquer les filtres
  useEffect(() => {
    let filtered = [...events];

    if (filters.status) {
      filtered = filtered.filter(event => event.status === filters.status);
    }

    if (filters.from) {
      filtered = filtered.filter(event => new Date(event.dateStart) >= new Date(filters.from!));
    }

    if (filters.to) {
      filtered = filtered.filter(event => new Date(event.dateStart) <= new Date(filters.to!));
    }

    setFilteredEvents(filtered);
  }, [events, filters]);

  const formatDateTime = (dateTime: string) => {
    return new Date(dateTime).toLocaleString('fr-FR', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  const formatDate = (dateTime: string) => {
    return new Date(dateTime).toLocaleDateString('fr-FR');
  };

  const getStatusIcon = (status: string) => {
    switch (status) {
      case 'ACTIVE':
        return <CheckCircle className="w-4 h-4 text-green-500" />;
      case 'CANCELLED':
        return <XCircle className="w-4 h-4 text-red-500" />;
      default:
        return <AlertCircle className="w-4 h-4 text-yellow-500" />;
    }
  };

  const getStatusBadge = (status: string) => {
    switch (status) {
      case 'ACTIVE':
        return 'badge-success';
      case 'CANCELLED':
        return 'badge-danger';
      default:
        return 'badge-warning';
    }
  };

  const handleCreateEvent = () => {
    if (!selectedRestaurant) {
      alert('Veuillez sélectionner un restaurant avant de créer un événement.');
      return;
    }
    setShowEventForm(true);
  };

  const handleEventSuccess = () => {
    // Recharger les événements
    const fetchEvents = async () => {
      try {
        setLoadingEvents(true);
        setError(null);
        const response = await eventService.getByRestaurant(selectedRestaurant);
        setEvents(response.data);
        setFilteredEvents(response.data);
      } catch (error) {
        console.error('Erreur lors du chargement des événements:', error);
        setError('Erreur lors du rechargement des événements');
      } finally {
        setLoadingEvents(false);
      }
    };
    fetchEvents();
  };

  const handleEditEvent = (event: Event) => {
    setSelectedEvent(event);
    setShowEventForm(true);
  };

  const handleDeleteEvent = async (eventId: number) => {
    if (window.confirm('Êtes-vous sûr de vouloir supprimer cet événement ?')) {
      try {
        await eventService.delete(eventId);
        handleEventSuccess();
      } catch (error) {
        console.error('Erreur lors de la suppression de l\'événement:', error);
        setError('Erreur lors de la suppression de l\'événement');
      }
    }
  };

  const handleCancelEvent = async (eventId: number) => {
    if (window.confirm('Êtes-vous sûr de vouloir annuler cet événement ?')) {
      try {
        await eventService.cancel(eventId);
        handleEventSuccess();
      } catch (error) {
        console.error('Erreur lors de l\'annulation de l\'événement:', error);
        setError('Erreur lors de l\'annulation de l\'événement');
      }
    }
  };

  const handleViewEvent = (event: Event) => {
    setSelectedEvent(event);
    setShowEventDetails(true);
  };

  const handleBookEvent = (event: Event) => {
    setSelectedEvent(event);
    setShowBookingForm(true);
  };

  const handleBookingSuccess = () => {
    // Recharger les événements pour mettre à jour les places disponibles
    handleEventSuccess();
  };

  if (loading) {
    return (
      <div className="events-manager">
        <div className="loading-container">
          <div className="loading-spinner"></div>
          <p>Chargement des restaurants...</p>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="events-manager">
        <div className="error-container">
          <AlertCircle className="w-8 h-8 text-red-500" />
          <h2>Erreur de chargement</h2>
          <p>{error}</p>
          <button 
            className="btn btn-primary"
            onClick={() => window.location.reload()}
          >
            Recharger la page
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="events-manager">
      <div className="events-header">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <h1 className="page-title">Gestion des Événements</h1>
          <p className="page-subtitle">
            Organisez et gérez vos événements et réservations
          </p>
        </motion.div>
      </div>

      {/* Sélecteur de restaurant et filtres */}
      <motion.div 
        className="restaurant-selector"
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.2 }}
      >
        <div className="selector-container">
          <label htmlFor="restaurant-select" className="selector-label">
            <MapPin className="w-4 h-4" />
            Restaurant :
          </label>
          <select
            id="restaurant-select"
            value={selectedRestaurant}
            onChange={(e) => setSelectedRestaurant(Number(e.target.value))}
            className="selector-input"
          >
            {restaurants.map(restaurant => (
              <option key={restaurant.id} value={restaurant.id}>
                {restaurant.name} ({restaurant.code})
              </option>
            ))}
          </select>
        </div>
        
        <div className="selector-actions">
          {/* Filtres */}
          <div className="filters-container">
            <select
              value={filters.status || ''}
              onChange={(e) => setFilters({...filters, status: e.target.value as any || undefined})}
              className="filter-select"
            >
              <option value="">Tous les statuts</option>
              <option value="ACTIVE">Actif</option>
              <option value="CANCELLED">Annulé</option>
            </select>
            
            <input
              type="date"
              value={filters.from || ''}
              onChange={(e) => setFilters({...filters, from: e.target.value || undefined})}
              className="filter-input"
              placeholder="Date de début"
            />
            
            <input
              type="date"
              value={filters.to || ''}
              onChange={(e) => setFilters({...filters, to: e.target.value || undefined})}
              className="filter-input"
              placeholder="Date de fin"
            />
          </div>
          
          {canCreateEvent() && (
            <button 
              className="btn btn-primary btn-sm"
              onClick={handleCreateEvent}
            >
              <Plus className="w-4 h-4" />
              Nouvel événement
            </button>
          )}
        </div>
      </motion.div>

      <div className="events-content">
        {loadingEvents && (
          <div className="loading-events">
            <div className="loading-spinner"></div>
            <p>Chargement des événements...</p>
          </div>
        )}
        
        {!loadingEvents && filteredEvents.length === 0 && (
          <div className="no-events">
            <Calendar className="w-12 h-12 text-gray-400" />
            <h3>Aucun événement trouvé</h3>
            <p>Aucun événement ne correspond aux critères sélectionnés.</p>
            {canCreateEvent() && (
              <button 
                className="btn btn-primary"
                onClick={handleCreateEvent}
              >
                <Plus className="w-4 h-4" />
                Créer le premier événement
              </button>
            )}
          </div>
        )}
        
        {!loadingEvents && filteredEvents.map((event, index) => (
          <motion.div
            key={event.id}
            className="event-card"
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: index * 0.1 }}
          >
            <div className="event-header">
              <h2 className="event-title">{event.title}</h2>
              <div className="event-status">
                <span className={`badge ${getStatusBadge(event.status)}`}>
                  {getStatusIcon(event.status)}
                  {event.status === 'ACTIVE' ? 'Actif' : 'Annulé'}
                </span>
              </div>
            </div>

            <div className="event-info">
              <div className="info-item">
                <Calendar className="w-4 h-4" />
                <span>{formatDateTime(event.dateStart)}</span>
              </div>
              
              {event.dateEnd && (
                <div className="info-item">
                  <Clock className="w-4 h-4" />
                  <span>Fin: {formatDateTime(event.dateEnd)}</span>
                </div>
              )}
              
              {event.capacity && (
                <div className="info-item">
                  <Users className="w-4 h-4" />
                  <span>
                    Capacité: {event.availableSpots || 0} / {event.capacity} places
                  </span>
                </div>
              )}
              
              {event.type && (
                <div className="info-item">
                  <Settings className="w-4 h-4" />
                  <span>Type: {event.type}</span>
                </div>
              )}
            </div>

            {event.description && (
              <div className="event-description">
                <p>{event.description}</p>
              </div>
            )}

            <div className="event-actions">
              <button 
                className="btn btn-info btn-sm"
                onClick={() => handleViewEvent(event)}
              >
                <Eye className="w-4 h-4" />
                Voir
              </button>
              
              {event.status === 'ACTIVE' && (
                <button 
                  className="btn btn-success btn-sm"
                  onClick={() => handleBookEvent(event)}
                >
                  <UserPlus className="w-4 h-4" />
                  Réserver
                </button>
              )}
              
              {canEditEvent() && (
                <button 
                  className="btn btn-secondary btn-sm"
                  onClick={() => handleEditEvent(event)}
                >
                  <Edit className="w-4 h-4" />
                  Modifier
                </button>
              )}
              
              {canDeleteEvent() && (
                <>
                  {event.status === 'ACTIVE' && (
                    <button 
                      className="btn btn-warning btn-sm"
                      onClick={() => handleCancelEvent(event.id)}
                    >
                      <XCircle className="w-4 h-4" />
                      Annuler
                    </button>
                  )}
                  
                  <button 
                    className="btn btn-danger btn-sm"
                    onClick={() => handleDeleteEvent(event.id)}
                  >
                    <Trash2 className="w-4 h-4" />
                    Supprimer
                  </button>
                </>
              )}
            </div>
          </motion.div>
        ))}
      </div>

      {/* Formulaires */}
      <EventForm
        isOpen={showEventForm}
        onClose={() => {
          setShowEventForm(false);
          setSelectedEvent(null);
        }}
        onSuccess={handleEventSuccess}
        event={selectedEvent}
        restaurantId={selectedRestaurant}
        restaurantName={restaurants.find(r => r.id === selectedRestaurant)?.name}
      />

      <BookingForm
        isOpen={showBookingForm}
        onClose={() => {
          setShowBookingForm(false);
          setSelectedEvent(null);
        }}
        onSuccess={handleBookingSuccess}
        event={selectedEvent}
        restaurantId={selectedRestaurant}
        events={[]}
      />

      <EventDetails
        event={selectedEvent}
        isOpen={showEventDetails}
        onClose={() => {
          setShowEventDetails(false);
          setSelectedEvent(null);
        }}
        onBookEvent={handleBookEvent}
        canEdit={canEditEvent()}
        canDelete={canDeleteEvent()}
        onEditEvent={handleEditEvent}
        onDeleteEvent={handleDeleteEvent}
        onCancelEvent={handleCancelEvent}
      />
    </div>
  );
};

export default EventsManager;
