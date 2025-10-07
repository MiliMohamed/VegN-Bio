import { useState, useEffect } from 'react';
import { restaurantService } from '../services/api';

export interface Restaurant {
  id: number;
  name: string;
  code: string;
  city: string;
  address?: string;
  phone?: string;
  email?: string;
  wifiAvailable?: boolean;
  meetingRoomsCount?: number;
  restaurantCapacity?: number;
  printerAvailable?: boolean;
  memberTrays?: boolean;
  deliveryAvailable?: boolean;
  specialEvents?: string;
  mondayThursdayHours?: string;
  fridayHours?: string;
  saturdayHours?: string;
  sundayHours?: string;
}

export const useRestaurants = () => {
  const [restaurants, setRestaurants] = useState<Restaurant[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetchRestaurants();
  }, []);

  const fetchRestaurants = async () => {
    try {
      setLoading(true);
      setError(null);
      const response = await restaurantService.getAll();
      setRestaurants(response.data);
    } catch (err: any) {
      setError('Erreur lors du chargement des restaurants');
      console.error('Error fetching restaurants:', err);
    } finally {
      setLoading(false);
    }
  };

  const getRestaurantName = (restaurantId: number): string => {
    const restaurant = restaurants.find(r => r.id === restaurantId);
    return restaurant ? restaurant.name : `Restaurant #${restaurantId}`;
  };

  return {
    restaurants,
    loading,
    error,
    getRestaurantName,
    refetch: fetchRestaurants
  };
};
