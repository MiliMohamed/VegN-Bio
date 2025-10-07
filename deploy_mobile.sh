#!/bin/bash

# Script de déploiement pour VegN-Bio Mobile
# Ce script configure et déploie l'application mobile Flutter

set -e

echo "🚀 Déploiement de VegN-Bio Mobile"

# Vérifier que Flutter est installé
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter n'est pas installé. Veuillez installer Flutter SDK 3.0.0 ou supérieur."
    exit 1
fi

# Vérifier la version de Flutter
FLUTTER_VERSION=$(flutter --version | head -n 1 | cut -d ' ' -f 2)
echo "📱 Version Flutter détectée: $FLUTTER_VERSION"

# Aller dans le répertoire de l'application mobile
cd vegn_bio_mobile

echo "📦 Installation des dépendances..."
flutter pub get

echo "🔧 Configuration des variables d'environnement..."
if [ ! -f "assets/.env" ]; then
    echo "❌ Le fichier assets/.env n'existe pas. Veuillez le créer avec vos configurations."
    exit 1
fi

echo "🧪 Exécution des tests..."
flutter test

echo "🔍 Analyse du code..."
flutter analyze

echo "📱 Build de l'application Android..."
flutter build apk --release

echo "🍎 Build de l'application iOS (si sur macOS)..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    flutter build ios --release
else
    echo "⚠️  Build iOS ignoré (non disponible sur cette plateforme)"
fi

echo "✅ Déploiement terminé avec succès!"
echo ""
echo "📁 Fichiers générés:"
echo "   - Android APK: build/app/outputs/flutter-apk/app-release.apk"
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "   - iOS IPA: build/ios/Release/Runner.app"
fi
echo ""
echo "🚀 Prochaines étapes:"
echo "   1. Tester l'application sur un dispositif réel"
echo "   2. Configurer les variables d'environnement pour la production"
echo "   3. Déployer sur les stores (Google Play Store, Apple App Store)"
echo ""
echo "📋 Configuration requise pour la production:"
echo "   - Modifier assets/.env avec l'URL de production du backend"
echo "   - Configurer les certificats de signature"
echo "   - Tester tous les endpoints API"
echo ""
echo "🎉 VegN-Bio Mobile est prêt pour le déploiement!"
