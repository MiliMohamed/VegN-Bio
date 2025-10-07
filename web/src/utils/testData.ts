// Script pour remplir la base de données avec des données de test
// Ce script peut être exécuté côté client ou serveur

const API_BASE_URL = process.env.REACT_APP_API_URL || 'https://vegn-bio-backend.onrender.com/api/v1';

// Données de test pour les restaurants
const testRestaurants = [
  {
    name: "Green Garden",
    code: "GG001",
    city: "Paris",
    address: "15 Rue de la Paix, 75001 Paris",
    phone: "+33 1 42 36 78 90",
    email: "contact@greengarden.fr"
  },
  {
    name: "Veggie Corner",
    code: "VC002",
    city: "Lyon",
    address: "8 Place Bellecour, 69002 Lyon",
    phone: "+33 4 78 92 15 43",
    email: "info@veggiecorner.fr"
  },
  {
    name: "Bio Bistro",
    code: "BB003",
    city: "Marseille",
    address: "22 Cours Mirabeau, 13001 Marseille",
    phone: "+33 4 91 25 67 89",
    email: "hello@biobistro.fr"
  },
  {
    name: "Nature's Table",
    code: "NT004",
    city: "Toulouse",
    address: "5 Place du Capitole, 31000 Toulouse",
    phone: "+33 5 61 23 45 67",
    email: "contact@naturestable.fr"
  },
  {
    name: "Fresh & Green",
    code: "FG005",
    city: "Nice",
    address: "12 Promenade des Anglais, 06000 Nice",
    phone: "+33 4 93 87 65 43",
    email: "info@freshandgreen.fr"
  }
];

// Données de test pour les menus
const testMenus = [
  {
    restaurantId: 1,
    title: "Menu Printemps Bio",
    activeFrom: "2024-03-01",
    activeTo: "2024-05-31",
    menuItems: [
      {
        name: "Salade de Quinoa aux Légumes de Saison",
        description: "Quinoa bio, tomates cerises, concombre, radis, vinaigrette à l'huile d'olive",
        priceCents: 1250,
        isVegan: true,
        allergens: []
      },
      {
        name: "Curry de Légumes au Lait de Coco",
        description: "Courgettes, aubergines, poivrons, lait de coco bio, riz basmati",
        priceCents: 1450,
        isVegan: true,
        allergens: []
      },
      {
        name: "Tarte aux Épinards et Chèvre",
        description: "Pâte brisée, épinards frais, fromage de chèvre bio, noix",
        priceCents: 1350,
        isVegan: false,
        allergens: ["gluten", "lactose"]
      }
    ]
  },
  {
    restaurantId: 2,
    title: "Menu Été Végétarien",
    activeFrom: "2024-06-01",
    activeTo: "2024-08-31",
    menuItems: [
      {
        name: "Gazpacho Andalou",
        description: "Tomates, concombres, poivrons, oignon, huile d'olive extra vierge",
        priceCents: 850,
        isVegan: true,
        allergens: []
      },
      {
        name: "Burger Végétarien aux Haricots Noirs",
        description: "Pain complet, galette de haricots noirs, avocat, tomate, salade",
        priceCents: 1650,
        isVegan: true,
        allergens: ["gluten"]
      },
      {
        name: "Tartare d'Avocat aux Graines",
        description: "Avocat, graines de chia, citron, coriandre, pain de seigle",
        priceCents: 1150,
        isVegan: true,
        allergens: ["gluten"]
      }
    ]
  }
];

// Données de test pour les événements
const testEvents = [
  {
    restaurantId: 1,
    title: "Atelier Cuisine Végétarienne",
    description: "Apprenez à cuisiner des plats végétariens délicieux et équilibrés",
    dateStart: "2024-04-15T14:00:00",
    dateEnd: "2024-04-15T17:00:00",
    capacity: 20,
    type: "WORKSHOP"
  },
  {
    restaurantId: 2,
    title: "Dégustation de Vins Bio",
    description: "Découverte de vins biologiques en accord avec nos plats végétariens",
    dateStart: "2024-04-20T19:00:00",
    dateEnd: "2024-04-20T22:00:00",
    capacity: 30,
    type: "TASTING"
  },
  {
    restaurantId: 3,
    title: "Conférence sur l'Agriculture Biologique",
    description: "Rencontre avec des producteurs locaux et découverte de leurs méthodes",
    dateStart: "2024-04-25T18:30:00",
    dateEnd: "2024-04-25T20:30:00",
    capacity: 50,
    type: "CONFERENCE"
  }
];

