import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider } from './contexts/AuthContext';
import SimpleLandingPage from './components/SimpleLandingPage';
import SimpleLogin from './components/SimpleLogin';
import SimpleRegister from './components/SimpleRegister';
import Login from './components/Login';
import ModernDashboard from './components/ModernDashboard';
import ModernRestaurants from './components/ModernRestaurants';
import ModernMenus from './components/ModernMenus';
import Events from './components/Events';
import Marketplace from './components/Marketplace';
import ModernEvents from './components/ModernEvents';
import ModernMarketplace from './components/ModernMarketplace';
import Reviews from './components/Reviews';
import SimpleHeader from './components/SimpleHeader';
import SimpleSidebar from './components/SimpleSidebar';
import Header from './components/Header';
import Sidebar from './components/Sidebar';
import ProtectedRoute from './components/ProtectedRoute';
import './styles/landing.css';
import './styles/modern-login.css';
import './styles/modern-app.css';
import './styles/modern-dashboard.css';
import './styles/modern-restaurants.css';
import './styles/modern-menus.css';
import './styles/modern-events-marketplace.css';
import './App.css';

function App() {
  return (
    <AuthProvider>
      <Router>
        <div className="App">
          <Routes>
            <Route path="/" element={<SimpleLandingPage />} />
            <Route path="/login" element={<SimpleLogin />} />
            <Route path="/register" element={<SimpleRegister />} />
            <Route path="/old-login" element={<Login />} />
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
  );
}

export default App;
