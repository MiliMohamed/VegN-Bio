import React, { useState, useEffect } from 'react';
import { marketplaceService } from '../services/api';

interface MarketplaceItem {
  id: number;
  supplierId: number;
  supplierName: string;
  title: string;
  description: string;
  unitPriceCents: number;
  unit: string;
  status: string;
  createdAt: string;
  updatedAt: string;
}

const Marketplace: React.FC = () => {
  const [items, setItems] = useState<MarketplaceItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    fetchMarketplaceItems();
  }, []);

  const fetchMarketplaceItems = async () => {
    try {
      setLoading(true);
      const response = await marketplaceService.getOffers();
      setItems(response.data);
    } catch (err: any) {
      setError('Erreur lors du chargement des articles');
      console.error('Error fetching marketplace items:', err);
    } finally {
      setLoading(false);
    }
  };

  if (loading) return <div className="loading">Chargement...</div>;
  if (error) return <div className="error">{error}</div>;

  return (
    <div className="marketplace">
      <div className="page-header">
        <h1>Marketplace</h1>
        <div className="header-actions">
          <input 
            type="text" 
            placeholder="Rechercher..." 
            className="search-input"
          />
          <select className="category-filter">
            <option value="">Toutes les catégories</option>
            <option value="vegetables">Légumes</option>
            <option value="fruits">Fruits</option>
            <option value="grains">Céréales</option>
            <option value="dairy">Produits laitiers</option>
          </select>
        </div>
      </div>
      
      <div className="marketplace-grid">
        {items.length === 0 ? (
          <div className="empty-state">
            <p>Aucun article trouvé</p>
          </div>
        ) : (
          items.map((item) => (
            <div key={item.id} className="marketplace-card">
              <div className="card-image">
                <div className="placeholder-image">🛒</div>
              </div>
              <div className="card-content">
                <h3>{item.title}</h3>
                <p className="item-description">{item.description}</p>
                <p className="item-supplier">Fournisseur: {item.supplierName}</p>
                <p className="item-unit">Unité: {item.unit}</p>
                <p className="item-status">Statut: {item.status}</p>
                <p className="item-price">Prix: {(item.unitPriceCents / 100).toFixed(2)}€/{item.unit}</p>
                <div className="card-actions">
                  <button className="btn-primary">Commander</button>
                  <button className="btn-secondary">Détails</button>
                </div>
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );
};

export default Marketplace;
