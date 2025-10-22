import React from 'react';
import { motion } from 'framer-motion';
import { 
  ShoppingCart, 
  Package, 
  Truck,
  Plus,
  Edit,
  Trash2,
  Eye,
  Star,
  MapPin,
  Phone,
  Mail,
  Lock
} from 'lucide-react';
import { marketplaceService } from '../services/api';
import { useAuth } from '../contexts/AuthContext';

interface Supplier {
  id: number;
  companyName: string;
  contactEmail: string;
}

interface Offer {
  id: number;
  title: string;
  description: string;
  unitPriceCents: number;
  unit: string;
  status: string;
  supplier: Supplier;
}

const ModernMarketplace: React.FC = () => {
  const { user } = useAuth();
  const [offers, setOffers] = React.useState<Offer[]>([]);
  const [suppliers, setSuppliers] = React.useState<Supplier[]>([]);
  const [loading, setLoading] = React.useState(true);
  const [activeTab, setActiveTab] = React.useState<'offers' | 'suppliers'>('offers');

  React.useEffect(() => {
    // Ne charger les données que si l'utilisateur est un fournisseur
    if (user?.role !== 'FOURNISSEUR') {
      setLoading(false);
      return;
    }

    const fetchData = async () => {
      try {
        const [offersRes, suppliersRes] = await Promise.all([
          marketplaceService.getOffers(),
          marketplaceService.getAllSuppliers()
        ]);
        setOffers(offersRes.data);
        setSuppliers(suppliersRes.data);
      } catch (error) {
        console.error('Erreur lors du chargement des données:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [user?.role]);

  // Vérifier si l'utilisateur est un fournisseur
  if (user?.role !== 'FOURNISSEUR') {
    return (
      <div className="modern-marketplace">
        <div className="marketplace-header">
          <div className="header-content">
            <div className="header-icon">
              <Lock className="w-8 h-8" />
            </div>
            <div className="header-text">
              <h1 className="page-title">Accès Restreint</h1>
              <p className="page-description">
                Cette section est réservée aux fournisseurs partenaires.
              </p>
            </div>
          </div>
        </div>
        
        <div className="access-denied-message">
          <div className="access-denied-content">
            <Lock className="w-16 h-16 text-gray-400 mb-4" />
            <h2 className="text-2xl font-semibold text-gray-700 mb-2">
              Marketplace Fournisseurs
            </h2>
            <p className="text-gray-600 mb-6">
              Pour accéder au marketplace des fournisseurs bio, vous devez avoir un compte fournisseur.
            </p>
            <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
              <h3 className="font-semibold text-blue-800 mb-2">Comment devenir fournisseur ?</h3>
              <ul className="text-blue-700 text-sm space-y-1">
                <li>• Contactez notre équipe commerciale</li>
                <li>• Fournissez vos certifications bio</li>
                <li>• Soumettez votre catalogue de produits</li>
                <li>• Obtenez votre accès fournisseur</li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    );
  }

  const formatPrice = (priceCents: number) => {
    return (priceCents / 100).toFixed(2) + ' €';
  };

  const getStatusColor = (status: string) => {
    const colors: { [key: string]: string } = {
      'PUBLISHED': 'success',
      'DRAFT': 'warning',
      'ARCHIVED': 'danger'
    };
    return colors[status] || 'primary';
  };

  const getStatusText = (status: string) => {
    const texts: { [key: string]: string } = {
      'PUBLISHED': 'Publiée',
      'DRAFT': 'Brouillon',
      'ARCHIVED': 'Archivée'
    };
    return texts[status] || 'Inconnu';
  };

  if (loading) {
    return (
      <div className="modern-marketplace">
        <div className="loading-container">
          <div className="loading-spinner"></div>
          <p>Chargement du marketplace...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="modern-marketplace">
      <div className="marketplace-header">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <h1 className="page-title">Marketplace Bio</h1>
          <p className="page-subtitle">
            Découvrez nos fournisseurs partenaires et leurs produits biologiques franciliens
          </p>
        </motion.div>
      </div>

      <div className="marketplace-tabs">
        <motion.button
          className={`tab-button ${activeTab === 'offers' ? 'active' : ''}`}
          onClick={() => setActiveTab('offers')}
          initial={{ opacity: 0, x: -20 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ duration: 0.6, delay: 0.2 }}
        >
          <Package className="w-5 h-5" />
          Offres ({offers.length})
        </motion.button>
        <motion.button
          className={`tab-button ${activeTab === 'suppliers' ? 'active' : ''}`}
          onClick={() => setActiveTab('suppliers')}
          initial={{ opacity: 0, x: 20 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ duration: 0.6, delay: 0.3 }}
        >
          <Truck className="w-5 h-5" />
          Fournisseurs ({suppliers.length})
        </motion.button>
      </div>

      {activeTab === 'offers' && (
        <div className="offers-section">
          <div className="section-actions">
            <motion.button
              className="btn btn-primary"
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6, delay: 0.4 }}
            >
              <Plus className="w-5 h-5" />
              Nouvelle offre
            </motion.button>
          </div>

          <div className="offers-grid">
            {offers.map((offer, index) => (
              <motion.div
                key={offer.id}
                className="offer-card"
                initial={{ opacity: 0, y: 30 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: index * 0.1 }}
                whileHover={{ y: -5 }}
              >
                <div className="offer-header">
                  <div className="offer-status">
                    <span className={`badge badge-${getStatusColor(offer.status)}`}>
                      {getStatusText(offer.status)}
                    </span>
                  </div>
                  <h3 className="offer-title">{offer.title}</h3>
                  <div className="offer-supplier">
                    <Truck className="w-4 h-4" />
                    <span>{offer.supplier.companyName}</span>
                  </div>
                </div>

                <div className="offer-description">
                  <p>{offer.description}</p>
                </div>

                <div className="offer-details">
                  <div className="detail-item">
                    <div className="detail-label">Prix unitaire</div>
                    <div className="detail-value">{formatPrice(offer.unitPriceCents)} / {offer.unit}</div>
                  </div>
                </div>

                <div className="offer-actions">
                  <button className="btn btn-primary btn-sm">
                    <ShoppingCart className="w-4 h-4" />
                    Commander
                  </button>
                  <button className="btn btn-secondary btn-sm">
                    <Eye className="w-4 h-4" />
                    Voir détails
                  </button>
                  <button className="btn btn-secondary btn-sm">
                    <Edit className="w-4 h-4" />
                    Modifier
                  </button>
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      )}

      {activeTab === 'suppliers' && (
        <div className="suppliers-section">
          <div className="section-actions">
            <motion.button
              className="btn btn-primary"
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6, delay: 0.4 }}
            >
              <Plus className="w-5 h-5" />
              Nouveau fournisseur
            </motion.button>
          </div>

          <div className="suppliers-grid">
            {suppliers.map((supplier, index) => (
              <motion.div
                key={supplier.id}
                className="supplier-card"
                initial={{ opacity: 0, y: 30 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: index * 0.1 }}
                whileHover={{ y: -5 }}
              >
                <div className="supplier-header">
                  <div className="supplier-logo">
                    <Truck className="w-8 h-8" />
                  </div>
                  <h3 className="supplier-name">{supplier.companyName}</h3>
                </div>

                <div className="supplier-contact">
                  <div className="contact-item">
                    <Mail className="w-4 h-4" />
                    <span>{supplier.contactEmail}</span>
                  </div>
                </div>

                <div className="supplier-stats">
                  <div className="stat-item">
                    <div className="stat-value">12</div>
                    <div className="stat-label">Offres actives</div>
                  </div>
                  <div className="stat-item">
                    <div className="stat-value">4.8</div>
                    <div className="stat-label">Note moyenne</div>
                  </div>
                </div>

                <div className="supplier-actions">
                  <button className="btn btn-primary btn-sm">
                    <Eye className="w-4 h-4" />
                    Voir profil
                  </button>
                  <button className="btn btn-secondary btn-sm">
                    <Edit className="w-4 h-4" />
                    Modifier
                  </button>
                  <button className="btn btn-danger btn-sm">
                    <Trash2 className="w-4 h-4" />
                    Supprimer
                  </button>
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
};

export default ModernMarketplace;