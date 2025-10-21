# Script de déploiement pour corriger le problème CORS
# Ce script aide à redéployer le backend avec la configuration CORS corrigée

Write-Host "🚀 Déploiement du backend VegN-Bio avec correction CORS" -ForegroundColor Green
Write-Host "=========================================================" -ForegroundColor Green

# Vérifier que nous sommes dans le bon répertoire
if (-not (Test-Path "backend/pom.xml")) {
    Write-Host "❌ Erreur: Ce script doit être exécuté depuis la racine du projet VegN-Bio" -ForegroundColor Red
    Write-Host "   Répertoire actuel: $(Get-Location)" -ForegroundColor Red
    Write-Host "   Fichier attendu: backend/pom.xml" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Répertoire correct détecté" -ForegroundColor Green

# Vérifier les modifications CORS
Write-Host "`n🔍 Vérification des modifications CORS..." -ForegroundColor Yellow
$corsFile = "backend/src/main/java/com/vegnbio/api/config/CorsConfig.java"
if (Test-Path $corsFile) {
    $corsContent = Get-Content $corsFile -Raw
    if ($corsContent -match "https://\*\.onrender\.com") {
        Write-Host "✅ Configuration CORS mise à jour détectée" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Configuration CORS non mise à jour" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ Fichier CORS non trouvé: $corsFile" -ForegroundColor Red
}

# Instructions pour le déploiement
Write-Host "`n📋 Instructions de déploiement:" -ForegroundColor Cyan
Write-Host "1. Commitez les modifications CORS:" -ForegroundColor White
Write-Host "   git add backend/src/main/java/com/vegnbio/api/config/CorsConfig.java" -ForegroundColor Gray
Write-Host "   git commit -m 'Fix CORS configuration for Render deployment'" -ForegroundColor Gray

Write-Host "`n2. Poussez vers le repository:" -ForegroundColor White
Write-Host "   git push origin main" -ForegroundColor Gray

Write-Host "`n3. Le déploiement automatique sur Render devrait se déclencher" -ForegroundColor White
Write-Host "   Vérifiez le dashboard Render: https://dashboard.render.com" -ForegroundColor Gray

Write-Host "`n4. Une fois déployé, testez l'API:" -ForegroundColor White
Write-Host "   powershell -ExecutionPolicy Bypass -File test-backend-api.ps1" -ForegroundColor Gray

Write-Host "`n🔧 Alternative: Déploiement manuel avec Docker" -ForegroundColor Yellow
Write-Host "Si le déploiement automatique ne fonctionne pas:" -ForegroundColor White
Write-Host "1. Construisez l'image Docker:" -ForegroundColor Gray
Write-Host "   cd backend" -ForegroundColor Gray
Write-Host "   docker build -t vegn-bio-backend ." -ForegroundColor Gray

Write-Host "`n2. Testez localement:" -ForegroundColor Gray
Write-Host "   docker run -p 8080:8080 vegn-bio-backend" -ForegroundColor Gray

Write-Host "`n3. Poussez vers un registry Docker:" -ForegroundColor Gray
Write-Host "   docker tag vegn-bio-backend your-registry/vegn-bio-backend" -ForegroundColor Gray
Write-Host "   docker push your-registry/vegn-bio-backend" -ForegroundColor Gray

Write-Host "`n📊 Résultats attendus après correction:" -ForegroundColor Cyan
Write-Host "✅ Authentification fonctionnelle (login/register)" -ForegroundColor Green
Write-Host "✅ Endpoints protégés accessibles avec token" -ForegroundColor Green
Write-Host "✅ Endpoints spécifiques par ID fonctionnels" -ForegroundColor Green
Write-Host "✅ Chatbot complet opérationnel" -ForegroundColor Green
Write-Host "✅ Taux de réussite des tests: ~90%" -ForegroundColor Green

Write-Host "`n⚠️ Points d'attention:" -ForegroundColor Yellow
Write-Host "- Le déploiement peut prendre 5-10 minutes" -ForegroundColor White
Write-Host "- Vérifiez les logs Render en cas d'erreur" -ForegroundColor White
Write-Host "- Testez d'abord en local si possible" -ForegroundColor White

Write-Host "`n🎯 Prochaines étapes après correction:" -ForegroundColor Magenta
Write-Host "1. Tester l'authentification avec les comptes de production" -ForegroundColor White
Write-Host "2. Vérifier tous les endpoints protégés" -ForegroundColor White
Write-Host "3. Tester l'intégration avec le frontend" -ForegroundColor White
Write-Host "4. Configurer le monitoring et les alertes" -ForegroundColor White

Write-Host "`n✨ Bon déploiement !" -ForegroundColor Green
