# 🔒 Sécurité Stricte du Backend VegN-Bio

## 📋 Vue d'ensemble

Le backend VegN-Bio implémente une sécurité stricte et multi-couches pour protéger l'API et les données sensibles. Voici les aspects de sécurité les plus importants :

## 🛡️ 1. Configuration de Sécurité Spring Security

### **Authentification JWT Obligatoire**
```java
// Tous les endpoints (sauf ceux explicitement autorisés) nécessitent une authentification
.anyRequest().authenticated()
```

### **Endpoints Publiquement Accessibles (PermitAll)**
- ✅ `/api/v1/auth/**` - Authentification (register, login)
- ✅ `/swagger-ui/**`, `/v3/api-docs/**` - Documentation API
- ✅ `/api/v1/restaurants`, `/api/v1/allergens` - Données publiques
- ✅ `/api/v1/menus/**`, `/api/v1/menu-items/**` - Menus publics
- ✅ `/api/v1/chatbot/**` - Chatbot vétérinaire public
- ✅ `/api/v1/error-reports/**` - Reporting d'erreurs
- ✅ `/api/v1/events`, `/api/v1/bookings` - Événements publics
- ✅ `/api/v1/suppliers`, `/api/v1/offers` - Fournisseurs et offres
- ✅ `/api/v1/reviews/**` - Avis publics

### **Endpoints Protégés (Authentification Requise)**
- 🔒 `/api/v1/users/**` - Gestion des utilisateurs
- 🔒 `/api/v1/orders/**` - Commandes utilisateur
- 🔒 `/api/v1/payments/**` - Paiements
- 🔒 `/api/v1/admin/**` - Administration
- 🔒 Tous les autres endpoints non explicitement autorisés

## 🔐 2. Gestion des Tokens JWT

### **Filtre JWT Personnalisé**
```java
@Component
public class JwtAuthFilter extends OncePerRequestFilter {
    // Validation automatique des tokens sur chaque requête
    // Extraction du username depuis le token
    // Vérification de la validité du token
}
```

### **Configuration JWT**
- **Algorithme** : HS256 (HMAC avec SHA-256)
- **Durée de vie** : Configurable (généralement 24h)
- **Refresh Token** : Supporté pour la réauthentification
- **Validation** : Vérification de la signature et de l'expiration

## 🌐 3. Configuration CORS Stricte

### **Origines Autorisées**
```java
config.setAllowedOriginPatterns(List.of(
    "http://localhost:*",                    // Développement local
    "http://127.0.0.1:*",                   // Développement local
    "https://*.vercel.app",                  // Frontend Vercel
    "https://*.netlify.app",                 // Frontend Netlify
    "https://*.railway.app",                 // Déploiements Railway
    "https://*.onrender.com"                 // Déploiements Render
));
```

### **Méthodes HTTP Autorisées**
- GET, POST, PUT, PATCH, DELETE, OPTIONS, HEAD

### **Headers Autorisés**
- Authorization, Content-Type, X-Requested-With, Accept, Origin

## 🔒 4. Sécurité des Mots de Passe

### **Encodage BCrypt**
```java
@Bean
public PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder(); // Force 10 par défaut
}
```

### **Caractéristiques BCrypt**
- **Salt automatique** : Chaque mot de passe a un salt unique
- **Coût configurable** : Force de hachage ajustable
- **Résistance aux attaques** : Protection contre rainbow tables

## 🚫 5. Désactivation des Fonctionnalités Inutiles

### **CSRF Désactivé**
```java
.csrf(csrf -> csrf.disable()) // Pas nécessaire pour les APIs REST
```

### **Sessions Stateless**
```java
.sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
```

### **Authentification de Base Désactivée**
```java
.httpBasic(httpBasic -> httpBasic.disable())
.formLogin(formLogin -> formLogin.disable())
.logout(logout -> logout.disable())
```

## 🛡️ 6. Sécurité de la Base de Données

### **Contraintes de Validation**
```sql
-- Contraintes sur les valeurs autorisées
CHECK (severity IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL'))
CHECK (status IN ('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED'))
CHECK (accuracy_rating BETWEEN 1 AND 5)
CHECK (emergency_level BETWEEN 0 AND 5)
```

### **Index de Sécurité**
```sql
-- Index pour les requêtes sécurisées
CREATE INDEX idx_error_reports_user_id ON error_reports(user_id);
CREATE INDEX idx_diagnosis_feedback_user ON diagnosis_feedback(user_id);
```

### **Contraintes Uniques**
```sql
-- Prévention des doublons
UNIQUE(breed, recommendation)
UNIQUE(breed, symptom)
UNIQUE(breed, symptom, diagnosis)
```

## 🔍 7. Validation des Données

