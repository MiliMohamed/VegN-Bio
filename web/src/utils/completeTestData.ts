// Script complet pour remplir toute la base de données VegN-Bio
const API_BASE_URL = process.env.REACT_APP_API_URL || 'https://vegn-bio-backend.onrender.com/api/v1';

// Données complètes pour les restaurants
const completeRestaurants = [
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

// Menus complets avec plusieurs plats
const completeMenus = [
  {
    restaurantId: 68,
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
      },
      {
        name: "Smoothie Bowl Acai",
        description: "Bowl d'açaï, granola maison, fruits frais, noix de coco",
        priceCents: 950,
        isVegan: true,
        allergens: ["nuts"]
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
      },
      {
        name: "Salade César Végétarienne",
        description: "Salade romaine, parmesan, croûtons, sauce césar maison",
        priceCents: 1250,
        isVegan: false,
        allergens: ["gluten", "lactose", "egg"]
      }
    ]
  },
  {
    restaurantId: 3,
    title: "Menu Méditerranéen",
    activeFrom: "2024-09-01",
    activeTo: "2024-11-30",
    menuItems: [
      {
        name: "Ratatouille Provençale",
        description: "Aubergines, courgettes, tomates, poivrons, herbes de Provence",
        priceCents: 1200,
        isVegan: true,
        allergens: []
      },
      {
        name: "Pizza Margherita Végétarienne",
        description: "Pâte fine, tomates, mozzarella, basilic frais",
        priceCents: 1450,
        isVegan: false,
        allergens: ["gluten", "lactose"]
      },
      {
        name: "Pâtes aux Légumes Grillés",
        description: "Pâtes complètes, légumes grillés, huile d'olive, parmesan",
        priceCents: 1350,
        isVegan: false,
        allergens: ["gluten", "lactose"]
      }
    ]
  }
];

// Événements complets
const completeEvents = [
  {
    restaurantId: 68,
    title: "Atelier Cuisine Végétarienne",
    description: "Apprenez à cuisiner des plats végétariens délicieux et équilibrés avec notre chef. Découvrez les techniques de base et les ingrédients essentiels.",
    dateStart: "2024-04-15T14:00:00",
    dateEnd: "2024-04-15T17:00:00",
    capacity: 20,
    type: "WORKSHOP"
  },
  {
    restaurantId: 2,
    title: "Dégustation de Vins Bio",
    description: "Découverte de vins biologiques en accord avec nos plats végétariens. Rencontre avec des vignerons locaux.",
    dateStart: "2024-04-20T19:00:00",
    dateEnd: "2024-04-20T22:00:00",
    capacity: 30,
    type: "TASTING"
  },
  {
    restaurantId: 3,
    title: "Conférence sur l'Agriculture Biologique",
    description: "Rencontre avec des producteurs locaux et découverte de leurs méthodes de culture biologique.",
    dateStart: "2024-04-25T18:30:00",
    dateEnd: "2024-04-25T20:30:00",
    capacity: 50,
    type: "CONFERENCE"
  },
  {
    restaurantId: 68,
    title: "Brunch Dominical Bio",
    description: "Brunch dominical avec produits locaux et biologiques. Réservation recommandée.",
    dateStart: "2024-04-28T10:00:00",
    dateEnd: "2024-04-28T14:00:00",
    capacity: 40,
    type: "BRUNCH"
  },
  {
    restaurantId: 2,
    title: "Soirée Tapas Végétariennes",
    description: "Découvrez nos tapas végétariennes créatives accompagnées de cocktails sans alcool.",
    dateStart: "2024-05-02T19:30:00",
    dateEnd: "2024-05-02T23:00:00",
    capacity: 25,
    type: "EVENT"
  }
];

// Fournisseurs complets
const completeSuppliers = [
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
  },
  {
    name: "Jardins de Provence",
    contactPerson: "Pierre Moreau",
    email: "info@jardins-provence.fr",
    phone: "+33 4 91 23 45 67",
    address: "12 Chemin des Oliviers, 13000 Marseille",
    specialties: ["Herbes de Provence", "Huile d'olive", "Légumes méditerranéens"]
  },
  {
    name: "Ferme Alpine Bio",
    contactPerson: "Claire Bernard",
    email: "contact@ferme-alpine.fr",
    phone: "+33 4 93 45 67 89",
    address: "8 Route de la Montagne, 06000 Nice",
    specialties: ["Fromages de montagne", "Légumes de montagne", "Champignons"]
  }
];

