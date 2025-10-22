import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider } from './contexts/AuthContext';
import { CartProvider } from './contexts/CartContext';
import { FavoritesProvider } from './contexts/FavoritesContext';
import { ThemeProvider } from './contexts/ThemeContext';
import { NotificationProvider } from './components/NotificationProvider';
import ModernLandingPage from './components/ModernLandingPage';
import ModernLogin from './components/ModernLogin';
import ModernRegister from './components/ModernRegister';
import ModernDashboard from './components/ModernDashboard';
import ModernRestaurants from './components/ModernRestaurants';
import ModernMenus from './components/ModernMenus';
import ModernRooms from './components/ModernRooms';
import ModernEvents from './components/ModernEvents';
import ModernMarketplace from './components/ModernMarketplace';
import ModernReviews from './components/ModernReviews';
import ModernChatbot from './components/ModernChatbot';
import ModernUsers from './components/ModernUsers';
import ModernCart from './components/ModernCart';
import ModernFavorites from './components/ModernFavorites';
import ModernProfile from './components/ModernProfile';
import ModernSettings from './components/ModernSettings';
import ModernHeader from './components/ModernHeader';
import ModernSidebar from './components/ModernSidebar';
import ProtectedRoute from './components/ProtectedRoute';
import './styles/modern-app.css';

function App() {
  return (
    <NotificationProvider>
      <ThemeProvider>
        <AuthProvider>
          <CartProvider>
            <FavoritesProvider>
              <Router>
          <div className="App">
            <Routes>
              <Route path="/" element={<ModernLandingPage />} />
              <Route path="/login" element={<ModernLogin />} />
              <Route path="/register" element={<ModernRegister />} />
              <Route path="/app/*" element={
                <ProtectedRoute>
                  <div className="modern-app-container">
                    <ModernHeader />
                    <ModernSidebar />
                    <div className="modern-main-content">
                      <Routes>
                        <Route path="/dashboard" element={<ModernDashboard />} />
                        <Route path="/restaurants" element={<ModernRestaurants />} />
                        <Route path="/menus" element={<ModernMenus />} />
                        <Route path="/rooms" element={<ModernRooms />} />
                        <Route path="/events" element={<ModernEvents />} />
                        <Route path="/marketplace" element={<ModernMarketplace />} />
                        <Route path="/reviews" element={<ModernReviews />} />
                        <Route path="/chatbot" element={<ModernChatbot />} />
                        <Route path="/users" element={<ModernUsers />} />
                        <Route path="/cart" element={<ModernCart />} />
                        <Route path="/favorites" element={<ModernFavorites />} />
                        <Route path="/profile" element={<ModernProfile />} />
                        <Route path="/settings" element={<ModernSettings />} />
                        <Route path="/" element={<Navigate to="/app/dashboard" replace />} />
                      </Routes>
                    </div>
                  </div>
                </ProtectedRoute>
              } />
            </Routes>
          </div>
          </Router>
        </FavoritesProvider>
      </CartProvider>
    </AuthProvider>
  </ThemeProvider>
</NotificationProvider>
  );
}

export default App;