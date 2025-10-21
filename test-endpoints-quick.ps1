# Test rapide des endpoints après déploiement CORS
# Ce script teste les endpoints critiques pour vérifier si la correction CORS a fonctionné

$BaseUrl = "https://vegn-bio-backend.onrender.com/api/v1"

Write-Host "🔍 Test rapide des endpoints après correction CORS" -ForegroundColor Yellow
Write-Host "=================================================" -ForegroundColor Yellow
Write-Host "Heure: $(Get-Date)" -ForegroundColor Gray
Write-Host ""

# Test 1: Endpoints publics qui devraient fonctionner
Write-Host "1️⃣ Test des endpoints publics" -ForegroundColor Cyan
$publicEndpoints = @(
    @{ Name = "Restaurants"; Path = "/restaurants" },
    @{ Name = "Allergènes"; Path = "/allergens" },
    @{ Name = "Événements"; Path = "/events" },
    @{ Name = "Fournisseurs"; Path = "/suppliers" },
    @{ Name = "Offres"; Path = "/offers" }
)

$publicSuccess = 0
foreach ($endpoint in $publicEndpoints) {
    try {
        $response = Invoke-RestMethod -Uri "$BaseUrl$($endpoint.Path)" -Method GET -ErrorAction Stop
        Write-Host "✅ $($endpoint.Name)" -ForegroundColor Green
        $publicSuccess++
    }
    catch {
        Write-Host "❌ $($endpoint.Name) - $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    }
}

Write-Host "Résultat: $publicSuccess/$($publicEndpoints.Count) endpoints publics fonctionnels" -ForegroundColor $(if($publicSuccess -eq $publicEndpoints.Count) {"Green"} else {"Yellow"})
Write-Host ""

# Test 2: Authentification (le plus critique)
Write-Host "2️⃣ Test de l'authentification" -ForegroundColor Cyan
$authTests = @(
    @{ Name = "Admin"; Email = "admin@vegnbio.com"; Password = "AdminVegN2024!" },
    @{ Name = "Restaurateur"; Email = "bastille@vegnbio.com"; Password = "Bastille2024!" },
    @{ Name = "Client"; Email = "client1@example.com"; Password = "Client12024!" }
)

$authSuccess = 0
foreach ($test in $authTests) {
    try {
        $loginBody = @{
            email = $test.Email
            password = $test.Password
        } | ConvertTo-Json
        
        $response = Invoke-RestMethod -Uri "$BaseUrl/auth/login" -Method POST -ContentType "application/json" -Body $loginBody -ErrorAction Stop
        
        if ($response.token) {
            Write-Host "✅ $($test.Name) - Token obtenu" -ForegroundColor Green
            $authSuccess++
            
            # Test rapide d'un endpoint protégé avec ce token
            try {
                $headers = @{ "Authorization" = "Bearer $($response.token)" }
                $meResponse = Invoke-RestMethod -Uri "$BaseUrl/auth/me" -Method GET -Headers $headers -ErrorAction Stop
                Write-Host "   ✅ Endpoint protégé /auth/me fonctionnel" -ForegroundColor Green
            }
            catch {
                Write-Host "   ❌ Endpoint protégé /auth/me échoué" -ForegroundColor Red
            }
        }
        else {
            Write-Host "❌ $($test.Name) - Pas de token dans la réponse" -ForegroundColor Red
        }
    }
    catch {
        Write-Host "❌ $($test.Name) - $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    }
}

Write-Host "Résultat: $authSuccess/$($authTests.Count) authentifications réussies" -ForegroundColor $(if($authSuccess -eq $authTests.Count) {"Green"} else {"Red"})
Write-Host ""

# Test 3: Endpoints qui étaient bloqués par CORS
Write-Host "3️⃣ Test des endpoints précédemment bloqués" -ForegroundColor Cyan
$blockedEndpoints = @(
    @{ Name = "Menus"; Path = "/menus" },
    @{ Name = "Réservations"; Path = "/bookings" },
    @{ Name = "Avis"; Path = "/reviews" },
    @{ Name = "Restaurant ID 1"; Path = "/restaurants/1" },
    @{ Name = "Allergène GLUTEN"; Path = "/allergens/GLUTEN" }
)

$blockedSuccess = 0
foreach ($endpoint in $blockedEndpoints) {
    try {
        $response = Invoke-RestMethod -Uri "$BaseUrl$($endpoint.Path)" -Method GET -ErrorAction Stop
        Write-Host "✅ $($endpoint.Name)" -ForegroundColor Green
        $blockedSuccess++
    }
    catch {
        Write-Host "❌ $($endpoint.Name) - $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    }
}

Write-Host "Résultat: $blockedSuccess/$($blockedEndpoints.Count) endpoints précédemment bloqués maintenant fonctionnels" -ForegroundColor $(if($blockedSuccess -gt 0) {"Green"} else {"Red"})
Write-Host ""

# Test 4: Chatbot complet
Write-Host "4️⃣ Test du chatbot complet" -ForegroundColor Cyan
$chatbotTests = @(
    @{ Name = "Chat simple"; Path = "/chatbot/chat"; Method = "POST"; Body = @{ message = "Bonjour"; userId = "test" } | ConvertTo-Json },
    @{ Name = "Diagnostic"; Path = "/chatbot/diagnosis"; Method = "POST"; Body = @{ breed = "Chien"; symptoms = @("fatigue"); age = 5; userId = "test" } | ConvertTo-Json },
    @{ Name = "Recommandations"; Path = "/chatbot/recommendations"; Method = "POST"; Body = @{ breed = "Chien"; symptoms = @("fatigue"); age = 5; userId = "test" } | ConvertTo-Json },
    @{ Name = "Races"; Path = "/chatbot/breeds"; Method = "GET" },
    @{ Name = "Symptômes"; Path = "/chatbot/symptoms/Chien"; Method = "GET" }
)

$chatbotSuccess = 0
foreach ($test in $chatbotTests) {
    try {
        if ($test.Method -eq "POST") {
            $response = Invoke-RestMethod -Uri "$BaseUrl$($test.Path)" -Method POST -ContentType "application/json" -Body $test.Body -ErrorAction Stop
        } else {
            $response = Invoke-RestMethod -Uri "$BaseUrl$($test.Path)" -Method GET -ErrorAction Stop
        }
        Write-Host "✅ $($test.Name)" -ForegroundColor Green
        $chatbotSuccess++
    }
    catch {
        Write-Host "❌ $($test.Name) - $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    }
}

Write-Host "Résultat: $chatbotSuccess/$($chatbotTests.Count) endpoints chatbot fonctionnels" -ForegroundColor $(if($chatbotSuccess -eq $chatbotTests.Count) {"Green"} else {"Yellow"})
Write-Host ""

# Résumé final
$totalTests = $publicSuccess + $authSuccess + $blockedSuccess + $chatbotSuccess
$maxTests = $publicEndpoints.Count + $authTests.Count + $blockedEndpoints.Count + $chatbotTests.Count
$successRate = [math]::Round(($totalTests / $maxTests) * 100, 1)

Write-Host "📊 RÉSUMÉ FINAL" -ForegroundColor Magenta
Write-Host "===============" -ForegroundColor Magenta
Write-Host "Tests réussis: $totalTests/$maxTests" -ForegroundColor White
Write-Host "Taux de réussite: $successRate%" -ForegroundColor White

if ($successRate -ge 90) {
    Write-Host "🎉 EXCELLENT! La correction CORS a fonctionné!" -ForegroundColor Green
} elseif ($successRate -ge 70) {
    Write-Host "✅ BIEN! La correction CORS a partiellement fonctionné." -ForegroundColor Yellow
} elseif ($successRate -ge 50) {
    Write-Host "⚠️ MOYEN! Quelques améliorations mais problèmes persistants." -ForegroundColor Yellow
} else {
    Write-Host "❌ PROBLÈME! La correction CORS n'a pas fonctionné." -ForegroundColor Red
}

Write-Host ""
Write-Host "💡 Prochaines étapes:" -ForegroundColor Cyan
if ($authSuccess -eq 0) {
    Write-Host "- Vérifier que le déploiement Render est terminé" -ForegroundColor White
    Write-Host "- Attendre 5-10 minutes supplémentaires" -ForegroundColor White
    Write-Host "- Vérifier les logs Render pour des erreurs" -ForegroundColor White
} elseif ($authSuccess -gt 0) {
    Write-Host "- L'authentification fonctionne! Tester l'intégration frontend" -ForegroundColor White
    Write-Host "- Vérifier tous les endpoints protégés" -ForegroundColor White
    Write-Host "- Tester avec les applications mobile et web" -ForegroundColor White
}

Write-Host ""
Write-Host "🔄 Pour relancer ce test:" -ForegroundColor Gray
Write-Host "powershell -ExecutionPolicy Bypass -File test-endpoints-quick.ps1" -ForegroundColor Gray