// Offres complètes du marketplace
const completeOffers = [
  {
    supplierId: 1,
    title: "Légumes de Printemps Bio",
    description: "Panier de légumes de saison cultivés sans pesticides : carottes, radis, épinards, asperges",
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
    description: "Farine de blé bio moulue à la meule de pierre, idéale pour le pain et les pâtisseries",
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
    description: "Fromage de chèvre artisanal au lait cru, affiné 3 semaines",
    priceCents: 1200,
    quantity: 25,
    unit: "pièce",
    availableFrom: "2024-04-01",
    availableTo: "2024-04-15",
    isActive: true
  },
  {
    supplierId: 4,
    title: "Huile d'Olive Extra Vierge",
    description: "Huile d'olive extra vierge première pression à froid, récolte 2024",
    priceCents: 1800,
    quantity: 30,
    unit: "bouteille 500ml",
    availableFrom: "2024-04-01",
    availableTo: "2024-06-30",
    isActive: true
  },
  {
    supplierId: 5,
    title: "Champignons de Montagne",
    description: "Mélange de champignons sauvages : cèpes, girolles, trompettes",
    priceCents: 2200,
    quantity: 15,
    unit: "kg",
    availableFrom: "2024-04-01",
    availableTo: "2024-05-31",
    isActive: true
  }
];

// Avis et reviews complets
const completeReviews = [
  {
    restaurantId: 68,
    customerName: "Marie Dupont",
    customerEmail: "marie.dupont@email.com",
    rating: 5,
    comment: "Excellent restaurant ! Les plats sont délicieux et les ingrédients vraiment bio. L'ambiance est chaleureuse et le service impeccable.",
    status: "APPROVED"
  },
  {
    restaurantId: 68,
    customerName: "Jean Martin",
    customerEmail: "jean.martin@email.com",
    rating: 4,
    comment: "Très bon restaurant végétarien. Les portions sont généreuses et les prix raisonnables. Je recommande !",
    status: "APPROVED"
  },
  {
    restaurantId: 2,
    customerName: "Sophie Laurent",
    customerEmail: "sophie.laurent@email.com",
    rating: 5,
    comment: "Un vrai coup de cœur ! La cuisine est inventive et les produits de qualité. L'équipe est très sympathique.",
    status: "APPROVED"
  },
  {
    restaurantId: 2,
    customerName: "Pierre Moreau",
    customerEmail: "pierre.moreau@email.com",
    rating: 4,
    comment: "Restaurant agréable avec une belle carte végétarienne. Les desserts sont particulièrement réussis.",
    status: "APPROVED"
  },
  {
    restaurantId: 3,
    customerName: "Claire Bernard",
    customerEmail: "claire.bernard@email.com",
    rating: 5,
    comment: "Parfait pour découvrir la cuisine méditerranéenne végétarienne. Les plats sont savoureux et bien présentés.",
    status: "APPROVED"
  },
  {
    restaurantId: 3,
    customerName: "Antoine Petit",
    customerEmail: "antoine.petit@email.com",
    rating: 3,
    comment: "Correct mais pas exceptionnel. Les prix sont un peu élevés pour ce qui est proposé.",
    status: "PENDING"
  },
  {
    restaurantId: 68,
    customerName: "Isabelle Roux",
    customerEmail: "isabelle.roux@email.com",
    rating: 5,
    comment: "Un restaurant qui mérite vraiment le détour ! Cuisine créative et produits frais. À refaire absolument.",
    status: "APPROVED"
  },
  {
    restaurantId: 2,
    customerName: "Marc Dubois",
    customerEmail: "marc.dubois@email.com",
    rating: 4,
    comment: "Bonne adresse pour les végétariens. L'ambiance est détendue et les plats bien préparés.",
    status: "APPROVED"
  }
];

// Reports/Signalisations
const completeReports = [
  {
    restaurantId: 68,
    reporterName: "Client Anonyme",
    reporterEmail: "anonymous@email.com",
    reason: "QUALITY_ISSUE",
    description: "Le plat était froid à l'arrivée",
    status: "RESOLVED"
  },
  {
    restaurantId: 2,
    reporterName: "Marie Client",
    reporterEmail: "marie.client@email.com",
    reason: "SERVICE_ISSUE",
    description: "Service lent et personnel peu aimable",
    status: "INVESTIGATING"
  },
  {
    restaurantId: 3,
    reporterName: "Jean Utilisateur",
    reporterEmail: "jean.utilisateur@email.com",
    reason: "HYGIENE_ISSUE",
    description: "Problème d'hygiène dans les sanitaires",
    status: "PENDING"
  }
];

