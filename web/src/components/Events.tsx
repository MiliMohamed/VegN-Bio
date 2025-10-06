import React, { useState, useEffect } from 'react';
import { eventService } from '../services/api';

interface Event {
  id: number;
  title: string;
  description: string;
  date: string;
  location: string;
  maxParticipants: number;
  currentParticipants: number;
  status: string;
}

const Events: React.FC = () => {
  const [events, setEvents] = useState<Event[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

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

  if (loading) return <div className="loading">Chargement...</div>;
  if (error) return <div className="error">{error}</div>;

  return (
    <div className="events">
      <div className="page-header">
        <h1>Événements</h1>
        <button className="btn-primary">Créer un événement</button>
      </div>
      
      <div className="events-grid">
        {events.length === 0 ? (
          <div className="empty-state">
            <p>Aucun événement trouvé</p>
          </div>
        ) : (
          events.map((event) => (
            <div key={event.id} className="event-card">
              <h3>{event.title}</h3>
              <p className="event-description">{event.description}</p>
              <p className="event-date">Date: {new Date(event.date).toLocaleDateString('fr-FR')}</p>
              <p className="event-location">Lieu: {event.location}</p>
              <p className="event-participants">
                Participants: {event.currentParticipants}/{event.maxParticipants}
              </p>
              <p className={`event-status status-${event.status.toLowerCase()}`}>
                Statut: {event.status}
              </p>
              <div className="card-actions">
                <button className="btn-secondary">Modifier</button>
                <button className="btn-danger">Supprimer</button>
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );
};

export default Events;
