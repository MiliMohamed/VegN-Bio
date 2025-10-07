// Script de test complet pour vérifier tous les endpoints backend
const API_BASE_URL = 'https://vegn-bio-backend.onrender.com/api/v1';

// Fonction utilitaire pour faire des requêtes
const makeRequest = async (url, options = {}) => {
  try {
    const token = localStorage.getItem('token');
    const response = await fetch(url, {
      headers: {
        'Content-Type': 'application/json',
        ...(token && { 'Authorization': `Bearer ${token}` }),
        ...options.headers
      },
      ...options
    });
    
    const data = await response.json().catch(() => null);
    
    return {
      success: response.ok,
      status: response.status,
      statusText: response.statusText,
      data,
      url
    };
  } catch (error) {
    return {
      success: false,
      error: error.message,
      url
    };
  }
};

// Tests des endpoints d'authentification
export const testAuthEndpoints = async () => {
  console.log('🔐 Test des endpoints d\'authentification...');
  
  const tests = [
    {
      name: 'POST /auth/register',
      test: () => makeRequest(`${API_BASE_URL}/auth/register`, {
        method: 'POST',
        body: JSON.stringify({
          email: 'test@example.com',
          password: 'Test123!',
          fullName: 'Test User',
          role: 'CLIENT'
        })
      })
    },
    {
      name: 'POST /auth/login',
      test: () => makeRequest(`${API_BASE_URL}/auth/login`, {
        method: 'POST',
        body: JSON.stringify({
          email: 'admin@vegnbio.com',
          password: 'Admin123!'
        })
      })
    }
  ];
  
  const results = [];
  for (const test of tests) {
    const result = await test.test();
    results.push({ name: test.name, ...result });
    console.log(`${test.name}: ${result.success ? '✅' : '❌'} ${result.status || result.error}`);
  }
  
  return results;
};

// Tests des endpoints de restaurants
export const testRestaurantEndpoints = async () => {
  console.log('🏪 Test des endpoints de restaurants...');
  
  const tests = [
    {
      name: 'GET /restaurants',
      test: () => makeRequest(`${API_BASE_URL}/restaurants`)
    },
    {
      name: 'GET /restaurants/1',
      test: () => makeRequest(`${API_BASE_URL}/restaurants/1`)
    },
    {
      name: 'POST /restaurants',
      test: () => makeRequest(`${API_BASE_URL}/restaurants`, {
        method: 'POST',
        body: JSON.stringify({
          name: 'Test Restaurant',
          code: 'TEST001',
          city: 'Test City',
          address: 'Test Address',
          phone: '+33123456789',
          email: 'test@restaurant.com'
        })
      })
    }
  ];
  
  const results = [];
  for (const test of tests) {
    const result = await test.test();
    results.push({ name: test.name, ...result });
    console.log(`${test.name}: ${result.success ? '✅' : '❌'} ${result.status || result.error}`);
  }
  
  return results;
};

// Tests des endpoints de menus
export const testMenuEndpoints = async () => {
  console.log('🍽️ Test des endpoints de menus...');
  
  const tests = [
    {
      name: 'GET /menus/restaurant/1',
      test: () => makeRequest(`${API_BASE_URL}/menus/restaurant/1`)
    },
    {
      name: 'GET /menus/restaurant/1/active',
      test: () => makeRequest(`${API_BASE_URL}/menus/restaurant/1/active`)
    },
    {
      name: 'POST /menus',
      test: () => makeRequest(`${API_BASE_URL}/menus`, {
        method: 'POST',
        body: JSON.stringify({
          restaurantId: 1,
          title: 'Test Menu',
          activeFrom: '2024-01-01',
          activeTo: '2024-12-31'
        })
      })
    }
  ];
  
  const results = [];
  for (const test of tests) {
    const result = await test.test();
    results.push({ name: test.name, ...result });
    console.log(`${test.name}: ${result.success ? '✅' : '❌'} ${result.status || result.error}`);
  }
  
  return results;
};

