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
  User,
  Phone,
  CalendarDays,
  Settings
} from 'lucide-react';
import { bookingService, restaurantService, eventService } from '../services/api';
import { Booking, Event } from '../types/events';
import BookingForm from './BookingForm';
import BookingDetails from './BookingDetails';
import '../styles/modern-theme-system.css';
import '../styles/bookings.css';

const BookingsManager: React.FC = () => {
  const { user } = useAuth();
  const { actualTheme } = useTheme();
  const [bookings, setBookings] = useState<Booking[]>([]);
  const [filteredBookings, setFilteredBookings] = useState<Booking[]>([]);
  const [events, setEvents] = useState<Event[]>([]);
  const [loading, setLoading] = useState(true);
  const [loadingBookings, setLoadingBookings] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [selectedRestaurant, setSelectedRestaurant] = useState<number>(1);
  const [restaurants, setRestaurants] = useState<any[]>([]);
  const [showBookingForm, setShowBookingForm] = useState(false);
  const [showBookingDetails, setShowBookingDetails] = useState(false);
  const [selectedBooking, setSelectedBooking] = useState<Booking | null>(null);
  const [selectedEvent, setSelectedEvent] = useState<Event | null>(null);
  const [statusFilter, setStatusFilter] = useState<string>('');

  // Fonctions de vérification des permissions
  const canManageBookings = () => {
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

  // Charger les réservations quand un restaurant est sélectionné
  useEffect(() => {
    const fetchBookings = async () => {
      if (!selectedRestaurant) return;
      
      try {
        setLoadingBookings(true);
        setError(null);
        const response = await bookingService.getBookingsByRestaurant(selectedRestaurant);
        setBookings(response.data);
        setFilteredBookings(response.data);
        
        // Charger les événements pour avoir les détails
        const eventsRes = await eventService.getByRestaurant(selectedRestaurant);
        setEvents(eventsRes.data);
      } catch (error) {
        console.error('Erreur lors du chargement des réservations:', error);
        setError('Erreur lors du chargement des réservations');
        setBookings([]);
        setFilteredBookings([]);
      } finally {
        setLoadingBookings(false);
        setLoading(false);
      }
    };

    fetchBookings();
  }, [selectedRestaurant]);

  // Appliquer les filtres
  useEffect(() => {
    let filtered = [...bookings];

    if (statusFilter) {
      filtered = filtered.filter(booking => booking.status === statusFilter);
    }

    setFilteredBookings(filtered);
  }, [bookings, statusFilter]);

  const formatDateTime = (dateTime: string) => {
    return new Date(dateTime).toLocaleString('fr-FR', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  const getStatusIcon = (status: string) => {
    switch (status) {
      case 'CONFIRMED':
        return <CheckCircle className="w-4 h-4 text-green-500" />;
      case 'CANCELLED':
        return <XCircle className="w-4 h-4 text-red-500" />;
      case 'PENDING':
        return <AlertCircle className="w-4 h-4 text-yellow-500" />;
      default:
        return <AlertCircle className="w-4 h-4 text-gray-500" />;
    }
  };

  const getStatusBadge = (status: string) => {
    switch (status) {
      case 'CONFIRMED':
        return 'badge-success';
      case 'CANCELLED':
        return 'badge-danger';
      case 'PENDING':
        return 'badge-warning';
      default:
        return 'badge-secondary';
    }
  };

  const getStatusLabel = (status: string) => {
    switch (status) {
      case 'CONFIRMED':
        return 'Confirmée';
      case 'CANCELLED':
        return 'Annulée';
      case 'PENDING':
        return 'En attente';
      default:
        return status;
    }
  };

  const getEventForBooking = (booking: Booking) => {
    return events.find(event => event.id === booking.eventId);
  };

  const handleCreateBooking = () => {
    if (!selectedRestaurant) {
      alert('Veuillez sélectionner un restaurant avant de créer une réservation.');
      return;
    }
    setShowBookingForm(true);
  };

  const handleBookingSuccess = () => {
    // Recharger les réservations
    const fetchBookings = async () => {
      try {
        setLoadingBookings(true);
        setError(null);
        const response = await bookingService.getBookingsByRestaurant(selectedRestaurant);
        setBookings(response.data);
        setFilteredBookings(response.data);
      } catch (error) {
        console.error('Erreur lors du chargement des réservations:', error);
        setError('Erreur lors du rechargement des réservations');
      } finally {
        setLoadingBookings(false);
      }
    };
    fetchBookings();
  };

  const handleUpdateBookingStatus = async (bookingId: number, newStatus: string) => {
    try {
      await bookingService.updateBookingStatus(bookingId, { status: newStatus });
      handleBookingSuccess();
    } catch (error) {
      console.error('Erreur lors de la mise à jour du statut:', error);
      setError('Erreur lors de la mise à jour du statut');
    }
  };

  const handleViewBooking = (booking: Booking) => {
    setSelectedBooking(booking);
    setShowBookingDetails(true);
  };

  const handleDeleteBooking = async (bookingId: number) => {
    if (window.confirm('Êtes-vous sûr de vouloir supprimer cette réservation ?')) {
      try {
        await bookingService.deleteBooking(bookingId);
        handleBookingSuccess();
      } catch (error) {
        console.error('Erreur lors de la suppression de la réservation:', error);
        setError('Erreur lors de la suppression de la réservation');
      }
    }
  };

  if (loading) {
    return (
      <div className="bookings-manager">
        <div className="loading-container">
          <div className="loading-spinner"></div>
          <p>Chargement des restaurants...</p>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="bookings-manager">
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
    <div className="bookings-manager">
      <div className="bookings-header">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <h1 className="page-title">Gestion des Réservations</h1>
          <p className="page-subtitle">
            Gérez les réservations de vos événements
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
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value)}
              className="filter-select"
            >
              <option value="">Tous les statuts</option>
              <option value="PENDING">En attente</option>
              <option value="CONFIRMED">Confirmée</option>
              <option value="CANCELLED">Annulée</option>
            </select>
          </div>
          
          <button 
            className="btn btn-primary btn-sm"
            onClick={handleCreateBooking}
          >
            <Plus className="w-4 h-4" />
            Nouvelle réservation
          </button>
        </div>
      </motion.div>

      <div className="bookings-content">
        {loadingBookings && (
          <div className="loading-bookings">
            <div className="loading-spinner"></div>
            <p>Chargement des réservations...</p>
          </div>
        )}
        
        {!loadingBookings && filteredBookings.length === 0 && (
          <div className="no-bookings">
            <Calendar className="w-12 h-12 text-gray-400" />
            <h3>Aucune réservation trouvée</h3>
            <p>Aucune réservation ne correspond aux critères sélectionnés.</p>
            <button 
              className="btn btn-primary"
              onClick={handleCreateBooking}
            >
              <Plus className="w-4 h-4" />
              Créer la première réservation
            </button>
          </div>
        )}
        
        {!loadingBookings && filteredBookings.map((booking, index) => {
          const event = getEventForBooking(booking);
          return (
            <motion.div
              key={booking.id}
              className="booking-card"
              initial={{ opacity: 0, y: 30 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6, delay: index * 0.1 }}
            >
              <div className="booking-header">
                <h2 className="booking-title">{booking.customerName}</h2>
                <div className="booking-status">
                  <span className={`badge ${getStatusBadge(booking.status)}`}>
                    {getStatusIcon(booking.status)}
                    {getStatusLabel(booking.status)}
                  </span>
                </div>
              </div>

              <div className="booking-info">
                <div className="info-item">
                  <User className="w-4 h-4" />
                  <span>{booking.customerName}</span>
                </div>
                
                {booking.customerPhone && (
                  <div className="info-item">
                    <Phone className="w-4 h-4" />
                    <span>{booking.customerPhone}</span>
                  </div>
                )}
                
                <div className="info-item">
                  <Users className="w-4 h-4" />
                  <span>{booking.pax} personne{booking.pax > 1 ? 's' : ''}</span>
                </div>
                
                {event && (
                  <div className="info-item">
                    <Calendar className="w-4 h-4" />
                    <span>{event.title}</span>
                  </div>
                )}
                
                <div className="info-item">
                  <Clock className="w-4 h-4" />
                  <span>Créée le {formatDateTime(booking.createdAt)}</span>
                </div>
              </div>

              <div className="booking-actions">
                <button 
                  className="btn btn-info btn-sm"
                  onClick={() => handleViewBooking(booking)}
                >
                  <Eye className="w-4 h-4" />
                  Voir
                </button>
                
                {canManageBookings() && booking.status === 'PENDING' && (
                  <button 
                    className="btn btn-success btn-sm"
                    onClick={() => handleUpdateBookingStatus(booking.id, 'CONFIRMED')}
                  >
                    <CheckCircle className="w-4 h-4" />
                    Confirmer
                  </button>
                )}
                
                {canManageBookings() && booking.status === 'CONFIRMED' && (
                  <button 
                    className="btn btn-warning btn-sm"
                    onClick={() => handleUpdateBookingStatus(booking.id, 'PENDING')}
                  >
                    <AlertCircle className="w-4 h-4" />
                    En attente
                  </button>
                )}
                
                {canManageBookings() && booking.status !== 'CANCELLED' && (
                  <button 
                    className="btn btn-danger btn-sm"
                    onClick={() => handleUpdateBookingStatus(booking.id, 'CANCELLED')}
                  >
                    <XCircle className="w-4 h-4" />
                    Annuler
                  </button>
                )}
                
                {canManageBookings() && (
                  <button 
                    className="btn btn-danger btn-sm"
                    onClick={() => handleDeleteBooking(booking.id)}
                  >
                    <Trash2 className="w-4 h-4" />
                    Supprimer
                  </button>
                )}
              </div>
            </motion.div>
          );
        })}
      </div>

      {/* Formulaires */}
      <BookingForm
        isOpen={showBookingForm}
        onClose={() => {
          setShowBookingForm(false);
          setSelectedEvent(null);
        }}
        onSuccess={handleBookingSuccess}
        event={selectedEvent}
        restaurantId={selectedRestaurant}
        events={events}
      />

      <BookingDetails
        booking={selectedBooking}
        isOpen={showBookingDetails}
        onClose={() => {
          setShowBookingDetails(false);
          setSelectedBooking(null);
        }}
        event={selectedBooking ? getEventForBooking(selectedBooking) : null}
        canManage={canManageBookings()}
        onUpdateStatus={handleUpdateBookingStatus}
        onDelete={handleDeleteBooking}
      />
    </div>
  );
};

export default BookingsManager;
