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

const Marketplace: React.FC = () => {
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

  // Hook pour récupérer les restaurants
  const { getRestaurantName } = useRestaurants();

  // Vérifier les permissions
  const userRole = localStorage.getItem('userRole');
  const canManageMarketplace = userRole === 'ADMIN' || userRole === 'FOURNISSEUR';

  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      setLoading(true);
      
      // Récupérer les offres
      const offersResponse = await marketplaceService.getOffers();
      setItems(offersResponse.data);
      
      // Récupérer les fournisseurs
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

  // Filtrage des éléments
  const filteredItems = items.filter(item => {
    const matchesSearch = item.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         item.description.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesCategory = !filterCategory || item.category === filterCategory;
    const matchesSupplier = !filterSupplier || item.supplierId.toString() === filterSupplier;
    
    return matchesSearch && matchesCategory && matchesSupplier;
  });

  const categories = ['LEGUMES', 'FRUITS', 'CEREALES', 'LEGUMINEUSES', 'EPICES', 'AUTRES'];

  if (loading) return <div className="loading">Chargement...</div>;
  if (error) return <div className="error">{error}</div>;

  return (
    <div className="marketplace">
      <div className="page-header">
        <h1>Marketplace Bio</h1>
        {canManageMarketplace && (
          <div className="header-actions">
            <button 
              className="btn-primary"
              onClick={() => setShowCreateForm(!showCreateForm)}
            >
              {showCreateForm ? 'Annuler' : 'Créer une offre'}
            </button>
            <button 
              className="btn-secondary"
              onClick={() => setShowSupplierForm(!showSupplierForm)}
            >
              {showSupplierForm ? 'Annuler' : 'Ajouter fournisseur'}
            </button>
          </div>
        )}
      </div>

      {/* Formulaire de création d'offre */}
      {showCreateForm && canManageMarketplace && (
        <div className="create-form">
          <h3>Créer une nouvelle offre</h3>
          <form onSubmit={handleCreateItem}>
            <div className="form-row">
              <div className="form-group">
                <label>Fournisseur *</label>
                <select
                  value={newItem.supplierId}
                  onChange={(e) => setNewItem({...newItem, supplierId: parseInt(e.target.value)})}
                  required
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
                <label>Titre *</label>
                <input
                  type="text"
                  value={newItem.title}
                  onChange={(e) => setNewItem({...newItem, title: e.target.value})}
                  required
                />
              </div>
            </div>
            
            <div className="form-row">
              <div className="form-group">
                <label>Prix (€) *</label>
                <input
                  type="number"
                  step="0.01"
                  value={newItem.price}
                  onChange={(e) => setNewItem({...newItem, price: parseFloat(e.target.value)})}
                  min="0"
                  required
                />
              </div>
              
              <div className="form-group">
                <label>Unité *</label>
                <select
                  value={newItem.unit}
                  onChange={(e) => setNewItem({...newItem, unit: e.target.value})}
                  required
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
              <label>Description *</label>
              <textarea
                value={newItem.description}
                onChange={(e) => setNewItem({...newItem, description: e.target.value})}
                required
              />
            </div>
            
            <div className="form-group">
              <label>Catégorie *</label>
              <select
                value={newItem.category}
                onChange={(e) => setNewItem({...newItem, category: e.target.value})}
                required
              >
                {categories.map((category) => (
                  <option key={category} value={category}>{category}</option>
                ))}
              </select>
            </div>
            
            <div className="form-actions">
              <button type="submit" className="btn-primary">Créer l'offre</button>
              <button type="button" className="btn-secondary" onClick={() => setShowCreateForm(false)}>
                Annuler
              </button>
            </div>
          </form>
        </div>
      )}

      {/* Formulaire d'ajout de fournisseur */}
      {showSupplierForm && canManageMarketplace && (
        <div className="create-form">
          <h3>Ajouter un nouveau fournisseur</h3>
          <form onSubmit={handleCreateSupplier}>
            <div className="form-row">
              <div className="form-group">
                <label>Nom *</label>
                <input
                  type="text"
                  value={newSupplier.name}
                  onChange={(e) => setNewSupplier({...newSupplier, name: e.target.value})}
                  required
                />
              </div>
              
              <div className="form-group">
                <label>Email *</label>
                <input
                  type="email"
                  value={newSupplier.email}
                  onChange={(e) => setNewSupplier({...newSupplier, email: e.target.value})}
                  required
                />
              </div>
            </div>
            
            <div className="form-row">
              <div className="form-group">
                <label>Téléphone *</label>
                <input
                  type="tel"
                  value={newSupplier.phone}
                  onChange={(e) => setNewSupplier({...newSupplier, phone: e.target.value})}
                  required
                />
              </div>
              
              <div className="form-group">
                <label>Adresse *</label>
                <input
                  type="text"
                  value={newSupplier.address}
                  onChange={(e) => setNewSupplier({...newSupplier, address: e.target.value})}
                  required
                />
              </div>
            </div>
            
            <div className="form-actions">
              <button type="submit" className="btn-primary">Créer le fournisseur</button>
              <button type="button" className="btn-secondary" onClick={() => setShowSupplierForm(false)}>
                Annuler
              </button>
            </div>
          </form>
        </div>
      )}

      {/* Filtres */}
      <div className="filters">
        <div className="search-box">
          <input
            type="text"
            placeholder="Rechercher par titre ou description..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>
        
        <div className="filter-selects">
          <select
            value={filterCategory}
            onChange={(e) => setFilterCategory(e.target.value)}
          >
            <option value="">Toutes les catégories</option>
            {categories.map((category) => (
              <option key={category} value={category}>{category}</option>
            ))}
          </select>
          
          <select
            value={filterSupplier}
            onChange={(e) => setFilterSupplier(e.target.value)}
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

      {/* Grille des offres */}
      <div className="marketplace-grid">
        {filteredItems.length === 0 ? (
          <div className="empty-state">
            <p>Aucune offre trouvée</p>
          </div>
        ) : (
          filteredItems.map((item) => (
            <div key={item.id} className="marketplace-card">
              <div className="card-image">
                <div className="placeholder-image">🌱</div>
              </div>
              <div className="card-content">
                <h3>{item.title}</h3>
                <p className="item-description">{item.description}</p>
                <p className="item-supplier">Fournisseur: {item.supplierName}</p>
                <p className="item-category">Catégorie: {item.category}</p>
                <p className="item-price">{item.price}€ / {item.unit}</p>
                <p className="item-status">Statut: <span className={`status-${item.status.toLowerCase()}`}>{item.status}</span></p>
                <p className="item-date">Ajouté le: {new Date(item.createdAt).toLocaleDateString('fr-FR')}</p>
              </div>
              <div className="card-actions">
                <button className="btn-primary">Voir détails</button>
                <button className="btn-secondary">Contacter</button>
                {canManageMarketplace && (
                  <button 
                    className="btn-danger"
                    onClick={() => handleDeleteItem(item.id)}
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

export default Marketplace;