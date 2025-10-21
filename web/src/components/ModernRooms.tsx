import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { MapPin, Filter, Search, Plus, Calendar, Users, Clock } from 'lucide-react';
import RoomCard from './RoomCard';
import RoomReservationModal from './RoomReservationModal';
import api from '../services/api';

interface Room {
  id: number;
  restaurantId: number;
  restaurantName: string;
  name: string;
  description: string;
  capacity: number;
  hourlyRateCents: number;
  hasWifi: boolean;
  hasPrinter: boolean;
  hasProjector: boolean;
  hasWhiteboard: boolean;
  status: string;
  createdAt: string;
  updatedAt: string;
}

interface Restaurant {
  id: number;
  name: string;
  address: string;
  city: string;
  phone: string;
}

const ModernRooms: React.FC = () => {
  const [rooms, setRooms] = useState<Room[]>([]);
  const [restaurants, setRestaurants] = useState<Restaurant[]>([]);
  const [selectedRestaurant, setSelectedRestaurant] = useState<number | null>(null);
  const [minCapacity, setMinCapacity] = useState<number | null>(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [selectedRoom, setSelectedRoom] = useState<Room | null>(null);
  const [isReservationModalOpen, setIsReservationModalOpen] = useState(false);

  useEffect(() => {
    loadRestaurants();
  }, []);

  useEffect(() => {
    if (selectedRestaurant) {
      loadRooms(selectedRestaurant);
    }
  }, [selectedRestaurant, minCapacity]);

  const loadRestaurants = async () => {
    try {
      const response = await api.get('/api/v1/restaurants');
      setRestaurants(response.data);
      if (response.data.length > 0) {
        setSelectedRestaurant(response.data[0].id);
      }
    } catch (err: any) {
      setError('Erreur lors du chargement des restaurants');
      console.error('Error loading restaurants:', err);
    }
  };

  const loadRooms = async (restaurantId: number) => {
    try {
      setLoading(true);
      const response = await api.get(`/api/v1/rooms/restaurant/${restaurantId}/available`, {
        params: minCapacity ? { minCapacity } : {}
      });
      setRooms(response.data);
      setError(null);
    } catch (err: any) {
      setError('Erreur lors du chargement des salles');
      console.error('Error loading rooms:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleReserveRoom = (room: Room) => {
    setSelectedRoom(room);
    setIsReservationModalOpen(true);
  };

  const handleReservationCreated = () => {
    // Refresh rooms list after successful reservation
    if (selectedRestaurant) {
      loadRooms(selectedRestaurant);
    }
  };

  const filteredRooms = rooms.filter(room => {
    const matchesSearch = !searchTerm || 
      room.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      room.description.toLowerCase().includes(searchTerm.toLowerCase()) ||
      room.restaurantName.toLowerCase().includes(searchTerm.toLowerCase());
    
    return matchesSearch;
  });

  const selectedRestaurantData = restaurants.find(r => r.id === selectedRestaurant);

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white shadow-sm border-b">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <div className="flex items-center space-x-4">
              <h1 className="text-2xl font-bold text-gray-900">Réservation de Salles</h1>
              {selectedRestaurantData && (
                <div className="flex items-center space-x-2 text-sm text-gray-600">
                  <MapPin className="w-4 h-4" />
                  <span>{selectedRestaurantData.name}</span>
                </div>
              )}
            </div>
            
            <div className="flex items-center space-x-2 text-sm text-gray-600">
              <Calendar className="w-4 h-4" />
              <span>{new Date().toLocaleDateString('fr-FR')}</span>
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Filters */}
        <div className="bg-white rounded-2xl shadow-lg p-6 mb-8">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            {/* Restaurant selection */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Restaurant
              </label>
              <select
                value={selectedRestaurant || ''}
                onChange={(e) => setSelectedRestaurant(Number(e.target.value))}
                className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              >
                <option value="">Sélectionner un restaurant</option>
                {restaurants.map(restaurant => (
                  <option key={restaurant.id} value={restaurant.id}>
                    {restaurant.name}
                  </option>
                ))}
              </select>
            </div>

            {/* Capacity filter */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Capacité minimum
              </label>
              <select
                value={minCapacity || ''}
                onChange={(e) => setMinCapacity(e.target.value ? Number(e.target.value) : null)}
                className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              >
                <option value="">Toutes les capacités</option>
                <option value="2">2+ personnes</option>
                <option value="4">4+ personnes</option>
                <option value="6">6+ personnes</option>
                <option value="8">8+ personnes</option>
                <option value="10">10+ personnes</option>
                <option value="15">15+ personnes</option>
              </select>
            </div>

            {/* Search */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Recherche
              </label>
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-5 h-5" />
                <input
                  type="text"
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  placeholder="Rechercher une salle..."
                  className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>
            </div>

            {/* Results count */}
            <div className="flex items-end">
              <div className="text-sm text-gray-600">
                {filteredRooms.length} salle{filteredRooms.length > 1 ? 's' : ''} disponible{filteredRooms.length > 1 ? 's' : ''}
              </div>
            </div>
          </div>
        </div>

        {/* Info banner */}
        <div className="bg-blue-50 border border-blue-200 rounded-xl p-4 mb-8">
          <div className="flex items-start space-x-3">
            <Calendar className="w-6 h-6 text-blue-600 mt-1" />
            <div>
              <h3 className="font-semibold text-blue-900 mb-1">Réservation de salles</h3>
              <p className="text-blue-700 text-sm">
                Réservez nos salles de réunion équipées pour vos événements professionnels, 
                formations ou réunions d'équipe. Toutes nos salles sont équipées du Wi-Fi 
                et d'équipements modernes.
              </p>
            </div>
          </div>
        </div>

        {/* Error message */}
        {error && (
          <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg mb-6">
            {error}
          </div>
        )}

        {/* Loading */}
        {loading && (
          <div className="flex items-center justify-center py-12">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500"></div>
          </div>
        )}

        {/* Rooms grid */}
        {!loading && (
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
            {filteredRooms.map((room) => (
              <RoomCard
                key={room.id}
                room={room}
                onReserve={handleReserveRoom}
                showReserveButton={true}
              />
            ))}
          </div>
        )}

        {/* Empty state */}
        {!loading && filteredRooms.length === 0 && (
          <div className="text-center py-12">
            <div className="w-24 h-24 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <Calendar className="w-12 h-12 text-gray-400" />
            </div>
            <h3 className="text-xl font-semibold text-gray-600 mb-2">Aucune salle disponible</h3>
            <p className="text-gray-500">Essayez de modifier vos critères de recherche</p>
          </div>
        )}

        {/* Restaurant info */}
        {selectedRestaurantData && (
          <div className="mt-12 bg-white rounded-2xl shadow-lg p-6">
            <h3 className="text-xl font-bold text-gray-900 mb-4">Informations du restaurant</h3>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <h4 className="font-semibold text-gray-700 mb-2">{selectedRestaurantData.name}</h4>
                <div className="space-y-2 text-sm text-gray-600">
                  <div className="flex items-center space-x-2">
                    <MapPin className="w-4 h-4" />
                    <span>{selectedRestaurantData.address}, {selectedRestaurantData.city}</span>
                  </div>
                  <div className="flex items-center space-x-2">
                    <Clock className="w-4 h-4" />
                    <span>Ouvert tous les jours</span>
                  </div>
                </div>
              </div>
              <div className="text-sm text-gray-600">
                <p>
                  Nos salles de réunion sont parfaites pour vos événements professionnels. 
                  Réservez dès maintenant pour garantir votre créneau.
                </p>
              </div>
            </div>
          </div>
        )}
      </div>

      {/* Reservation Modal */}
      <RoomReservationModal
        isOpen={isReservationModalOpen}
        onClose={() => {
          setIsReservationModalOpen(false);
          setSelectedRoom(null);
        }}
        room={selectedRoom}
        onReservationCreated={handleReservationCreated}
      />
    </div>
  );
};

export default ModernRooms;
