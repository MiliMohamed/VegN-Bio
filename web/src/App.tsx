import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider } from './contexts/AuthContext';
import { NotificationProvider } from './components/NotificationProvider';
import SimpleLandingPage from './components/SimpleLandingPage';
import SimpleLogin from './components/SimpleLogin';
import SimpleRegister from './components/SimpleRegister';
import ModernDashboard from './components/ModernDashboard';
import ModernRestaurants from './components/ModernRestaurants';
import ModernMenus from './components/ModernMenus';
import ModernEvents from './components/ModernEvents';
import ModernMarketplace from './components/ModernMarketplace';
import Reviews from './components/Reviews';
import SimpleHeader from './components/SimpleHeader';
import SimpleSidebar from './components/SimpleSidebar';
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
                <div className="modern-app-container">
                  <SimpleHeader />
                  <SimpleSidebar />
                  <div className="main-content">
                    <Routes>
                      <Route path="/dashboard" element={<ModernDashboard />} />
                      <Route path="/restaurants" element={<ModernRestaurants />} />
                      <Route path="/menus" element={<ModernMenus />} />
                      <Route path="/events" element={<ModernEvents />} />
                      <Route path="/marketplace" element={<ModernMarketplace />} />
                      <Route path="/reviews" element={<Reviews />} />
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
