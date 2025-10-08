import axios from 'axios';

const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:8080/api/v1';

// Create axios instance with default config
const api = axios.create({
  baseURL: API_BASE_URL,
  timeout: 10000,
});

// Request interceptor to add auth token
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Response interceptor to handle errors
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Token expired or invalid
      localStorage.removeItem('token');
      localStorage.removeItem('userRole');
      localStorage.removeItem('userEmail');
      localStorage.removeItem('userName');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

// API service functions
export const authService = {
  login: (email: string, password: string) =>
    api.post('/auth/login', { email, password }),
  register: (userData: any) =>
    api.post('/auth/register', userData),
};

export const restaurantService = {
  getAll: () => api.get('/restaurants'),
  getById: (id: number) => api.get(`/restaurants/${id}`),
  create: (restaurantData: any) => api.post('/restaurants', restaurantData),
  update: (id: number, restaurantData: any) => api.put(`/restaurants/${id}`, restaurantData),
  delete: (id: number) => api.delete(`/restaurants/${id}`),
};

export const menuService = {
  getMenusByRestaurant: (restaurantId: number) => api.get(`/menus/restaurant/${restaurantId}`),
  getActiveMenusByRestaurant: (restaurantId: number, date?: string) => {
    const params = date ? `?date=${date}` : '';
    return api.get(`/menus/restaurant/${restaurantId}/active${params}`);
  },
  create: (menuData: any) => api.post('/menus', menuData),
  update: (id: number, menuData: any) => api.put(`/menus/${id}`, menuData),
  delete: (id: number) => api.delete(`/menus/${id}`),
  
  // Menu Items
  createMenuItem: (itemData: any) => api.post('/menu-items', itemData),
  getMenuItemsByMenu: (menuId: number) => api.get(`/menu-items/menu/${menuId}`),
  updateMenuItem: (id: number, itemData: any) => api.put(`/menu-items/${id}`, itemData),
  deleteMenuItem: (id: number) => api.delete(`/menu-items/${id}`),
};

export const eventService = {
  getAll: () => api.get('/events'),
  getById: (id: number) => api.get(`/events/${id}`),
  create: (eventData: any) => api.post('/events', eventData),
  update: (id: number, eventData: any) => api.put(`/events/${id}`, eventData),
  delete: (id: number) => api.delete(`/events/${id}`),
  cancel: (id: number) => api.patch(`/events/${id}/cancel`),
};

export const marketplaceService = {
  // Offers
  getOffers: (search?: string) => {
    const params = search ? `?search=${encodeURIComponent(search)}` : '';
    return api.get(`/offers${params}`);
  },
  getOffersBySupplier: (supplierId: number) => api.get(`/offers/supplier/${supplierId}`),
  createOffer: (offerData: any) => api.post('/offers', offerData),
  updateOffer: (id: number, offerData: any) => api.put(`/offers/${id}`, offerData),
  deleteOffer: (id: number) => api.delete(`/offers/${id}`),
  
  // Suppliers
  getSuppliers: (search?: string) => {
    const params = search ? `?search=${encodeURIComponent(search)}` : '';
    return api.get(`/suppliers${params}`);
  },
  getAllSuppliers: () => api.get('/suppliers/all'),
  createSupplier: (supplierData: any) => api.post('/suppliers', supplierData),
  updateSupplier: (id: number, supplierData: any) => api.put(`/suppliers/${id}`, supplierData),
  deleteSupplier: (id: number) => api.delete(`/suppliers/${id}`),
};

export const feedbackService = {
  // Reviews
  getReviews: () => api.get('/reviews/restaurant/1'), // Utilise le restaurant 1 par défaut
  getReviewsByRestaurant: (restaurantId: number) => api.get(`/reviews/restaurant/${restaurantId}`),
  getAllReviewsByRestaurant: (restaurantId: number) => api.get(`/reviews/restaurant/${restaurantId}/all`),
  getPendingReviews: () => api.get('/reviews/pending'),
  getReview: (reviewId: number) => api.get(`/reviews/${reviewId}`),
  createReview: (reviewData: any) => api.post('/reviews', reviewData),
  updateReviewStatus: (reviewId: number, statusData: any) => api.patch(`/reviews/${reviewId}/status`, statusData),
  getRestaurantReviewStats: (restaurantId: number) => api.get(`/reviews/restaurant/${restaurantId}/stats`),
  
  // Reports
  getReports: () => api.get('/reports/active'), // Utilise les rapports actifs par défaut
  getActiveReports: () => api.get('/reports/active'),
  getReportsByRestaurant: (restaurantId: number) => api.get(`/reports/restaurant/${restaurantId}`),
  getActiveReportsByRestaurant: (restaurantId: number) => api.get(`/reports/restaurant/${restaurantId}/active`),
  getReportsByStatus: (status: string) => api.get(`/reports/status/${status}`),
  getReport: (reportId: number) => api.get(`/reports/${reportId}`),
  createReport: (reportData: any) => api.post('/reports', reportData),
  updateReportStatus: (reportId: number, statusData: any) => api.patch(`/reports/${reportId}/status`, statusData),
};

