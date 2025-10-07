# VegN-Bio Mobile

Application mobile Flutter pour la consultation des menus et le chatbot vétérinaire de VegN-Bio.

## 🚀 Fonctionnalités

### 📱 Consultation des Menus
- Affichage des restaurants disponibles
- Consultation des menus par restaurant
- Filtrage par allergènes
- Informations détaillées sur les plats (prix, description, allergènes)

### 🤖 Chatbot Vétérinaire
- Assistant virtuel pour la santé des animaux
- Diagnostic basé sur la race et les symptômes
- Recommandations personnalisées
- Apprentissage continu grâce aux consultations vétérinaires
- Historique des consultations

### 📊 Reporting d'Erreurs
- Signalement automatique des erreurs
- Collecte d'informations système
- Statistiques pour les administrateurs
- Nettoyage automatique des anciens rapports

## 🛠️ Technologies Utilisées

- **Flutter** : Framework de développement mobile
- **Provider** : Gestion d'état
- **Dio** : Client HTTP
- **flutter_chat_ui** : Interface de chat
- **SharedPreferences** : Stockage local
- **Logger** : Logging des erreurs

## 📋 Prérequis

- Flutter SDK 3.0.0 ou supérieur
- Dart SDK 3.0.0 ou supérieur
- Android Studio / VS Code
- Backend VegN-Bio en production

## 🚀 Installation

1. **Cloner le projet**
   ```bash
   git clone <repository-url>
   cd vegn_bio_mobile
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Configurer les variables d'environnement**
   - Modifier le fichier `assets/.env`
   - Remplacer `https://votre-backend-url.up.railway.app` par l'URL de votre backend

4. **Lancer l'application**
   ```bash
   flutter run
   ```

## ⚙️ Configuration

### Variables d'Environnement

Le fichier `assets/.env` contient les configurations suivantes :

```env
# Configuration de l'API Backend
API_BASE_URL=https://votre-backend-url.up.railway.app/api/v1
API_TIMEOUT=30000

# Configuration du chatbot vétérinaire
CHATBOT_API_URL=https://votre-backend-url.up.railway.app/api/v1/chatbot
CHATBOT_MODEL_VERSION=v1.0

# Configuration du reporting d'erreurs
ERROR_REPORTING_ENABLED=true
ERROR_REPORTING_URL=https://votre-backend-url.up.railway.app/api/v1/errors
```

### Backend Requirements

L'application nécessite les endpoints suivants dans le backend :

#### Menus et Restaurants
- `GET /api/v1/restaurants` - Liste des restaurants
- `GET /api/v1/restaurants/{id}` - Détails d'un restaurant
- `GET /api/v1/menus/restaurant/{id}` - Menus d'un restaurant
- `GET /api/v1/menus/restaurant/{id}/active` - Menus actifs d'un restaurant
- `GET /api/v1/menus/{id}` - Détails d'un menu

#### Allergènes
- `GET /api/v1/allergens` - Liste des allergènes
- `GET /api/v1/allergens/{code}` - Détails d'un allergène
- `POST /api/v1/allergens/check-menu` - Vérifier les allergènes d'un menu

#### Chatbot Vétérinaire
- `POST /api/v1/chatbot/chat` - Envoyer un message au chatbot
- `POST /api/v1/chatbot/diagnosis` - Obtenir un diagnostic vétérinaire
- `POST /api/v1/chatbot/recommendations` - Obtenir des recommandations
- `POST /api/v1/chatbot/consultations` - Sauvegarder une consultation
- `GET /api/v1/chatbot/consultations` - Historique des consultations
- `GET /api/v1/chatbot/breeds` - Races d'animaux supportées
- `GET /api/v1/chatbot/symptoms/{breed}` - Symptômes communs pour une race

#### Reporting d'Erreurs
- `POST /api/v1/errors/report` - Signaler une erreur
- `GET /api/v1/errors/user/{userId}` - Erreurs d'un utilisateur
- `GET /api/v1/errors/type/{errorType}` - Erreurs par type
- `GET /api/v1/errors/statistics` - Statistiques d'erreurs
- `DELETE /api/v1/errors/cleanup` - Nettoyer les anciens rapports

## 📱 Structure de l'Application

```
lib/
├── models/           # Modèles de données
│   ├── menu.dart
│   ├── allergen.dart
│   ├── restaurant.dart
│   ├── chat.dart
│   └── error_report.dart
├── services/         # Services API
│   ├── api_service.dart
│   ├── allergen_service.dart
│   ├── chatbot_service.dart
│   └── error_reporting_service.dart
├── providers/        # Gestion d'état
│   ├── menu_provider.dart
│   ├── allergen_provider.dart
│   └── chatbot_provider.dart
├── screens/          # Écrans de l'application
│   ├── home_screen.dart
│   ├── restaurant_list_screen.dart
│   ├── menu_list_screen.dart
│   ├── allergen_filter_screen.dart
│   └── chatbot_screen.dart
├── widgets/          # Widgets réutilisables
└── utils/            # Utilitaires
```

## 🔧 Développement

### Ajout de nouvelles fonctionnalités

1. **Modèles** : Créer les modèles dans `lib/models/`
2. **Services** : Implémenter les appels API dans `lib/services/`
3. **Providers** : Gérer l'état dans `lib/providers/`
4. **Écrans** : Créer les interfaces dans `lib/screens/`

### Tests

```bash
# Tests unitaires
flutter test

# Tests d'intégration
flutter test integration_test/
```

### Build

```bash
# Build Android
flutter build apk --release

# Build iOS
flutter build ios --release
```

## 🐛 Gestion des Erreurs

L'application inclut un système de reporting d'erreurs automatique qui :

- Capture les erreurs non gérées
- Collecte les informations système
- Envoie les rapports au backend
- Permet aux administrateurs de surveiller la santé de l'application

## 📊 Monitoring

Les administrateurs peuvent consulter :

- Statistiques d'erreurs par type
- Erreurs par utilisateur
- Erreurs par dispositif
- Tendances temporelles

## 🤝 Contribution

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 👥 Support

Pour toute question ou problème :

1. Consulter la documentation du backend
2. Vérifier les logs d'erreurs
3. Contacter l'équipe de développement

---

**VegN-Bio Mobile** - Votre assistant pour une alimentation bio et la santé de vos animaux 🐾