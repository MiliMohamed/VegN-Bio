import React from 'react';

const Header: React.FC = () => {
  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('userRole');
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