// Tests des endpoints de menu items
export const testMenuItemEndpoints = async () => {
  console.log('🍴 Test des endpoints de menu items...');
  
  const tests = [
    {
      name: 'GET /menu-items/menu/1',
      test: () => makeRequest(`${API_BASE_URL}/menu-items/menu/1`)
    },
    {
      name: 'GET /menu-items/search?name=pizza',
      test: () => makeRequest(`${API_BASE_URL}/menu-items/search?name=pizza`)
    },
    {
      name: 'POST /menu-items',
      test: () => makeRequest(`${API_BASE_URL}/menu-items`, {
        method: 'POST',
        body: JSON.stringify({
          menuId: 1,
          name: 'Test Item',
          description: 'Test Description',
          priceCents: 1000,
          isVegan: true,
          allergens: []
        })
      })
    }
  ];
  
  const results = [];
  for (const test of tests) {
    const result = await test.test();
    results.push({ name: test.name, ...result });
    console.log(`${test.name}: ${result.success ? '✅' : '❌'} ${result.status || result.error}`);
  }
  
  return results;
};

// Tests des endpoints d'événements
export const testEventEndpoints = async () => {
  console.log('🎉 Test des endpoints d\'événements...');
  
  const tests = [
    {
      name: 'GET /events',
      test: () => makeRequest(`${API_BASE_URL}/events`)
    },
    {
      name: 'GET /events?restaurantId=1',
      test: () => makeRequest(`${API_BASE_URL}/events?restaurantId=1`)
    },
    {
      name: 'POST /events',
      test: () => makeRequest(`${API_BASE_URL}/events`, {
        method: 'POST',
        body: JSON.stringify({
          restaurantId: 1,
          title: 'Test Event',
          description: 'Test Description',
          dateStart: '2024-12-31T18:00:00',
          dateEnd: '2024-12-31T22:00:00',
          capacity: 50,
          type: 'WORKSHOP'
        })
      })
    }
  ];
  
  const results = [];
  for (const test of tests) {
    const result = await test.test();
    results.push({ name: test.name, ...result });
    console.log(`${test.name}: ${result.success ? '✅' : '❌'} ${result.status || result.error}`);
  }
  
  return results;
};

// Tests des endpoints de bookings
export const testBookingEndpoints = async () => {
  console.log('📅 Test des endpoints de réservations...');
  
  const tests = [
    {
      name: 'GET /bookings/event/1',
      test: () => makeRequest(`${API_BASE_URL}/bookings/event/1`)
    },
    {
      name: 'POST /bookings',
      test: () => makeRequest(`${API_BASE_URL}/bookings`, {
        method: 'POST',
        body: JSON.stringify({
          eventId: 1,
          customerName: 'Test Customer',
          customerEmail: 'customer@test.com',
          numberOfPeople: 2
        })
      })
    }
  ];
  
  const results = [];
  for (const test of tests) {
    const result = await test.test();
    results.push({ name: test.name, ...result });
    console.log(`${test.name}: ${result.success ? '✅' : '❌'} ${result.status || result.error}`);
  }
  
  return results;
};

// Tests des endpoints de fournisseurs
export const testSupplierEndpoints = async () => {
  console.log('🏭 Test des endpoints de fournisseurs...');
  
  const tests = [
    {
      name: 'GET /suppliers',
      test: () => makeRequest(`${API_BASE_URL}/suppliers`)
    },
    {
      name: 'GET /suppliers?search=bio',
      test: () => makeRequest(`${API_BASE_URL}/suppliers?search=bio`)
    },
    {
      name: 'POST /suppliers',
      test: () => makeRequest(`${API_BASE_URL}/suppliers`, {
        method: 'POST',
        body: JSON.stringify({
          name: 'Test Supplier',
          contactPerson: 'Test Person',
          email: 'supplier@test.com',
          phone: '+33123456789',
          address: 'Test Address',
          specialties: ['Test Specialty']
        })
      })
    }
  ];
  
  const results = [];
  for (const test of tests) {
    const result = await test.test();
    results.push({ name: test.name, ...result });
    console.log(`${test.name}: ${result.success ? '✅' : '❌'} ${result.status || result.error}`);
  }
  
  return results;
};

// Tests des endpoints d'offres
export const testOfferEndpoints = async () => {
  console.log('🛒 Test des endpoints d\'offres...');
  
  const tests = [
    {
      name: 'GET /offers',
      test: () => makeRequest(`${API_BASE_URL}/offers`)
    },
    {
      name: 'GET /offers?search=legumes',
      test: () => makeRequest(`${API_BASE_URL}/offers?search=legumes`)
    },
    {
      name: 'GET /offers/supplier/1',
      test: () => makeRequest(`${API_BASE_URL}/offers/supplier/1`)
    }
  ];
  
  const results = [];
  for (const test of tests) {
    const result = await test.test();
    results.push({ name: test.name, ...result });
    console.log(`${test.name}: ${result.success ? '✅' : '❌'} ${result.status || result.error}`);
  }
  
  return results;
};

