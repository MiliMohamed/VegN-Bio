# 🧪 Guide de Test en Production - VegN-Bio

Ce guide explique comment tester l'authentification et les endpoints en production sur Vercel (frontend) et Render (backend).

## 📋 Scripts Disponibles

### 1. Scripts PowerShell (Windows)

#### `test-production-auth.ps1` - Test Complet
Script complet qui teste tous les aspects de l'authentification et des endpoints.

```powershell
# Test complet avec URL par défaut
.\test-production-auth.ps1

# Test complet en mode verbeux
.\test-production-auth.ps1 -Verbose

# Test complet avec URL personnalisée
.\test-production-auth.ps1 -BackendUrl "https://your-backend.com"
```

#### `quick-test-production.ps1` - Test Rapide
Script simple pour vérifier rapidement les endpoints essentiels.

```powershell
# Test rapide avec URL par défaut
.\quick-test-production.ps1

# Test rapide avec URL personnalisée
.\quick-test-production.ps1 -BackendUrl "https://your-backend.com"
```

### 2. Scripts Bash (Linux/macOS)

#### `test-production-auth.sh` - Test Complet
Script complet pour les systèmes Unix.

```bash
# Rendre exécutable
chmod +x test-production-auth.sh

# Exécuter le test
./test-production-auth.sh
```

#### `quick-test-production.sh` - Test Rapide
Script simple pour les systèmes Unix.

```bash
# Rendre exécutable
chmod +x quick-test-production.sh

# Exécuter le test rapide
./quick-test-production.sh
```

## 🎯 Tests Effectués

### Tests d'Authentification
1. **Enregistrement d'utilisateur** - Test de création d'un nouveau compte
2. **Connexion** - Test de connexion avec les identifiants
3. **Profil utilisateur** - Test de récupération du profil avec token JWT
4. **Sécurité** - Test d'accès sans token (doit échouer)

### Tests des Endpoints
1. **Endpoints protégés** - Test d'accès aux restaurants avec authentification
2. **Base de données** - Test d'accès aux consultations vétérinaires
3. **Chatbot vétérinaire** - Test de génération de diagnostics
4. **Rapports d'erreurs** - Test du système de reporting
5. **Endpoints publics** - Test des endpoints sans authentification

### Tests de Performance
1. **Temps de réponse** - Mesure du temps de réponse des endpoints
2. **Connectivité** - Test de disponibilité des services

## 📊 Interprétation des Résultats

### ✅ Succès (Vert)
- **Connectivité Backend** : Le backend est accessible
- **Enregistrement** : Nouvel utilisateur créé avec succès
- **Connexion** : Token JWT obtenu
- **Profil utilisateur** : Données utilisateur récupérées
- **Endpoints protégés** : Accès autorisé avec token
- **Sécurité** : Accès non autorisé correctement bloqué
- **Base de données** : Tables accessibles
- **Performance** : Temps de réponse < 5 secondes

### ⚠️ Avertissement (Jaune)
- **Frontend inaccessible** : Le frontend Vercel n'est pas accessible
- **Performance lente** : Temps de réponse > 5 secondes
- **Endpoints publics** : Format de réponse inattendu

### ❌ Erreur (Rouge)
- **Backend inaccessible** : Le backend Render n'est pas accessible
- **Échec d'enregistrement** : Erreur lors de la création d'utilisateur
- **Échec de connexion** : Token JWT non obtenu
- **Profil inaccessible** : Données utilisateur non récupérées
- **Endpoints protégés** : Accès refusé avec token valide
- **Base de données** : Tables inaccessibles

## 🔧 Configuration

### URLs par Défaut
- **Backend** : `https://vegn-bio-backend.onrender.com`
- **Frontend** : `https://vegn-bio-frontend.vercel.app`

### Variables d'Environnement
Les scripts utilisent des données de test générées automatiquement :
- **Username** : `testuser_[timestamp]`
- **Email** : `test[timestamp]@example.com`
- **Password** : `TestPassword123!`

## 🚀 Utilisation Recommandée

### Avant le Déploiement
```powershell
# Test rapide pour vérifier la connectivité
.\quick-test-production.ps1
```

### Après le Déploiement
```powershell
# Test complet pour vérifier tous les aspects
.\test-production-auth.ps1 -Verbose
```

### En Cas de Problème
```powershell
# Test avec URL personnalisée
.\test-production-auth.ps1 -BackendUrl "https://your-backend-url.com" -Verbose
```

## 📝 Exemple de Sortie

```
🚀 Test rapide d'authentification - VegN-Bio
=========================================
Test connectivité... ✅ OK
Test enregistrement... ✅ OK
Test connexion... ✅ OK
Test profil utilisateur... ✅ OK
Test endpoints protégés... ✅ OK
Test chatbot vétérinaire... ✅ OK
Test base de données... ✅ OK
Test sécurité... ✅ OK
Test performance... ✅ OK (1234ms)

🎉 Test rapide terminé!
Backend: https://vegn-bio-backend.onrender.com
```

## 🛠️ Dépannage

### Problèmes Courants

1. **Backend inaccessible**
   - Vérifier que Render est déployé
   - Vérifier l'URL du backend
   - Vérifier les logs Render

2. **Échec d'authentification**
   - Vérifier que la base de données est accessible
   - Vérifier les migrations Flyway
   - Vérifier les logs d'application

3. **Performance lente**
   - Render free tier peut être lent
   - Vérifier les logs de performance
   - Considérer l'upgrade du plan

### Logs Utiles
- **Render Logs** : Dashboard Render > Logs
- **Application Logs** : Spring Boot logs dans Render
- **Database Logs** : PostgreSQL logs dans Render

## 📞 Support

En cas de problème :
1. Vérifier les logs Render
2. Tester avec les scripts fournis
3. Vérifier la configuration des URLs
4. Consulter la documentation Render/Vercel
