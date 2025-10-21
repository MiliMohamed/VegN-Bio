# VegN-Bio - Documentation Technique et Architecture

## 📋 Table des Matières
1. [Vue d'ensemble](#vue-densemble)
2. [Architecture Générale](#architecture-générale)
3. [Backend - Spring Boot](#backend---spring-boot)
4. [Frontend - React](#frontend---react)
5. [Services et Modules](#services-et-modules)
6. [Liens Backend-Frontend](#liens-backend-frontend)
7. [Base de Données](#base-de-données)
8. [Sécurité et Authentification](#sécurité-et-authentification)
9. [Déploiement](#déploiement)

---

## Vue d'ensemble

**VegN-Bio** est une application web complète de gestion de restaurant bio végétarien développée avec une architecture moderne séparant le backend et le frontend.

### Technologies Principales
- **Backend**: Spring Boot 3.3.3 (Java 17)
- **Frontend**: React 18 avec TypeScript
- **Base de données**: PostgreSQL
- **Authentification**: JWT (JSON Web Token)
- **Conteneurisation**: Docker & Docker Compose

### URLs des Services
| Service | URL (Développement) | URL (Production) |
|---------|---------------------|------------------|
| Frontend Web | http://localhost:3000 | https://vegn-bio.onrender.com |
| Backend API | http://localhost:8080 | https://vegn-bio-api.onrender.com |
| Base de données | localhost:5432 | (Géré par Render) |
| Documentation API | http://localhost:8080/swagger-ui.html | https://vegn-bio-api.onrender.com/swagger-ui.html |

---

## Architecture Générale

```
┌─────────────────────────────────────────────────────────────┐
│                    CLIENT (Navigateur)                       │
└──────────────────────────┬──────────────────────────────────┘
                           │ HTTP/HTTPS
                           ↓
┌─────────────────────────────────────────────────────────────┐
│              FRONTEND - React + TypeScript                   │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │  Components │  │  Services   │  │   Contexts  │         │
│  │    (UI)     │→ │   (API)     │→ │   (State)   │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
└──────────────────────────┬──────────────────────────────────┘
                           │ REST API (Axios)
                           │ Authorization: Bearer {JWT}
                           ↓
┌─────────────────────────────────────────────────────────────┐
│              BACKEND - Spring Boot (Java)                    │
│  ┌──────────────────────────────────────────────────┐       │
│  │         Security Layer (JWT Filter)              │       │
│  └────────────────────┬─────────────────────────────┘       │
│                       ↓                                      │
│  ┌──────────────────────────────────────────────────┐       │
│  │              Controllers (REST)                  │       │
│  │  /api/v1/auth | /menus | /restaurants | ...     │       │
│  └────────────────────┬─────────────────────────────┘       │
│                       ↓                                      │
│  ┌──────────────────────────────────────────────────┐       │
│  │              Services (Business Logic)           │       │
│  └────────────────────┬─────────────────────────────┘       │
│                       ↓                                      │
│  ┌──────────────────────────────────────────────────┐       │
│  │         Repositories (Data Access - JPA)         │       │
│  └────────────────────┬─────────────────────────────┘       │
└───────────────────────┼──────────────────────────────────────┘
                        │ JDBC
                        ↓
┌─────────────────────────────────────────────────────────────┐
│                  BASE DE DONNÉES                             │
│                    PostgreSQL                                │
│  ┌──────┐  ┌────────┐  ┌──────┐  ┌──────────┐             │
│  │Users │  │Menus   │  │Events│  │Marketplace│  ...        │
│  └──────┘  └────────┘  └──────┘  └──────────┘             │
└─────────────────────────────────────────────────────────────┘
```

---

## Backend - Spring Boot

### Structure du Projet
```
backend/
├── src/main/java/com/vegnbio/api/
│   ├── VegnBioApplication.java          # Point d'entrée
│   ├── config/                          # Configurations
│   │   ├── SecurityConfig.java          # Sécurité & JWT
│   │   ├── CorsConfig.java              # CORS
│   │   └── OpenApiConfig.java           # Swagger/OpenAPI
│   └── modules/                         # Modules métier
│       ├── auth/                        # Authentification
│       ├── restaurant/                  # Gestion restaurants
│       ├── menu/                        # Gestion menus
│       ├── events/                      # Événements & réservations
│       ├── marketplace/                 # Marketplace bio
│       ├── feedback/                    # Avis & signalements
│       ├── caisse/                      # Système de caisse
│       ├── allergen/                    # Allergènes
│       ├── chatbot/                     # Assistant virtuel
│       └── errorreporting/              # Rapports d'erreurs
└── src/main/resources/
    ├── application.yml                  # Configuration principale
    ├── application-production.yml       # Configuration production
    └── db/migration/                    # Migrations Flyway
        └── V1__init.sql                 # Schéma initial
```

### Configuration (application.yml)
```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/vegnbiodb
    username: postgres
    password: postgres
  jpa:
    hibernate:
      ddl-auto: update
  flyway:
    enabled: true
    locations: classpath:db/migration

server:
  port: 8080

app:
  jwt:
    secret: ${JWT_SECRET:change-me}
```

### Dépendances Principales (pom.xml)
- **spring-boot-starter-web** - Framework web
- **spring-boot-starter-security** - Sécurité
- **spring-boot-starter-data-jpa** - Accès aux données
- **postgresql** - Driver PostgreSQL
- **flyway-core** - Migrations de base de données
- **jjwt** (v0.11.5) - Gestion des JWT
- **springdoc-openapi** (v2.6.0) - Documentation API
- **lombok** - Réduction du code boilerplate

---

## Frontend - React

### Structure du Projet
```
web/
├── public/
│   └── index.html                       # Page HTML principale
├── src/
│   ├── index.tsx                        # Point d'entrée React
│   ├── App.tsx                          # Composant racine
│   ├── components/                      # Composants React
│   │   ├── ModernLogin.tsx              # Page de connexion
│   │   ├── ModernRegister.tsx           # Page d'inscription
│   │   ├── ModernDashboard.tsx          # Tableau de bord
│   │   ├── ModernRestaurants.tsx        # Gestion restaurants
│   │   ├── ModernMenus.tsx              # Gestion menus
│   │   ├── ModernEvents.tsx             # Gestion événements
│   │   ├── ModernMarketplace.tsx        # Marketplace
│   │   ├── ProfessionalChatbot.tsx      # Chatbot IA
│   │   ├── ProfessionalReviews.tsx      # Avis clients
│   │   └── ProtectedRoute.tsx           # Routes protégées
│   ├── contexts/
│   │   └── AuthContext.tsx              # Contexte d'authentification
│   ├── services/
│   │   └── api.ts                       # Client API Axios
│   ├── hooks/
│   │   └── useRestaurants.ts            # Hook personnalisé
│   └── styles/                          # Fichiers CSS
└── package.json                         # Dépendances npm
```

### Dépendances Principales (package.json)
- **react** (v18.2.0) - Bibliothèque UI
- **react-router-dom** (v6.8.0) - Routing
- **axios** (v1.6.0) - Client HTTP
- **typescript** (v4.9.0) - Typage statique
- **bootstrap** (v5.3.2) - Framework CSS
- **react-bootstrap** (v2.9.1) - Composants Bootstrap
- **framer-motion** (v10.16.4) - Animations
- **lucide-react** (v0.292.0) - Icônes

### Configuration de l'API (src/services/api.ts)
```typescript
import axios from 'axios';

const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:8080';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Intercepteur pour ajouter le token JWT
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export default api;
```

---

## Services et Modules

### 1. 🔐 Module d'Authentification (Auth)

**Backend**: `modules/auth/`

#### Entités
- **User**: Utilisateur du système

#### Contrôleur: `AuthController`
| Endpoint | Méthode | Description |
|----------|---------|-------------|
| `/api/v1/auth/register` | POST | Inscription d'un nouvel utilisateur |
| `/api/v1/auth/login` | POST | Connexion et génération du JWT |
| `/api/v1/auth/me` | GET | Récupérer les infos de l'utilisateur connecté |

#### Services
- **AuthService**: Gestion de l'inscription et connexion
- **JwtService**: Génération et validation des tokens JWT
- **UserService**: Gestion des utilisateurs

#### DTO
- **LoginRequest**: Email et mot de passe
- **RegisterRequest**: Données d'inscription
- **AuthResponse**: Token JWT + informations utilisateur
- **UserDto**: Informations utilisateur

**Frontend**: `contexts/AuthContext.tsx`, `components/ModernLogin.tsx`, `components/ModernRegister.tsx`

#### Flux d'authentification
```
1. Utilisateur soumet email/password → Frontend
2. Frontend → POST /api/v1/auth/login → Backend
3. Backend vérifie les credentials
4. Backend génère un JWT token
5. Backend → {token, user} → Frontend
6. Frontend stocke le token dans localStorage
7. Frontend utilise le token pour toutes les requêtes suivantes
```

---

### 2. 🍽️ Module Restaurants

**Backend**: `modules/restaurant/`

#### Entités
- **Restaurant**: Informations du restaurant (nom, adresse, contact, etc.)

#### Contrôleur: `RestaurantController`
| Endpoint | Méthode | Description | Autorisation |
|----------|---------|-------------|--------------|
| `/api/v1/restaurants` | GET | Liste de tous les restaurants | Public |
| `/api/v1/restaurants` | POST | Créer un restaurant | RESTAURATEUR |
| `/api/v1/restaurants/{id}` | GET | Détails d'un restaurant | Public |
| `/api/v1/restaurants/{id}` | PUT | Modifier un restaurant | RESTAURATEUR |
| `/api/v1/restaurants/{id}` | DELETE | Supprimer un restaurant | ADMIN |

#### Services
- **RestaurantService**: Logique métier des restaurants

**Frontend**: `components/ModernRestaurants.tsx`

#### Fonctionnalités
- Affichage de la liste des restaurants avec filtres
- Ajout/modification/suppression de restaurants
- Affichage des détails (adresse, horaires, contact)
- Carte interactive des restaurants

---

### 3. 📋 Module Menus

**Backend**: `modules/menu/`

#### Entités
- **Menu**: Menu du restaurant (nom, description, période)
- **MenuItem**: Plat du menu (nom, prix, allergènes, catégorie)

#### Contrôleurs

**MenuController**
| Endpoint | Méthode | Description | Autorisation |
|----------|---------|-------------|--------------|
| `/api/v1/menus` | POST | Créer un menu | RESTAURATEUR |
| `/api/v1/menus/restaurant/{id}` | GET | Menus d'un restaurant | Public |
| `/api/v1/menus/restaurant/{id}/active` | GET | Menus actifs | Public |
| `/api/v1/menus/{id}` | GET | Détails d'un menu | Public |
| `/api/v1/menus/{id}` | PUT | Modifier un menu | RESTAURATEUR |
| `/api/v1/menus/{id}` | DELETE | Supprimer un menu | RESTAURATEUR |

**MenuItemController**
| Endpoint | Méthode | Description | Autorisation |
|----------|---------|-------------|--------------|
| `/api/v1/menu-items` | POST | Ajouter un plat | RESTAURATEUR |
| `/api/v1/menu-items/menu/{id}` | GET | Plats d'un menu | Public |
| `/api/v1/menu-items/{id}` | GET | Détails d'un plat | Public |
| `/api/v1/menu-items/{id}` | PUT | Modifier un plat | RESTAURATEUR |
| `/api/v1/menu-items/{id}` | DELETE | Supprimer un plat | RESTAURATEUR |

#### Services
- **MenuService**: Gestion des menus
- **MenuItemService**: Gestion des plats

**Frontend**: `components/ModernMenus.tsx`

#### Fonctionnalités
- Affichage des menus par restaurant
- Filtrage par date et catégorie
- Gestion des plats (CRUD)
- Indication des allergènes
- Prix et descriptions détaillées

---

### 4. 🎉 Module Événements

**Backend**: `modules/events/`

#### Entités
- **Event**: Événement organisé par un restaurant
- **Booking**: Réservation pour un événement
- **EventStatus**: ACTIVE, CANCELLED, COMPLETED
- **BookingStatus**: PENDING, CONFIRMED, CANCELLED

#### Contrôleurs

**EventController**
| Endpoint | Méthode | Description | Autorisation |
|----------|---------|-------------|--------------|
| `/api/v1/events` | POST | Créer un événement | RESTAURATEUR |
| `/api/v1/events` | GET | Liste des événements | Public |
| `/api/v1/events/{id}` | GET | Détails d'un événement | Public |
| `/api/v1/events/{id}/cancel` | PATCH | Annuler un événement | RESTAURATEUR |

**BookingController**
| Endpoint | Méthode | Description | Autorisation |
|----------|---------|-------------|--------------|
| `/api/v1/bookings` | POST | Créer une réservation | Authentifié |
| `/api/v1/bookings/event/{id}` | GET | Réservations d'un événement | Public |
| `/api/v1/bookings/restaurant/{id}` | GET | Réservations d'un restaurant | RESTAURATEUR |
| `/api/v1/bookings/{id}` | GET | Détails d'une réservation | Authentifié |
| `/api/v1/bookings/{id}/status` | PATCH | Changer le statut | RESTAURATEUR |

#### Services
- **EventService**: Gestion des événements
- **BookingService**: Gestion des réservations

**Frontend**: `components/ModernEvents.tsx`

#### Fonctionnalités
- Calendrier des événements
- Création d'événements (ateliers, dégustations, conférences)
- Système de réservation
- Gestion de la capacité
- Suivi des réservations

---

### 5. 🛒 Module Marketplace

**Backend**: `modules/marketplace/`

#### Entités
- **Supplier**: Fournisseur de produits bio
- **Offer**: Offre de produit sur la marketplace
- **SupplierStatus**: ACTIVE, INACTIVE, PENDING
- **OfferStatus**: AVAILABLE, SOLD_OUT, DISCONTINUED

#### Contrôleurs

**SupplierController**
| Endpoint | Méthode | Description | Autorisation |
|----------|---------|-------------|--------------|
| `/api/v1/suppliers` | POST | Créer un fournisseur | Authentifié |
| `/api/v1/suppliers` | GET | Fournisseurs actifs | Public |
| `/api/v1/suppliers/all` | GET | Tous les fournisseurs | ADMIN |
| `/api/v1/suppliers/{id}` | GET | Détails d'un fournisseur | Public |
| `/api/v1/suppliers/{id}/status` | PATCH | Changer le statut | ADMIN |

**OfferController**
| Endpoint | Méthode | Description | Autorisation |
|----------|---------|-------------|--------------|
| `/api/v1/offers` | POST | Créer une offre | Fournisseur |
| `/api/v1/offers` | GET | Offres disponibles | Public |
| `/api/v1/offers/supplier/{id}` | GET | Offres d'un fournisseur | Public |
| `/api/v1/offers/{id}` | GET | Détails d'une offre | Public |
| `/api/v1/offers/{id}` | PUT | Modifier une offre | Fournisseur |
| `/api/v1/offers/{id}/status` | PATCH | Changer le statut | Fournisseur |

#### Services
- **SupplierService**: Gestion des fournisseurs
- **OfferService**: Gestion des offres

**Frontend**: `components/ModernMarketplace.tsx`

#### Fonctionnalités
- Catalogue de produits bio
- Recherche et filtrage par catégorie
- Profils des fournisseurs
- Gestion des offres
- Système de commande

---

### 6. ⭐ Module Feedback (Avis et Signalements)

**Backend**: `modules/feedback/`

#### Entités
- **Review**: Avis client sur un restaurant
- **Report**: Signalement d'un problème
- **ReviewStatus**: PENDING, APPROVED, REJECTED
- **ReportStatus**: OPEN, IN_PROGRESS, RESOLVED, CLOSED

#### Contrôleurs

**ReviewController**
| Endpoint | Méthode | Description | Autorisation |
|----------|---------|-------------|--------------|
| `/api/v1/reviews` | POST | Créer un avis | CLIENT |
| `/api/v1/reviews/restaurant/{id}` | GET | Avis d'un restaurant | Public |
| `/api/v1/reviews/{id}` | GET | Détails d'un avis | Public |
| `/api/v1/reviews/{id}/status` | PATCH | Modérer un avis | ADMIN |

**ReportController**
| Endpoint | Méthode | Description | Autorisation |
|----------|---------|-------------|--------------|
| `/api/v1/reports` | POST | Créer un signalement | Authentifié |
| `/api/v1/reports` | GET | Liste des signalements | ADMIN |
| `/api/v1/reports/{id}` | GET | Détails d'un signalement | ADMIN |
| `/api/v1/reports/{id}/status` | PATCH | Changer le statut | ADMIN |

#### Services
- **ReviewService**: Gestion des avis
- **ReportService**: Gestion des signalements

**Frontend**: `components/ProfessionalReviews.tsx`

#### Fonctionnalités
- Système de notation (1-5 étoiles)
- Commentaires clients
- Modération des avis
- Signalement de problèmes
- Statistiques des avis

---

### 7. 💰 Module Caisse

**Backend**: `modules/caisse/`

#### Entités
- **Ticket**: Ticket de caisse
- **TicketLine**: Ligne de ticket (article)
- **TicketStatus**: OPEN, PAID, CANCELLED

#### Contrôleurs

**TicketController**
| Endpoint | Méthode | Description | Autorisation |
|----------|---------|-------------|--------------|
| `/api/v1/tickets` | POST | Créer un ticket | RESTAURATEUR |
| `/api/v1/tickets/restaurant/{id}` | GET | Tickets d'un restaurant | RESTAURATEUR |
| `/api/v1/tickets/{id}` | GET | Détails d'un ticket | RESTAURATEUR |
| `/api/v1/tickets/{id}/pay` | PATCH | Marquer comme payé | RESTAURATEUR |
| `/api/v1/tickets/{id}/cancel` | PATCH | Annuler un ticket | RESTAURATEUR |

**TicketLineController**
| Endpoint | Méthode | Description | Autorisation |
|----------|---------|-------------|--------------|
| `/api/v1/ticket-lines` | POST | Ajouter une ligne | RESTAURATEUR |
| `/api/v1/ticket-lines/ticket/{id}` | GET | Lignes d'un ticket | RESTAURATEUR |
| `/api/v1/ticket-lines/{id}` | DELETE | Supprimer une ligne | RESTAURATEUR |

#### Services
- **TicketService**: Gestion des tickets
- **TicketLineService**: Gestion des lignes de tickets

#### Fonctionnalités
- Création de tickets de caisse
- Ajout/suppression d'articles
- Calcul automatique du total
- Gestion des paiements
- Historique des ventes

---

### 8. 🤖 Module Chatbot (Assistant Virtuel)

**Backend**: `modules/chatbot/`

#### Entités
- **VeterinaryConsultation**: Consultation vétérinaire pour animaux

#### Contrôleur: `ChatbotController`
| Endpoint | Méthode | Description | Autorisation |
|----------|---------|-------------|--------------|
| `/api/v1/chatbot/chat` | POST | Envoyer un message | Public |
| `/api/v1/chatbot/diagnose` | POST | Diagnostic vétérinaire | Public |
| `/api/v1/chatbot/consultation` | POST | Créer une consultation | Public |
| `/api/v1/chatbot/consultations` | GET | Liste des consultations | ADMIN |

#### Services
- **ChatbotService**: Logique de conversation IA

**Frontend**: `components/ProfessionalChatbot.tsx`

#### Fonctionnalités
- Assistant virtuel pour conseils alimentaires
- Diagnostic vétérinaire pour animaux de compagnie
- Suggestions de menu
- Réponses aux questions fréquentes

---

### 9. 🚨 Module Error Reporting

**Backend**: `modules/errorreporting/`

#### Entités
- **ErrorReport**: Rapport d'erreur technique

#### Contrôleur: `ErrorReportingController`
| Endpoint | Méthode | Description | Autorisation |
|----------|---------|-------------|--------------|
| `/api/v1/errors/report` | POST | Signaler une erreur | Public |
| `/api/v1/errors` | GET | Liste des erreurs | ADMIN |
| `/api/v1/errors/statistics` | GET | Statistiques d'erreurs | ADMIN |

#### Services
- **ErrorReportingService**: Collecte et analyse des erreurs

#### Fonctionnalités
- Reporting automatique d'erreurs
- Collecte de logs
- Statistiques d'erreurs
- Alertes administrateurs

---

### 10. 🥜 Module Allergènes

**Backend**: `modules/allergen/`

#### Entités
- **Allergen**: Allergène (code, nom, description)

#### Contrôleur: `AllergenController`
| Endpoint | Méthode | Description | Autorisation |
|----------|---------|-------------|--------------|
| `/api/v1/allergens` | GET | Liste des allergènes | Public |
| `/api/v1/allergens/{code}` | GET | Détails d'un allergène | Public |

#### Services
- **AllergenService**: Gestion des allergènes

#### Fonctionnalités
- Liste standardisée des allergènes
- Association aux plats du menu
- Filtrage des menus par allergènes
- Alertes allergènes

---

## Liens Backend-Frontend

### Flux de Communication

#### 1. Authentification
```
Frontend (ModernLogin.tsx)
  ↓ api.post('/api/v1/auth/login', {email, password})
Backend (AuthController.login)
  ↓ AuthService.login()
  ↓ JwtService.generateToken()
Backend → {token, user}
  ↓
Frontend → localStorage.setItem('token')
  ↓
Frontend → AuthContext.setUser(user)
```

#### 2. Récupération des Restaurants
```
Frontend (ModernRestaurants.tsx)
  ↓ useEffect(() => loadRestaurants())
  ↓ api.get('/api/v1/restaurants')
  ↓ Headers: {Authorization: 'Bearer ' + token}
Backend (RestaurantController.getAllRestaurants)
  ↓ JwtAuthFilter vérifie le token (optionnel pour GET)
  ↓ RestaurantService.getAllRestaurants()
  ↓ RestaurantRepository.findAll()
PostgreSQL → Liste de restaurants
  ↓
Backend → JSON: [RestaurantDto]
  ↓
Frontend → setState(restaurants)
  ↓
Frontend → Affichage dans l'UI
```

#### 3. Création d'un Menu
```
Frontend (ModernMenus.tsx)
  ↓ handleSubmit()
  ↓ api.post('/api/v1/menus', menuData)
  ↓ Headers: {Authorization: 'Bearer ' + token}
Backend (MenuController.createMenu)
  ↓ JwtAuthFilter vérifie le token
  ↓ @PreAuthorize("hasRole('RESTAURATEUR')")
  ↓ MenuService.createMenu(request)
  ↓ MenuRepository.save(menu)
PostgreSQL → Menu sauvegardé
  ↓
Backend → JSON: MenuDto
  ↓
Frontend → Notification de succès
  ↓
Frontend → Rafraîchissement de la liste
```

### Gestion des Erreurs

#### Frontend (api.ts)
```typescript
api.interceptors.response.use(
  response => response,
  error => {
    if (error.response?.status === 401) {
      // Token invalide → Déconnexion
      localStorage.removeItem('token');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);
```

#### Backend (SecurityConfig)
```java
@Bean
public SecurityFilterChain securityFilterChain(HttpSecurity http) {
    return http
        .cors(cors -> cors.configurationSource(corsConfigurationSource()))
        .csrf(csrf -> csrf.disable())
        .authorizeHttpRequests(auth -> auth
            .requestMatchers("/api/v1/auth/**").permitAll()
            .requestMatchers(HttpMethod.GET, "/api/v1/restaurants/**").permitAll()
            .requestMatchers(HttpMethod.GET, "/api/v1/menus/**").permitAll()
            .anyRequest().authenticated()
        )
        .sessionManagement(session -> 
            session.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
        )
        .addFilterBefore(jwtAuthFilter, 
            UsernamePasswordAuthenticationFilter.class)
        .build();
}
```

---

## Base de Données

### Schéma PostgreSQL (simplifié)

```sql
-- Table des utilisateurs
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    role VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des restaurants
CREATE TABLE restaurants (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT,
    phone VARCHAR(50),
    email VARCHAR(255),
    owner_id BIGINT REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des menus
CREATE TABLE menus (
    id BIGSERIAL PRIMARY KEY,
    restaurant_id BIGINT REFERENCES restaurants(id),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des plats
CREATE TABLE menu_items (
    id BIGSERIAL PRIMARY KEY,
    menu_id BIGINT REFERENCES menus(id),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2),
    category VARCHAR(100),
    is_vegetarian BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des événements
CREATE TABLE events (
    id BIGSERIAL PRIMARY KEY,
    restaurant_id BIGINT REFERENCES restaurants(id),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    event_date TIMESTAMP NOT NULL,
    max_capacity INTEGER,
    price DECIMAL(10,2),
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des réservations
CREATE TABLE bookings (
    id BIGSERIAL PRIMARY KEY,
    event_id BIGINT REFERENCES events(id),
    user_id BIGINT REFERENCES users(id),
    guests_count INTEGER DEFAULT 1,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des fournisseurs
CREATE TABLE suppliers (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    contact_email VARCHAR(255),
    contact_phone VARCHAR(50),
    bio TEXT,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des offres marketplace
CREATE TABLE offers (
    id BIGSERIAL PRIMARY KEY,
    supplier_id BIGINT REFERENCES suppliers(id),
    product_name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2),
    unit VARCHAR(50),
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des avis
CREATE TABLE reviews (
    id BIGSERIAL PRIMARY KEY,
    restaurant_id BIGINT REFERENCES restaurants(id),
    user_id BIGINT REFERENCES users(id),
    rating INTEGER CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des signalements
CREATE TABLE reports (
    id BIGSERIAL PRIMARY KEY,
    restaurant_id BIGINT REFERENCES restaurants(id),
    user_id BIGINT REFERENCES users(id),
    title VARCHAR(255),
    description TEXT,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des tickets de caisse
CREATE TABLE tickets (
    id BIGSERIAL PRIMARY KEY,
    restaurant_id BIGINT REFERENCES restaurants(id),
    total_amount DECIMAL(10,2),
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des lignes de tickets
CREATE TABLE ticket_lines (
    id BIGSERIAL PRIMARY KEY,
    ticket_id BIGINT REFERENCES tickets(id),
    menu_item_id BIGINT REFERENCES menu_items(id),
    quantity INTEGER,
    unit_price DECIMAL(10,2),
    total_price DECIMAL(10,2)
);

-- Table des allergènes
CREATE TABLE allergens (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(10) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Table de liaison menu_items <-> allergens
CREATE TABLE menu_item_allergens (
    menu_item_id BIGINT REFERENCES menu_items(id),
    allergen_id BIGINT REFERENCES allergens(id),
    PRIMARY KEY (menu_item_id, allergen_id)
);
```

### Migrations Flyway

Les migrations sont gérées par **Flyway** et se trouvent dans `backend/src/main/resources/db/migration/`.

- **V1__init.sql**: Création du schéma initial
- Les migrations suivantes seront nommées V2__, V3__, etc.

Flyway s'exécute automatiquement au démarrage de l'application et applique les migrations manquantes.

---

## Sécurité et Authentification

### Architecture de Sécurité

```
Request → JwtAuthFilter → SecurityConfig → Controller
            ↓
        Vérifie JWT
            ↓
        Extrait User
            ↓
    SecurityContext
```

### Génération du JWT

```java
// JwtService.java
public String generateToken(User user) {
    return Jwts.builder()
        .setSubject(user.getEmail())
        .claim("userId", user.getId())
        .claim("role", user.getRole())
        .setIssuedAt(new Date())
        .setExpiration(new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 24)) // 24h
        .signWith(getSigningKey(), SignatureAlgorithm.HS256)
        .compact();
}
```

### Validation du JWT

```java
// JwtAuthFilter.java
@Override
protected void doFilterInternal(HttpServletRequest request, 
                                 HttpServletResponse response, 
                                 FilterChain filterChain) {
    String authHeader = request.getHeader("Authorization");
    if (authHeader != null && authHeader.startsWith("Bearer ")) {
        String token = authHeader.substring(7);
        String email = jwtService.extractEmail(token);
        
        if (email != null && jwtService.isTokenValid(token)) {
            User user = userRepository.findByEmail(email);
            UsernamePasswordAuthenticationToken authToken = 
                new UsernamePasswordAuthenticationToken(
                    user, null, user.getAuthorities()
                );
            SecurityContextHolder.getContext().setAuthentication(authToken);
        }
    }
    filterChain.doFilter(request, response);
}
```

### Rôles et Permissions

| Rôle | Permissions |
|------|-------------|
| **ADMIN** | Accès complet à tous les modules |
| **RESTAURATEUR** | Gestion de son restaurant, menus, événements, caisse |
| **CLIENT** | Consultation, réservations, avis |
| **SUPPLIER** | Gestion de ses offres marketplace |

### CORS Configuration

```java
// CorsConfig.java
@Bean
public CorsConfigurationSource corsConfigurationSource() {
    CorsConfiguration configuration = new CorsConfiguration();
    configuration.setAllowedOrigins(Arrays.asList(
        "http://localhost:3000",
        "https://vegn-bio.onrender.com"
    ));
    configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "PATCH"));
    configuration.setAllowedHeaders(Arrays.asList("*"));
    configuration.setAllowCredentials(true);
    
    UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
    source.registerCorsConfiguration("/**", configuration);
    return source;
}
```

---

## Déploiement

### Architecture de Déploiement

```
┌─────────────────────────────────────────────────────────────┐
│                  RENDER (Cloud Platform)                     │
│                                                              │
│  ┌────────────────────┐        ┌──────────────────────┐    │
│  │   Web Service      │        │   Web Service        │    │
│  │   (Frontend)       │        │   (Backend)          │    │
│  │   React + Nginx    │◄──────►│   Spring Boot        │    │
│  │   Port: 3000       │  REST  │   Port: 8080         │    │
│  └────────────────────┘  API   └──────────┬───────────┘    │
│                                            │                 │
│                                            │ JDBC            │
│                                            ↓                 │
│                          ┌─────────────────────────────┐    │
│                          │  PostgreSQL Database        │    │
│                          │  (Managed Service)          │    │
│                          └─────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

### Variables d'Environnement

#### Backend (Production)
```
SPRING_DATASOURCE_URL=jdbc:postgresql://[host]:[port]/[database]
SPRING_DATASOURCE_USERNAME=[username]
SPRING_DATASOURCE_PASSWORD=[password]
JWT_SECRET=[secret-key-32-chars-minimum]
SPRING_PROFILES_ACTIVE=production
```

#### Frontend (Production)
```
REACT_APP_API_URL=https://vegn-bio-api.onrender.com
```

### Docker Configuration

#### Backend Dockerfile
```dockerfile
FROM eclipse-temurin:17-jdk-alpine as build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN ./mvnw clean package -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

#### Frontend Dockerfile
```dockerfile
FROM node:18-alpine as build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### Scripts de Déploiement

#### `deploy-production.ps1`
Script PowerShell pour déployer sur Render depuis Windows.

#### `test-api-production.ps1`
Script de test pour valider le déploiement.

### Monitoring et Logs

- **Backend Logs**: Accessible via Render Dashboard
- **Database Monitoring**: PostgreSQL logs dans Render
- **Error Tracking**: Module ErrorReporting collecte les erreurs

---

## Annexes

### A. Codes HTTP Standards

| Code | Signification |
|------|---------------|
| 200 | OK - Requête réussie |
| 201 | Created - Ressource créée |
| 400 | Bad Request - Données invalides |
| 401 | Unauthorized - Non authentifié |
| 403 | Forbidden - Non autorisé |
| 404 | Not Found - Ressource introuvable |
| 500 | Internal Server Error - Erreur serveur |

### B. Format des Réponses API

#### Succès
```json
{
  "id": 1,
  "name": "Restaurant Bio Végétal",
  "address": "123 Rue Verte",
  "email": "contact@restau.bio"
}
```

#### Erreur
```json
{
  "timestamp": "2024-01-15T10:30:00",
  "status": 400,
  "error": "Bad Request",
  "message": "Email already exists",
  "path": "/api/v1/auth/register"
}
```

### C. Commandes Utiles

#### Docker
```bash
# Démarrer tous les services
docker-compose -f devops/docker-compose.yml up -d

# Voir les logs
docker-compose -f devops/docker-compose.yml logs -f api

# Arrêter les services
docker-compose -f devops/docker-compose.yml down

# Nettoyer les volumes
docker-compose -f devops/docker-compose.yml down -v
```

#### Maven (Backend)
```bash
# Compiler
./mvnw clean package

# Lancer
./mvnw spring-boot:run

# Tests
./mvnw test
```

#### npm (Frontend)
```bash
# Installer les dépendances
npm install

# Démarrer en développement
npm start

# Build pour production
npm run build

# Tests
npm test
```

### D. Outils de Développement

| Outil | Usage | URL |
|-------|-------|-----|
| **Swagger UI** | Documentation API interactive | http://localhost:8080/swagger-ui.html |
| **pgAdmin** | Administration PostgreSQL | http://localhost:5050 |
| **Postman** | Test d'API | Desktop app |
| **React DevTools** | Débogage React | Extension navigateur |

---

## Conclusion

VegN-Bio est une application complète et moderne qui suit les meilleures pratiques de développement:

✅ **Architecture découplée** - Frontend et Backend séparés
✅ **API REST** - Communication standardisée
✅ **Sécurité robuste** - JWT, rôles, autorisations
✅ **Base de données normalisée** - PostgreSQL avec migrations
✅ **Code maintenable** - Structure modulaire, conventions
✅ **Documentation complète** - Swagger, README, ce document
✅ **Déploiement facilité** - Docker, scripts automatisés
✅ **Scalabilité** - Microservices ready, stateless

---

**Document généré le**: 10 octobre 2025  
**Version**: 1.0  
**Projet**: VegN-Bio  
**Contact**: admin@vegnbio.com



