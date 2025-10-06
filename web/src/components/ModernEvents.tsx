import React, { useState, useEffect } from 'react';
import { eventService } from '../services/api';
import { useRestaurants } from '../hooks/useRestaurants';

interface Event {
  id: number;
  restaurantId: number;
  title: string;
  type: string;
  dateStart: string;
  dateEnd: string;
  capacity: number;
  description: string;
  status: string;
  availableSpots: number;
}

interface CreateEventData {
  restaurantId: number;
  title: string;
  description: string;
  dateStart: string;
  dateEnd: string;
  capacity: number;
  type: string;
}

const ModernEvents: React.FC = () => {
  const [events, setEvents] = useState<Event[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [showCreateForm, setShowCreateForm] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  const [filterType, setFilterType] = useState('');
  const [filterStatus, setFilterStatus] = useState('');
  const [newEvent, setNewEvent] = useState<CreateEventData>({
    restaurantId: 1,
    title: '',
    description: '',
    dateStart: '',
    dateEnd: '',
    capacity: 0,
    type: 'WORKSHOP'
  });

  const { restaurants, getRestaurantName } = useRestaurants();

  const userRole = localStorage.getItem('userRole');
  const canCreateEvents = userRole === 'RESTAURATEUR' || userRole === 'ADMIN';

  useEffect(() => {
    fetchEvents();
  }, []);

  const fetchEvents = async () => {
    try {
      setLoading(true);
      const response = await eventService.getAll();
      setEvents(response.data);
    } catch (err: any) {
      setError('Erreur lors du chargement des événements');
      console.error('Error fetching events:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleCreateEvent = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const response = await eventService.create(newEvent);
      setEvents([...events, response.data]);
      setNewEvent({
        restaurantId: 1,
        title: '',
        description: '',
        dateStart: '',
        dateEnd: '',
        capacity: 0,
        type: 'WORKSHOP'
      });
      setShowCreateForm(false);
      alert('Événement créé avec succès');
    } catch (err: any) {
      console.error('Erreur lors de la création:', err);
      alert('Erreur lors de la création de l\'événement');
    }
  };

  const handleCancelEvent = async (eventId: number) => {
    if (!window.confirm('Êtes-vous sûr de vouloir annuler cet événement ?')) {
      return;
    }

    try {
      await eventService.cancel(eventId);
      setEvents(events.filter(event => event.id !== eventId));
      alert('Événement annulé avec succès');
    } catch (err: any) {
      console.error('Erreur lors de l\'annulation:', err);
      alert('Erreur lors de l\'annulation de l\'événement');
    }
  };

  const filteredEvents = events.filter(event => {
    const matchesSearch = event.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         event.description.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         getRestaurantName(event.restaurantId).toLowerCase().includes(searchTerm.toLowerCase());
    const matchesType = !filterType || event.type === filterType;
    const matchesStatus = !filterStatus || event.status === filterStatus;
    return matchesSearch && matchesType && matchesStatus;
  });

  const getEventTypeIcon = (type: string) => {
    switch (type) {
      case 'WORKSHOP': return '🎨';
      case 'CONFERENCE': return '🎤';
      case 'TASTING': return '🍽️';
      case 'MARKET': return '🛒';
      default: return '📅';
    }
  };

  const getEventTypeColor = (type: string) => {
    switch (type) {
      case 'WORKSHOP': return '#e74c3c';
      case 'CONFERENCE': return '#3498db';
      case 'TASTING': return '#f39c12';
      case 'MARKET': return '#27ae60';
      default: return '#95a5a6';
    }
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'ACTIVE': return '#27ae60';
      case 'CANCELLED': return '#e74c3c';
      case 'COMPLETED': return '#3498db';
      default: return '#95a5a6';
    }
  };

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return {
      date: date.toLocaleDateString('fr-FR'),
      time: date.toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' })
    };
  };

  if (loading) {
    return (
      <div className="modern-loading">
        <div className="loading-spinner"></div>
        <p>Chargement des événements...</p>
      </div>
    );
  }

  if (error) {
    return (
      <div className="modern-error">
        <div className="error-icon">⚠️</div>
        <p>{error}</p>
        <button className="btn-primary" onClick={fetchEvents}>Réessayer</button>
      </div>
    );
  }

  return (
    <div className="modern-events">
      <div className="modern-page-header">
        <div className="header-content">
          <div className="header-title">
            <h1>📅 Événements</h1>
            <p>Découvrez et participez aux événements bio de votre région</p>
          </div>
          {canCreateEvents && (
            <button 
              className="modern-btn primary"
              onClick={() => setShowCreateForm(!showCreateForm)}
            >
              <span className="btn-icon">➕</span>
              {showCreateForm ? 'Annuler' : 'Créer un événement'}
            </button>
          )}
        </div>
      </div>

      {showCreateForm && canCreateEvents && (
        <div className="modern-form-container">
          <div className="form-header">
            <h3>🎨 Créer un nouvel événement</h3>
            <p>Remplissez les informations ci-dessous pour créer votre événement</p>
          </div>
          <form onSubmit={handleCreateEvent} className="modern-form">
            <div className="form-grid">
              <div className="form-group">
                <label>🏪 Restaurant *</label>
                <select
                  value={newEvent.restaurantId}
                  onChange={(e) => setNewEvent({...newEvent, restaurantId: parseInt(e.target.value)})}
                  required
                  className="modern-select"
                >
                  {restaurants.map((restaurant) => (
                    <option key={restaurant.id} value={restaurant.id}>
                      {restaurant.name} - {restaurant.city}
                    </option>
                  ))}
                </select>
              </div>
              <div className="form-group">
                <label>📝 Titre *</label>
                <input
                  type="text"
                  value={newEvent.title}
                  onChange={(e) => setNewEvent({...newEvent, title: e.target.value})}
                  required
                  className="modern-input"
                  placeholder="Nom de votre événement"
                />
              </div>
            </div>
            <div className="form-group">
              <label>📄 Description *</label>
              <textarea
                value={newEvent.description}
                onChange={(e) => setNewEvent({...newEvent, description: e.target.value})}
                required
                className="modern-textarea"
                placeholder="Décrivez votre événement..."
                rows={4}
              />
            </div>
            <div className="form-grid">
              <div className="form-group">
                <label>📅 Date de début *</label>
                <input
                  type="datetime-local"
                  value={newEvent.dateStart}
                  onChange={(e) => setNewEvent({...newEvent, dateStart: e.target.value})}
                  required
                  className="modern-input"
                />
              </div>
              <div className="form-group">
                <label>📅 Date de fin *</label>
                <input
                  type="datetime-local"
                  value={newEvent.dateEnd}
                  onChange={(e) => setNewEvent({...newEvent, dateEnd: e.target.value})}
                  required
                  className="modern-input"
                />
              </div>
            </div>
            <div className="form-grid">
              <div className="form-group">
                <label>👥 Capacité *</label>
                <input
                  type="number"
                  value={newEvent.capacity}
                  onChange={(e) => setNewEvent({...newEvent, capacity: parseInt(e.target.value)})}
                  min={1}
                  required
                  className="modern-input"
                  placeholder="Nombre de places"
                />
              </div>
              <div className="form-group">
                <label>🏷️ Type *</label>
                <select
                  value={newEvent.type}
                  onChange={(e) => setNewEvent({...newEvent, type: e.target.value})}
                  required
                  className="modern-select"
                >
                  <option value="WORKSHOP">🎨 Atelier</option>
                  <option value="CONFERENCE">🎤 Conférence</option>
                  <option value="TASTING">🍽️ Dégustation</option>
                  <option value="MARKET">🛒 Marché</option>
                </select>
              </div>
            </div>
            <div className="form-actions">
              <button type="submit" className="modern-btn primary">
                <span className="btn-icon">✅</span>
                Créer l'événement
              </button>
              <button type="button" className="modern-btn secondary" onClick={() => setShowCreateForm(false)}>
                <span className="btn-icon">❌</span>
                Annuler
              </button>
            </div>
          </form>
        </div>
      )}

      <div className="modern-filters">
        <div className="search-container">
          <div className="search-box">
            <span className="search-icon">🔍</span>
            <input
              type="text"
              placeholder="Rechercher un événement..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="modern-search"
            />
          </div>
        </div>
        <div className="filter-container">
          <select
            value={filterType}
            onChange={(e) => setFilterType(e.target.value)}
            className="modern-filter"
          >
            <option value="">Tous les types</option>
            <option value="WORKSHOP">🎨 Ateliers</option>
            <option value="CONFERENCE">🎤 Conférences</option>
            <option value="TASTING">🍽️ Dégustations</option>
            <option value="MARKET">🛒 Marchés</option>
          </select>
          <select
            value={filterStatus}
            onChange={(e) => setFilterStatus(e.target.value)}
            className="modern-filter"
          >
            <option value="">Tous les statuts</option>
            <option value="ACTIVE">🟢 Actifs</option>
            <option value="CANCELLED">🔴 Annulés</option>
            <option value="COMPLETED">🔵 Terminés</option>
          </select>
        </div>
      </div>

      <div className="modern-events-grid">
        {events.length === 0 || filteredEvents.length === 0 ? (
          <div className="modern-empty-state">
            <div className="empty-icon">📅</div>
            <h3>Aucun événement trouvé</h3>
            <p>Il n'y a pas d'événements correspondant à vos critères de recherche.</p>
          </div>
        ) : (
          filteredEvents.map((event) => {
            const startDate = formatDate(event.dateStart);
            const endDate = formatDate(event.dateEnd);
            const typeColor = getEventTypeColor(event.type);
            const statusColor = getStatusColor(event.status);
            return (
              <div key={event.id} className="modern-event-card">
                <div className="event-header" style={{ backgroundColor: typeColor }}>
                  <div className="event-type">
                    <span className="type-icon">{getEventTypeIcon(event.type)}</span>
                    <span className="type-label">{event.type}</span>
                  </div>
                  <div className="event-status" style={{ backgroundColor: statusColor }}>
                    {event.status}
                  </div>
                </div>
                <div className="event-content">
                  <h3 className="event-title">{event.title}</h3>
                  <p className="event-restaurant">🏪 {getRestaurantName(event.restaurantId)}</p>
                  <p className="event-description">{event.description}</p>
                  <div className="event-details">
                    <div className="detail-item">
                      <span className="detail-icon">📅</span>
                      <div className="detail-content">
                        <span className="detail-label">Début</span>
                        <span className="detail-value">{startDate.date} à {startDate.time}</span>
                      </div>
                    </div>
                    <div className="detail-item">
                      <span className="detail-icon">⏰</span>
                      <div className="detail-content">
                        <span className="detail-label">Fin</span>
                        <span className="detail-value">{endDate.date} à {endDate.time}</span>
                      </div>
                    </div>
                    <div className="detail-item">
                      <span className="detail-icon">👥</span>
                      <div className="detail-content">
                        <span className="detail-label">Places</span>
                        <span className="detail-value">{event.availableSpots}/{event.capacity}</span>
                      </div>
                    </div>
                  </div>
                </div>
                <div className="event-actions">
                  <button className="modern-btn primary small">
                    <span className="btn-icon">👁️</span>
                    Voir détails
                  </button>
                  {canCreateEvents && event.status === 'ACTIVE' && (
                    <button 
                      className="modern-btn danger small"
                      onClick={() => handleCancelEvent(event.id)}
                    >
                      <span className="btn-icon">❌</span>
                      Annuler
                    </button>
                  )}
                </div>
              </div>
            );
          })
        )}
      </div>
    </div>
  );
};

export default ModernEvents;
