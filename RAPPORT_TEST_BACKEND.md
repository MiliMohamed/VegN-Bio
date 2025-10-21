# Rapport de Test - API VegN-Bio Backend
# URL: https://vegn-bio-backend.onrender.com
# Date: 21 Octobre 2025

## Résumé Exécutif

L'API backend VegN-Bio est **partiellement fonctionnelle** avec un taux de réussite de **36%** (9/25 tests réussis).

### ✅ Points Positifs
- **Serveur accessible** : Le backend répond aux requêtes
- **Endpoints publics fonctionnels** : 
  - `/api/v1/restaurants` ✅
  - `/api/v1/allergens` ✅  
  - `/api/v1/events` ✅
  - `/api/v1/suppliers` ✅
  - `/api/v1/offers` ✅
- **Chatbot partiellement fonctionnel** :
  - `/api/v1/chatbot/chat` ✅
  - `/api/v1/chatbot/breeds` ✅
  - `/api/v1/chatbot/symptoms/{breed}` ✅
- **Données présentes** : 12 restaurants, 14 allergènes, races d'animaux supportées

### ❌ Problèmes Identifiés

#### 1. **Problème Principal : Configuration CORS**
- **Symptôme** : Erreurs 403 Forbidden sur de nombreux endpoints
- **Cause** : Configuration CORS trop restrictive dans `CorsConfig.java`
- **Impact** : 
  - Authentification impossible (login/register)
  - Endpoints protégés inaccessibles
  - Endpoints spécifiques par ID bloqués

#### 2. **Endpoints Affectés par CORS**
```
❌ /api/v1/auth/login (403)
❌ /api/v1/auth/register (403)  
❌ /api/v1/auth/me (403)
❌ /api/v1/menus (403)
❌ /api/v1/bookings (403)
❌ /api/v1/reviews (403)
❌ /api/v1/restaurants/{id} (403)
❌ /api/v1/allergens/{code} (403)
❌ /api/v1/events/{id} (403)
❌ /api/v1/chatbot/diagnosis (403)
❌ /api/v1/chatbot/recommendations (403)
```

#### 3. **Configuration CORS Actuelle**
```java
config.setAllowedOriginPatterns(List.of(
    "http://localhost:3000", 
    "http://127.0.0.1:3000", 
    "http://web:3000",
    "http://localhost:3005",
    "http://127.0.0.1:3005",
    "http://localhost:8080",
    "http://127.0.0.1:8080",
    "https://*.vercel.app",
    "https://*.netlify.app",
    "https://*.railway.app"
));
```

## Solutions Recommandées

### 🔧 Solution Immédiate : Mise à jour CORS

Modifier `backend/src/main/java/com/vegnbio/api/config/CorsConfig.java` :

```java
@Configuration
public class CorsConfig {
  @Bean
  public CorsFilter corsFilter() {
    CorsConfiguration config = new CorsConfiguration();
    config.setAllowCredentials(true);
    config.setAllowedOriginPatterns(List.of(
        "http://localhost:*",           // Tous les ports locaux
        "http://127.0.0.1:*",          // Tous les ports locaux
        "https://*.vercel.app",         // Vercel
        "https://*.netlify.app",        // Netlify
        "https://*.railway.app",        // Railway
        "https://*.onrender.com",       // Render (nouveau)
        "https://vegn-bio-backend.onrender.com", // Backend lui-même
        "https://vegn-bio-frontend.onrender.com" // Frontend si déployé
    ));
    config.setAllowedMethods(List.of("GET","POST","PUT","PATCH","DELETE","OPTIONS"));
    config.setAllowedHeaders(List.of("*"));
    UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
    source.registerCorsConfiguration("/**", config);
    return new CorsFilter(source);
  }
}
```

### 🔧 Solution Alternative : CORS Permissif pour Tests

Pour les tests, vous pouvez temporairement permettre toutes les origines :

