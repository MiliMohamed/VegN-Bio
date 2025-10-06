import React from 'react';

const Dashboard: React.FC = () => {
  return (
    <div className="dashboard">
      <h1>Tableau de bord</h1>
      
      <div className="stats-grid">
        <div className="stat-card">
          <h3>Restaurants</h3>
          <div className="number">5</div>
        </div>
        
        <div className="stat-card">
          <h3>Menus</h3>
          <div className="number">12</div>
        </div>
        
        <div className="stat-card">
          <h3>Événements</h3>
          <div className="number">8</div>
        </div>
        
        <div className="stat-card">
          <h3>Avis</h3>
          <div className="number">24</div>
        </div>
      </div>
      
      <div style={{ background: 'white', padding: '2rem', borderRadius: '10px', boxShadow: '0 2px 10px rgba(0,0,0,0.1)' }}>
        <h2>Bienvenue sur VegN-Bio</h2>
        <p>Gérez vos restaurants, menus, événements et plus encore depuis ce tableau de bord.</p>
      </div>
    </div>
  );
};

export default Dashboard;
