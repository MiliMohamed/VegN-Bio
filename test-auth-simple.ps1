# Test détaillé de l'authentification VegN-Bio Backend
Write-Host "Test détaillé de l'authentification" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Heure: $(Get-Date)" -ForegroundColor Gray
Write-Host ""

$BaseUrl = "https://vegn-bio-backend.onrender.com/api/v1"

# Test 1: Vérifier que l'endpoint auth existe
Write-Host "1. Test de connectivité de l'endpoint auth" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$BaseUrl/auth/login" -Method OPTIONS -ErrorAction Stop
    Write-Host "SUCCESS - Endpoint auth accessible (OPTIONS: $($response.StatusCode))" -ForegroundColor Green
} catch {
    Write-Host "ERROR - Endpoint auth inaccessible: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 2: Test avec différents comptes
Write-Host "`n2. Test d'authentification avec différents comptes" -ForegroundColor Yellow

$testAccounts = @(
    @{ Name = "Admin Principal"; Email = "admin@vegnbio.com"; Password = "AdminVegN2024!" },
    @{ Name = "Manager"; Email = "manager@vegnbio.com"; Password = "ManagerVegN2024!" },
    @{ Name = "Restaurateur Bastille"; Email = "bastille@vegnbio.com"; Password = "Bastille2024!" },
    @{ Name = "Client Test"; Email = "client1@example.com"; Password = "Client12024!" }
)

foreach ($account in $testAccounts) {
    Write-Host "`n   Test: $($account.Name)" -ForegroundColor White
    Write-Host "   Email: $($account.Email)" -ForegroundColor Gray
    
    try {
        $loginBody = @{
            email = $account.Email
            password = $account.Password
        } | ConvertTo-Json
        
        Write-Host "   Envoi de la requête..." -ForegroundColor Gray
        
        $response = Invoke-RestMethod -Uri "$BaseUrl/auth/login" -Method POST -ContentType "application/json" -Body $loginBody -ErrorAction Stop
        
        if ($response.token) {
            Write-Host "   SUCCESS - Token obtenu!" -ForegroundColor Green
            Write-Host "   Token: $($response.token.Substring(0,30))..." -ForegroundColor Gray
            
            # Test de l'endpoint /auth/me avec ce token
            try {
                $headers = @{ "Authorization" = "Bearer $($response.token)" }
                $meResponse = Invoke-RestMethod -Uri "$BaseUrl/auth/me" -Method GET -Headers $headers -ErrorAction Stop
                Write-Host "   SUCCESS - Endpoint /auth/me fonctionne" -ForegroundColor Green
                Write-Host "   Utilisateur: $($meResponse.fullName) ($($meResponse.role))" -ForegroundColor Gray
            } catch {
                Write-Host "   ERROR - Endpoint /auth/me échoué: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
            }
        } else {
            Write-Host "   ERROR - Pas de token dans la réponse" -ForegroundColor Red
            Write-Host "   Réponse: $($response | ConvertTo-Json)" -ForegroundColor Gray
        }
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $errorMessage = $_.Exception.Message
        
        Write-Host "   ERROR - Status: $statusCode" -ForegroundColor Red
        Write-Host "   Erreur: $errorMessage" -ForegroundColor Red
    }
}

# Test 3: Test avec des données invalides
Write-Host "`n3. Test avec des données invalides" -ForegroundColor Yellow

$invalidTests = @(
    @{ Name = "Email invalide"; Email = "invalid@test.com"; Password = "AdminVegN2024!" },
    @{ Name = "Mot de passe invalide"; Email = "admin@vegnbio.com"; Password = "WrongPassword" }
)

foreach ($test in $invalidTests) {
    Write-Host "`n   Test: $($test.Name)" -ForegroundColor White
    
    try {
        $loginBody = @{
            email = $test.Email
            password = $test.Password
        } | ConvertTo-Json
        
        $response = Invoke-RestMethod -Uri "$BaseUrl/auth/login" -Method POST -ContentType "application/json" -Body $loginBody -ErrorAction Stop
        
        Write-Host "   WARNING - Réponse inattendue: $($response | ConvertTo-Json)" -ForegroundColor Yellow
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        Write-Host "   SUCCESS - Erreur attendue: $statusCode" -ForegroundColor Green
    }
}

# Test 4: Vérifier les headers CORS
Write-Host "`n4. Test des headers CORS" -ForegroundColor Yellow

try {
    $response = Invoke-WebRequest -Uri "$BaseUrl/auth/login" -Method OPTIONS -ErrorAction Stop
    
    Write-Host "   Headers de réponse:" -ForegroundColor White
    $response.Headers.GetEnumerator() | ForEach-Object {
        if ($_.Key -match "Access-Control|Origin") {
            Write-Host "   $($_.Key): $($_.Value)" -ForegroundColor Gray
        }
    }
    
    if ($response.Headers["Access-Control-Allow-Origin"]) {
        Write-Host "   SUCCESS - Headers CORS présents" -ForegroundColor Green
    } else {
        Write-Host "   ERROR - Headers CORS manquants" -ForegroundColor Red
    }
} catch {
    Write-Host "   ERROR - Impossible de vérifier les headers CORS" -ForegroundColor Red
}

# Test 5: Test de l'endpoint register
Write-Host "`n5. Test de l'endpoint register" -ForegroundColor Yellow

try {
    $registerBody = @{
        email = "test@example.com"
        password = "TestPassword123!"
        fullName = "Test User"
        role = "CLIENT"
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "$BaseUrl/auth/register" -Method POST -ContentType "application/json" -Body $registerBody -ErrorAction Stop
    
    if ($response.token) {
        Write-Host "   SUCCESS - Register fonctionne - Token obtenu" -ForegroundColor Green
    } else {
        Write-Host "   WARNING - Register répond mais pas de token" -ForegroundColor Yellow
    }
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    Write-Host "   ERROR - Register échoué: $statusCode" -ForegroundColor Red
}

Write-Host "`nRésumé du test d'authentification" -ForegroundColor Magenta
Write-Host "=====================================" -ForegroundColor Magenta
Write-Host "Si tous les tests échouent avec 403, le problème est probablement:" -ForegroundColor White
Write-Host "- Configuration CORS non déployée" -ForegroundColor Gray
Write-Host "- Problème de configuration de sécurité" -ForegroundColor Gray
Write-Host "- Backend en cours de redémarrage" -ForegroundColor Gray
Write-Host ""
Write-Host "Si certains tests réussissent, le problème est spécifique à certains comptes." -ForegroundColor White
