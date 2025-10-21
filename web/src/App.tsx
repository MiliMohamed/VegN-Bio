import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider } from './contexts/AuthContext';
import { NotificationProvider } from './components/NotificationProvider';
import SimpleLandingPage from './components/SimpleLandingPage';
import SimpleLogin from './components/SimpleLogin';
import SimpleRegister from './components/SimpleRegister';
import ProfessionalDashboard from './components/ProfessionalDashboard';
import ModernRestaurants from './components/ModernRestaurants';
import ModernMenus from './components/ModernMenus';
import ModernRooms from './components/ModernRooms';
import ModernEvents from './components/ModernEvents';
import ModernMarketplace from './components/ModernMarketplace';
import ProfessionalReviews from './components/ProfessionalReviews';
import ProfessionalChatbot from './components/ProfessionalChatbot';
import ProfessionalUsers from './components/ProfessionalUsers';
import ProfessionalHeader from './components/ProfessionalHeader';
import ProfessionalSidebar from './components/ProfessionalSidebar';
import ProtectedRoute from './components/ProtectedRoute';
import './styles/app-reset.css';
import './styles/landing.css';
import './styles/modern-login.css';
import './styles/modern-app.css';
import './styles/modern-dashboard.css';
import './styles/modern-restaurants.css';
import './styles/modern-menus.css';
import './styles/modern-events-marketplace.css';
import './styles/modern-unified.css';
import './styles/professional-dashboard.css';
import './styles/professional-sidebar.css';
import './styles/professional-header.css';
import './styles/professional-app.css';
import './styles/professional-reviews.css';
import './styles/professional-chatbot.css';
import './styles/professional-users.css';

function App() {
  return (
    <NotificationProvider>
      <AuthProvider>
        <Router>
        <div className="App">
          <Routes>
            <Route path="/" element={<SimpleLandingPage />} />
            <Route path="/login" element={<SimpleLogin />} />
            <Route path="/register" element={<SimpleRegister />} />
            <Route path="/app/*" element={
              <ProtectedRoute>
                <div className="professional-app-container">
                  <ProfessionalHeader />
                  <ProfessionalSidebar />
                  <div className="professional-main-content">
                    <Routes>
                      <Route path="/dashboard" element={<ProfessionalDashboard />} />
                      <Route path="/restaurants" element={<ModernRestaurants />} />
                      <Route path="/menus" element={<ModernMenus />} />
                      <Route path="/rooms" element={<ModernRooms />} />
                      <Route path="/events" element={<ModernEvents />} />
                      <Route path="/marketplace" element={<ModernMarketplace />} />
                      <Route path="/reviews" element={<ProfessionalReviews />} />
                      <Route path="/chatbot" element={<ProfessionalChatbot />} />
                      <Route path="/users" element={<ProfessionalUsers />} />
                      <Route path="/" element={<Navigate to="/app/dashboard" replace />} />
                    </Routes>
                  </div>
                </div>
              </ProtectedRoute>
            } />
          </Routes>
        </div>
      </Router>
    </AuthProvider>
    </NotificationProvider>
  );
}

export default App;
