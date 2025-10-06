import React, { useState, useEffect } from 'react';
import { menuService } from '../services/api';

interface MenuItem {
  id: number;
  name: string;
  description: string;
  priceCents: number;
  isVegan: boolean;
  allergens: Array<{
    id: number;
    code: string;
    label: string;
  }>;
}

interface Menu {
  id: number;
  title: string;
  activeFrom: string;
  activeTo: string;
  menuItems: MenuItem[];
}

const Menus: React.FC = () => {
  const [menus, setMenus] = useState<Menu[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    fetchMenus();
  }, []);

  const fetchMenus = async () => {
    try {
      setLoading(true);
      // Pour l'instant, on récupère les menus du premier restaurant
      const response = await menuService.getByRestaurant(1);
      setMenus(response.data);
    } catch (err: any) {
      setError('Erreur lors du chargement des menus');
      console.error('Error fetching menus:', err);
    } finally {
      setLoading(false);
    }
  };

  if (loading) return <div className="loading">Chargement...</div>;
  if (error) return <div className="error">{error}</div>;

  return (
    <div className="menus">
      <div className="page-header">
        <h1>Menus</h1>
        <button className="btn-primary">Ajouter un menu</button>
      </div>
      
      <div className="menus-grid">
        {menus.length === 0 ? (
          <div className="empty-state">
            <p>Aucun menu trouvé</p>
          </div>
        ) : (
          menus.map((menu) => (
            <div key={menu.id} className="menu-card">
              <h3>{menu.title}</h3>
              <p className="menu-dates">
                Du {new Date(menu.activeFrom).toLocaleDateString('fr-FR')} au {new Date(menu.activeTo).toLocaleDateString('fr-FR')}
              </p>
              <div className="menu-items">
                {menu.menuItems.map((item) => (
                  <div key={item.id} className="menu-item">
                    <h4>{item.name}</h4>
                    <p className="item-description">{item.description}</p>
                    <p className="item-price">Prix: {(item.priceCents / 100).toFixed(2)}€</p>
                    <p className="item-vegan">{item.isVegan ? '🌱 Végan' : '🍽️ Non-végan'}</p>
                    {item.allergens.length > 0 && (
                      <p className="item-allergens">
                        Allergènes: {item.allergens.map(a => a.label).join(', ')}
                      </p>
                    )}
                  </div>
                ))}
              </div>
              <div className="card-actions">
                <button className="btn-secondary">Modifier</button>
                <button className="btn-danger">Supprimer</button>
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );
};

export default Menus;
