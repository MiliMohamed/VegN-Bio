# 🐾 VegN-Bio Mobile - Application Mobile Complète

## 📱 Description

VegN-Bio Mobile est une application mobile complète qui permet aux clients de :

- **Consulter les menus** des restaurants végétariens
- **Filtrer par allergènes** pour une sécurité alimentaire optimale
- **Utiliser un chatbot vétérinaire** pour diagnostiquer les maladies d'animaux
- **Accéder au tableau de bord admin** pour le monitoring et l'analyse

## 🚀 Fonctionnalités Principales

### 1. 🍽️ Consultation des Menus
- Affichage des restaurants partenaires
- Consultation des menus détaillés
- Filtrage par allergènes
- Interface intuitive et moderne

### 2. 🐕 Chatbot Vétérinaire Intelligent
- **Sélection de race** : Chien, Chat, Oiseau, etc.
- **Sélection de symptômes** : Liste dynamique selon la race
- **Diagnostic automatique** avec niveau de confiance
- **Système d'apprentissage** basé sur les consultations
- **Sauvegarde des consultations** pour améliorer les diagnostics futurs

### 3. 📊 Tableau de Bord Admin
- **Statistiques d'erreurs** en temps réel
- **Historique des consultations** vétérinaires
- **Analyse des patterns** d'apprentissage
- **Monitoring de l'application**

### 4. 🔧 Système de Reporting d'Erreurs
- **Reporting automatique** des erreurs
- **Informations détaillées** sur l'appareil
- **Catégorisation** des erreurs (API, Chatbot, Navigation)
- **Statistiques** pour les développeurs

## 🛠️ Installation et Configuration

### Prérequis
- Flutter SDK 3.0.0+
- Dart SDK
- Android Studio / Xcode (pour le déploiement mobile)

### Installation

1. **Cloner le projet**
```bash
git clone <repository-url>
cd VegN-Bio/vegn_bio_mobile
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Configuration des variables d'environnement**
```bash
# Copier le fichier d'exemple
cp env_example.txt .env

# Modifier les valeurs selon votre environnement
nano .env
```

4. **Lancer l'application**
```bash
# Pour le web
flutter run -d chrome --web-port=3000

# Pour Android
flutter run -d android

# Pour iOS
flutter run -d ios
```

## 🔧 Configuration Backend

L'application nécessite un backend fonctionnel avec les endpoints suivants :

### API Endpoints
- `GET /api/v1/restaurants` - Liste des restaurants
- `GET /api/v1/menus/{restaurantId}` - Menus d'un restaurant
- `GET /api/v1/allergens` - Liste des allergènes
- `POST /api/v1/chatbot/diagnosis` - Diagnostic vétérinaire
- `POST /api/v1/chatbot/consultations` - Sauvegarde des consultations
- `GET /api/v1/chatbot/breeds` - Races supportées
- `GET /api/v1/chatbot/symptoms/{breed}` - Symptômes par race
- `POST /api/v1/errors/report` - Reporting d'erreurs

## 🧠 Système d'Apprentissage du Chatbot

### Fonctionnement
1. **Collecte des données** : Chaque consultation est automatiquement sauvegardée
2. **Analyse des patterns** : Le système identifie les combinaisons race/symptômes les plus fréquentes
3. **Amélioration continue** : Les diagnostics s'améliorent avec le temps
4. **Confiance** : Chaque diagnostic inclut un niveau de confiance

### Données Collectées
- Race de l'animal
- Symptômes observés
- Diagnostic proposé
- Recommandations
- Niveau de confiance
- Timestamp de la consultation

## 📱 Interface Utilisateur

### Navigation
- **Restaurants** : Consultation des menus
- **Allergènes** : Filtrage et information
- **Vétérinaire** : Chatbot diagnostique
- **Admin** : Tableau de bord (accès restreint)

### Design
- **Material Design 3** : Interface moderne et intuitive
- **Responsive** : Adapté à tous les écrans
- **Accessibilité** : Support des lecteurs d'écran
- **Thème** : Couleurs cohérentes avec la marque

## 🔒 Sécurité et Confidentialité

### Données Sensibles
- **Chiffrement** des communications API
- **Validation** des données côté client et serveur
- **Gestion des erreurs** sans exposition d'informations sensibles
- **Logs sécurisés** pour le debugging

### Respect de la Vie Privée
- **Anonymisation** des données de consultation
- **Consentement** pour la collecte de données
- **Suppression** des données sur demande

## 🚀 Déploiement

### Web
```bash
flutter build web
# Déployer le dossier build/web
```

### Android
```bash
flutter build apk --release
# ou
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 📊 Monitoring et Analytics

### Métriques Collectées
- **Utilisation** des fonctionnalités
- **Erreurs** et exceptions
- **Performance** de l'application
- **Consultations** vétérinaires

### Tableau de Bord Admin
- Accès via l'onglet "Admin" dans l'application
- Visualisation des statistiques en temps réel
- Export des données pour analyse

## 🤝 Contribution

### Structure du Projet
```
lib/
├── models/          # Modèles de données
├── services/        # Services API
├── providers/       # Gestion d'état
├── screens/         # Écrans de l'application
├── widgets/         # Composants réutilisables
└── utils/           # Utilitaires
```

### Guidelines
- **Code propre** et commenté
- **Tests unitaires** pour les fonctions critiques
- **Documentation** des nouvelles fonctionnalités
- **Respect** des conventions Flutter/Dart

## 📞 Support

Pour toute question ou problème :
- **Issues GitHub** : Signaler les bugs
- **Documentation** : Consulter la documentation technique
- **Email** : support@vegnbio.com

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus de détails.

---

**VegN-Bio Mobile** - Votre compagnon pour une alimentation saine et des animaux en bonne santé ! 🐾🌱