// Service pour les réservations d'événements
export const bookingService = {
  getBookingsByEvent: (eventId: number) => api.get(`/bookings/event/${eventId}`),
  createBooking: (bookingData: any) => api.post('/bookings', bookingData),
  getBooking: (bookingId: number) => api.get(`/bookings/${bookingId}`),
  updateBooking: (bookingId: number, bookingData: any) => api.put(`/bookings/${bookingId}`, bookingData),
  deleteBooking: (bookingId: number) => api.delete(`/bookings/${bookingId}`),
  getBookingsByCustomer: (customerEmail: string) => api.get(`/bookings/customer/${customerEmail}`),
};

// Service pour les allergènes
export const allergenService = {
  getAll: () => api.get('/allergens'),
  getById: (id: string) => api.get(`/allergens/${id}`),
  search: (name: string) => api.get(`/allergens/search?name=${encodeURIComponent(name)}`),
};

// Service pour les consultations vétérinaires (Chatbot)
export const veterinaryService = {
  createConsultation: (consultationData: any) => api.post('/veterinary/consultations', consultationData),
  getConsultations: () => api.get('/veterinary/consultations'),
  getConsultation: (id: number) => api.get(`/veterinary/consultations/${id}`),
  updateConsultation: (id: number, consultationData: any) => api.put(`/veterinary/consultations/${id}`, consultationData),
  deleteConsultation: (id: number) => api.delete(`/veterinary/consultations/${id}`),
};

// Service pour les diagnostics vétérinaires
export const diagnosisService = {
  createDiagnosis: (diagnosisData: any) => api.post('/veterinary/diagnoses', diagnosisData),
  getDiagnoses: () => api.get('/veterinary/diagnoses'),
  getDiagnosis: (id: number) => api.get(`/veterinary/diagnoses/${id}`),
  updateDiagnosis: (id: number, diagnosisData: any) => api.put(`/veterinary/diagnoses/${id}`, diagnosisData),
  deleteDiagnosis: (id: number) => api.delete(`/veterinary/diagnoses/${id}`),
};

// Service pour le chatbot
export const chatbotService = {
  sendMessage: (message: string) => api.post('/chatbot/message', { message }),
  getConversationHistory: () => api.get('/chatbot/history'),
  clearHistory: () => api.delete('/chatbot/history'),
};

// Service pour les tickets de caisse
export const ticketService = {
  createTicket: (ticketData: any) => api.post('/tickets', ticketData),
  getTickets: () => api.get('/tickets'),
  getTicket: (id: number) => api.get(`/tickets/${id}`),
  updateTicket: (id: number, ticketData: any) => api.put(`/tickets/${id}`, ticketData),
  deleteTicket: (id: number) => api.delete(`/tickets/${id}`),
  getTicketsByDateRange: (startDate: string, endDate: string) => 
    api.get(`/tickets/date-range?start=${startDate}&end=${endDate}`),
};

// Service pour les lignes de ticket
export const ticketLineService = {
  createTicketLine: (ticketLineData: any) => api.post('/ticket-lines', ticketLineData),
  getTicketLines: () => api.get('/ticket-lines'),
  getTicketLine: (id: number) => api.get(`/ticket-lines/${id}`),
  updateTicketLine: (id: number, ticketLineData: any) => api.put(`/ticket-lines/${id}`, ticketLineData),
  deleteTicketLine: (id: number) => api.delete(`/ticket-lines/${id}`),
  getTicketLinesByTicket: (ticketId: number) => api.get(`/ticket-lines/ticket/${ticketId}`),
};

// Service pour les rapports d'erreur
export const errorReportService = {
  createErrorReport: (errorData: any) => api.post('/error-reports', errorData),
  getErrorReports: () => api.get('/error-reports'),
  getErrorReport: (id: number) => api.get(`/error-reports/${id}`),
  updateErrorReport: (id: number, errorData: any) => api.put(`/error-reports/${id}`, errorData),
  deleteErrorReport: (id: number) => api.delete(`/error-reports/${id}`),
  getErrorReportsByStatus: (status: string) => api.get(`/error-reports/status/${status}`),
};

// Service pour les utilisateurs
export const userService = {
  getUsers: () => api.get('/users'),
  getUser: (id: number) => api.get(`/users/${id}`),
  updateUser: (id: number, userData: any) => api.put(`/users/${id}`, userData),
  deleteUser: (id: number) => api.delete(`/users/${id}`),
  getUsersByRole: (role: string) => api.get(`/users/role/${role}`),
};

export default api;
