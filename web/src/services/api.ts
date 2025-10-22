import axios from 'axios';

const API_BASE_URL = process.env.REACT_APP_API_URL || 'https://vegn-bio-backend.onrender.com/api/v1/';

// Create axios instance with default config
const api = axios.create({
  baseURL: API_BASE_URL,
  timeout: 10000,
});

// Request interceptor to add auth token
api.interceptors.request.use(
  (config) => {
    // Don't add token for public endpoints (register, login)
    const publicEndpoints = ['auth/register', 'auth/login'];
    const isPublicEndpoint = publicEndpoints.some(endpoint => config.url?.includes(endpoint));
    
    if (!isPublicEndpoint) {
      const token = localStorage.getItem('token');
      if (token) {
        config.headers.Authorization = `Bearer ${token}`;
      }
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
  deleteReview: (reviewId: number) => api.delete(`/reviews/${reviewId}`),
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

// Service pour les événements
export const eventService = {
  getAll: () => api.get('/events'),
  getById: (id: number) => api.get(`/events/${id}`),
  getByRestaurant: (restaurantId: number, from?: string, to?: string) => {
    const params = new URLSearchParams();
    params.append('restaurantId', restaurantId.toString());
    if (from) params.append('from', from);
    if (to) params.append('to', to);
    return api.get(`/events?${params.toString()}`);
  },
  getActiveEvents: (from?: string) => {
    const params = from ? `?from=${from}` : '';
    return api.get(`/events${params}`);
  },
  create: (eventData: any) => api.post('/events', eventData),
  update: (id: number, eventData: any) => api.put(`/events/${id}`, eventData),
  delete: (id: number) => api.delete(`/events/${id}`),
  cancel: (id: number) => api.patch(`/events/${id}/cancel`),
};

// Service pour les réservations d'événements
export const bookingService = {
  getBookingsByEvent: (eventId: number) => api.get(`/bookings/event/${eventId}`),
  getBookingsByRestaurant: (restaurantId: number) => api.get(`/bookings/restaurant/${restaurantId}`),
  createBooking: (bookingData: any) => api.post('/bookings', bookingData),
  getBooking: (bookingId: number) => api.get(`/bookings/${bookingId}`),
  updateBookingStatus: (bookingId: number, statusData: any) => api.patch(`/bookings/${bookingId}/status`, statusData),
  deleteBooking: (bookingId: number) => api.delete(`/bookings/${bookingId}`),
  getBookingsByCustomer: (customerEmail: string) => api.get(`/bookings/customer/${customerEmail}`),
};

// Service pour les allergènes
export const allergenService = {
  getAll: () => api.get('/allergens'),
  getById: (id: string) => api.get(`/allergens/${id}`),
  search: (name: string) => api.get(`/allergens/search?name=${encodeURIComponent(name)}`),
  getByCode: (code: string) => api.get(`/allergens/${code}`),
};

// Service pour les items de menu
export const menuItemService = {
  create: (data: any) => api.post('/menu-items', data),
  getByMenu: (menuId: number) => api.get(`/menu-items/menu/${menuId}`),
  search: (name: string) => api.get(`/menu-items/search?name=${name}`),
  filter: (params: {
    name?: string;
    isVegan?: boolean;
    minPrice?: number;
    maxPrice?: number;
    excludeAllergenIds?: number[];
  }) => {
    const searchParams = new URLSearchParams();
    if (params.name) searchParams.append('name', params.name);
    if (params.isVegan !== undefined) searchParams.append('isVegan', params.isVegan.toString());
    if (params.minPrice !== undefined) searchParams.append('minPrice', params.minPrice.toString());
    if (params.maxPrice !== undefined) searchParams.append('maxPrice', params.maxPrice.toString());
    if (params.excludeAllergenIds) {
      params.excludeAllergenIds.forEach(id => searchParams.append('excludeAllergenIds', id.toString()));
    }
    return api.get(`/menu-items/filter?${searchParams.toString()}`);
  },
  getById: (id: number) => api.get(`/menu-items/${id}`),
  update: (id: number, data: any) => api.put(`/menu-items/${id}`, data),
  delete: (id: number) => api.delete(`/menu-items/${id}`),
};

// Service pour les consultations vétérinaires (Chatbot)
export const veterinaryService = {
  createConsultation: (consultationData: any) => api.post('/veterinary/consultations', consultationData),
  getConsultations: () => api.get('/veterinary/consultations'),
  getConsultation: (id: number) => api.get(`/veterinary/consultations/${id}`),
  updateConsultation: (id: number, consultationData: any) => api.put(`/veterinary/consultations/${id}`, consultationData),
  deleteConsultation: (id: number) => api.delete(`/veterinary/consultations/${id}`),
  
  // Services pour le diagnostic vétérinaire
  createDiagnosis: (diagnosisData: any) => api.post('/veterinary/diagnoses', diagnosisData),
  getSupportedBreeds: () => api.get('/veterinary/breeds'),
  getCommonSymptoms: (breed?: string) => {
    const params = breed ? `?breed=${encodeURIComponent(breed)}` : '';
    return api.get(`/veterinary/symptoms${params}`);
  },
  getDiagnosisHistory: (userId?: string) => {
    const params = userId ? `?userId=${userId}` : '';
    return api.get(`/veterinary/diagnoses${params}`);
  },
  getEmergencySymptoms: () => api.get('/veterinary/symptoms/emergency'),
  getPreventiveRecommendations: (breed: string) => api.get(`/veterinary/preventive/${breed}`),
  getFeedingRecommendations: (breed: string) => api.get(`/veterinary/feeding/${breed}`),
  getBehavioralRecommendations: (breed: string, symptoms: string[]) => 
    api.post(`/veterinary/behavioral/${breed}`, { symptoms }),
  saveConsultationFeedback: (consultationId: number, feedback: any) => 
    api.post(`/veterinary/consultations/${consultationId}/feedback`, feedback),
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
  getLearningStatistics: () => api.get('/chatbot/learning-statistics'),
  getLearningData: () => api.get('/chatbot/learning-data'),
  updateLearningData: (data: any) => api.put('/chatbot/learning-data', data),
  resetLearningData: () => api.delete('/chatbot/learning-data'),
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
  getErrorReports: (params?: any) => api.get('/error-reports', { params }),
  getErrorReport: (id: number) => api.get(`/error-reports/${id}`),
  updateErrorReport: (id: number, errorData: any) => api.put(`/error-reports/${id}`, errorData),
  deleteErrorReport: (id: number) => api.delete(`/error-reports/${id}`),
  getErrorReportsByStatus: (status: string) => api.get(`/error-reports/status/${status}`),
  getErrorStatistics: () => api.get('/error-reports/statistics'),
  getRecentErrors: (hours: number = 24) => api.get(`/error-reports/recent?hours=${hours}`),
  updateErrorStatus: (id: number, status: string) => api.patch(`/error-reports/${id}/status?status=${status}`),
  createBulkErrorReports: (requests: any[]) => api.post('/error-reports/bulk', requests),
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