```java
config.setAllowedOriginPatterns(List.of("*"));
```

### 🔧 Solution de Production : Configuration Environnement

Utiliser des profils Spring pour différentes configurations :

```java
@Profile("production")
public CorsConfiguration productionCorsConfig() {
    // Configuration restrictive pour la production
}

@Profile("development") 
public CorsConfiguration developmentCorsConfig() {
    // Configuration permissive pour le développement
}
```

## Tests Détaillés

### Endpoints Fonctionnels ✅
| Endpoint | Status | Description |
|----------|--------|-------------|
| `GET /api/v1/restaurants` | 200 | Liste des 12 restaurants |
| `GET /api/v1/allergens` | 200 | Liste des 14 allergènes |
| `GET /api/v1/events` | 200 | Liste des événements |
| `GET /api/v1/suppliers` | 200 | Liste des fournisseurs |
| `GET /api/v1/offers` | 200 | Liste des offres |
| `POST /api/v1/chatbot/chat` | 200 | Chat simple fonctionnel |
| `GET /api/v1/chatbot/breeds` | 200 | 11 races supportées |
| `GET /api/v1/chatbot/symptoms/{breed}` | 200 | Symptômes par race |
| `GET /api/v1/menus/{id}` | 200 | Menu spécifique (ID 1) |

### Endpoints Problématiques ❌
| Endpoint | Status | Erreur |
|----------|--------|--------|
| `POST /api/v1/auth/login` | 403 | CORS - Authentification impossible |
| `GET /api/v1/menus` | 403 | CORS - Liste des menus |
| `GET /api/v1/bookings` | 403 | CORS - Réservations |
| `GET /api/v1/reviews` | 403 | CORS - Avis |
| `GET /api/v1/restaurants/{id}` | 403 | CORS - Restaurant spécifique |
| `GET /api/v1/allergens/{code}` | 403 | CORS - Allergène spécifique |
| `POST /api/v1/chatbot/diagnosis` | 403 | CORS - Diagnostic vétérinaire |
| `POST /api/v1/chatbot/recommendations` | 403 | CORS - Recommandations |

## Données Disponibles

### Restaurants (12)
- Veg'N Bio Bastille (BAS)
- Veg'N Bio République (REP)  
- Veg'N Bio Nation (NAT)
- Veg'N Bio Place d'Italie (ITA)
- Veg'N Bio Montparnasse (MON)
- Veg'N Bio Ivry (IVR)
- Veg'N Bio Beaubourg (BOU)
- Green Garden (GG001)
- Veggie Corner (VC002)
- Bio Bistro (BB003)
- Nature's Table (NT004)
- Fresh & Green (FG005)

### Allergènes (14)
- GLUTEN, CRUST, EGG, FISH, PEANUT, SOY, MILK, NUTS, CELERY, MUSTARD, SESAME, SULPHITES, LUPIN, MOLLUSCS

### Races d'Animaux Supportées (11)
- Chat, Chien, Cochon d'Inde, Hamster, Lapin, Lézard, Non spécifié, Oiseau, Poisson, Serpent, Tortue

## Recommandations

### Priorité 1 : Corriger CORS
1. Mettre à jour la configuration CORS
2. Redéployer le backend
3. Retester l'authentification

### Priorité 2 : Tests Complets
1. Tester tous les endpoints après correction CORS
2. Vérifier l'authentification avec les comptes de production
3. Tester les endpoints protégés

### Priorité 3 : Monitoring
1. Configurer des logs détaillés
2. Surveiller les erreurs CORS
3. Mettre en place des alertes

## Conclusion

Le backend VegN-Bio est **techniquement fonctionnel** mais souffre d'un **problème de configuration CORS** qui empêche l'utilisation complète de l'API. Une fois ce problème résolu, l'API devrait être pleinement opérationnelle.

**Action immédiate requise** : Mise à jour de la configuration CORS et redéploiement.