// Tests des endpoints d'allergènes
export const testAllergenEndpoints = async () => {
  console.log('⚠️ Test des endpoints d\'allergènes...');
  
  const tests = [
    {
      name: 'GET /allergens',
      test: () => makeRequest(`${API_BASE_URL}/allergens`)
    },
    {
      name: 'GET /allergens/GLUTEN',
      test: () => makeRequest(`${API_BASE_URL}/allergens/GLUTEN`)
    }
  ];
  
  const results = [];
  for (const test of tests) {
    const result = await test.test();
    results.push({ name: test.name, ...result });
    console.log(`${test.name}: ${result.success ? '✅' : '❌'} ${result.status || result.error}`);
  }
  
  return results;
};

// Test complet de tous les endpoints
export const testAllEndpoints = async () => {
  console.log('🚀 Début des tests complets des endpoints backend...');
  
  const allResults = {
    auth: await testAuthEndpoints(),
    restaurants: await testRestaurantEndpoints(),
    menus: await testMenuEndpoints(),
    menuItems: await testMenuItemEndpoints(),
    events: await testEventEndpoints(),
    bookings: await testBookingEndpoints(),
    suppliers: await testSupplierEndpoints(),
    offers: await testOfferEndpoints(),
    allergens: await testAllergenEndpoints()
  };
  
  // Statistiques
  const totalTests = Object.values(allResults).flat().length;
  const successfulTests = Object.values(allResults).flat().filter(r => r.success).length;
  const failedTests = totalTests - successfulTests;
  
  console.log('\n📊 Résultats des tests:');
  console.log(`Total: ${totalTests}`);
  console.log(`✅ Réussis: ${successfulTests}`);
  console.log(`❌ Échecs: ${failedTests}`);
  console.log(`📈 Taux de réussite: ${((successfulTests / totalTests) * 100).toFixed(1)}%`);
  
  // Détail des échecs
  const failures = Object.values(allResults).flat().filter(r => !r.success);
  if (failures.length > 0) {
    console.log('\n❌ Endpoints en échec:');
    failures.forEach(failure => {
      console.log(`- ${failure.name}: ${failure.status || failure.error}`);
    });
  }
  
  return allResults;
};

// Test de connectivité de base
export const testBasicConnectivity = async () => {
  console.log('🌐 Test de connectivité de base...');
  
  try {
    const response = await fetch(`${API_BASE_URL}/restaurants`);
    if (response.ok) {
      console.log('✅ Backend accessible');
      return true;
    } else {
      console.log(`❌ Backend accessible mais erreur: ${response.status}`);
      return false;
    }
  } catch (error) {
    console.log(`❌ Backend inaccessible: ${error.message}`);
    return false;
  }
};

// Fonction principale pour lancer tous les tests
export const runBackendTests = async () => {
  console.log('🧪 === TESTS BACKEND VEGN-BIO ===\n');
  
  // Test de connectivité
  const isConnected = await testBasicConnectivity();
  if (!isConnected) {
    console.log('❌ Impossible de se connecter au backend. Vérifiez l\'URL et la disponibilité.');
    return;
  }
  
  console.log('\n');
  
  // Tests complets
  const results = await testAllEndpoints();
  
  console.log('\n🎯 Tests terminés !');
  
  return results;
};

// Export pour utilisation dans la console du navigateur
if (typeof window !== 'undefined') {
  window.testBackend = {
    runAllTests: runBackendTests,
    testAuth: testAuthEndpoints,
    testRestaurants: testRestaurantEndpoints,
    testMenus: testMenuEndpoints,
    testMenuItems: testMenuItemEndpoints,
    testEvents: testEventEndpoints,
    testBookings: testBookingEndpoints,
    testSuppliers: testSupplierEndpoints,
    testOffers: testOfferEndpoints,
    testAllergens: testAllergenEndpoints,
    testConnectivity: testBasicConnectivity
  };
  
  console.log('🔧 Tests backend disponibles dans window.testBackend');
  console.log('💡 Utilisez: window.testBackend.runAllTests() pour lancer tous les tests');
}
