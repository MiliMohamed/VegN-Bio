import React from 'react';
import { motion } from 'framer-motion';
import { X, User, Phone, Users, Calendar, Clock, CheckCircle, XCircle, AlertCircle, Trash2 } from 'lucide-react';
import { Booking, Event } from '../types/events';
import '../styles/modern-theme-system.css';
import '../styles/booking-details.css';

interface BookingDetailsProps {
  booking: Booking | null;
  isOpen: boolean;
  onClose: () => void;
  event: Event | null;
  canManage: boolean;
  onUpdateStatus: (bookingId: number, status: string) => void;
  onDelete: (bookingId: number) => void;
}

const BookingDetails: React.FC<BookingDetailsProps> = ({
  booking,
  isOpen,
  onClose,
  event,
  canManage,
  onUpdateStatus,
  onDelete
}) => {
  if (!isOpen || !booking) return null;

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
        return <CheckCircle className="w-5 h-5 text-green-500" />;
      case 'CANCELLED':
        return <XCircle className="w-5 h-5 text-red-500" />;
      case 'PENDING':
        return <AlertCircle className="w-5 h-5 text-yellow-500" />;
      default:
        return <AlertCircle className="w-5 h-5 text-gray-500" />;
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

  return (
    <div className="modal-overlay">
      <motion.div
        className="modal-content booking-details-modal"
        initial={{ opacity: 0, scale: 0.9 }}
        animate={{ opacity: 1, scale: 1 }}
        exit={{ opacity: 0, scale: 0.9 }}
        transition={{ duration: 0.3 }}
      >
        <div className="modal-header">
          <h2 className="modal-title">Réservation #{booking.id}</h2>
          <button 
            className="btn btn-ghost btn-sm"
            onClick={onClose}
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        <div className="booking-details-content">
          <div className="booking-status">
            <span className={`badge ${getStatusBadge(booking.status)}`}>
              {getStatusIcon(booking.status)}
              {getStatusLabel(booking.status)}
            </span>
          </div>

          <div className="booking-info-grid">
            <div className="info-item">
              <User className="w-5 h-5" />
              <div className="info-content">
                <span className="info-label">Client</span>
                <span className="info-value">{booking.customerName}</span>
              </div>
            </div>

            {booking.customerPhone && (
              <div className="info-item">
                <Phone className="w-5 h-5" />
                <div className="info-content">
                  <span className="info-label">Téléphone</span>
                  <span className="info-value">{booking.customerPhone}</span>
                </div>
              </div>
            )}

            <div className="info-item">
              <Users className="w-5 h-5" />
              <div className="info-content">
                <span className="info-label">Nombre de personnes</span>
                <span className="info-value">{booking.pax} personne{booking.pax > 1 ? 's' : ''}</span>
              </div>
            </div>

            <div className="info-item">
              <Clock className="w-5 h-5" />
              <div className="info-content">
                <span className="info-label">Date de réservation</span>
                <span className="info-value">{formatDateTime(booking.createdAt)}</span>
              </div>
            </div>
          </div>

          {event && (
            <div className="event-info-card">
              <h3 className="event-info-title">
                <Calendar className="w-4 h-4" />
                Événement réservé
              </h3>
              <div className="event-info-details">
                <div className="event-title">{event.title}</div>
                <div className="event-datetime">{formatDateTime(event.dateStart)}</div>
                {event.type && (
                  <div className="event-type">Type: {event.type}</div>
                )}
                {event.description && (
                  <div className="event-description">{event.description}</div>
                )}
              </div>
            </div>
          )}

          {canManage && (
            <div className="booking-actions">
              <h3 className="actions-title">Actions</h3>
              <div className="actions-buttons">
                {booking.status === 'PENDING' && (
                  <button 
                    className="btn btn-success"
                    onClick={() => onUpdateStatus(booking.id, 'CONFIRMED')}
                  >
                    <CheckCircle className="w-4 h-4" />
                    Confirmer
                  </button>
                )}
                
                {booking.status === 'CONFIRMED' && (
                  <button 
                    className="btn btn-warning"
                    onClick={() => onUpdateStatus(booking.id, 'PENDING')}
                  >
                    <AlertCircle className="w-4 h-4" />
                    Mettre en attente
                  </button>
                )}
                
                {booking.status !== 'CANCELLED' && (
                  <button 
                    className="btn btn-danger"
                    onClick={() => onUpdateStatus(booking.id, 'CANCELLED')}
                  >
                    <XCircle className="w-4 h-4" />
                    Annuler
                  </button>
                )}
                
                <button 
                  className="btn btn-danger"
                  onClick={() => onDelete(booking.id)}
                >
                  <Trash2 className="w-4 h-4" />
                  Supprimer
                </button>
              </div>
            </div>
          )}
        </div>
      </motion.div>
    </div>
  );
};

export default BookingDetails;
