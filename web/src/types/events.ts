// Types pour les événements et réservations
export interface Event {
  id: number;
  restaurantId: number;
  title: string;
  type?: string;
  dateStart: string;
  dateEnd?: string;
  capacity?: number;
  description?: string;
  status: 'ACTIVE' | 'CANCELLED';
  availableSpots?: number;
}

export interface Booking {
  id: number;
  eventId: number;
  customerName: string;
  customerPhone?: string;
  pax: number;
  status: 'PENDING' | 'CONFIRMED' | 'CANCELLED';
  createdAt: string;
}

export interface CreateEventRequest {
  restaurantId: number;
  title: string;
  type?: string;
  dateStart: string;
  dateEnd?: string;
  capacity?: number;
  description?: string;
}

export interface CreateBookingRequest {
  eventId: number;
  customerName: string;
  customerPhone?: string;
  pax: number;
}

export interface UpdateBookingStatusRequest {
  status: 'PENDING' | 'CONFIRMED' | 'CANCELLED';
}

// Types pour les filtres
export interface EventFilters {
  restaurantId?: number;
  from?: string;
  to?: string;
  status?: 'ACTIVE' | 'CANCELLED';
}

export interface BookingFilters {
  eventId?: number;
  restaurantId?: number;
  status?: 'PENDING' | 'CONFIRMED' | 'CANCELLED';
}
