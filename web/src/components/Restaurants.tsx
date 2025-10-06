import React, { useState, useEffect } from 'react';
import { restaurantService } from '../services/api';

interface Restaurant {
  id: number;
  name: string;
  address: string;
  phone: string;
  email: string;
}

const Restaurants: React.FC = () => {
  const [restaurants, setRestaurants] = useState<Restaurant[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    fetchRestaurants();
  }, []);

  const fetchRestaurants = async () => {
    try {
      setLoading(true);
      const response = await restaurantService.getAll();
      setRestaurants(response.data);
    } catch (err: any) {
      setError('Erreur lors du chargement des restaurants');
      console.error('Error fetching restaurants:', err);
    } finally {
      setLoading(false);
    }
  };

  if (loading) return <div className="loading">Chargement...</div>;
  if (error) return <div className="error">{error}</div>;

  return (
    <div className="restaurants">
      <div className="page-header">
        <h1>Restaurants</h1>
        <button className="btn-primary">Ajouter un restaurant</button>
      </div>
      
      <div className="restaurants-grid">
        {restaurants.length === 0 ? (
          <div className="empty-state">
            <p>Aucun restaurant trouvé</p>
          </div>
        ) : (
          restaurants.map((restaurant) => (
            <div key={restaurant.id} className="restaurant-card">
              <h3>{restaurant.name}</h3>
              <p><strong>Adresse:</strong> {restaurant.address}</p>
              <p><strong>Téléphone:</strong> {restaurant.phone}</p>
              <p><strong>Email:</strong> {restaurant.email}</p>
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

export default Restaurants;
