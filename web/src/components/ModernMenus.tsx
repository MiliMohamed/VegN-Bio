import React, { useState, useEffect } from 'react';
import { 
  Utensils, 
  Plus, 
  Edit, 
  Trash2, 
  Search,
  Filter,
  Eye,
  Calendar,
  Clock,
  CheckCircle,
  AlertCircle,
  Building2,
  DollarSign,
  Leaf,
  Star,
  ChefHat
} from 'lucide-react';
import { menuService } from '../services/api';
import { useRestaurants } from '../hooks/useRestaurants';

interface Menu {
  id: number;
  title: string;
  activeFrom: string;
  activeTo: string;
  restaurantId: number;
  menuItems: MenuItem[];
}

interface MenuItem {
  id: number;
  name: string;
  description: string;
  priceCents: number;
  isVegan: boolean;
  allergens: any[];
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
  isVegan: boolean;
  allergens: string[];
}

const ModernMenus: React.FC = () => {
  const [menus, setMenus] = useState<Menu[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [showCreateForm, setShowCreateForm] = useState(false);
  const [showMenuItemForm, setShowMenuItemForm] = useState(false);
  const [selectedMenuId, setSelectedMenuId] = useState<number | null>(null);
  const [editingMenu, setEditingMenu] = useState<Menu | null>(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [filterRestaurant, setFilterRestaurant] = useState('');
  const [newMenu, setNewMenu] = useState<CreateMenuData>({
    restaurantId: 0,
    title: '',
    activeFrom: '',
    activeTo: ''
  });
  const [newMenuItem, setNewMenuItem] = useState<CreateMenuItemData>({
    menuId: 0,
    name: '',
    description: '',
    price: 0,
    isVegan: false,
    allergens: []
  });

  const { restaurants, loading: restaurantsLoading } = useRestaurants();

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
        restaurantId: 0,
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

  const handleDeleteMenu = async (id: number) => {
    if (!window.confirm('Êtes-vous sûr de vouloir supprimer ce menu ?')) {
      return;
    }

    try {
      await menuService.delete(id);
      setMenus(menus.filter(menu => menu.id !== id));
      alert('Menu supprimé avec succès');
    } catch (err: any) {
      console.error('Erreur lors de la suppression:', err);
      alert('Erreur lors de la suppression du menu');
    }
  };

  const getRestaurantName = (restaurantId: number): string => {
    const restaurant = restaurants.find(r => r.id === restaurantId);
    return restaurant ? restaurant.name : `Restaurant #${restaurantId}`;
  };

  const formatPrice = (priceCents: number): string => {
    return `€${(priceCents / 100).toFixed(2)}`;
  };

  // Filtrer les menus
  const filteredMenus = menus.filter(menu => {
    const matchesSearch = menu.title.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesRestaurant = filterRestaurant === '' || menu.restaurantId.toString() === filterRestaurant;
    return matchesSearch && matchesRestaurant;
  });

  if (loading || restaurantsLoading) {
    return (
      <div className="modern-menus">
        <div className="loading-container">
          <div className="loading-spinner">
            <Utensils className="spinner-icon" />
            <p>Chargement des menus...</p>
          </div>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="modern-menus">
        <div className="error-container">
          <AlertCircle className="error-icon" />
          <h3>Erreur de chargement</h3>
          <p>{error}</p>
          <button className="btn btn-primary" onClick={fetchMenus}>
            Réessayer
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="modern-menus">
      {/* Header Section */}
      <div className="menus-header">
        <div className="header-content">
          <div className="header-info">
            <h1 className="page-title">
              <Utensils className="title-icon" />
              Menus
            </h1>
            <p className="page-subtitle">
              Gérez vos menus et plats végétariens
            </p>
          </div>
          <div className="header-stats">
            <div className="stat-item">
              <div className="stat-value">{menus.length}</div>
              <div className="stat-label">Menus</div>
            </div>
            <div className="stat-item">
              <div className="stat-value">{menus.reduce((acc, menu) => acc + menu.menuItems.length, 0)}</div>
              <div className="stat-label">Plats</div>
            </div>
            <div className="stat-item">
              <div className="stat-value">100%</div>
              <div className="stat-label">Bio</div>
            </div>
          </div>
        </div>
        {canCreateMenus && (
          <div className="header-actions">
            <button 
              className="btn btn-outline-primary"
              onClick={() => setShowMenuItemForm(!showMenuItemForm)}
            >
              <Plus className="btn-icon" />
              Ajouter un plat
            </button>
            <button 
              className="btn btn-primary btn-lg"
              onClick={() => setShowCreateForm(!showCreateForm)}
            >
              <Plus className="btn-icon" />
              Nouveau Menu
            </button>
          </div>
        )}
      </div>

      {/* Filters and Search */}
      <div className="menus-filters">
        <div className="search-section">
          <div className="search-input-group">
            <Search className="search-icon" />
            <input
              type="text"
              className="search-input"
              placeholder="Rechercher par nom de menu..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
            />
          </div>
        </div>
        <div className="filter-section">
          <div className="filter-group">
            <Filter className="filter-icon" />
            <select
              className="filter-select"
              value={filterRestaurant}
              onChange={(e) => setFilterRestaurant(e.target.value)}
            >
              <option value="">Tous les restaurants</option>
              {restaurants.map(restaurant => (
                <option key={restaurant.id} value={restaurant.id}>
                  {restaurant.name}
                </option>
              ))}
            </select>
          </div>
        </div>
      </div>

      {/* Create Menu Form */}
      {showCreateForm && canCreateMenus && (
        <div className="menu-form-container">
          <div className="content-card">
            <div className="content-card-header">
              <h3 className="content-card-title">Créer un nouveau menu</h3>
              <button className="btn btn-outline-secondary" onClick={() => setShowCreateForm(false)}>
                Annuler
              </button>
            </div>
            <div className="content-card-body">
              <form onSubmit={handleCreateMenu}>
                <div className="row g-3">
                  <div className="col-md-6">
                    <div className="form-group">
                      <label className="form-label">Restaurant *</label>
                      <select
                        className="form-control"
                        value={newMenu.restaurantId}
                        onChange={(e) => setNewMenu({...newMenu, restaurantId: parseInt(e.target.value)})}
                        required
                      >
                        <option value={0}>Sélectionner un restaurant</option>
                        {restaurants.map((restaurant) => (
                          <option key={restaurant.id} value={restaurant.id}>
                            {restaurant.name} - {restaurant.city}
                          </option>
                        ))}
                      </select>
                    </div>
                  </div>
                  <div className="col-md-6">
                    <div className="form-group">
                      <label className="form-label">Titre du Menu *</label>
                      <input
                        type="text"
                        className="form-control"
                        value={newMenu.title}
                        onChange={(e) => setNewMenu({...newMenu, title: e.target.value})}
                        placeholder="ex: Menu Automne Bio"
                        required
                      />
                    </div>
                  </div>
                  <div className="col-md-6">
                    <div className="form-group">
                      <label className="form-label">Actif du *</label>
                      <input
                        type="date"
                        className="form-control"
                        value={newMenu.activeFrom}
                        onChange={(e) => setNewMenu({...newMenu, activeFrom: e.target.value})}
                        required
                      />
                    </div>
                  </div>
                  <div className="col-md-6">
                    <div className="form-group">
                      <label className="form-label">Actif jusqu'au *</label>
                      <input
                        type="date"
                        className="form-control"
                        value={newMenu.activeTo}
                        onChange={(e) => setNewMenu({...newMenu, activeTo: e.target.value})}
                        required
                      />
                    </div>
                  </div>
                </div>
                <div className="form-actions">
                  <button type="submit" className="btn btn-primary">
                    <CheckCircle className="btn-icon" />
                    Créer le Menu
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      )}

      {/* Create Menu Item Form */}
      {showMenuItemForm && canCreateMenus && (
        <div className="menu-form-container">
          <div className="content-card">
            <div className="content-card-header">
              <h3 className="content-card-title">Ajouter un plat</h3>
              <button className="btn btn-outline-secondary" onClick={() => setShowMenuItemForm(false)}>
                Annuler
              </button>
            </div>
            <div className="content-card-body">
              <form onSubmit={handleCreateMenuItem}>
                <div className="row g-3">
                  <div className="col-md-6">
                    <div className="form-group">
                      <label className="form-label">Menu *</label>
                      <select
                        className="form-control"
                        value={selectedMenuId || ''}
                        onChange={(e) => {
                          const menuId = parseInt(e.target.value);
                          setSelectedMenuId(menuId);
                          setNewMenuItem({...newMenuItem, menuId});
                        }}
                        required
                      >
                        <option value="">Sélectionner un menu</option>
                        {menus.map((menu) => (
                          <option key={menu.id} value={menu.id}>
                            {menu.title} - {getRestaurantName(menu.restaurantId)}
                          </option>
                        ))}
                      </select>
                    </div>
                  </div>
                  <div className="col-md-6">
                    <div className="form-group">
                      <label className="form-label">Nom du Plat *</label>
                      <input
                        type="text"
                        className="form-control"
                        value={newMenuItem.name}
                        onChange={(e) => setNewMenuItem({...newMenuItem, name: e.target.value})}
                        placeholder="ex: Burger Tofu Bio"
                        required
                      />
                    </div>
                  </div>
                  <div className="col-md-6">
                    <div className="form-group">
                      <label className="form-label">Prix (€) *</label>
                      <input
                        type="number"
                        step="0.01"
                        min="0"
                        className="form-control"
                        value={newMenuItem.price}
                        onChange={(e) => setNewMenuItem({...newMenuItem, price: parseFloat(e.target.value)})}
                        placeholder="12.90"
                        required
                      />
                    </div>
                  </div>
                  <div className="col-md-6">
                    <div className="form-group">
                      <label className="form-label">Vegan</label>
                      <div className="form-check">
                        <input
                          type="checkbox"
                          className="form-check-input"
                          checked={newMenuItem.isVegan}
                          onChange={(e) => setNewMenuItem({...newMenuItem, isVegan: e.target.checked})}
                        />
                        <label className="form-check-label">
                          <Leaf className="form-check-icon" />
                          Plat 100% végétalien
                        </label>
                      </div>
                    </div>
                  </div>
                  <div className="col-12">
                    <div className="form-group">
                      <label className="form-label">Description</label>
                      <textarea
                        className="form-control"
                        rows={3}
                        value={newMenuItem.description}
                        onChange={(e) => setNewMenuItem({...newMenuItem, description: e.target.value})}
                        placeholder="Décrivez ce plat délicieux..."
                      />
                    </div>
                  </div>
                </div>
                <div className="form-actions">
                  <button type="submit" className="btn btn-primary">
                    <CheckCircle className="btn-icon" />
                    Ajouter le Plat
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      )}

      {/* Menus Grid */}
      <div className="menus-grid">
        {filteredMenus.length === 0 ? (
          <div className="empty-state">
            <Utensils className="empty-icon" />
            <h3>Aucun menu trouvé</h3>
            <p>
              {searchTerm || filterRestaurant 
                ? 'Aucun menu ne correspond à vos critères de recherche.'
                : 'Commencez par créer votre premier menu.'
              }
            </p>
            {canCreateMenus && !searchTerm && !filterRestaurant && (
              <button 
                className="btn btn-primary"
                onClick={() => setShowCreateForm(true)}
              >
                <Plus className="btn-icon" />
                Créer le premier menu
              </button>
            )}
          </div>
        ) : (
          <div className="row g-4">
            {filteredMenus.map((menu) => (
              <div key={menu.id} className="col-lg-4 col-md-6">
                <div className="menu-card">
                  <div className="menu-header">
                    <div className="menu-info">
                      <h3 className="menu-title">{menu.title}</h3>
                      <div className="menu-restaurant">
                        <Building2 className="restaurant-icon" />
                        {getRestaurantName(menu.restaurantId)}
                      </div>
                    </div>
                    <div className="menu-status">
                      <div className="status-badge active">
                        <CheckCircle className="status-icon" />
                        Actif
                      </div>
                    </div>
                  </div>
                  
                  <div className="menu-period">
                    <div className="period-item">
                      <Calendar className="period-icon" />
                      <div className="period-content">
                        <div className="period-label">Du</div>
                        <div className="period-value">{new Date(menu.activeFrom).toLocaleDateString('fr-FR')}</div>
                      </div>
                    </div>
                    <div className="period-item">
                      <Clock className="period-icon" />
                      <div className="period-content">
                        <div className="period-label">Au</div>
                        <div className="period-value">{new Date(menu.activeTo).toLocaleDateString('fr-FR')}</div>
                      </div>
                    </div>
                  </div>
                  
                  <div className="menu-items">
                    <div className="menu-items-header">
                      <ChefHat className="items-icon" />
                      <span>Plats ({menu.menuItems.length})</span>
                    </div>
                    <div className="items-list">
                      {menu.menuItems.slice(0, 3).map((item) => (
                        <div key={item.id} className="menu-item">
                          <div className="item-info">
                            <div className="item-name">{item.name}</div>
                            <div className="item-description">{item.description}</div>
                            {item.isVegan && (
                              <div className="item-vegan">
                                <Leaf className="vegan-icon" />
                                Vegan
                              </div>
                            )}
                          </div>
                          <div className="item-price">{formatPrice(item.priceCents)}</div>
                        </div>
                      ))}
                      {menu.menuItems.length > 3 && (
                        <div className="more-items">
                          +{menu.menuItems.length - 3} autres plats
                        </div>
                      )}
                    </div>
                  </div>
                  
                  {canCreateMenus && (
                    <div className="menu-actions">
                      <button 
                        className="btn btn-outline-primary btn-sm"
                        onClick={() => {
                          setSelectedMenuId(menu.id);
                          setNewMenuItem({...newMenuItem, menuId: menu.id});
                          setShowMenuItemForm(true);
                        }}
                      >
                        <Plus className="btn-icon" />
                        Ajouter Plat
                      </button>
                      <button 
                        className="btn btn-outline-secondary btn-sm"
                        onClick={() => {/* View details */}}
                      >
                        <Eye className="btn-icon" />
                        Voir
                      </button>
                      <button 
                        className="btn btn-outline-danger btn-sm"
                        onClick={() => handleDeleteMenu(menu.id)}
                      >
                        <Trash2 className="btn-icon" />
                        Supprimer
                      </button>
                    </div>
                  )}
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};

export default ModernMenus;
