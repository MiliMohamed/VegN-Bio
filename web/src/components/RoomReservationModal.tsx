import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Calendar, Clock, Users, MapPin, X, CheckCircle, AlertCircle } from 'lucide-react';
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
}

interface RoomReservationModalProps {
  isOpen: boolean;
  onClose: () => void;
  room: Room | null;
  onReservationCreated?: () => void;
}

const RoomReservationModal: React.FC<RoomReservationModalProps> = ({
  isOpen,
  onClose,
  room,
  onReservationCreated
}) => {
  const [formData, setFormData] = useState({
    startTime: '',
    endTime: '',
    purpose: '',
    attendeesCount: 1,
    specialRequirements: '',
    notes: ''
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState(false);

  useEffect(() => {
    if (isOpen && room) {
      // Reset form when modal opens
      setFormData({
        startTime: '',
        endTime: '',
        purpose: '',
        attendeesCount: 1,
        specialRequirements: '',
        notes: ''
      });
      setError(null);
      setSuccess(false);
    }
  }, [isOpen, room]);

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: name === 'attendeesCount' ? parseInt(value) || 1 : value
    }));
  };

  const validateForm = () => {
    if (!formData.startTime || !formData.endTime) {
      setError('Veuillez sélectionner les heures de début et de fin');
      return false;
    }

    if (!formData.purpose) {
      setError('Veuillez indiquer le but de la réservation');
      return false;
    }

    const startTime = new Date(formData.startTime);
    const endTime = new Date(formData.endTime);

    if (startTime >= endTime) {
      setError('L\'heure de fin doit être après l\'heure de début');
      return false;
    }

    if (startTime < new Date()) {
      setError('La réservation ne peut pas être dans le passé');
      return false;
    }

    if (formData.attendeesCount > room!.capacity) {
      setError(`Le nombre de participants ne peut pas dépasser la capacité de la salle (${room!.capacity})`);
      return false;
    }

    return true;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!room || !validateForm()) return;

    setLoading(true);
    setError(null);

    try {
      const reservationData = {
        roomId: room.id,
        startTime: formData.startTime,
        endTime: formData.endTime,
        purpose: formData.purpose,
        attendeesCount: formData.attendeesCount,
        specialRequirements: formData.specialRequirements,
        notes: formData.notes
      };

      await api.post(`/api/v1/rooms/${room.id}/reservations`, reservationData);
      
      setSuccess(true);
      setTimeout(() => {
        onReservationCreated?.();
        onClose();
      }, 2000);

    } catch (err: any) {
      setError(err.response?.data?.message || 'Erreur lors de la création de la réservation');
    } finally {
      setLoading(false);
    }
  };

  const calculateDuration = () => {
    if (!formData.startTime || !formData.endTime) return 0;
    
    const start = new Date(formData.startTime);
    const end = new Date(formData.endTime);
    return Math.ceil((end.getTime() - start.getTime()) / (1000 * 60 * 60));
  };

  const calculateTotalPrice = () => {
    const duration = calculateDuration();
    return duration * (room?.hourlyRateCents || 0);
  };

  const formatPrice = (cents: number) => {
    return (cents / 100).toFixed(2) + ' €';
  };

  if (!isOpen || !room) return null;

  return (
    <AnimatePresence>
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        exit={{ opacity: 0 }}
        className="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4"
        onClick={onClose}
      >
        <motion.div
          initial={{ scale: 0.9, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          exit={{ scale: 0.9, opacity: 0 }}
          className="bg-white rounded-2xl shadow-2xl w-full max-w-2xl max-h-[90vh] overflow-hidden"
          onClick={(e) => e.stopPropagation()}
        >
          {/* Header */}
          <div className="bg-gradient-to-r from-blue-500 to-blue-600 text-white p-6">
            <div className="flex items-center justify-between">
              <div>
                <h2 className="text-2xl font-bold mb-1">Réserver {room.name}</h2>
                <p className="text-blue-100">{room.restaurantName}</p>
              </div>
              <button
                onClick={onClose}
                className="p-2 hover:bg-white hover:bg-opacity-20 rounded-full transition-colors"
              >
                <X className="w-6 h-6" />
              </button>
            </div>
          </div>

          {/* Content */}
          <div className="p-6 overflow-y-auto max-h-[calc(90vh-140px)]">
            {success ? (
              <div className="text-center py-12">
                <CheckCircle className="w-16 h-16 text-green-500 mx-auto mb-4" />
                <h3 className="text-2xl font-bold text-gray-900 mb-2">Réservation confirmée !</h3>
                <p className="text-gray-600">Votre réservation a été créée avec succès.</p>
              </div>
            ) : (
              <form onSubmit={handleSubmit} className="space-y-6">
                {/* Error message */}
                {error && (
                  <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg flex items-center space-x-2">
                    <AlertCircle className="w-5 h-5" />
                    <span>{error}</span>
                  </div>
                )}

                {/* Room info */}
                <div className="bg-blue-50 rounded-xl p-4">
                  <h3 className="font-semibold text-blue-900 mb-2">Informations de la salle</h3>
                  <div className="grid grid-cols-2 gap-4 text-sm">
                    <div className="flex items-center space-x-2">
                      <Users className="w-4 h-4 text-blue-600" />
                      <span>Capacité : {room.capacity} personnes</span>
                    </div>
                    <div className="flex items-center space-x-2">
                      <Clock className="w-4 h-4 text-blue-600" />
                      <span>Tarif : {formatPrice(room.hourlyRateCents)}/h</span>
                    </div>
                  </div>
                </div>

                {/* Date and time */}
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Heure de début
                    </label>
                    <input
                      type="datetime-local"
                      name="startTime"
                      value={formData.startTime}
                      onChange={handleInputChange}
                      className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      required
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Heure de fin
                    </label>
                    <input
                      type="datetime-local"
                      name="endTime"
                      value={formData.endTime}
                      onChange={handleInputChange}
                      className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      required
                    />
                  </div>
                </div>

                {/* Purpose */}
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    But de la réservation *
                  </label>
                  <input
                    type="text"
                    name="purpose"
                    value={formData.purpose}
                    onChange={handleInputChange}
                    placeholder="Ex: Réunion équipe, Formation, Conférence..."
                    className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    required
                  />
                </div>

                {/* Attendees count */}
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Nombre de participants
                  </label>
                  <input
                    type="number"
                    name="attendeesCount"
                    value={formData.attendeesCount}
                    onChange={handleInputChange}
                    min="1"
                    max={room.capacity}
                    className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  />
                </div>

                {/* Special requirements */}
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Exigences spéciales
                  </label>
                  <textarea
                    name="specialRequirements"
                    value={formData.specialRequirements}
                    onChange={handleInputChange}
                    placeholder="Ex: Équipement audiovisuel, restauration, etc."
                    rows={3}
                    className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"
                  />
                </div>

                {/* Notes */}
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Notes supplémentaires
                  </label>
                  <textarea
                    name="notes"
                    value={formData.notes}
                    onChange={handleInputChange}
                    placeholder="Informations complémentaires..."
                    rows={2}
                    className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"
                  />
                </div>

                {/* Price calculation */}
                {formData.startTime && formData.endTime && (
                  <div className="bg-green-50 rounded-xl p-4">
                    <h3 className="font-semibold text-green-900 mb-2">Récapitulatif</h3>
                    <div className="space-y-1 text-sm">
                      <div className="flex justify-between">
                        <span>Durée :</span>
                        <span>{calculateDuration()} heure(s)</span>
                      </div>
                      <div className="flex justify-between">
                        <span>Tarif horaire :</span>
                        <span>{formatPrice(room.hourlyRateCents)}</span>
                      </div>
                      <div className="flex justify-between font-bold text-lg border-t border-green-200 pt-2">
                        <span>Total :</span>
                        <span className="text-green-600">{formatPrice(calculateTotalPrice())}</span>
                      </div>
                    </div>
                  </div>
                )}

                {/* Submit button */}
                <button
                  type="submit"
                  disabled={loading}
                  className="w-full bg-blue-500 text-white py-3 rounded-xl font-semibold hover:bg-blue-600 transition-colors disabled:opacity-50 flex items-center justify-center space-x-2"
                >
                  {loading ? (
                    <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-white"></div>
                  ) : (
                    <>
                      <Calendar className="w-5 h-5" />
                      <span>Confirmer la réservation</span>
                    </>
                  )}
                </button>
              </form>
            )}
          </div>
        </motion.div>
      </motion.div>
    </AnimatePresence>
  );
};

export default RoomReservationModal;
