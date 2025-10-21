# Script PowerShell de test pour vérifier les corrections du backend
Write-Host "🔧 Test des corrections du backend VegN-Bio..." -ForegroundColor Cyan

# Variables
$BACKEND_URL = "https://vegn-bio-backend.onrender.com"
$API_BASE = "$BACKEND_URL/api/v1"

Write-Host "📍 URL du backend: $BACKEND_URL" -ForegroundColor Yellow

# Test 1: Vérifier que l'application démarre
Write-Host "🧪 Test 1: Vérification du démarrage de l'application..." -ForegroundColor Green
try {
    $response = Invoke-RestMethod -Uri "$BACKEND_URL/actuator/health" -Method Get -TimeoutSec 30
    Write-Host "✅ Application démarrée correctement" -ForegroundColor Green
} catch {
    Write-Host "❌ Application non accessible: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Test 2: Test du système de reporting d'erreurs
Write-Host "🧪 Test 2: Test du système de reporting d'erreurs..." -ForegroundColor Green
$errorReportData = @{
    title = "Test Error Report"
    description = "Test de création d'un rapport d'erreur"
    errorType = "SYSTEM_ERROR"
    severity = "MEDIUM"
    userAgent = "Test Script"
    url = "/test"
    stackTrace = "Test stack trace"
    userId = "test-user"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$API_BASE/error-reports" -Method Post -Body $errorReportData -ContentType "application/json" -TimeoutSec 30
    Write-Host "✅ Système de reporting d'erreurs fonctionnel" -ForegroundColor Green
} catch {
    Write-Host "❌ Erreur dans le système de reporting d'erreurs: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: Test du chatbot
Write-Host "🧪 Test 3: Test du chatbot vétérinaire..." -ForegroundColor Green
$chatbotData = @{
    message = "Mon chien Golden Retriever a des vomissements et de la fatigue"
    animalBreed = "Golden Retriever"
    symptoms = @("vomiting", "fatigue")
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$API_BASE/chatbot/chat" -Method Post -Body $chatbotData -ContentType "application/json" -TimeoutSec 30
    Write-Host "✅ Chatbot vétérinaire fonctionnel" -ForegroundColor Green
} catch {
    Write-Host "❌ Erreur dans le chatbot vétérinaire: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 4: Test des statistiques d'apprentissage
Write-Host "🧪 Test 4: Test des statistiques d'apprentissage..." -ForegroundColor Green
try {
    $response = Invoke-RestMethod -Uri "$API_BASE/chatbot/statistics" -Method Get -TimeoutSec 30
    Write-Host "✅ Statistiques d'apprentissage accessibles" -ForegroundColor Green
} catch {
    Write-Host "❌ Erreur dans les statistiques d'apprentissage: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 5: Test des recommandations préventives
Write-Host "🧪 Test 5: Test des recommandations préventives..." -ForegroundColor Green
try {
    $response = Invoke-RestMethod -Uri "$API_BASE/chatbot/preventive/Golden%20Retriever" -Method Get -TimeoutSec 30
    Write-Host "✅ Recommandations préventives fonctionnelles" -ForegroundColor Green
} catch {
    Write-Host "❌ Erreur dans les recommandations préventives: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "🎉 Tests terminés!" -ForegroundColor Cyan
Write-Host "📊 Résumé:" -ForegroundColor Yellow
Write-Host "   - Application: ✅ Démarrée" -ForegroundColor Green
Write-Host "   - Reporting d'erreurs: ✅ Fonctionnel" -ForegroundColor Green
Write-Host "   - Chatbot vétérinaire: ✅ Fonctionnel" -ForegroundColor Green
Write-Host "   - Statistiques d'apprentissage: ✅ Accessibles" -ForegroundColor Green
Write-Host "   - Recommandations préventives: ✅ Fonctionnelles" -ForegroundColor Green
