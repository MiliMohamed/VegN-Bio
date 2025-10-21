import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { MapPin, Clock, Phone, Mail, Wifi, Printer, Users, Calendar } from 'lucide-react';
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

interface RoomCardProps {
  room: Room;
  onReserve?: (room: Room) => void;
  showReserveButton?: boolean;
}

const RoomCard: React.FC<RoomCardProps> = ({ 
  room, 
  onReserve, 
  showReserveButton = true 
}) => {
  const formatPrice = (cents: number) => {
    return (cents / 100).toFixed(2) + ' €';
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'AVAILABLE':
        return 'bg-green-100 text-green-700';
      case 'MAINTENANCE':
        return 'bg-yellow-100 text-yellow-700';
      case 'OUT_OF_ORDER':
        return 'bg-red-100 text-red-700';
      default:
        return 'bg-gray-100 text-gray-700';
    }
  };

  const getStatusText = (status: string) => {
    switch (status) {
      case 'AVAILABLE':
        return 'Disponible';
      case 'MAINTENANCE':
        return 'Maintenance';
      case 'OUT_OF_ORDER':
        return 'Hors service';
      default:
        return status;
    }
  };

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      whileHover={{ y: -5 }}
      className="bg-white rounded-2xl shadow-lg hover:shadow-xl transition-all duration-300 overflow-hidden border border-gray-100"
    >
      {/* Header */}
      <div className="bg-gradient-to-r from-blue-500 to-blue-600 text-white p-6">
        <div className="flex items-start justify-between">
          <div className="flex-1">
            <h3 className="text-2xl font-bold mb-2">{room.name}</h3>
            <p className="text-blue-100 mb-3">{room.description}</p>
            <div className="flex items-center space-x-4 text-sm">
              <div className="flex items-center space-x-1">
                <MapPin className="w-4 h-4" />
                <span>{room.restaurantName}</span>
              </div>
              <div className="flex items-center space-x-1">
                <Users className="w-4 h-4" />
                <span>{room.capacity} personnes</span>
              </div>
            </div>
          </div>
          <div className="text-right">
            <div className={`px-3 py-1 rounded-full text-sm font-semibold ${getStatusColor(room.status)}`}>
              {getStatusText(room.status)}
            </div>
            {room.hourlyRateCents > 0 && (
              <div className="text-2xl font-bold mt-2">
                {formatPrice(room.hourlyRateCents)}/h
              </div>
            )}
          </div>
        </div>
      </div>

      <div className="p-6">
        {/* Equipment */}
        <div className="mb-6">
          <h4 className="text-lg font-semibold text-gray-900 mb-3">Équipements disponibles</h4>
          <div className="grid grid-cols-2 gap-3">
            <div className={`flex items-center space-x-2 p-3 rounded-lg ${room.hasWifi ? 'bg-green-50 text-green-700' : 'bg-gray-50 text-gray-400'}`}>
              <Wifi className="w-5 h-5" />
              <span className="font-medium">Wi-Fi</span>
            </div>
            <div className={`flex items-center space-x-2 p-3 rounded-lg ${room.hasPrinter ? 'bg-green-50 text-green-700' : 'bg-gray-50 text-gray-400'}`}>
              <Printer className="w-5 h-5" />
              <span className="font-medium">Imprimante</span>
            </div>
            <div className={`flex items-center space-x-2 p-3 rounded-lg ${room.hasProjector ? 'bg-green-50 text-green-700' : 'bg-gray-50 text-gray-400'}`}>
              <Calendar className="w-5 h-5" />
              <span className="font-medium">Projecteur</span>
            </div>
            <div className={`flex items-center space-x-2 p-3 rounded-lg ${room.hasWhiteboard ? 'bg-green-50 text-green-700' : 'bg-gray-50 text-gray-400'}`}>
              <div className="w-5 h-5 border-2 border-current rounded"></div>
              <span className="font-medium">Tableau</span>
            </div>
          </div>
        </div>

        {/* Capacity info */}
        <div className="mb-6">
          <div className="bg-blue-50 rounded-xl p-4">
            <div className="flex items-center space-x-2 mb-2">
              <Users className="w-5 h-5 text-blue-600" />
              <span className="font-semibold text-blue-900">Capacité</span>
            </div>
            <p className="text-blue-700">
              Cette salle peut accueillir jusqu'à <strong>{room.capacity} personnes</strong> pour vos réunions, 
              conférences ou événements.
            </p>
          </div>
        </div>

        {/* Pricing */}
        {room.hourlyRateCents > 0 && (
          <div className="mb-6">
            <div className="bg-green-50 rounded-xl p-4">
              <div className="flex items-center space-x-2 mb-2">
                <Clock className="w-5 h-5 text-green-600" />
                <span className="font-semibold text-green-900">Tarification</span>
              </div>
              <p className="text-green-700">
                Tarif horaire : <strong>{formatPrice(room.hourlyRateCents)}</strong>
              </p>
            </div>
          </div>
        )}

        {/* Action buttons */}
        {showReserveButton && (
          <div className="flex space-x-3">
            <button
              onClick={() => onReserve?.(room)}
              disabled={room.status !== 'AVAILABLE'}
              className={`flex-1 py-3 px-6 rounded-xl font-semibold transition-colors flex items-center justify-center space-x-2 ${
                room.status === 'AVAILABLE'
                  ? 'bg-blue-500 text-white hover:bg-blue-600'
                  : 'bg-gray-300 text-gray-500 cursor-not-allowed'
              }`}
            >
              <Calendar className="w-5 h-5" />
              <span>
                {room.status === 'AVAILABLE' ? 'Réserver' : 'Indisponible'}
              </span>
            </button>
          </div>
        )}

        {/* Last updated */}
        <div className="mt-4 pt-4 border-t border-gray-200">
          <p className="text-xs text-gray-500">
            Dernière mise à jour : {new Date(room.updatedAt || room.createdAt).toLocaleDateString('fr-FR')}
          </p>
        </div>
      </div>
    </motion.div>
  );
};

export default RoomCard;