// Données de test pour les fournisseurs
const testSuppliers = [
  {
    name: "Ferme Bio du Val de Loire",
    contactPerson: "Marie Dubois",
    email: "contact@fermebio-valdeloire.fr",
    phone: "+33 2 47 89 12 34",
    address: "123 Route de la Ferme, 37000 Tours",
    specialties: ["Légumes bio", "Fruits de saison", "Herbes aromatiques"]
  },
  {
    name: "Coopérative Agricole Bio",
    contactPerson: "Jean Martin",
    email: "info@coopbio.fr",
    phone: "+33 4 75 23 45 67",
    address: "45 Avenue des Champs, 26000 Valence",
    specialties: ["Céréales bio", "Légumineuses", "Huiles végétales"]
  },
  {
    name: "Producteurs Locaux Unis",
    contactPerson: "Sophie Laurent",
    email: "contact@producteurs-locaux.fr",
    phone: "+33 5 61 78 90 12",
    address: "78 Rue de la Production, 31000 Toulouse",
    specialties: ["Produits laitiers bio", "Œufs fermiers", "Miel artisanal"]
  }
];

// Données de test pour les offres du marketplace
const testOffers = [
  {
    supplierId: 1,
    title: "Légumes de Printemps Bio",
    description: "Panier de légumes de saison cultivés sans pesticides",
    priceCents: 2500,
    quantity: 50,
    unit: "panier",
    availableFrom: "2024-04-01",
    availableTo: "2024-04-30",
    isActive: true
  },
  {
    supplierId: 2,
    title: "Farine de Blé Bio T65",
    description: "Farine de blé bio moulue à la meule de pierre",
    priceCents: 450,
    quantity: 100,
    unit: "kg",
    availableFrom: "2024-04-01",
    availableTo: "2024-12-31",
    isActive: true
  },
  {
    supplierId: 3,
    title: "Fromage de Chèvre Bio",
    description: "Fromage de chèvre artisanal au lait cru",
    priceCents: 1200,
    quantity: 25,
    unit: "pièce",
    availableFrom: "2024-04-01",
    availableTo: "2024-04-15",
    isActive: true
  }
];

// Fonction pour créer un restaurant
export const createTestRestaurant = async (restaurantData: any) => {
  try {
    const response = await fetch(`${API_BASE_URL}/restaurants`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${localStorage.getItem('token')}`
      },
      body: JSON.stringify(restaurantData)
    });
    
    if (!response.ok) {
      throw new Error(`Erreur ${response.status}: ${response.statusText}`);
    }
    
    return await response.json();
  } catch (error) {
    console.error('Erreur lors de la création du restaurant:', error);
    throw error;
  }
};

// Fonction pour créer un menu avec ses items
export const createTestMenu = async (menuData: any) => {
  try {
    // Créer le menu
    const menuResponse = await fetch(`${API_BASE_URL}/menus`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${localStorage.getItem('token')}`
      },
      body: JSON.stringify({
        restaurantId: menuData.restaurantId,
        title: menuData.title,
        activeFrom: menuData.activeFrom,
        activeTo: menuData.activeTo
      })
    });
    
    if (!menuResponse.ok) {
      throw new Error(`Erreur lors de la création du menu: ${menuResponse.statusText}`);
    }
    
    const menu = await menuResponse.json();
    
    // Créer les items du menu
    for (const item of menuData.menuItems) {
      const itemResponse = await fetch(`${API_BASE_URL}/menu-items`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${localStorage.getItem('token')}`
        },
        body: JSON.stringify({
          ...item,
          menuId: menu.id
        })
      });
      
      if (!itemResponse.ok) {
        console.error(`Erreur lors de la création de l'item: ${item.name}`);
      }
    }
    
    return menu;
  } catch (error) {
    console.error('Erreur lors de la création du menu:', error);
    throw error;
  }
};

