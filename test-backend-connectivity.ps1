#!/usr/bin/env pwsh
# Test de connectivité du backend VegN-Bio

param(
    [string]$BackendUrl = "https://vegn-bio-backend.onrender.com"
)

$ErrorActionPreference = "Continue"

Write-Host "🔍 Test de connectivité du backend VegN-Bio" -ForegroundColor Blue
Write-Host "===========================================" -ForegroundColor Blue
Write-Host "URL: $BackendUrl"
Write-Host ""

# Test 1: Ping de base
Write-Host -NoNewline "1. Test de ping de base... "
try {
    $response = Invoke-WebRequest -Uri $BackendUrl -Method GET -TimeoutSec 10 -ErrorAction Stop
    Write-Host "✅ OK (Status: $($response.StatusCode))" -ForegroundColor Green
} catch {
    Write-Host "❌ ÉCHEC" -ForegroundColor Red
    Write-Host "   Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 2: Test avec curl (si disponible)
Write-Host -NoNewline "2. Test avec curl... "
try {
    $curlResult = curl -s --connect-timeout 10 $BackendUrl 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ OK" -ForegroundColor Green
    } else {
        Write-Host "❌ ÉCHEC" -ForegroundColor Red
    }
} catch {
    Write-Host "⚠️ curl non disponible" -ForegroundColor Yellow
}

# Test 3: Test de l'endpoint info
Write-Host -NoNewline "3. Test endpoint /api/info... "
try {
    $response = Invoke-RestMethod -Uri "$BackendUrl/api/info" -Method GET -TimeoutSec 10 -ErrorAction Stop
    Write-Host "✅ OK" -ForegroundColor Green
    Write-Host "   Réponse: $($response | ConvertTo-Json -Compress)" -ForegroundColor Gray
} catch {
    Write-Host "❌ ÉCHEC" -ForegroundColor Red
    Write-Host "   Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 4: Test de l'endpoint health
Write-Host -NoNewline "4. Test endpoint /actuator/health... "
try {
    $response = Invoke-RestMethod -Uri "$BackendUrl/actuator/health" -Method GET -TimeoutSec 10 -ErrorAction Stop
    Write-Host "✅ OK" -ForegroundColor Green
    Write-Host "   Status: $($response.status)" -ForegroundColor Gray
} catch {
    Write-Host "❌ ÉCHEC" -ForegroundColor Red
    Write-Host "   Erreur: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 5: Test de l'endpoint restaurants (doit retourner 403/401)
Write-Host -NoNewline "5. Test endpoint protégé /api/restaurants... "
try {
    $response = Invoke-WebRequest -Uri "$BackendUrl/api/restaurants" -Method GET -TimeoutSec 10 -ErrorAction Stop
    Write-Host "⚠️ Réponse inattendue (Status: $($response.StatusCode))" -ForegroundColor Yellow
} catch {
    if ($_.Exception.Response.StatusCode -eq 403 -or $_.Exception.Response.StatusCode -eq 401) {
        Write-Host "✅ OK (Accès correctement bloqué)" -ForegroundColor Green
    } else {
        Write-Host "❌ ÉCHEC" -ForegroundColor Red
        Write-Host "   Erreur: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Test 6: Test de performance
Write-Host -NoNewline "6. Test de performance... "
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
try {
    Invoke-WebRequest -Uri $BackendUrl -Method GET -TimeoutSec 30 -ErrorAction Stop | Out-Null
    $stopwatch.Stop()
    $responseTime = $stopwatch.ElapsedMilliseconds
    
    if ($responseTime -lt 5000) {
        Write-Host "✅ OK (${responseTime}ms)" -ForegroundColor Green
    } else {
        Write-Host "⚠️ LENT (${responseTime}ms)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ ÉCHEC" -ForegroundColor Red
}

# Test 7: Vérification des headers
Write-Host -NoNewline "7. Vérification des headers... "
try {
    $response = Invoke-WebRequest -Uri $BackendUrl -Method GET -TimeoutSec 10 -ErrorAction Stop
    $corsHeader = $response.Headers["Access-Control-Allow-Origin"]
    if ($corsHeader) {
        Write-Host "✅ CORS configuré ($corsHeader)" -ForegroundColor Green
    } else {
        Write-Host "⚠️ CORS non configuré" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ ÉCHEC" -ForegroundColor Red
}

Write-Host ""
Write-Host "📊 Résumé:" -ForegroundColor Blue
Write-Host "- Si tous les tests passent: Le backend est opérationnel" -ForegroundColor Green
Write-Host "- Si des tests échouent: Vérifier les logs Render" -ForegroundColor Red
Write-Host "- Si les performances sont lentes: Normal pour le plan gratuit Render" -ForegroundColor Yellow

Write-Host ""
Write-Host "🔗 URLs utiles:" -ForegroundColor Blue
Write-Host "- Backend: $BackendUrl"
Write-Host "- Dashboard Render: https://dashboard.render.com"
Write-Host "- Logs Render: https://dashboard.render.com/web/srv-d3i2ci9r0fns73cpojgg/logs"
