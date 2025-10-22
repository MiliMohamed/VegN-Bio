import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { useAuth } from '../contexts/AuthContext';
import { usePersonalBookings } from '../contexts/PersonalBookingsContext';
import { 
  Calendar,
  Clock,
  Users,
  MapPin,
  AlertCircle,
  CheckCircle,
  XCircle,
  Eye,
  Trash2,
  RefreshCw,
  CalendarDays,
  UserPlus
} from 'lucide-react';
import { Booking, Event } from '../types/events';
import BookingDetails from './BookingDetails';
import '../styles/modern-theme-system.css';
import '../styles/personal-bookings.css';

const PersonalBookings: React.FC = () => {
  const { user } = useAuth();
  const { bookings, loading, error, refreshBookings, removeBooking } = usePersonalBookings();
  const [selectedBooking, setSelectedBooking] = useState<Booking | null>(null);
  const [showBookingDetails, setShowBookingDetails] = useState(false);
  const [statusFilter, setStatusFilter] = useState<string>('');

  useEffect(() => {
    refreshBookings();
  }, []);

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

  const filteredBookings = bookings.filter(booking => 
    !statusFilter || booking.status === statusFilter
  );

  const handleViewBooking = (booking: Booking) => {
    setSelectedBooking(booking);
    setShowBookingDetails(true);
  };

  const handleDeleteBooking = async (bookingId: number) => {
    if (window.confirm('Êtes-vous sûr de vouloir supprimer cette réservation ?')) {
      removeBooking(bookingId);
    }
  };

  if (loading) {
    return (
      <div className="personal-bookings">
        <div className="loading-container">
          <div className="loading-spinner"></div>
          <p>Chargement de vos réservations...</p>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="personal-bookings">
        <div className="error-container">
          <AlertCircle className="w-8 h-8 text-red-500" />
          <h2>Erreur de chargement</h2>
          <p>{error}</p>
          <button 
            className="btn btn-primary"
            onClick={refreshBookings}
          >
            <RefreshCw className="w-4 h-4" />
            Réessayer
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="personal-bookings">
      <div className="bookings-header">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <h1 className="page-title">Mes Réservations</h1>
          <p className="page-subtitle">
            Gérez vos réservations d'événements
          </p>
        </motion.div>
      </div>

      {/* Filtres et actions */}
      <motion.div 
        className="bookings-controls"
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.2 }}
      >
        <div className="controls-container">
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
          
          <div className="actions-container">
            <button 
              className="btn btn-secondary btn-sm"
              onClick={refreshBookings}
            >
              <RefreshCw className="w-4 h-4" />
              Actualiser
            </button>
          </div>
        </div>
      </motion.div>

      <div className="bookings-content">
        {filteredBookings.length === 0 && (
          <div className="no-bookings">
            <Calendar className="w-12 h-12 text-gray-400" />
            <h3>Aucune réservation trouvée</h3>
            <p>
              {statusFilter 
                ? `Aucune réservation avec le statut "${getStatusLabel(statusFilter)}"` 
                : "Vous n'avez pas encore de réservations."
              }
            </p>
            <div className="no-bookings-actions">
              <a href="/app/events-manager" className="btn btn-primary">
                <CalendarDays className="w-4 h-4" />
                Voir les événements
              </a>
            </div>
          </div>
        )}
        
        {filteredBookings.map((booking, index) => (
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
                <Users className="w-4 h-4" />
                <span>{booking.pax} personne{booking.pax > 1 ? 's' : ''}</span>
              </div>
              
              {booking.customerPhone && (
                <div className="info-item">
                  <span>Tél: {booking.customerPhone}</span>
                </div>
              )}
              
              <div className="info-item">
                <Clock className="w-4 h-4" />
                <span>Réservée le {formatDateTime(booking.createdAt)}</span>
              </div>
              
              {booking.event && (
                <div className="info-item">
                  <Calendar className="w-4 h-4" />
                  <span>{booking.event.title}</span>
                </div>
              )}
            </div>

            <div className="booking-actions">
              <button 
                className="btn btn-info btn-sm"
                onClick={() => handleViewBooking(booking)}
              >
                <Eye className="w-4 h-4" />
                Voir détails
              </button>
              
              <button 
                className="btn btn-danger btn-sm"
                onClick={() => handleDeleteBooking(booking.id)}
              >
                <Trash2 className="w-4 h-4" />
                Supprimer
              </button>
            </div>
          </motion.div>
        ))}
      </div>

      {/* Modal de détails */}
      <BookingDetails
        booking={selectedBooking}
        isOpen={showBookingDetails}
        onClose={() => {
          setShowBookingDetails(false);
          setSelectedBooking(null);
        }}
        event={selectedBooking ? (selectedBooking as any).event : null}
        canManage={false}
        onUpdateStatus={() => {}}
        onDelete={() => {}}
      />
    </div>
  );
};

export default PersonalBookings;
