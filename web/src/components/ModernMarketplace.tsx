import React, { useState, useEffect } from 'react';
import { marketplaceService } from '../services/api';
import { useRestaurants } from '../hooks/useRestaurants';

interface MarketplaceItem {
  id: number;
  supplierId: number;
  supplierName: string;
  title: string;
  description: string;
  price: number;
  unit: string;
  category: string;
  status: string;
  createdAt: string;
  updatedAt: string;
}

interface Supplier {
  id: number;
  name: string;
  email: string;
  phone: string;
  address: string;
  status: string;
}

const ModernMarketplace: React.FC = () => {
  const [items, setItems] = useState<MarketplaceItem[]>([]);
  const [suppliers, setSuppliers] = useState<Supplier[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [searchTerm, setSearchTerm] = useState('');
  const [filterCategory, setFilterCategory] = useState('');
  const [filterSupplier, setFilterSupplier] = useState('');
  const [showCreateForm, setShowCreateForm] = useState(false);
  const [showSupplierForm, setShowSupplierForm] = useState(false);
  const [newItem, setNewItem] = useState({
    supplierId: 0,
    title: '',
    description: '',
    price: 0,
    unit: '',
    category: 'LEGUMES'
  });
  const [newSupplier, setNewSupplier] = useState({
    name: '',
    email: '',
    phone: '',
    address: ''
  });

  const { getRestaurantName } = useRestaurants();

  const userRole = localStorage.getItem('userRole');
  const canManageMarketplace = userRole === 'ADMIN' || userRole === 'FOURNISSEUR';

  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      setLoading(true);
      const offersResponse = await marketplaceService.getOffers();
      setItems(offersResponse.data);
      const suppliersResponse = await marketplaceService.getSuppliers();
      setSuppliers(suppliersResponse.data);
    } catch (err: any) {
      setError('Erreur lors du chargement des données');
      console.error('Error fetching marketplace data:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleCreateItem = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const response = await marketplaceService.createOffer(newItem);
      setItems([...items, response.data]);
      setNewItem({
        supplierId: 0,
        title: '',
        description: '',
        price: 0,
        unit: '',
        category: 'LEGUMES'
      });
      setShowCreateForm(false);
      alert('Offre créée avec succès');
    } catch (err: any) {
      console.error('Erreur lors de la création:', err);
      alert('Erreur lors de la création de l\'offre');
    }
  };

  const handleCreateSupplier = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const response = await marketplaceService.createSupplier(newSupplier);
      setSuppliers([...suppliers, response.data]);
      setNewSupplier({
        name: '',
        email: '',
        phone: '',
        address: ''
      });
      setShowSupplierForm(false);
      alert('Fournisseur créé avec succès');
    } catch (err: any) {
      console.error('Erreur lors de la création:', err);
      alert('Erreur lors de la création du fournisseur');
    }
  };

  const handleDeleteItem = async (itemId: number) => {
    if (!window.confirm('Êtes-vous sûr de vouloir supprimer cette offre ?')) {
      return;
    }
    try {
      await marketplaceService.deleteOffer(itemId);
      setItems(items.filter(item => item.id !== itemId));
      alert('Offre supprimée avec succès');
    } catch (err: any) {
      console.error('Erreur lors de la suppression:', err);
      alert('Erreur lors de la suppression de l\'offre');
    }
  };

  const filteredItems = items.filter(item => {
    const matchesSearch = item.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         item.description.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         item.supplierName.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesCategory = !filterCategory || item.category === filterCategory;
    const matchesSupplier = !filterSupplier || item.supplierId.toString() === filterSupplier;
    return matchesSearch && matchesCategory && matchesSupplier;
  });

  const categories = [
    { value: 'LEGUMES', label: '🥕 Légumes', color: '#27ae60' },
    { value: 'FRUITS', label: '🍎 Fruits', color: '#e74c3c' },
    { value: 'CEREALES', label: '🌾 Céréales', color: '#f39c12' },
    { value: 'LEGUMINEUSES', label: '🫘 Légumineuses', color: '#8e44ad' },
    { value: 'EPICES', label: '🌶️ Épices', color: '#e67e22' },
    { value: 'AUTRES', label: '🌱 Autres', color: '#95a5a6' }
  ];

  const getCategoryIcon = (category: string) => {
    const cat = categories.find(c => c.value === category);
    return cat ? cat.label.split(' ')[0] : '🌱';
  };

  const getCategoryColor = (category: string) => {
    const cat = categories.find(c => c.value === category);
    return cat ? cat.color : '#95a5a6';
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'ACTIVE': return '#27ae60';
      case 'INACTIVE': return '#e74c3c';
      case 'PENDING': return '#f39c12';
      default: return '#95a5a6';
    }
  };

  if (loading) {
    return (
      <div className="modern-loading">
        <div className="loading-spinner"></div>
        <p>Chargement du marketplace...</p>
      </div>
    );
  }

  if (error) {
    return (
      <div className="modern-error">
        <div className="error-icon">⚠️</div>
        <p>{error}</p>
        <button className="modern-btn primary" onClick={fetchData}>Réessayer</button>
      </div>
    );
  }

  return (
    <div className="modern-marketplace">
      <div className="modern-page-header">
        <div className="header-content">
          <div className="header-title">
            <h1>🛒 Marketplace Bio</h1>
            <p>Découvrez les meilleurs produits bio de nos fournisseurs locaux</p>
          </div>
          {canManageMarketplace && (
            <div className="header-actions">
              <button 
                className="modern-btn primary"
                onClick={() => setShowCreateForm(!showCreateForm)}
              >
                <span className="btn-icon">➕</span>
                {showCreateForm ? 'Annuler' : 'Créer une offre'}
              </button>
              <button 
                className="modern-btn secondary"
                onClick={() => setShowSupplierForm(!showSupplierForm)}
              >
                <span className="btn-icon">🏪</span>
                {showSupplierForm ? 'Annuler' : 'Ajouter fournisseur'}
              </button>
            </div>
          )}
        </div>
      </div>

      {showCreateForm && canManageMarketplace && (
        <div className="modern-form-container">
          <div className="form-header">
            <h3>🛍️ Créer une nouvelle offre</h3>
            <p>Ajoutez un nouveau produit au marketplace</p>
          </div>
          <form onSubmit={handleCreateItem} className="modern-form">
            <div className="form-grid">
              <div className="form-group">
                <label>🏪 Fournisseur *</label>
                <select
                  value={newItem.supplierId}
                  onChange={(e) => setNewItem({...newItem, supplierId: parseInt(e.target.value)})}
                  required
                  className="modern-select"
                >
                  <option value={0}>Sélectionner un fournisseur</option>
                  {suppliers.map((supplier) => (
                    <option key={supplier.id} value={supplier.id}>
                      {supplier.name}
                    </option>
                  ))}
                </select>
              </div>
              <div className="form-group">
                <label>📝 Titre *</label>
                <input
                  type="text"
                  value={newItem.title}
                  onChange={(e) => setNewItem({...newItem, title: e.target.value})}
                  required
                  className="modern-input"
                  placeholder="Nom du produit"
                />
              </div>
            </div>
            <div className="form-grid">
              <div className="form-group">
                <label>💰 Prix (€) *</label>
                <input
                  type="number"
                  step="0.01"
                  value={newItem.price}
                  onChange={(e) => setNewItem({...newItem, price: parseFloat(e.target.value)})}
                  min={0}
                  required
                  className="modern-input"
                  placeholder="0.00"
                />
              </div>
              <div className="form-group">
                <label>📏 Unité *</label>
                <select
                  value={newItem.unit}
                  onChange={(e) => setNewItem({...newItem, unit: e.target.value})}
                  required
                  className="modern-select"
                >
                  <option value="">Sélectionner une unité</option>
                  <option value="kg">Kilogramme (kg)</option>
                  <option value="g">Gramme (g)</option>
                  <option value="L">Litre (L)</option>
                  <option value="mL">Millilitre (mL)</option>
                  <option value="pièce">Pièce</option>
                  <option value="boîte">Boîte</option>
                  <option value="paquet">Paquet</option>
                </select>
              </div>
            </div>
            <div className="form-group">
              <label>📄 Description *</label>
              <textarea
                value={newItem.description}
                onChange={(e) => setNewItem({...newItem, description: e.target.value})}
                required
                className="modern-textarea"
                placeholder="Décrivez le produit..."
                rows={4}
              />
            </div>
            <div className="form-group">
              <label>🏷️ Catégorie *</label>
              <select
                value={newItem.category}
                onChange={(e) => setNewItem({...newItem, category: e.target.value})}
                required
                className="modern-select"
              >
                {categories.map((category) => (
                  <option key={category.value} value={category.value}>
                    {category.label}
                  </option>
                ))}
              </select>
            </div>
            <div className="form-actions">
              <button type="submit" className="modern-btn primary">
                <span className="btn-icon">✅</span>
                Créer l'offre
              </button>
              <button type="button" className="modern-btn secondary" onClick={() => setShowCreateForm(false)}>
                <span className="btn-icon">❌</span>
                Annuler
              </button>
            </div>
          </form>
        </div>
      )}

      {showSupplierForm && canManageMarketplace && (
        <div className="modern-form-container">
          <div className="form-header">
            <h3>🏪 Ajouter un nouveau fournisseur</h3>
            <p>Enregistrez un nouveau fournisseur dans le système</p>
          </div>
          <form onSubmit={handleCreateSupplier} className="modern-form">
            <div className="form-grid">
              <div className="form-group">
                <label>📝 Nom *</label>
                <input
                  type="text"
                  value={newSupplier.name}
                  onChange={(e) => setNewSupplier({...newSupplier, name: e.target.value})}
                  required
                  className="modern-input"
                  placeholder="Nom du fournisseur"
                />
              </div>
              <div className="form-group">
                <label>📧 Email *</label>
                <input
                  type="email"
                  value={newSupplier.email}
                  onChange={(e) => setNewSupplier({...newSupplier, email: e.target.value})}
                  required
                  className="modern-input"
                  placeholder="email@exemple.com"
                />
              </div>
            </div>
            <div className="form-grid">
              <div className="form-group">
                <label>📞 Téléphone *</label>
                <input
                  type="tel"
                  value={newSupplier.phone}
                  onChange={(e) => setNewSupplier({...newSupplier, phone: e.target.value})}
                  required
                  className="modern-input"
                  placeholder="0123456789"
                />
              </div>
              <div className="form-group">
                <label>📍 Adresse *</label>
                <input
                  type="text"
                  value={newSupplier.address}
                  onChange={(e) => setNewSupplier({...newSupplier, address: e.target.value})}
                  required
                  className="modern-input"
                  placeholder="Adresse complète"
                />
              </div>
            </div>
            <div className="form-actions">
              <button type="submit" className="modern-btn primary">
                <span className="btn-icon">✅</span>
                Créer le fournisseur
              </button>
              <button type="button" className="modern-btn secondary" onClick={() => setShowSupplierForm(false)}>
                <span className="btn-icon">❌</span>
                Annuler
              </button>
            </div>
          </form>
        </div>
      )}

      <div className="modern-filters">
        <div className="search-container">
          <div className="search-box">
            <span className="search-icon">🔍</span>
            <input
              type="text"
              placeholder="Rechercher un produit..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="modern-search"
            />
          </div>
        </div>
        <div className="filter-container">
          <select
            value={filterCategory}
            onChange={(e) => setFilterCategory(e.target.value)}
            className="modern-filter"
          >
            <option value="">Toutes les catégories</option>
            {categories.map((category) => (
              <option key={category.value} value={category.value}>
                {category.label}
              </option>
            ))}
          </select>
          <select
            value={filterSupplier}
            onChange={(e) => setFilterSupplier(e.target.value)}
            className="modern-filter"
          >
            <option value="">Tous les fournisseurs</option>
            {suppliers.map((supplier) => (
              <option key={supplier.id} value={supplier.id.toString()}>
                {supplier.name}
              </option>
            ))}
          </select>
        </div>
      </div>

      <div className="marketplace-stats">
        <div className="stat-card">
          <div className="stat-icon">🛍️</div>
          <div className="stat-content">
            <span className="stat-number">{filteredItems.length}</span>
            <span className="stat-label">Produits disponibles</span>
          </div>
        </div>
        <div className="stat-card">
          <div className="stat-icon">🏪</div>
          <div className="stat-content">
            <span className="stat-number">{suppliers.length}</span>
            <span className="stat-label">Fournisseurs actifs</span>
          </div>
        </div>
        <div className="stat-card">
          <div className="stat-icon">🏷️</div>
          <div className="stat-content">
            <span className="stat-number">{categories.length}</span>
            <span className="stat-label">Catégories</span>
          </div>
        </div>
      </div>

      <div className="modern-marketplace-grid">
        {filteredItems.length === 0 ? (
          <div className="modern-empty-state">
            <div className="empty-icon">🛒</div>
            <h3>Aucune offre trouvée</h3>
            <p>Il n'y a pas de produits correspondant à vos critères de recherche.</p>
          </div>
        ) : (
          filteredItems.map((item) => {
            const categoryColor = getCategoryColor(item.category);
            const statusColor = getStatusColor(item.status);
            return (
              <div key={item.id} className="modern-marketplace-card">
                <div className="product-image" style={{ backgroundColor: categoryColor }}>
                  <div className="category-badge" style={{ backgroundColor: categoryColor }}>
                    {getCategoryIcon(item.category)}
                  </div>
                  <div className="product-placeholder">🌱</div>
                </div>
                <div className="product-content">
                  <div className="product-header">
                    <h3 className="product-title">{item.title}</h3>
                    <div className="product-status" style={{ backgroundColor: statusColor }}>
                      {item.status}
                    </div>
                  </div>
                  <p className="product-supplier">🏪 {item.supplierName}</p>
                  <p className="product-description">{item.description}</p>
                  <div className="product-details">
                    <div className="price-section">
                      <span className="product-price">{item.price}€</span>
                      <span className="product-unit">/ {item.unit}</span>
                    </div>
                    <div className="product-meta">
                      <span className="product-category" style={{ color: categoryColor }}>
                        {getCategoryIcon(item.category)} {item.category}
                      </span>
                      <span className="product-date">📅 {new Date(item.createdAt).toLocaleDateString('fr-FR')}</span>
                    </div>
                  </div>
                </div>
                <div className="product-actions">
                  <button className="modern-btn primary small">
                    <span className="btn-icon">👁️</span>
                    Voir détails
                  </button>
                  <button className="modern-btn secondary small">
                    <span className="btn-icon">📞</span>
                    Contacter
                  </button>
                  {canManageMarketplace && (
                    <button 
                      className="modern-btn danger small"
                      onClick={() => handleDeleteItem(item.id)}
                    >
                      <span className="btn-icon">🗑️</span>
                      Supprimer
                    </button>
                  )}
                </div>
              </div>
            );
          })
        )}
      </div>
    </div>
  );
};

export default ModernMarketplace;