// Fonction pour créer un événement
export const createTestEvent = async (eventData: any) => {
  try {
    const response = await fetch(`${API_BASE_URL}/events`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${localStorage.getItem('token')}`
      },
      body: JSON.stringify(eventData)
    });
    
    if (!response.ok) {
      throw new Error(`Erreur ${response.status}: ${response.statusText}`);
    }
    
    return await response.json();
  } catch (error) {
    console.error('Erreur lors de la création de l\'événement:', error);
    throw error;
  }
};

// Fonction pour créer un fournisseur
export const createTestSupplier = async (supplierData: any) => {
  try {
    const response = await fetch(`${API_BASE_URL}/suppliers`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${localStorage.getItem('token')}`
      },
      body: JSON.stringify(supplierData)
    });
    
    if (!response.ok) {
      throw new Error(`Erreur ${response.status}: ${response.statusText}`);
    }
    
    return await response.json();
  } catch (error) {
    console.error('Erreur lors de la création du fournisseur:', error);
    throw error;
  }
};

// Fonction pour créer une offre
export const createTestOffer = async (offerData: any) => {
  try {
    const response = await fetch(`${API_BASE_URL}/offers`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${localStorage.getItem('token')}`
      },
      body: JSON.stringify(offerData)
    });
    
    if (!response.ok) {
      throw new Error(`Erreur ${response.status}: ${response.statusText}`);
    }
    
    return await response.json();
  } catch (error) {
    console.error('Erreur lors de la création de l\'offre:', error);
    throw error;
  }
};

// Fonction principale pour remplir la base de données
export const populateDatabase = async () => {
  try {
    console.log('🚀 Début du remplissage de la base de données...');
    
    // Créer les restaurants
    console.log('📝 Création des restaurants...');
    const createdRestaurants = [];
    for (const restaurant of testRestaurants) {
      try {
        const created = await createTestRestaurant(restaurant);
        createdRestaurants.push(created);
        console.log(`✅ Restaurant créé: ${created.name}`);
      } catch (error) {
        console.error(`❌ Erreur pour le restaurant ${restaurant.name}:`, error);
      }
    }
    
    // Créer les menus
    console.log('🍽️ Création des menus...');
    for (const menu of testMenus) {
      try {
        const created = await createTestMenu(menu);
        console.log(`✅ Menu créé: ${created.title}`);
      } catch (error) {
        console.error(`❌ Erreur pour le menu ${menu.title}:`, error);
      }
    }
    
    // Créer les événements
    console.log('🎉 Création des événements...');
    for (const event of testEvents) {
      try {
        const created = await createTestEvent(event);
        console.log(`✅ Événement créé: ${created.title}`);
      } catch (error) {
        console.error(`❌ Erreur pour l'événement ${event.title}:`, error);
      }
    }
    
    // Créer les fournisseurs
    console.log('🏪 Création des fournisseurs...');
    const createdSuppliers = [];
    for (const supplier of testSuppliers) {
      try {
        const created = await createTestSupplier(supplier);
        createdSuppliers.push(created);
        console.log(`✅ Fournisseur créé: ${created.name}`);
      } catch (error) {
        console.error(`❌ Erreur pour le fournisseur ${supplier.name}:`, error);
      }
    }
    
    // Créer les offres
    console.log('🛒 Création des offres...');
    for (const offer of testOffers) {
      try {
        const created = await createTestOffer(offer);
        console.log(`✅ Offre créée: ${created.title}`);
      } catch (error) {
        console.error(`❌ Erreur pour l'offre ${offer.title}:`, error);
      }
    }
    
    console.log('🎉 Remplissage de la base de données terminé !');
    return {
      restaurants: createdRestaurants,
      suppliers: createdSuppliers
    };
    
  } catch (error) {
    console.error('❌ Erreur lors du remplissage de la base de données:', error);
    throw error;
  }
};

// Export des données de test pour utilisation dans les composants
export {
  testRestaurants,
  testMenus,
  testEvents,
  testSuppliers,
  testOffers
};
