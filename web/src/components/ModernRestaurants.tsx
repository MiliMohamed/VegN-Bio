import React, { useState, useEffect } from 'react';
import { 
  Building2, 
  MapPin, 
  Phone, 
  Mail, 
  Plus, 
  Edit, 
  Trash2, 
  Search,
  Filter,
  Eye,
  Star,
  Users,
  Clock,
  CheckCircle,
  AlertCircle,
  MoreVertical
} from 'lucide-react';
import { restaurantService } from '../services/api';

interface Restaurant {
  id: number;
  name: string;
  code: string;
  city: string;
  address?: string;
  phone?: string;
  email?: string;
}

interface CreateRestaurantData {
  name: string;
  code: string;
  city: string;
  address: string;
  phone: string;
  email: string;
}

const ModernRestaurants: React.FC = () => {
  const [restaurants, setRestaurants] = useState<Restaurant[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [showCreateForm, setShowCreateForm] = useState(false);
  const [editingRestaurant, setEditingRestaurant] = useState<Restaurant | null>(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [filterCity, setFilterCity] = useState('');
  const [newRestaurant, setNewRestaurant] = useState<CreateRestaurantData>({
    name: '',
    code: '',
    city: '',
    address: '',
    phone: '',
    email: ''
  });

  // Vérifier si l'utilisateur peut gérer les restaurants (ADMIN seulement)
  const userRole = localStorage.getItem('userRole');
  const canManageRestaurants = userRole === 'ADMIN';

  useEffect(() => {
    fetchRestaurants();
  }, []);

  const fetchRestaurants = async () => {
    try {
      setLoading(true);
      setError('');
      const response = await restaurantService.getAll();
      setRestaurants(response.data);
    } catch (err: any) {
      setError('Erreur lors du chargement des restaurants');
      console.error('Error fetching restaurants:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleCreateRestaurant = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const response = await restaurantService.create(newRestaurant);
      setRestaurants([...restaurants, response.data]);
      setNewRestaurant({
        name: '',
        code: '',
        city: '',
        address: '',
        phone: '',
        email: ''
      });
      setShowCreateForm(false);
      alert('Restaurant créé avec succès');
    } catch (err: any) {
      console.error('Erreur lors de la création:', err);
      alert('Erreur lors de la création du restaurant');
    }
  };

  const handleUpdateRestaurant = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!editingRestaurant) return;

    try {
      const response = await restaurantService.update(editingRestaurant.id, editingRestaurant);
      setRestaurants(restaurants.map(r => 
        r.id === editingRestaurant.id ? response.data : r
      ));
      setEditingRestaurant(null);
      alert('Restaurant mis à jour avec succès');
    } catch (err: any) {
      console.error('Erreur lors de la mise à jour:', err);
      alert('Erreur lors de la mise à jour du restaurant');
    }
  };

  const handleDeleteRestaurant = async (id: number) => {
    if (!window.confirm('Êtes-vous sûr de vouloir supprimer ce restaurant ?')) {
      return;
    }

    try {
      await restaurantService.delete(id);
      setRestaurants(restaurants.filter(r => r.id !== id));
      alert('Restaurant supprimé avec succès');
    } catch (err: any) {
      console.error('Erreur lors de la suppression:', err);
      alert('Erreur lors de la suppression du restaurant');
    }
  };

  const startEdit = (restaurant: Restaurant) => {
    setEditingRestaurant({ ...restaurant });
    setShowCreateForm(false);
  };

  const cancelEdit = () => {
    setEditingRestaurant(null);
    setNewRestaurant({
      name: '',
      code: '',
      city: '',
      address: '',
      phone: '',
      email: ''
    });
  };

  // Filtrer les restaurants
  const filteredRestaurants = restaurants.filter(restaurant => {
    const matchesSearch = restaurant.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         restaurant.code.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         restaurant.city.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesCity = filterCity === '' || restaurant.city === filterCity;
    return matchesSearch && matchesCity;
  });

  const cities = Array.from(new Set(restaurants.map(r => r.city)));

  if (loading) {
    return (
      <div className="modern-restaurants">
        <div className="loading-container">
          <div className="loading-spinner">
            <Building2 className="spinner-icon" />
            <p>Chargement des restaurants...</p>
          </div>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="modern-restaurants">
        <div className="error-container">
          <AlertCircle className="error-icon" />
          <h3>Erreur de chargement</h3>
          <p>{error}</p>
          <button className="btn btn-primary" onClick={fetchRestaurants}>
            Réessayer
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="modern-restaurants">
      {/* Header Section */}
      <div className="restaurants-header">
        <div className="header-content">
          <div className="header-info">
            <h1 className="page-title">
              <Building2 className="title-icon" />
              Restaurants
            </h1>
            <p className="page-subtitle">
              Gérez vos restaurants et leurs informations
            </p>
          </div>
          <div className="header-stats">
            <div className="stat-item">
              <div className="stat-value">{restaurants.length}</div>
              <div className="stat-label">Total</div>
            </div>
            <div className="stat-item">
              <div className="stat-value">{cities.length}</div>
              <div className="stat-label">Villes</div>
            </div>
            <div className="stat-item">
              <div className="stat-value">100%</div>
              <div className="stat-label">Bio</div>
            </div>
          </div>
        </div>
        {canManageRestaurants && (
          <button 
            className="btn btn-primary btn-lg"
            onClick={() => setShowCreateForm(!showCreateForm)}
          >
            <Plus className="btn-icon" />
            Nouveau Restaurant
          </button>
        )}
      </div>

      {/* Filters and Search */}
      <div className="restaurants-filters">
        <div className="search-section">
          <div className="search-input-group">
            <Search className="search-icon" />
            <input
              type="text"
              className="search-input"
              placeholder="Rechercher par nom, code ou ville..."
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
              value={filterCity}
              onChange={(e) => setFilterCity(e.target.value)}
            >
              <option value="">Toutes les villes</option>
              {cities.map(city => (
                <option key={city} value={city}>{city}</option>
              ))}
            </select>
          </div>
        </div>
      </div>

      {/* Create/Edit Form */}
      {(showCreateForm || editingRestaurant) && canManageRestaurants && (
        <div className="restaurant-form-container">
          <div className="content-card">
            <div className="content-card-header">
              <h3 className="content-card-title">
                {editingRestaurant ? 'Modifier le Restaurant' : 'Nouveau Restaurant'}
              </h3>
              <button className="btn btn-outline-secondary" onClick={cancelEdit}>
                Annuler
              </button>
            </div>
            <div className="content-card-body">
              <form onSubmit={editingRestaurant ? handleUpdateRestaurant : handleCreateRestaurant}>
                <div className="row g-3">
                  <div className="col-md-6">
                    <div className="form-group">
                      <label className="form-label">Nom du Restaurant *</label>
                      <input
                        type="text"
                        className="form-control"
                        value={editingRestaurant ? editingRestaurant.name : newRestaurant.name}
                        onChange={(e) => editingRestaurant 
                          ? setEditingRestaurant({...editingRestaurant, name: e.target.value})
                          : setNewRestaurant({...newRestaurant, name: e.target.value})
                        }
                        required
                      />
                    </div>
                  </div>
                  <div className="col-md-6">
                    <div className="form-group">
                      <label className="form-label">Code *</label>
                      <input
                        type="text"
                        className="form-control"
                        value={editingRestaurant ? editingRestaurant.code : newRestaurant.code}
                        onChange={(e) => editingRestaurant 
                          ? setEditingRestaurant({...editingRestaurant, code: e.target.value})
                          : setNewRestaurant({...newRestaurant, code: e.target.value})
                        }
                        required
                      />
                    </div>
                  </div>
                  <div className="col-md-6">
                    <div className="form-group">
                      <label className="form-label">Ville *</label>
                      <input
                        type="text"
                        className="form-control"
                        value={editingRestaurant ? editingRestaurant.city : newRestaurant.city}
                        onChange={(e) => editingRestaurant 
                          ? setEditingRestaurant({...editingRestaurant, city: e.target.value})
                          : setNewRestaurant({...newRestaurant, city: e.target.value})
                        }
                        required
                      />
                    </div>
                  </div>
                  <div className="col-md-6">
                    <div className="form-group">
                      <label className="form-label">Adresse</label>
                      <input
                        type="text"
                        className="form-control"
                        value={editingRestaurant ? editingRestaurant.address || '' : newRestaurant.address}
                        onChange={(e) => editingRestaurant 
                          ? setEditingRestaurant({...editingRestaurant, address: e.target.value})
                          : setNewRestaurant({...newRestaurant, address: e.target.value})
                        }
                      />
                    </div>
                  </div>
                  <div className="col-md-6">
                    <div className="form-group">
                      <label className="form-label">Téléphone</label>
                      <input
                        type="tel"
                        className="form-control"
                        value={editingRestaurant ? editingRestaurant.phone || '' : newRestaurant.phone}
                        onChange={(e) => editingRestaurant 
                          ? setEditingRestaurant({...editingRestaurant, phone: e.target.value})
                          : setNewRestaurant({...newRestaurant, phone: e.target.value})
                        }
                      />
                    </div>
                  </div>
                  <div className="col-md-6">
                    <div className="form-group">
                      <label className="form-label">Email</label>
                      <input
                        type="email"
                        className="form-control"
                        value={editingRestaurant ? editingRestaurant.email || '' : newRestaurant.email}
                        onChange={(e) => editingRestaurant 
                          ? setEditingRestaurant({...editingRestaurant, email: e.target.value})
                          : setNewRestaurant({...newRestaurant, email: e.target.value})
                        }
                      />
                    </div>
                  </div>
                </div>
                <div className="form-actions">
                  <button type="submit" className="btn btn-primary">
                    <CheckCircle className="btn-icon" />
                    {editingRestaurant ? 'Mettre à jour' : 'Créer'}
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      )}

      {/* Restaurants Grid */}
      <div className="restaurants-grid">
        {filteredRestaurants.length === 0 ? (
          <div className="empty-state">
            <Building2 className="empty-icon" />
            <h3>Aucun restaurant trouvé</h3>
            <p>
              {searchTerm || filterCity 
                ? 'Aucun restaurant ne correspond à vos critères de recherche.'
                : 'Commencez par créer votre premier restaurant.'
              }
            </p>
            {canManageRestaurants && !searchTerm && !filterCity && (
              <button 
                className="btn btn-primary"
                onClick={() => setShowCreateForm(true)}
              >
                <Plus className="btn-icon" />
                Créer le premier restaurant
              </button>
            )}
          </div>
        ) : (
          <div className="row g-4">
            {filteredRestaurants.map((restaurant) => (
              <div key={restaurant.id} className="col-lg-4 col-md-6">
                <div className="restaurant-card">
                  <div className="restaurant-header">
                    <div className="restaurant-info">
                      <h3 className="restaurant-name">{restaurant.name}</h3>
                      <div className="restaurant-code">{restaurant.code}</div>
                    </div>
                    <div className="restaurant-status">
                      <div className="status-badge active">
                        <CheckCircle className="status-icon" />
                        Actif
                      </div>
                    </div>
                  </div>
                  
                  <div className="restaurant-details">
                    <div className="detail-item">
                      <MapPin className="detail-icon" />
                      <div className="detail-content">
                        <div className="detail-label">Ville</div>
                        <div className="detail-value">{restaurant.city}</div>
                      </div>
                    </div>
                    
                    {restaurant.address && (
                      <div className="detail-item">
                        <MapPin className="detail-icon" />
                        <div className="detail-content">
                          <div className="detail-label">Adresse</div>
                          <div className="detail-value">{restaurant.address}</div>
                        </div>
                      </div>
                    )}
                    
                    {restaurant.phone && (
                      <div className="detail-item">
                        <Phone className="detail-icon" />
                        <div className="detail-content">
                          <div className="detail-label">Téléphone</div>
                          <div className="detail-value">{restaurant.phone}</div>
                        </div>
                      </div>
                    )}
                    
                    {restaurant.email && (
                      <div className="detail-item">
                        <Mail className="detail-icon" />
                        <div className="detail-content">
                          <div className="detail-label">Email</div>
                          <div className="detail-value">{restaurant.email}</div>
                        </div>
                      </div>
                    )}
                  </div>
                  
                  <div className="restaurant-stats">
                    <div className="stat-mini">
                      <Users className="stat-mini-icon" />
                      <span>12 Menus</span>
                    </div>
                    <div className="stat-mini">
                      <Star className="stat-mini-icon" />
                      <span>4.8/5</span>
                    </div>
                  </div>
                  
                  {canManageRestaurants && (
                    <div className="restaurant-actions">
                      <button 
                        className="btn btn-outline-primary btn-sm"
                        onClick={() => startEdit(restaurant)}
                      >
                        <Edit className="btn-icon" />
                        Modifier
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
                        onClick={() => handleDeleteRestaurant(restaurant.id)}
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

export default ModernRestaurants;
