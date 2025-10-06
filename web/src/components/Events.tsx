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

const Events: React.FC = () => {
  const [events, setEvents] = useState<Event[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [showCreateForm, setShowCreateForm] = useState(false);
  const [newEvent, setNewEvent] = useState<CreateEventData>({
    restaurantId: 1,
    title: '',
    description: '',
    dateStart: '',
    dateEnd: '',
    capacity: 0,
    type: 'WORKSHOP'
  });

  // Hook pour récupérer les restaurants
  const { restaurants, getRestaurantName } = useRestaurants();

  // Vérifier si l'utilisateur peut créer des événements (RESTAURATEUR ou ADMIN)
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

  if (loading) return <div className="loading">Chargement...</div>;
  if (error) return <div className="error">{error}</div>;

  return (
    <div className="events">
      <div className="page-header">
        <h1>Événements</h1>
        {canCreateEvents && (
          <button 
            className="btn-primary"
            onClick={() => setShowCreateForm(!showCreateForm)}
          >
            {showCreateForm ? 'Annuler' : 'Créer un événement'}
          </button>
        )}
      </div>

      {showCreateForm && canCreateEvents && (
        <div className="create-form">
          <h3>Créer un nouvel événement</h3>
          <form onSubmit={handleCreateEvent}>
            <div className="form-row">
              <div className="form-group">
                <label>Restaurant *</label>
                <select
                  value={newEvent.restaurantId}
                  onChange={(e) => setNewEvent({...newEvent, restaurantId: parseInt(e.target.value)})}
                  required
                >
                  {restaurants.map((restaurant) => (
                    <option key={restaurant.id} value={restaurant.id}>
                      {restaurant.name} - {restaurant.city}
                    </option>
                  ))}
                </select>
              </div>
              
              <div className="form-group">
                <label>Titre *</label>
                <input
                  type="text"
                  value={newEvent.title}
                  onChange={(e) => setNewEvent({...newEvent, title: e.target.value})}
                  required
                />
              </div>
            </div>
            
            <div className="form-group">
              <label>Description *</label>
              <textarea
                value={newEvent.description}
                onChange={(e) => setNewEvent({...newEvent, description: e.target.value})}
                required
              />
            </div>
            
            <div className="form-row">
              <div className="form-group">
                <label>Date de début *</label>
                <input
                  type="datetime-local"
                  value={newEvent.dateStart}
                  onChange={(e) => setNewEvent({...newEvent, dateStart: e.target.value})}
                  required
                />
              </div>
              
              <div className="form-group">
                <label>Date de fin *</label>
                <input
                  type="datetime-local"
                  value={newEvent.dateEnd}
                  onChange={(e) => setNewEvent({...newEvent, dateEnd: e.target.value})}
                  required
                />
              </div>
            </div>
            
            <div className="form-row">
              <div className="form-group">
                <label>Capacité *</label>
                <input
                  type="number"
                  value={newEvent.capacity}
                  onChange={(e) => setNewEvent({...newEvent, capacity: parseInt(e.target.value)})}
                  min="1"
                  required
                />
              </div>
              
              <div className="form-group">
                <label>Type *</label>
                <select
                  value={newEvent.type}
                  onChange={(e) => setNewEvent({...newEvent, type: e.target.value})}
                  required
                >
                  <option value="WORKSHOP">Atelier</option>
                  <option value="CONFERENCE">Conférence</option>
                  <option value="TASTING">Dégustation</option>
                  <option value="MARKET">Marché</option>
                </select>
              </div>
            </div>
            
            <div className="form-actions">
              <button type="submit" className="btn-primary">Créer l'événement</button>
              <button type="button" className="btn-secondary" onClick={() => setShowCreateForm(false)}>
                Annuler
              </button>
            </div>
          </form>
        </div>
      )}

      <div className="events-grid">
        {events.length === 0 ? (
          <div className="empty-state">
            <p>Aucun événement trouvé</p>
          </div>
        ) : (
          events.map((event) => (
            <div key={event.id} className="event-card">
              <h3>{event.title}</h3>
              <p><strong>Restaurant:</strong> {getRestaurantName(event.restaurantId)}</p>
              <p><strong>Type:</strong> {event.type}</p>
              <p><strong>Date de début:</strong> {new Date(event.dateStart).toLocaleString('fr-FR')}</p>
              <p><strong>Date de fin:</strong> {new Date(event.dateEnd).toLocaleString('fr-FR')}</p>
              <p><strong>Places disponibles:</strong> {event.availableSpots}/{event.capacity}</p>
              <p><strong>Statut:</strong> <span className={`status-${event.status.toLowerCase()}`}>{event.status}</span></p>
              <p className="event-description">{event.description}</p>
              <div className="card-actions">
                <button className="btn-primary">Voir détails</button>
                {canCreateEvents && event.status === 'ACTIVE' && (
                  <button 
                    className="btn-danger"
                    onClick={() => handleCancelEvent(event.id)}
                  >
                    Annuler
                  </button>
                )}
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );
};

export default Events;