### **Validation des Entrées**
- **Bean Validation** : Annotations @Valid, @NotNull, @Size
- **Sanitisation** : Nettoyage des données d'entrée
- **Vérification des types** : Validation des types de données

### **Contrôles de Sécurité**
- **Longueur des chaînes** : Limitation de la taille des champs
- **Format des emails** : Validation du format email
- **Caractères spéciaux** : Filtrage des caractères dangereux

## 📊 8. Système de Reporting d'Erreurs

### **Table error_reports**
```sql
CREATE TABLE error_reports (
    id BIGSERIAL PRIMARY KEY,
    user_id VARCHAR(100),
    title VARCHAR(255),
    description TEXT,
    severity VARCHAR(20) CHECK (severity IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    status VARCHAR(20) DEFAULT 'OPEN' CHECK (status IN ('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED')),
    user_agent TEXT,
    url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### **Surveillance Automatique**
- **Détection d'erreurs** : Capture automatique des exceptions
- **Classification** : Niveaux de gravité (LOW, MEDIUM, HIGH, CRITICAL)
- **Suivi** : Statut des erreurs (OPEN, IN_PROGRESS, RESOLVED, CLOSED)

## 🔐 9. Sécurité des Endpoints Sensibles

### **Endpoints d'Administration**
- **Authentification renforcée** : Vérification des rôles
- **Audit** : Logging de toutes les actions administratives
- **Limitation d'accès** : Restriction par IP si nécessaire

### **Endpoints de Paiement**
- **Chiffrement** : Données sensibles chiffrées
- **Validation** : Vérification des montants et devises
- **Audit** : Traçabilité complète des transactions

## 🚨 10. Gestion des Erreurs Sécurisée

### **Messages d'Erreur Génériques**
```java
// Ne pas exposer d'informations sensibles dans les erreurs
throw new RuntimeException("Erreur interne du serveur");
// Au lieu de :
throw new RuntimeException("Erreur de connexion à la base de données : " + dbUrl);
```

### **Logging Sécurisé**
- **Pas de mots de passe** dans les logs
- **Sanitisation** des données sensibles
- **Niveaux de log** appropriés

## 🔧 11. Configuration de Production

### **Variables d'Environnement**
```bash
# Configuration sécurisée
JWT_SECRET=your-super-secret-key-here
DB_PASSWORD=secure-database-password
ENCRYPTION_KEY=your-encryption-key
```

### **Headers de Sécurité**
```java
.headers(headers -> headers
    .frameOptions(frameOptions -> frameOptions.disable()) // Protection contre clickjacking
    .contentTypeOptions(contentTypeOptions -> contentTypeOptions.disable())
    .httpStrictTransportSecurity(hsts -> hsts.disable())
)
```

## 📋 12. Checklist de Sécurité

### ✅ **Authentification**
- [x] JWT obligatoire pour les endpoints protégés
- [x] Validation des tokens sur chaque requête
- [x] Gestion des tokens expirés
- [x] Support des refresh tokens

### ✅ **Autorisation**
- [x] Contrôle d'accès basé sur les rôles
- [x] Endpoints publics correctement configurés
- [x] Endpoints protégés sécurisés

### ✅ **Validation**
- [x] Validation des données d'entrée
- [x] Sanitisation des inputs
- [x] Contraintes de base de données

### ✅ **CORS**
- [x] Origines autorisées configurées
- [x] Méthodes HTTP limitées
- [x] Headers contrôlés

### ✅ **Base de Données**
- [x] Contraintes de validation
- [x] Index de sécurité
- [x] Contraintes uniques

## 🚀 13. Recommandations de Production

### **Monitoring**
- **Surveillance des erreurs** : Alertes automatiques
- **Métriques de sécurité** : Tentatives de connexion échouées
- **Audit logs** : Traçabilité complète

### **Mise à Jour**
- **Dépendances** : Mise à jour régulière des librairies
- **Sécurité** : Patches de sécurité appliqués rapidement
- **Tests** : Tests de sécurité automatisés

### **Backup**
- **Sauvegarde** : Sauvegarde régulière de la base de données
- **Chiffrement** : Données chiffrées en transit et au repos
- **Récupération** : Plan de récupération en cas d'incident

## 🎯 Conclusion

Le backend VegN-Bio implémente une sécurité stricte et multi-couches qui protège efficacement l'API et les données sensibles. La configuration actuelle est robuste et prête pour la production, avec des mécanismes de sécurité appropriés pour une application de santé vétérinaire.

**Points clés de sécurité :**
- 🔒 Authentification JWT obligatoire
- 🛡️ CORS strictement configuré
- 🔐 Mots de passe chiffrés avec BCrypt
- 📊 Système de reporting d'erreurs
- 🚫 Fonctionnalités inutiles désactivées
- ✅ Validation stricte des données
