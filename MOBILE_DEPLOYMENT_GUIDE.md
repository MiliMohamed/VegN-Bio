# Guide de Déploiement VegN-Bio Mobile

Ce guide vous accompagne dans le déploiement de l'application mobile Flutter VegN-Bio qui se connecte à votre backend de production.

## 🎯 Vue d'Ensemble

L'application mobile VegN-Bio comprend :
- **Consultation des menus** et allergènes des restaurants
- **Chatbot vétérinaire** avec apprentissage automatique
- **Système de reporting d'erreurs** pour le monitoring

## 📋 Prérequis

### Développement
- Flutter SDK 3.0.0+
- Dart SDK 3.0.0+
- Android Studio / VS Code
- Git

### Production
- Backend VegN-Bio déployé et accessible
- Certificats de signature (Android/iOS)
- Comptes développeur (Google Play Store, Apple App Store)

## 🚀 Étapes de Déploiement

### 1. Configuration du Backend

Assurez-vous que votre backend inclut les nouveaux modules :

```bash
# Vérifier que les migrations sont appliquées
cd backend
./mvnw flyway:info

# Appliquer les nouvelles migrations si nécessaire
./mvnw flyway:migrate
```

### 2. Configuration de l'Application Mobile

#### Variables d'Environnement
Modifiez le fichier `vegn_bio_mobile/assets/.env` :

```env
# Remplacez par votre URL de production
API_BASE_URL=https://votre-backend-production.up.railway.app/api/v1
API_TIMEOUT=30000

CHATBOT_API_URL=https://votre-backend-production.up.railway.app/api/v1/chatbot
CHATBOT_MODEL_VERSION=v1.0

ERROR_REPORTING_ENABLED=true
ERROR_REPORTING_URL=https://votre-backend-production.up.railway.app/api/v1/errors
```

#### Test de Connexion
```bash
cd vegn_bio_mobile
flutter pub get
flutter run
```

### 3. Build de Production

#### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommandé pour Google Play)
flutter build appbundle --release
```

#### iOS
```bash
# Build iOS (nécessite macOS)
flutter build ios --release
```

### 4. Tests de Production

#### Tests Fonctionnels
- [ ] Connexion au backend de production
- [ ] Affichage des restaurants
- [ ] Consultation des menus
- [ ] Filtrage par allergènes
- [ ] Fonctionnement du chatbot
- [ ] Reporting d'erreurs

#### Tests de Performance
- [ ] Temps de chargement des données
- [ ] Responsivité de l'interface
- [ ] Gestion des erreurs réseau
- [ ] Consommation mémoire

### 5. Déploiement sur les Stores

#### Google Play Store
1. Créer un compte développeur Google Play
2. Configurer les certificats de signature
3. Uploader l'APK/AAB
4. Remplir les métadonnées de l'application
5. Soumettre pour révision

#### Apple App Store
1. Créer un compte développeur Apple
2. Configurer les certificats et provisioning profiles
3. Uploader via Xcode ou Application Loader
4. Remplir les métadonnées de l'application
5. Soumettre pour révision

## 🔧 Configuration Avancée

### Monitoring et Analytics

#### Firebase (Recommandé)
```bash
# Ajouter Firebase à votre projet Flutter
flutter pub add firebase_core firebase_analytics firebase_crashlytics
```

#### Configuration Firebase
1. Créer un projet Firebase
2. Ajouter les applications Android/iOS
3. Télécharger les fichiers de configuration
4. Configurer les services

### Sécurité

#### Certificats SSL
- Vérifier que votre backend utilise HTTPS
- Configurer les certificats SSL valides
- Tester la connexion sécurisée

#### Authentification (Optionnel)
Si vous souhaitez ajouter l'authentification :
```bash
flutter pub add firebase_auth
```

### Performance

#### Optimisation des Images
```bash
flutter pub add cached_network_image
```

#### Cache Local
```bash
flutter pub add hive hive_flutter
```

## 📊 Monitoring Post-Déploiement

### Métriques à Surveiller

#### Backend
- Temps de réponse des APIs
- Taux d'erreur
- Utilisation des ressources
- Logs d'erreurs

#### Application Mobile
- Crashes et erreurs
- Temps de chargement
- Utilisation des fonctionnalités
- Feedback utilisateurs

### Outils Recommandés

#### Backend Monitoring
- Railway Dashboard
- Application Insights
- New Relic
- Datadog

#### Mobile Analytics
- Firebase Analytics
- Firebase Crashlytics
- App Center
- Sentry

## 🐛 Résolution de Problèmes

### Problèmes Courants

#### Connexion Backend
```bash
# Vérifier la connectivité
curl -I https://votre-backend.up.railway.app/api/v1/restaurants

# Vérifier les logs
docker logs vegn_api
```

#### Erreurs de Build
```bash
# Nettoyer le cache Flutter
flutter clean
flutter pub get

# Vérifier les dépendances
flutter doctor
```

#### Problèmes de Performance
- Vérifier la taille des images
- Optimiser les requêtes API
- Implémenter la pagination
- Utiliser le cache local

### Support

#### Logs d'Erreurs
Les erreurs sont automatiquement reportées au backend via l'endpoint `/api/v1/errors/report`.

#### Debugging
```bash
# Mode debug
flutter run --debug

# Logs détaillés
flutter run --verbose
```

## 📈 Améliorations Futures

### Fonctionnalités Suggérées
- [ ] Notifications push
- [ ] Mode hors ligne
- [ ] Géolocalisation des restaurants
- [ ] Système de réservation
- [ ] Paiement mobile
- [ ] Chat en temps réel
- [ ] IA améliorée pour le chatbot

### Optimisations
- [ ] Lazy loading des images
- [ ] Cache intelligent
- [ ] Compression des données
- [ ] Mise à jour OTA

## 📞 Support et Maintenance

### Maintenance Régulière
- Mise à jour des dépendances Flutter
- Surveillance des métriques
- Mise à jour du contenu
- Optimisation des performances

### Contact
Pour toute question ou problème :
- Consulter la documentation Flutter
- Vérifier les logs d'erreurs
- Contacter l'équipe de développement

---

**🎉 Félicitations !** Votre application mobile VegN-Bio est maintenant déployée et prête à servir vos utilisateurs !
