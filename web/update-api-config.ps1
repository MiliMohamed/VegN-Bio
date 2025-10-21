# Script pour mettre à jour la configuration API du frontend
# Change l'URL de l'API de localhost vers Render.com

Write-Host "🔧 Mise à jour de la configuration API pour la production" -ForegroundColor Green
Write-Host "======================================================" -ForegroundColor Green

# Configuration
$PRODUCTION_API_URL = "https://vegn-bio-backend.onrender.com/api"
$API_SERVICE_FILE = "src/services/api.ts"

Write-Host "📝 Mise à jour du fichier API service..." -ForegroundColor Yellow

# Vérifier que le fichier existe
if (-not (Test-Path $API_SERVICE_FILE)) {
    Write-Host "❌ Fichier $API_SERVICE_FILE non trouvé" -ForegroundColor Red
    exit 1
}

# Lire le contenu du fichier
$content = Get-Content $API_SERVICE_FILE -Raw

# Remplacer l'URL de l'API
$oldPattern = 'const API_BASE_URL = "[^"]*"'
$newApiUrl = "const API_BASE_URL = `"$PRODUCTION_API_URL`""

if ($content -match $oldPattern) {
    $content = $content -replace $oldPattern, $newApiUrl
    Write-Host "✅ URL de l'API mise à jour vers: $PRODUCTION_API_URL" -ForegroundColor Green
} else {
    # Si le pattern n'est pas trouvé, ajouter la configuration
    $configLine = "const API_BASE_URL = `"$PRODUCTION_API_URL`";"
    $content = $configLine + "`n" + $content
    Write-Host "✅ Configuration API ajoutée: $PRODUCTION_API_URL" -ForegroundColor Green
}

# Sauvegarder le fichier
$content | Set-Content $API_SERVICE_FILE -NoNewline

Write-Host ""
Write-Host "🔍 Vérification de la connectivité..." -ForegroundColor Yellow

# Tester la connectivité avec l'API de production
try {
    $response = Invoke-RestMethod -Uri "$PRODUCTION_API_URL/health" -Method GET -TimeoutSec 10
    Write-Host "✅ API de production accessible" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Endpoint /health non disponible, test de l'API principale..." -ForegroundColor Yellow
    
    try {
        $response = Invoke-RestMethod -Uri "$PRODUCTION_API_URL" -Method GET -TimeoutSec 10
        Write-Host "✅ API de production accessible" -ForegroundColor Green
    } catch {
        Write-Host "❌ Impossible de se connecter à l'API de production" -ForegroundColor Red
        Write-Host "   Vérifiez que le backend est bien déployé sur Render.com" -ForegroundColor Red
    }
}

# Créer un fichier .env pour la production
Write-Host ""
Write-Host "📄 Création du fichier .env pour la production..." -ForegroundColor Yellow

$envContent = @"
REACT_APP_API_URL=$PRODUCTION_API_URL
REACT_APP_APP_NAME=VegN-Bio
REACT_APP_ENVIRONMENT=production
REACT_APP_BACKEND_URL=https://vegn-bio-backend.onrender.com
"@

$envContent | Set-Content ".env.production" -Encoding UTF8
Write-Host "✅ Fichier .env.production créé" -ForegroundColor Green

# Tester une requête de connexion
Write-Host ""
Write-Host "🧪 Test de connexion avec l'API de production..." -ForegroundColor Yellow

$testLogin = @{
    email = "admin@vegnbio.com"
    password = "AdminVegN2024!"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$PRODUCTION_API_URL/auth/login" -Method POST -Body $testLogin -ContentType "application/json"
    Write-Host "✅ Test de connexion réussi avec le compte admin" -ForegroundColor Green
    Write-Host "   Token reçu: $($response.token.Substring(0, 20))..." -ForegroundColor Cyan
} catch {
    Write-Host "❌ Test de connexion échoué: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "📊 Résumé de la configuration" -ForegroundColor Cyan
Write-Host "============================" -ForegroundColor Cyan
Write-Host "🌐 API URL: $PRODUCTION_API_URL" -ForegroundColor White
Write-Host "📁 Fichier configuré: $API_SERVICE_FILE" -ForegroundColor White
Write-Host "📄 Fichier .env: .env.production" -ForegroundColor White

Write-Host ""
Write-Host "🎉 Configuration terminée !" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Prochaines étapes:" -ForegroundColor Yellow
Write-Host "1. Redémarrez l'application frontend: npm start" -ForegroundColor White
Write-Host "2. Testez la connexion avec les comptes de production" -ForegroundColor White
Write-Host "3. Vérifiez que toutes les fonctionnalités marchent avec l'API distante" -ForegroundColor White
Write-Host ""
Write-Host "🔐 Comptes de test disponibles:" -ForegroundColor Yellow
Write-Host "- admin@vegnbio.com / AdminVegN2024!" -ForegroundColor White
Write-Host "- bastille@vegnbio.com / Bastille2024!" -ForegroundColor White
Write-Host "- client1@example.com / Client12024!" -ForegroundColor White
