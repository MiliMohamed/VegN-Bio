import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import Login from './components/Login';
import Dashboard from './components/Dashboard';
import Restaurants from './components/Restaurants';
import Menus from './components/Menus';
import Events from './components/Events';
import Marketplace from './components/Marketplace';
import Reviews from './components/Reviews';
import Header from './components/Header';
import Sidebar from './components/Sidebar';
import './App.css';

function App() {
  const isAuthenticated = localStorage.getItem('token');

  return (
    <Router>
      <div className="App">
        {isAuthenticated ? (
          <div className="app-container">
            <Header />
            <div className="main-content">
              <Sidebar />
              <main className="content">
                <Routes>
                  <Route path="/dashboard" element={<Dashboard />} />
                  <Route path="/restaurants" element={<Restaurants />} />
                  <Route path="/menus" element={<Menus />} />
                  <Route path="/events" element={<Events />} />
                  <Route path="/marketplace" element={<Marketplace />} />
                  <Route path="/reviews" element={<Reviews />} />
                  <Route path="/" element={<Navigate to="/dashboard" />} />
                </Routes>
              </main>
            </div>
          </div>
        ) : (
          <Routes>
            <Route path="/login" element={<Login />} />
            <Route path="*" element={<Navigate to="/login" />} />
          </Routes>
        )}
      </div>
    </Router>
  );
}

export default App;
