# 📱 Comment Lancer l'Application Mobile Flutter

## 🎯 Résumé Rapide

**Dossier à utiliser:** `vegn_bio_mobile/`

**Commande la plus simple:**
```powershell
cd vegn_bio_mobile
flutter run -d chrome --web-port=3000
```

---

## 📂 Il y a DEUX Dossiers Flutter dans le Projet

| Dossier | Description | Utilisation |
|---------|-------------|-------------|
| **`vegn_bio_mobile/`** | ✅ **À UTILISER** - Application complète avec chatbot vétérinaire | **Application principale** |
| `vegn_bio_app/` | ⚠️  Ancienne version ou tests | Ne pas utiliser |

---

## 🚀 Méthode 1: Avec les Scripts (RECOMMANDÉ)

### Sous Windows PowerShell:
```powershell
cd vegn_bio_mobile
.\run_mobile.ps1 web
```

### Sous Windows CMD:
```cmd
cd vegn_bio_mobile
run_mobile.bat web
```

**Options disponibles:**
- `web` - Lance sur Chrome (par défaut)
- `android` - Lance sur Android
- `windows` - Lance sur Windows Desktop
- `ios` - Lance sur iOS (Mac uniquement)

---

## 🚀 Méthode 2: Commandes Manuelles

### Étape 1: Se placer dans le bon dossier
```powershell
cd C:\Users\Mili\OneDrive\Bureau\VegN-Bio\vegn_bio_mobile
```

### Étape 2: Installer les dépendances
```powershell
flutter pub get
```

### Étape 3: Lancer l'application

#### 🌐 Sur Chrome (Web) - LE PLUS SIMPLE
```powershell
flutter run -d chrome --web-port=3000
```
**URL:** http://localhost:3000

#### 📱 Sur Android
```powershell
# 1. Connecter votre téléphone Android en USB
# OU lancer un émulateur Android depuis Android Studio

# 2. Vérifier que l'appareil est détecté
flutter devices

# 3. Lancer
flutter run -d android
```

#### 💻 Sur Windows Desktop
```powershell
flutter run -d windows
```

---

## ⚠️ IMPORTANT: Le Backend doit être lancé!

L'application mobile a besoin du backend pour fonctionner.

### Vérifier si le backend est lancé:
```powershell
# PowerShell
Invoke-WebRequest -Uri http://localhost:8080/api/v1/restaurants

# OU dans un navigateur
# Ouvrir: http://localhost:8080/api/v1/restaurants
```

### Lancer le backend si nécessaire:

**Option A: Avec Maven**
```powershell
# Dans un NOUVEAU terminal
cd backend
mvn spring-boot:run
```

**Option B: Avec Docker**
```powershell
# Depuis la racine du projet
docker-compose -f devops/docker-compose.yml up -d
```

---

## 📋 Checklist Avant de Lancer

Vérifiez ces points:

- [ ] ✅ Flutter est installé: `flutter --version`
- [ ] ✅ Vous êtes dans le dossier `vegn_bio_mobile/`
- [ ] ✅ Les dépendances sont installées: `flutter pub get`
- [ ] ✅ Le backend est lancé sur http://localhost:8080
- [ ] ✅ Un appareil est disponible: `flutter devices`

---

## 🎯 Configuration Complète - Pas à Pas

### 1️⃣ Ouvrir PowerShell
```
Touche Windows + X → PowerShell (Admin)
```

### 2️⃣ Naviguer vers le dossier
```powershell
cd C:\Users\Mili\OneDrive\Bureau\VegN-Bio\vegn_bio_mobile
```

### 3️⃣ Vérifier Flutter
```powershell
flutter doctor
```

Si des problèmes apparaissent, suivez les instructions affichées.

### 4️⃣ Installer les dépendances
```powershell
flutter pub get
```

### 5️⃣ Voir les appareils disponibles
```powershell
flutter devices
```

Vous devriez voir au minimum:
- **Chrome** (pour le web)
- **Windows** (si sur Windows)
- **Android** (si téléphone connecté ou émulateur lancé)

### 6️⃣ Lancer sur Chrome
```powershell
flutter run -d chrome --web-port=3000
```

### 7️⃣ Profiter de l'application! 🎉

---

## 🔄 Workflow de Développement

### Terminal 1: Backend
```powershell
cd C:\Users\Mili\OneDrive\Bureau\VegN-Bio\backend
mvn spring-boot:run
```
**Laissez ce terminal ouvert!**

### Terminal 2: Application Mobile
```powershell
cd C:\Users\Mili\OneDrive\Bureau\VegN-Bio\vegn_bio_mobile
flutter run -d chrome --web-port=3000
```
**Laissez ce terminal ouvert aussi!**

### Modification du Code
- Modifiez les fichiers dans `lib/`
- Appuyez sur **`r`** dans le terminal pour recharger
- Appuyez sur **`R`** pour redémarrer complètement
- Appuyez sur **`q`** pour quitter

---

## 🎨 Fonctionnalités de l'Application Mobile

Une fois lancée, vous verrez:

### 🏠 Onglet Accueil
- Liste des restaurants partenaires
- Menus disponibles

### 🍽️ Onglet Restaurants
- Consultation des menus détaillés
- Filtrage par allergènes
- Informations des restaurants

### 🐾 Onglet Vétérinaire (Chatbot)
- Sélection de la race de l'animal (Chien, Chat, etc.)
- Sélection des symptômes
- Diagnostic automatique avec IA
- Recommandations personnalisées
- Niveau de confiance du diagnostic

### 👤 Onglet Profil/Admin
- Statistiques de l'application
- Historique des consultations
- Gestion des erreurs

---

## 🐛 Problèmes Courants et Solutions

