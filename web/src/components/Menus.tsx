import React, { useState, useEffect } from 'react';
import { menuService } from '../services/api';
import { useRestaurants } from '../hooks/useRestaurants';

interface MenuItem {
  id: number;
  name: string;
  description: string;
  price: number;
  allergens: string[];
  isVegetarian: boolean;
  isVegan: boolean;
}

interface Menu {
  id: number;
  restaurantId: number;
  title: string;
  activeFrom: string;
  activeTo: string;
  menuItems: MenuItem[];
}

interface CreateMenuData {
  restaurantId: number;
  title: string;
  activeFrom: string;
  activeTo: string;
}

interface CreateMenuItemData {
  menuId: number;
  name: string;
  description: string;
  price: number;
  allergens: string[];
  isVegetarian: boolean;
  isVegan: boolean;
}

const Menus: React.FC = () => {
  const [menus, setMenus] = useState<Menu[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [showCreateForm, setShowCreateForm] = useState(false);
  const [showMenuItemForm, setShowMenuItemForm] = useState(false);
  const [selectedMenuId, setSelectedMenuId] = useState<number | null>(null);
  const [newMenu, setNewMenu] = useState<CreateMenuData>({
    restaurantId: 1,
    title: '',
    activeFrom: '',
    activeTo: ''
  });
  const [newMenuItem, setNewMenuItem] = useState<CreateMenuItemData>({
    menuId: 0,
    name: '',
    description: '',
    price: 0,
    allergens: [],
    isVegetarian: false,
    isVegan: false
  });

  // Hook pour récupérer les restaurants
  const { restaurants, getRestaurantName } = useRestaurants();

  // Vérifier si l'utilisateur peut créer des menus (RESTAURATEUR ou ADMIN)
  const userRole = localStorage.getItem('userRole');
  const canCreateMenus = userRole === 'RESTAURATEUR' || userRole === 'ADMIN';

  useEffect(() => {
    // Attendre que les restaurants soient chargés avant de charger les menus
    if (restaurants.length > 0) {
      fetchMenus();
    }
  }, [restaurants]);

  const fetchMenus = async () => {
    if (restaurants.length === 0) {
      setLoading(false);
      return;
    }

    try {
      setLoading(true);
      setError('');
      // Récupérer les menus de tous les restaurants
      const allMenus: Menu[] = [];
      for (const restaurant of restaurants) {
        try {
          const response = await menuService.getMenusByRestaurant(restaurant.id);
          const restaurantMenus = response.data.map((menu: any) => ({
            ...menu,
            restaurantId: restaurant.id
          }));
          allMenus.push(...restaurantMenus);
        } catch (err) {
          console.warn(`Erreur lors du chargement des menus du restaurant ${restaurant.id}:`, err);
        }
      }
      setMenus(allMenus);
      console.log(`Menus chargés: ${allMenus.length} menus trouvés`);
    } catch (err: any) {
      setError('Erreur lors du chargement des menus');
      console.error('Error fetching menus:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleCreateMenu = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const response = await menuService.create(newMenu);
      setMenus([...menus, response.data]);
      setNewMenu({
        restaurantId: 1,
        title: '',
        activeFrom: '',
        activeTo: ''
      });
      setShowCreateForm(false);
      alert('Menu créé avec succès');
    } catch (err: any) {
      console.error('Erreur lors de la création:', err);
      alert('Erreur lors de la création du menu');
    }
  };

  const handleCreateMenuItem = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      // Convertir les données pour correspondre au backend
      const itemData = {
        menuId: selectedMenuId,
        name: newMenuItem.name,
        description: newMenuItem.description,
        priceCents: Math.round(newMenuItem.price * 100), // Convertir en centimes
        isVegan: newMenuItem.isVegan,
        allergenIds: [] // Pour l'instant, pas d'allergènes
      };
      const response = await menuService.createMenuItem(itemData);
      
      // Mettre à jour le menu dans la liste
      setMenus(menus.map(menu => 
        menu.id === newMenuItem.menuId 
          ? { ...menu, menuItems: [...menu.menuItems, response.data] }
          : menu
      ));
      
      setNewMenuItem({
        menuId: 0,
        name: '',
        description: '',
        price: 0,
        allergens: [],
        isVegetarian: false,
        isVegan: false
      });
      setShowMenuItemForm(false);
      setSelectedMenuId(null);
      alert('Plat ajouté avec succès');
    } catch (err: any) {
      console.error('Erreur lors de la création:', err);
      alert('Erreur lors de l\'ajout du plat');
    }
  };

  const handleDeleteMenu = async (menuId: number) => {
    if (!window.confirm('Êtes-vous sûr de vouloir supprimer ce menu ?')) {
      return;
    }

    try {
      await menuService.delete(menuId);
      setMenus(menus.filter(menu => menu.id !== menuId));
      alert('Menu supprimé avec succès');
    } catch (err: any) {
      console.error('Erreur lors de la suppression:', err);
      alert('Erreur lors de la suppression du menu');
    }
  };

  if (loading) {
    return (
      <div className="loading">
        <p>Chargement des restaurants...</p>
        <p>Restaurants trouvés: {restaurants.length}</p>
        <p>Menus trouvés: {menus.length}</p>
      </div>
    );
  }
  if (error) return <div className="error">{error}</div>;

  return (
    <div className="menus">
      <div className="page-header">
        <h1>Menus</h1>
        {canCreateMenus && (
          <div className="header-actions">
            <button 
              className="btn-primary"
              onClick={() => setShowCreateForm(!showCreateForm)}
            >
              {showCreateForm ? 'Annuler' : 'Créer un menu'}
            </button>
            <button 
              className="btn-secondary"
              onClick={() => setShowMenuItemForm(!showMenuItemForm)}
            >
              {showMenuItemForm ? 'Annuler' : 'Ajouter un plat'}
            </button>
          </div>
        )}
      </div>

      {showCreateForm && canCreateMenus && (
        <div className="create-form">
          <h3>Créer un nouveau menu</h3>
          <form onSubmit={handleCreateMenu}>
            <div className="form-row">
              <div className="form-group">
                <label>Restaurant *</label>
                <select
                  value={newMenu.restaurantId}
                  onChange={(e) => setNewMenu({...newMenu, restaurantId: parseInt(e.target.value)})}
                  required
                >
                  {restaurants.map((restaurant) => (
                    <option key={restaurant.id} value={restaurant.id}>
                      {restaurant.name} - {restaurant.city}
                    </option>
                  ))}
                </select>
              </div>
              
              <div className="form-group">
                <label>Titre du menu *</label>
                <input
                  type="text"
                  value={newMenu.title}
                  onChange={(e) => setNewMenu({...newMenu, title: e.target.value})}
                  required
                />
              </div>
            </div>
            
            <div className="form-row">
              <div className="form-group">
                <label>Actif du *</label>
                <input
                  type="date"
                  value={newMenu.activeFrom}
                  onChange={(e) => setNewMenu({...newMenu, activeFrom: e.target.value})}
                  required
                />
              </div>
              
              <div className="form-group">
                <label>Actif jusqu'au *</label>
                <input
                  type="date"
                  value={newMenu.activeTo}
                  onChange={(e) => setNewMenu({...newMenu, activeTo: e.target.value})}
                  required
                />
              </div>
            </div>
            
            <div className="form-actions">
              <button type="submit" className="btn-primary">Créer le menu</button>
              <button type="button" className="btn-secondary" onClick={() => setShowCreateForm(false)}>
                Annuler
              </button>
            </div>
          </form>
        </div>
      )}

      {showMenuItemForm && canCreateMenus && (
        <div className="create-form">
          <h3>Ajouter un plat</h3>
          <form onSubmit={handleCreateMenuItem}>
            <div className="form-group">
              <label>Menu *</label>
              <select
                value={newMenuItem.menuId}
                onChange={(e) => setNewMenuItem({...newMenuItem, menuId: parseInt(e.target.value)})}
                required
              >
                <option value={0}>Sélectionner un menu</option>
                {menus.map((menu) => (
                  <option key={menu.id} value={menu.id}>
                    {menu.title} - {getRestaurantName(menu.restaurantId)}
                  </option>
                ))}
              </select>
            </div>
            
            <div className="form-row">
              <div className="form-group">
                <label>Nom du plat *</label>
                <input
                  type="text"
                  value={newMenuItem.name}
                  onChange={(e) => setNewMenuItem({...newMenuItem, name: e.target.value})}
                  required
                />
              </div>
              
              <div className="form-group">
                <label>Prix (€) *</label>
                <input
                  type="number"
                  step="0.01"
                  value={newMenuItem.price}
                  onChange={(e) => setNewMenuItem({...newMenuItem, price: parseFloat(e.target.value)})}
                  min="0"
                  required
                />
              </div>
            </div>
            
            <div className="form-group">
              <label>Description *</label>
              <textarea
                value={newMenuItem.description}
                onChange={(e) => setNewMenuItem({...newMenuItem, description: e.target.value})}
                required
              />
            </div>
            
            <div className="form-row">
              <div className="form-group">
                <label>Allergènes</label>
                <input
                  type="text"
                  value={newMenuItem.allergens.join(', ')}
                  onChange={(e) => setNewMenuItem({
                    ...newMenuItem, 
                    allergens: e.target.value.split(',').map(a => a.trim()).filter(a => a)
                  })}
                  placeholder="Ex: Gluten, Lactose, Noix"
                />
              </div>
              
              <div className="form-group">
                <label>Options</label>
                <div className="checkbox-group">
                  <label className="checkbox-label">
                    <input
                      type="checkbox"
                      checked={newMenuItem.isVegetarian}
                      onChange={(e) => setNewMenuItem({...newMenuItem, isVegetarian: e.target.checked})}
                    />
                    Végétarien
                  </label>
                  <label className="checkbox-label">
                    <input
                      type="checkbox"
                      checked={newMenuItem.isVegan}
                      onChange={(e) => setNewMenuItem({...newMenuItem, isVegan: e.target.checked})}
                    />
                    Végan
                  </label>
                </div>
              </div>
            </div>
            
            <div className="form-actions">
              <button type="submit" className="btn-primary">Ajouter le plat</button>
              <button type="button" className="btn-secondary" onClick={() => setShowMenuItemForm(false)}>
                Annuler
              </button>
            </div>
          </form>
        </div>
      )}

      <div className="menus-grid">
        {menus.length === 0 ? (
          <div className="empty-state">
            <p>Aucun menu trouvé</p>
            <p>Restaurants disponibles: {restaurants.length}</p>
            {canCreateMenus && (
              <p>Vous pouvez créer un nouveau menu en cliquant sur "Créer un menu"</p>
            )}
          </div>
        ) : (
          menus.map((menu) => (
            <div key={menu.id} className="menu-card">
              <div className="menu-header">
                <h3>{menu.title}</h3>
                <p><strong>Restaurant:</strong> {getRestaurantName(menu.restaurantId)}</p>
                <p><strong>Période:</strong> {new Date(menu.activeFrom).toLocaleDateString('fr-FR')} - {new Date(menu.activeTo).toLocaleDateString('fr-FR')}</p>
              </div>
              
              <div className="menu-items">
                <h4>Plats ({menu.menuItems.length})</h4>
                {menu.menuItems.length === 0 ? (
                  <p className="no-items">Aucun plat dans ce menu</p>
                ) : (
                  menu.menuItems.map((item) => (
                    <div key={item.id} className="menu-item">
                      <div className="item-info">
                        <h5>{item.name}</h5>
                        <p className="item-description">{item.description}</p>
                        <p className="item-price">{item.price}€</p>
                        {item.allergens.length > 0 && (
                          <p className="allergens">⚠️ Allergènes: {item.allergens.join(', ')}</p>
                        )}
                        <div className="item-badges">
                          {item.isVegan && <span className="badge badge-vegan">Végan</span>}
                          {item.isVegetarian && !item.isVegan && <span className="badge badge-vegetarian">Végétarien</span>}
                        </div>
                      </div>
                    </div>
                  ))
                )}
              </div>
              
              <div className="card-actions">
                <button className="btn-primary">Modifier</button>
                {canCreateMenus && (
                  <button 
                    className="btn-danger"
                    onClick={() => handleDeleteMenu(menu.id)}
                  >
                    Supprimer
                  </button>
                )}
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );
};

export default Menus;