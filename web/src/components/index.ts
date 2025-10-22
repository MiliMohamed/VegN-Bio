// ===== MODERN COMPONENTS EXPORTS =====

// Core Components
export { default as ModernModal } from './ModernModal';
export { ConfirmModal, FormModal, InfoModal } from './ModernModal';

export { default as ActionButton } from './ActionButton';
export { 
  ActionGroup, 
  TableRowActions, 
  CreateAction, 
  ConfirmAction, 
  StatusAction 
} from './ActionButton';

export { default as ModernTable } from './ModernTable';
export { default as FloatingActionButton } from './FloatingActionButton';
export { default as ModernNavigation } from './ModernNavigation';

// Layout Components
export { default as ModernHeader } from './ModernHeader';
export { default as ModernSidebar } from './ModernSidebar';
export { default as ModernDashboard } from './ModernDashboard';

// Auth Components
export { default as ModernLogin } from './ModernLogin';
export { default as ModernRegister } from './ModernRegister';

// Feature Components
export { default as ModernRestaurants } from './ModernRestaurants';
export { default as ModernMenus } from './ModernMenus';
export { default as ModernRooms } from './ModernRooms';
export { default as ModernEvents } from './ModernEvents';
export { default as ModernMarketplace } from './ModernMarketplace';
export { default as ModernReviews } from './ModernReviews';
export { default as ModernChatbot } from './ModernChatbot';
export { default as ModernUsers } from './ModernUsers';
export { default as ModernCart } from './ModernCart';
export { default as ModernFavorites } from './ModernFavorites';
export { default as ModernProfile } from './ModernProfile';
export { default as ModernSettings } from './ModernSettings';

// Utility Components
export { default as NotificationProvider } from './NotificationProvider';
export { default as ProtectedRoute } from './ProtectedRoute';

// Context Providers
export { AuthProvider, useAuth } from '../contexts/AuthContext';
export { CartProvider, useCart } from '../contexts/CartContext';
export { FavoritesProvider, useFavorites } from '../contexts/FavoritesContext';
export { ThemeProvider, useTheme } from '../contexts/ThemeContext';

// Services
export { default as apiService } from '../services/api';
export { authService, restaurantService, eventService, feedbackService } from '../services/api';

// Types
export type { ActionButtonProps } from './ActionButton';
export type { ModalProps } from './ModernModal';
export type { Column } from './ModernTable';
export type { ModernTableProps } from './ModernTable';