// Fonctions de création
export const createCompleteRestaurant = async (restaurantData: any) => {
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

export const createCompleteMenu = async (menuData: any) => {
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

export const createCompleteEvent = async (eventData: any) => {
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

export const createCompleteSupplier = async (supplierData: any) => {
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

export const createCompleteOffer = async (offerData: any) => {
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

export const createCompleteReview = async (reviewData: any) => {
  try {
    const response = await fetch(`${API_BASE_URL}/reviews`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${localStorage.getItem('token')}`
      },
      body: JSON.stringify(reviewData)
    });
    
    if (!response.ok) {
      throw new Error(`Erreur ${response.status}: ${response.statusText}`);
    }
    
    return await response.json();
  } catch (error) {
    console.error('Erreur lors de la création de l\'avis:', error);
    throw error;
  }
};

export const createCompleteReport = async (reportData: any) => {
  try {
    const response = await fetch(`${API_BASE_URL}/reports`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${localStorage.getItem('token')}`
      },
      body: JSON.stringify(reportData)
    });
    
    if (!response.ok) {
      throw new Error(`Erreur ${response.status}: ${response.statusText}`);
    }
    
    return await response.json();
  } catch (error) {
    console.error('Erreur lors de la création du rapport:', error);
    throw error;
  }
};

// Fonction principale pour remplir complètement la base de données
export const populateCompleteDatabase = async () => {
  try {
    console.log('🚀 Début du remplissage complet de la base de données...');
    
    // Créer les restaurants
    console.log('📝 Création des restaurants...');
    const createdRestaurants = [];
    for (const restaurant of completeRestaurants) {
      try {
        const created = await createCompleteRestaurant(restaurant);
        createdRestaurants.push(created);
        console.log(`✅ Restaurant créé: ${created.name}`);
      } catch (error) {
        console.error(`❌ Erreur pour le restaurant ${restaurant.name}:`, error);
      }
    }
    
    // Créer les menus avec leurs items
    console.log('🍽️ Création des menus...');
    for (const menu of completeMenus) {
      try {
        const created = await createCompleteMenu(menu);
        console.log(`✅ Menu créé: ${created.title}`);
      } catch (error) {
        console.error(`❌ Erreur pour le menu ${menu.title}:`, error);
      }
    }
    
    // Créer les événements
    console.log('🎉 Création des événements...');
    for (const event of completeEvents) {
      try {
        const created = await createCompleteEvent(event);
        console.log(`✅ Événement créé: ${created.title}`);
      } catch (error) {
        console.error(`❌ Erreur pour l'événement ${event.title}:`, error);
      }
    }
    
    // Créer les fournisseurs
    console.log('🏪 Création des fournisseurs...');
    const createdSuppliers = [];
    for (const supplier of completeSuppliers) {
      try {
        const created = await createCompleteSupplier(supplier);
        createdSuppliers.push(created);
        console.log(`✅ Fournisseur créé: ${created.name}`);
      } catch (error) {
        console.error(`❌ Erreur pour le fournisseur ${supplier.name}:`, error);
      }
    }
    
    // Créer les offres
    console.log('🛒 Création des offres...');
    for (const offer of completeOffers) {
      try {
        const created = await createCompleteOffer(offer);
        console.log(`✅ Offre créée: ${created.title}`);
      } catch (error) {
        console.error(`❌ Erreur pour l'offre ${offer.title}:`, error);
      }
    }
    
    // Créer les avis et reviews
    console.log('⭐ Création des avis et reviews...');
    for (const review of completeReviews) {
      try {
        const created = await createCompleteReview(review);
        console.log(`✅ Avis créé: ${created.customerName} - ${created.rating} étoiles`);
      } catch (error) {
        console.error(`❌ Erreur pour l'avis de ${review.customerName}:`, error);
      }
    }
    
    // Créer les rapports/signalisations
    console.log('📋 Création des rapports...');
    for (const report of completeReports) {
      try {
        const created = await createCompleteReport(report);
        console.log(`✅ Rapport créé: ${created.reason}`);
      } catch (error) {
        console.error(`❌ Erreur pour le rapport:`, error);
      }
    }
    
    console.log('🎉 Remplissage complet de la base de données terminé !');
    return {
      restaurants: createdRestaurants,
      suppliers: createdSuppliers
    };
    
  } catch (error) {
    console.error('❌ Erreur lors du remplissage complet:', error);
    throw error;
  }
};

// Export des données complètes
export {
  completeRestaurants,
  completeMenus,
  completeEvents,
  completeSuppliers,
  completeOffers,
  completeReviews,
  completeReports
};