### ❌ Problème: "Flutter command not found"
**Solution:**
```powershell
# Installer Flutter
# https://docs.flutter.dev/get-started/install/windows

# Vérifier l'installation
flutter --version
```

### ❌ Problème: "No devices found"
**Solution:**
```powershell
# Activer le support web
flutter config --enable-web

# Vérifier à nouveau
flutter devices

# Lancer sur Chrome spécifiquement
flutter run -d chrome
```

### ❌ Problème: "Backend connection refused"
**Solution:**
1. Vérifier que le backend est lancé:
   ```powershell
   # Dans un navigateur, ouvrir:
   http://localhost:8080/api/v1/restaurants
   ```

2. Si le backend ne répond pas, le lancer:
   ```powershell
   cd backend
   mvn spring-boot:run
   ```

### ❌ Problème: "Package not found" ou erreurs de compilation
**Solution:**
```powershell
# Nettoyer et réinstaller
flutter clean
flutter pub get

# Si ça ne marche toujours pas
flutter pub upgrade
```

### ❌ Problème: "Port 3000 already in use"
**Solution:**
```powershell
# Utiliser un autre port
flutter run -d chrome --web-port=8000

# OU arrêter le processus sur le port 3000
netstat -ano | findstr :3000
taskkill /PID <PID> /F
```

---

## 📱 Tester sur un Vrai Téléphone Android

### Étape 1: Activer le Mode Développeur
1. Ouvrir **Paramètres** sur le téléphone
2. Aller dans **À propos du téléphone**
3. Appuyer **7 fois** sur **Numéro de build**
4. Le mode développeur est activé!

### Étape 2: Activer le Débogage USB
1. Retourner dans **Paramètres**
2. Aller dans **Options de développeur**
3. Activer **Débogage USB**

### Étape 3: Connecter le Téléphone
1. Connecter le téléphone à l'ordinateur avec un câble USB
2. Sur le téléphone, autoriser le débogage USB

### Étape 4: Vérifier la Connexion
```powershell
flutter devices
```
Vous devriez voir votre téléphone dans la liste.

### Étape 5: Lancer l'Application
```powershell
flutter run -d android
```

---

## 🏗️ Compiler pour Production

### Pour Android (APK)
```powershell
flutter build apk --release
```
**Fichier généré:** `build/app/outputs/flutter-apk/app-release.apk`

### Pour Android (App Bundle - Google Play)
```powershell
flutter build appbundle --release
```
**Fichier généré:** `build/app/outputs/bundle/release/app-release.aab`

### Pour Web
```powershell
flutter build web
```
**Fichiers générés:** `build/web/`

### Pour Windows
```powershell
flutter build windows --release
```
**Fichiers générés:** `build/windows/runner/Release/`

---

## 📊 Commandes Utiles Flutter

| Commande | Description |
|----------|-------------|
| `flutter doctor` | Vérifier l'installation Flutter |
| `flutter devices` | Lister les appareils disponibles |
| `flutter pub get` | Installer les dépendances |
| `flutter pub upgrade` | Mettre à jour les dépendances |
| `flutter clean` | Nettoyer le projet |
| `flutter analyze` | Analyser le code |
| `flutter format .` | Formater le code |
| `flutter test` | Lancer les tests |
| `flutter run -v` | Mode verbose (debug) |
| `flutter --version` | Version de Flutter |

---

## 🌐 URLs à Connaître

| Service | URL | Description |
|---------|-----|-------------|
| **Backend API** | http://localhost:8080 | API REST |
| **Mobile Web** | http://localhost:3000 | Application mobile sur navigateur |
| **Frontend Web** | http://localhost:3000 | Interface web React |
| **Documentation API** | http://localhost:8080/swagger-ui.html | Swagger UI |
| **Backend Prod** | https://vegn-bio-api.onrender.com | Production Render |

---

## 📚 Documentation Supplémentaire

- 📖 **Guide de démarrage détaillé**: `vegn_bio_mobile/GUIDE_DEMARRAGE.md`
- 📖 **README du projet mobile**: `vegn_bio_mobile/README.md`
- 📖 **Architecture complète**: `ARCHITECTURE_ET_SERVICES.md`
- 📖 **Documentation Flutter**: https://docs.flutter.dev

---

## ✅ Récapitulatif - La Méthode la Plus Simple

**Pour lancer rapidement l'application mobile:**

```powershell
# 1. Ouvrir PowerShell
cd C:\Users\Mili\OneDrive\Bureau\VegN-Bio\vegn_bio_mobile

# 2. Installer les dépendances (première fois uniquement)
flutter pub get

# 3. Lancer sur Chrome
flutter run -d chrome --web-port=3000

# 4. Ouvrir le navigateur sur http://localhost:3000
# 5. Profiter! 🎉
```

**N'oubliez pas de lancer le backend dans un autre terminal:**

```powershell
cd C:\Users\Mili\OneDrive\Bureau\VegN-Bio\backend
mvn spring-boot:run
```

---

## 🎯 Prochaines Étapes

Une fois l'application lancée:

1. **Tester le chatbot vétérinaire** 🐾
   - Aller dans l'onglet "Vétérinaire"
   - Sélectionner une race d'animal
   - Choisir des symptômes
   - Obtenir un diagnostic

2. **Consulter les menus** 🍽️
   - Aller dans l'onglet "Restaurants"
   - Voir les menus disponibles
   - Filtrer par allergènes

3. **Explorer l'admin** ⚙️
   - Voir les statistiques
   - Consulter l'historique

---

**Besoin d'aide?** 💬
- Consultez `vegn_bio_mobile/README.md`
- Utilisez `flutter doctor` pour diagnostiquer les problèmes
- Vérifiez que le backend est bien lancé

**Bon développement!** 🚀



