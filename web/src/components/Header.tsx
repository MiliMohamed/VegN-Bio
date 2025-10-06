import React from 'react';
import { useAuth } from '../contexts/AuthContext';

const Header: React.FC = () => {
  const { logout } = useAuth();
  
  const handleLogout = () => {
    logout();
    window.location.href = '/login';
  };

  return (
    <header className="header">
      <h1>VegN-Bio</h1>
      <button onClick={handleLogout} className="logout-btn">
        Déconnexion
      </button>
    </header>
  );
};

export default Header;
