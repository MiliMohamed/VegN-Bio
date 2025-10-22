import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { bookingService } from '../services/api';
import { Booking, Event } from '../types/events';

export interface PersonalBooking extends Booking {
  event?: Event;
}

interface PersonalBookingsContextType {
  bookings: PersonalBooking[];
  loading: boolean;
  error: string | null;
  refreshBookings: () => Promise<void>;
  addBooking: (booking: PersonalBooking) => void;
  updateBooking: (bookingId: number, updates: Partial<Booking>) => void;
  removeBooking: (bookingId: number) => void;
  getBookingsCount: () => number;
}

const PersonalBookingsContext = createContext<PersonalBookingsContextType | undefined>(undefined);

export const usePersonalBookings = () => {
  const context = useContext(PersonalBookingsContext);
  if (!context) {
    throw new Error('usePersonalBookings must be used within a PersonalBookingsProvider');
  }
  return context;
};

interface PersonalBookingsProviderProps {
  children: ReactNode;
}

export const PersonalBookingsProvider: React.FC<PersonalBookingsProviderProps> = ({ children }) => {
  const [bookings, setBookings] = useState<PersonalBooking[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // Charger les réservations depuis localStorage au démarrage
  useEffect(() => {
    try {
      const savedBookings = localStorage.getItem('vegn-bio-personal-bookings');
      if (savedBookings) {
        setBookings(JSON.parse(savedBookings));
      }
    } catch (error) {
      console.error('Erreur lors du chargement des réservations:', error);
    }
  }, []);

  // Sauvegarder dans localStorage à chaque changement
  useEffect(() => {
    try {
      localStorage.setItem('vegn-bio-personal-bookings', JSON.stringify(bookings));
    } catch (error) {
      console.error('Erreur lors de la sauvegarde des réservations:', error);
    }
  }, [bookings]);

  const refreshBookings = async () => {
    setLoading(true);
    setError(null);
    
    try {
      // Pour l'instant, on garde les réservations locales
      // Plus tard, on pourra synchroniser avec le backend
      setLoading(false);
    } catch (error) {
      console.error('Erreur lors du chargement des réservations:', error);
      setError('Erreur lors du chargement des réservations');
      setLoading(false);
    }
  };

  const addBooking = (booking: PersonalBooking) => {
    setBookings(prevBookings => {
      // Vérifier si la réservation n'existe pas déjà
      const existingBooking = prevBookings.find(b => b.id === booking.id);
      if (existingBooking) {
        return prevBookings;
      }
      
      return [...prevBookings, booking];
    });
  };

  const updateBooking = (bookingId: number, updates: Partial<Booking>) => {
    setBookings(prevBookings =>
      prevBookings.map(booking =>
        booking.id === bookingId ? { ...booking, ...updates } : booking
      )
    );
  };

  const removeBooking = (bookingId: number) => {
    setBookings(prevBookings =>
      prevBookings.filter(booking => booking.id !== bookingId)
    );
  };

  const getBookingsCount = () => {
    return bookings.length;
  };

  const value: PersonalBookingsContextType = {
    bookings,
    loading,
    error,
    refreshBookings,
    addBooking,
    updateBooking,
    removeBooking,
    getBookingsCount,
  };

  return (
    <PersonalBookingsContext.Provider value={value}>
      {children}
    </PersonalBookingsContext.Provider>
  );
};
