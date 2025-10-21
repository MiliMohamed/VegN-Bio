# 🚀 Guide de Démarrage - VegN-Bio Mobile

## 📍 Vous êtes dans le bon dossier: `vegn_bio_mobile/`

## ⚡ Démarrage Rapide

### 1️⃣ Installation des dépendances

```powershell
# Depuis le dossier racine VegN-Bio
cd vegn_bio_mobile

# Installer les packages Flutter
flutter pub get
```

### 2️⃣ Configuration Backend

**Important**: L'application nécessite que le backend soit lancé!

```powershell
# Dans un autre terminal, depuis la racine du projet
cd backend
mvn spring-boot:run

# OU avec Docker
cd ..
docker-compose -f devops/docker-compose.yml up -d
```

Le backend doit être accessible sur: **http://localhost:8080**

### 3️⃣ Configuration des Variables d'Environnement (Optionnel)

Créer un fichier `.env` dans `vegn_bio_mobile/assets/`:

```env
API_BASE_URL=http://localhost:8080
```

### 4️⃣ Lancer l'Application

#### 🌐 Pour le Web (Recommandé pour tester)
```powershell
flutter run -d chrome --web-port=3000
```
Accessible sur: **http://localhost:3000**

#### 📱 Pour Android
```powershell
# Connecter un appareil Android ou lancer un émulateur
flutter devices

# Lancer l'app
flutter run -d android
```

#### 🍎 Pour iOS (Mac uniquement)
```powershell
flutter run -d ios
```

#### 💻 Pour Windows Desktop
```powershell
flutter run -d windows
```

---

## 🎯 Vérifications Avant de Lancer

### ✅ Checklist

- [ ] Flutter est installé: `flutter --version`
- [ ] Les dépendances sont installées: `flutter pub get`
- [ ] Le backend est lancé: http://localhost:8080/api/v1/restaurants
- [ ] Un appareil est disponible: `flutter devices`

### 🔍 Commandes de Vérification

```powershell
# Vérifier l'installation Flutter
flutter doctor

# Voir les appareils disponibles
flutter devices

# Vérifier que le backend répond
curl http://localhost:8080/api/v1/restaurants
# OU avec PowerShell
Invoke-WebRequest -Uri http://localhost:8080/api/v1/restaurants
```

---

## 📂 Structure des Commandes par Terminal

### Terminal 1: Backend
```powershell
cd C:\Users\Mili\OneDrive\Bureau\VegN-Bio\backend
mvn spring-boot:run
```

### Terminal 2: Application Mobile
```powershell
cd C:\Users\Mili\OneDrive\Bureau\VegN-Bio\vegn_bio_mobile
flutter run -d chrome --web-port=3000
```

---

## 🐛 Résolution des Problèmes Courants

### Problème 1: "No devices found"
```powershell
# Lancer Chrome
flutter run -d chrome

# OU installer les outils
flutter config --enable-web
flutter devices
```

### Problème 2: "Backend connection failed"
```powershell
# Vérifier que le backend est lancé
curl http://localhost:8080/api/v1/restaurants

# Vérifier les logs du backend
```

### Problème 3: "Package not found"
```powershell
# Nettoyer et réinstaller
flutter clean
flutter pub get
```

### Problème 4: "Build failed"
```powershell
# Sur Windows, exécuter en tant qu'administrateur
flutter doctor --android-licenses
flutter pub upgrade
```

---

## 🎨 Fonctionnalités de l'Application

### 🍽️ Onglet Restaurants
- Liste des restaurants partenaires
- Consultation des menus
- Filtrage par allergènes

### 🐾 Onglet Vétérinaire
- Sélection de la race de l'animal
- Sélection des symptômes
- Diagnostic automatique avec IA
- Recommandations personnalisées

### ⚙️ Onglet Admin
- Statistiques des erreurs
- Historique des consultations
- Monitoring de l'application

---

## 🔄 Mode Développement avec Hot Reload

Après avoir lancé `flutter run`, vous pouvez:

- **r** - Hot reload (recharge le code)
- **R** - Hot restart (redémarre l'app)
- **h** - Afficher l'aide
- **q** - Quitter

Les modifications du code sont automatiquement reflétées dans l'app!

---

## 📱 Compiler pour Production

### Web
```powershell
flutter build web
# Fichiers dans: build/web/
```

### Android APK
```powershell
flutter build apk --release
# Fichier: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (Google Play)
```powershell
flutter build appbundle --release
# Fichier: build/app/outputs/bundle/release/app-release.aab
```

### iOS (Mac uniquement)
```powershell
flutter build ios --release
```

---

## 🌐 URLs Importantes

| Service | URL Développement | URL Production |
|---------|-------------------|----------------|
| Backend API | http://localhost:8080 | https://vegn-bio-api.onrender.com |
| Mobile Web | http://localhost:3000 | À déployer |
| Frontend Web | http://localhost:3000 | https://vegn-bio.onrender.com |

---

## 🔧 Configuration Avancée

### Changer le Port Web
```powershell
flutter run -d chrome --web-port=8000
```

### Mode Debug Verbose
```powershell
flutter run -v
```

### Spécifier un Appareil
```powershell
# Lister les appareils
flutter devices

# Lancer sur un appareil spécifique
flutter run -d <device-id>
```

---

## 📊 Performance et Debug

### Activer le Mode Performance
```powershell
flutter run --profile
```

### Analyser les Performances
```powershell
flutter run --trace-startup
```

### DevTools
```powershell
# Lancer DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

---

## 🎓 Commandes Utiles

```powershell
# Mettre à jour Flutter
flutter upgrade

# Analyser le code
flutter analyze

# Formater le code
flutter format .

# Tester l'application
flutter test

# Voir la version
flutter --version

# Nettoyer les builds
flutter clean
```

---

## ✅ Premier Lancement - Résumé

**Depuis le dossier `VegN-Bio/vegn_bio_mobile/`:**

```powershell
# 1. Installer les dépendances
flutter pub get

# 2. Vérifier que tout est OK
flutter doctor

# 3. Lancer sur Chrome (le plus simple)
flutter run -d chrome --web-port=3000

# 4. Profiter de l'application! 🎉
```

---

**Besoin d'aide?** Consultez:
- 📖 [Documentation Flutter](https://docs.flutter.dev)
- 🐛 Issues GitHub du projet
- 💬 README.md du projet



