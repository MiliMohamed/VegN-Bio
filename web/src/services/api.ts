import axios from 'axios';

const API_BASE_URL = 'http://localhost:8080/api/v1';

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
  getByRestaurant: (restaurantId: number) => api.get(`/menus/restaurant/${restaurantId}`),
  getActiveByRestaurant: (restaurantId: number, date?: string) => {
    const params = date ? `?date=${date}` : '';
    return api.get(`/menus/restaurant/${restaurantId}/active${params}`);
  },
  create: (menuData: any) => api.post('/menus', menuData),
};

export const eventService = {
  getAll: () => api.get('/events'),
  getById: (id: number) => api.get(`/events/${id}`),
  create: (eventData: any) => api.post('/events', eventData),
  update: (id: number, eventData: any) => api.put(`/events/${id}`, eventData),
  delete: (id: number) => api.delete(`/events/${id}`),
};

export const marketplaceService = {
  getOffers: (search?: string) => {
    const params = search ? `?search=${encodeURIComponent(search)}` : '';
    return api.get(`/offers${params}`);
  },
  getOffersBySupplier: (supplierId: number) => api.get(`/offers/supplier/${supplierId}`),
  getSuppliers: (search?: string) => {
    const params = search ? `?search=${encodeURIComponent(search)}` : '';
    return api.get(`/suppliers${params}`);
  },
  getAllSuppliers: () => api.get('/suppliers/all'),
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

export default api;
