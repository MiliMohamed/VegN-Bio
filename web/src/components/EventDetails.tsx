import React from 'react';
import { motion } from 'framer-motion';
import { X, Calendar, Clock, Users, Settings, FileText, UserPlus, Edit, Trash2, XCircle } from 'lucide-react';
import { Event } from '../types/events';
import '../styles/modern-theme-system.css';
import '../styles/event-details.css';

interface EventDetailsProps {
  event: Event | null;
  isOpen: boolean;
  onClose: () => void;
  onBookEvent: (event: Event) => void;
  canEdit: boolean;
  canDelete: boolean;
  onEditEvent: (event: Event) => void;
  onDeleteEvent: (id: number) => void;
  onCancelEvent: (id: number) => void;
}

const EventDetails: React.FC<EventDetailsProps> = ({
  event,
  isOpen,
  onClose,
  onBookEvent,
  canEdit,
  canDelete,
  onEditEvent,
  onDeleteEvent,
  onCancelEvent
}) => {
  if (!isOpen || !event) return null;

  const formatDateTime = (dateTime: string) => {
    return new Date(dateTime).toLocaleString('fr-FR', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
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

  const getStatusLabel = (status: string) => {
    switch (status) {
      case 'ACTIVE':
        return 'Actif';
      case 'CANCELLED':
        return 'Annulé';
      default:
        return status;
    }
  };

  return (
    <div className="modal-overlay">
      <motion.div
        className="modal-content event-details-modal"
        initial={{ opacity: 0, scale: 0.9 }}
        animate={{ opacity: 1, scale: 1 }}
        exit={{ opacity: 0, scale: 0.9 }}
        transition={{ duration: 0.3 }}
      >
        <div className="modal-header">
          <h2 className="modal-title">{event.title}</h2>
          <button 
            className="btn btn-ghost btn-sm"
            onClick={onClose}
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        <div className="event-details-content">
          <div className="event-status">
            <span className={`badge ${getStatusBadge(event.status)}`}>
              {getStatusLabel(event.status)}
            </span>
          </div>

          <div className="event-info-grid">
            <div className="info-item">
              <Calendar className="w-5 h-5" />
              <div className="info-content">
                <span className="info-label">Date de début</span>
                <span className="info-value">{formatDateTime(event.dateStart)}</span>
              </div>
            </div>

            {event.dateEnd && (
              <div className="info-item">
                <Clock className="w-5 h-5" />
                <div className="info-content">
                  <span className="info-label">Date de fin</span>
                  <span className="info-value">{formatDateTime(event.dateEnd)}</span>
                </div>
              </div>
            )}

            {event.capacity && (
              <div className="info-item">
                <Users className="w-5 h-5" />
                <div className="info-content">
                  <span className="info-label">Capacité</span>
                  <span className="info-value">
                    {event.availableSpots || 0} / {event.capacity} places
                  </span>
                </div>
              </div>
            )}

            {event.type && (
              <div className="info-item">
                <Settings className="w-5 h-5" />
                <div className="info-content">
                  <span className="info-label">Type</span>
                  <span className="info-value">{event.type}</span>
                </div>
              </div>
            )}
          </div>

          {event.description && (
            <div className="event-description">
              <h3 className="description-title">
                <FileText className="w-4 h-4" />
                Description
              </h3>
              <p className="description-text">{event.description}</p>
            </div>
          )}

          <div className="event-actions">
            {event.status === 'ACTIVE' && (
              <button 
                className="btn btn-success"
                onClick={() => onBookEvent(event)}
              >
                <UserPlus className="w-4 h-4" />
                Réserver
              </button>
            )}
            
            {canEdit && (
              <button 
                className="btn btn-secondary"
                onClick={() => onEditEvent(event)}
              >
                <Edit className="w-4 h-4" />
                Modifier
              </button>
            )}
            
            {canDelete && (
              <>
                {event.status === 'ACTIVE' && (
                  <button 
                    className="btn btn-warning"
                    onClick={() => onCancelEvent(event.id)}
                  >
                    <XCircle className="w-4 h-4" />
                    Annuler
                  </button>
                )}
                
                <button 
                  className="btn btn-danger"
                  onClick={() => onDeleteEvent(event.id)}
                >
                  <Trash2 className="w-4 h-4" />
                  Supprimer
                </button>
              </>
            )}
          </div>
        </div>
      </motion.div>
    </div>
  );
};

export default EventDetails;
