# Script de test complet pour l'API VegN-Bio Backend
# Teste tous les endpoints disponibles sur https://vegn-bio-backend.onrender.com

param(
    [string]$BaseUrl = "https://vegn-bio-backend.onrender.com/api/v1",
    [switch]$Verbose = $false,
    [switch]$SkipAuth = $false
)

# Configuration des couleurs pour la sortie
$Colors = @{
    Success = "Green"
    Error = "Red"
    Warning = "Yellow"
    Info = "Cyan"
    Header = "Magenta"
}

# Fonction pour afficher les messages colorés
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# Fonction pour faire une requête HTTP
function Invoke-ApiRequest {
    param(
        [string]$Method = "GET",
        [string]$Uri,
        [hashtable]$Headers = @{},
        [string]$Body = $null,
        [string]$ContentType = "application/json"
    )
    
    try {
        $requestParams = @{
            Method = $Method
            Uri = $Uri
            Headers = $Headers
        }
        
        if ($Body) {
            $requestParams.Body = $Body
            $requestParams.ContentType = $ContentType
        }
        
        $response = Invoke-RestMethod @requestParams -ErrorAction Stop
        return @{
            Success = $true
            Data = $response
            StatusCode = 200
        }
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $errorMessage = $_.Exception.Message
        
        if ($_.Exception.Response) {
            try {
                $errorStream = $_.Exception.Response.GetResponseStream()
                $reader = New-Object System.IO.StreamReader($errorStream)
                $errorBody = $reader.ReadToEnd()
                $errorMessage = $errorBody
            }
            catch {
                # Ignore si on ne peut pas lire le body d'erreur
            }
        }
        
        return @{
            Success = $false
            Error = $errorMessage
            StatusCode = $statusCode
        }
    }
}

# Fonction pour tester un endpoint
function Test-Endpoint {
    param(
        [string]$Name,
        [string]$Method = "GET",
        [string]$Path,
        [hashtable]$Headers = @{},
        [string]$Body = $null,
        [string]$ExpectedStatus = "200"
    )
    
    $fullUri = "$BaseUrl$Path"
    Write-ColorOutput "Testing: $Name" $Colors.Info
    Write-ColorOutput "  $Method $fullUri" $Colors.Info
    
    $result = Invoke-ApiRequest -Method $Method -Uri $fullUri -Headers $Headers -Body $Body
    
    if ($result.Success) {
        Write-ColorOutput "  SUCCESS (Status: $($result.StatusCode))" $Colors.Success
        if ($Verbose -and $result.Data) {
            $jsonData = $result.Data | ConvertTo-Json -Depth 3
            Write-ColorOutput "  Response: $jsonData" $Colors.Info
        }
        return $true
    }
    else {
        Write-ColorOutput "  FAILED (Status: $($result.StatusCode))" $Colors.Error
        Write-ColorOutput "  Error: $($result.Error)" $Colors.Error
        return $false
    }
}

# Fonction pour obtenir un token d'authentification
function Get-AuthToken {
    param(
        [string]$Email,
        [string]$Password
    )
    
    $loginBody = @{
        email = $Email
        password = $Password
    } | ConvertTo-Json
    
    $result = Invoke-ApiRequest -Method "POST" -Uri "$BaseUrl/auth/login" -Body $loginBody
    
    if ($result.Success -and $result.Data.token) {
        return $result.Data.token
    }
    return $null
}

# Variables globales pour les tokens
$AdminToken = $null
$RestaurateurToken = $null
$ClientToken = $null

Write-ColorOutput "Test complet de l'API VegN-Bio Backend" $Colors.Header
Write-ColorOutput "=============================================" $Colors.Header
Write-ColorOutput "Base URL: $BaseUrl" $Colors.Info
Write-ColorOutput ""

# 1. Test de connectivité de base
Write-ColorOutput "Test de connectivité de base" $Colors.Header
Write-ColorOutput "===============================" $Colors.Header

$connectivityTests = @(
    @{ Name = "Health Check"; Path = "/health"; Method = "GET" },
    @{ Name = "API Info"; Path = "/"; Method = "GET" }
)

$connectivityPassed = 0
foreach ($test in $connectivityTests) {
    if (Test-Endpoint -Name $test.Name -Method $test.Method -Path $test.Path) {
        $connectivityPassed++
    }
}

Write-ColorOutput "Connectivité: $connectivityPassed/$($connectivityTests.Count) tests réussis" $Colors.Info
Write-ColorOutput ""

# 2. Test des endpoints publics
Write-ColorOutput "Test des endpoints publics" $Colors.Header
Write-ColorOutput "=============================" $Colors.Header

$publicTests = @(
    @{ Name = "Liste des restaurants"; Path = "/restaurants"; Method = "GET" },
    @{ Name = "Liste des allergènes"; Path = "/allergens"; Method = "GET" },
    @{ Name = "Liste des menus"; Path = "/menus"; Method = "GET" },
    @{ Name = "Liste des événements"; Path = "/events"; Method = "GET" },
    @{ Name = "Liste des réservations"; Path = "/bookings"; Method = "GET" },
    @{ Name = "Liste des fournisseurs"; Path = "/suppliers"; Method = "GET" },
    @{ Name = "Liste des offres"; Path = "/offers"; Method = "GET" },
    @{ Name = "Liste des avis"; Path = "/reviews"; Method = "GET" }
)

$publicPassed = 0
foreach ($test in $publicTests) {
    if (Test-Endpoint -Name $test.Name -Method $test.Method -Path $test.Path) {
        $publicPassed++
    }
}

Write-ColorOutput "Endpoints publics: $publicPassed/$($publicTests.Count) tests réussis" $Colors.Info
Write-ColorOutput ""

# 3. Test d'authentification
if (-not $SkipAuth) {
    Write-ColorOutput "Test d'authentification" $Colors.Header
    Write-ColorOutput "=========================" $Colors.Header
    
    # Test de connexion avec différents comptes
    $authTests = @(
        @{ Name = "Connexion Admin"; Email = "admin@vegnbio.com"; Password = "AdminVegN2024!" },
        @{ Name = "Connexion Restaurateur"; Email = "bastille@vegnbio.com"; Password = "Bastille2024!" },
        @{ Name = "Connexion Client"; Email = "client1@example.com"; Password = "Client12024!" }
    )
    
    $authPassed = 0
    foreach ($test in $authTests) {
        Write-ColorOutput "Testing: $($test.Name)" $Colors.Info
        
        $token = Get-AuthToken -Email $test.Email -Password $test.Password
        
        if ($token) {
            Write-ColorOutput "  SUCCESS - Token obtenu" $Colors.Success
            
            # Stocker les tokens pour les tests suivants
            if ($test.Name -eq "Connexion Admin") { $AdminToken = $token }
            elseif ($test.Name -eq "Connexion Restaurateur") { $RestaurateurToken = $token }
            elseif ($test.Name -eq "Connexion Client") { $ClientToken = $token }
            
            $authPassed++
        }
        else {
            Write-ColorOutput "  FAILED - Impossible d'obtenir le token" $Colors.Error
        }
    }
    
    Write-ColorOutput "Authentification: $authPassed/$($authTests.Count) tests réussis" $Colors.Info
    Write-ColorOutput ""
}

# 4. Test des endpoints protégés
if ($AdminToken) {
    Write-ColorOutput "Test des endpoints protégés (Admin)" $Colors.Header
    Write-ColorOutput "=====================================" $Colors.Header
    
    $adminHeaders = @{ "Authorization" = "Bearer $AdminToken" }
    
    $protectedTests = @(
        @{ Name = "Informations utilisateur actuel"; Path = "/auth/me"; Method = "GET"; Headers = $adminHeaders },
        @{ Name = "Liste des utilisateurs"; Path = "/users"; Method = "GET"; Headers = $adminHeaders }
    )
    
    $protectedPassed = 0
    foreach ($test in $protectedTests) {
        if (Test-Endpoint -Name $test.Name -Method $test.Method -Path $test.Path -Headers $test.Headers) {
            $protectedPassed++
        }
    }
    
    Write-ColorOutput "Endpoints protégés (Admin): $protectedPassed/$($protectedTests.Count) tests réussis" $Colors.Info
    Write-ColorOutput ""
}

# 5. Test du chatbot
Write-ColorOutput "Test du chatbot" $Colors.Header
Write-ColorOutput "==================" $Colors.Header

$chatbotTests = @(
    @{ 
        Name = "Chat simple"; 
        Path = "/chatbot/chat"; 
        Method = "POST"; 
        Body = @{
            message = "Bonjour, pouvez-vous m'aider avec mon animal?"
            userId = "test-user-123"
        } | ConvertTo-Json
    },
    @{ 
        Name = "Diagnostic vétérinaire"; 
        Path = "/chatbot/diagnosis"; 
        Method = "POST"; 
        Body = @{
            breed = "Golden Retriever"
            symptoms = @("fatigue", "perte d'appétit")
            age = 5
            userId = "test-user-123"
        } | ConvertTo-Json
    },
    @{ 
        Name = "Recommandations"; 
        Path = "/chatbot/recommendations"; 
        Method = "POST"; 
        Body = @{
            breed = "Golden Retriever"
            symptoms = @("fatigue", "perte d'appétit")
            age = 5
            userId = "test-user-123"
        } | ConvertTo-Json
    },
    @{ Name = "Races supportées"; Path = "/chatbot/breeds"; Method = "GET" },
    @{ Name = "Symptômes communs"; Path = "/chatbot/symptoms/Golden Retriever"; Method = "GET" }
)

$chatbotPassed = 0
foreach ($test in $chatbotTests) {
    if (Test-Endpoint -Name $test.Name -Method $test.Method -Path $test.Path -Body $test.Body) {
        $chatbotPassed++
    }
}

Write-ColorOutput "Chatbot: $chatbotPassed/$($chatbotTests.Count) tests réussis" $Colors.Info
Write-ColorOutput ""

# 6. Test des endpoints spécifiques par ID
Write-ColorOutput "Test des endpoints spécifiques" $Colors.Header
Write-ColorOutput "===============================" $Colors.Header

$specificTests = @(
    @{ Name = "Restaurant par ID"; Path = "/restaurants/1"; Method = "GET" },
    @{ Name = "Allergène par code"; Path = "/allergens/GLUTEN"; Method = "GET" },
    @{ Name = "Menu par ID"; Path = "/menus/1"; Method = "GET" },
    @{ Name = "Événement par ID"; Path = "/events/1"; Method = "GET" }
)

$specificPassed = 0
foreach ($test in $specificTests) {
    if (Test-Endpoint -Name $test.Name -Method $test.Method -Path $test.Path) {
        $specificPassed++
    }
}

Write-ColorOutput "Endpoints spécifiques: $specificPassed/$($specificTests.Count) tests réussis" $Colors.Info
Write-ColorOutput ""

# 7. Test des erreurs et cas limites
Write-ColorOutput "Test des erreurs et cas limites" $Colors.Header
Write-ColorOutput "=================================" $Colors.Header

$errorTests = @(
    @{ Name = "Restaurant inexistant"; Path = "/restaurants/99999"; Method = "GET"; ExpectedStatus = "404" },
    @{ Name = "Connexion avec mauvais mot de passe"; Path = "/auth/login"; Method = "POST"; Body = @{ email = "admin@vegnbio.com"; password = "wrongpassword" } | ConvertTo-Json; ExpectedStatus = "401" },
    @{ Name = "Endpoint protégé sans token"; Path = "/auth/me"; Method = "GET"; ExpectedStatus = "401" }
)

$errorPassed = 0
foreach ($test in $errorTests) {
    $result = Invoke-ApiRequest -Method $test.Method -Uri "$BaseUrl$($test.Path)" -Body $test.Body
    
    if (-not $result.Success -and $result.StatusCode -eq [int]$test.ExpectedStatus) {
        Write-ColorOutput "SUCCESS $($test.Name) - Erreur attendue (Status: $($result.StatusCode))" $Colors.Success
        $errorPassed++
    }
    else {
        Write-ColorOutput "FAILED $($test.Name) - Erreur inattendue (Status: $($result.StatusCode))" $Colors.Error
    }
}

Write-ColorOutput "Tests d'erreur: $errorPassed/$($errorTests.Count) tests réussis" $Colors.Info
Write-ColorOutput ""

# 8. Résumé final
Write-ColorOutput "RESUME FINAL" $Colors.Header
Write-ColorOutput "===============" $Colors.Header

$totalTests = $connectivityPassed + $publicPassed + $authPassed + $protectedPassed + $chatbotPassed + $specificPassed + $errorPassed
$maxTests = $connectivityTests.Count + $publicTests.Count + $authTests.Count + $protectedTests.Count + $chatbotTests.Count + $specificTests.Count + $errorTests.Count

Write-ColorOutput "Tests réussis: $totalTests/$maxTests" $Colors.Info
Write-ColorOutput "Taux de réussite: $([math]::Round(($totalTests / $maxTests) * 100, 2))%" $Colors.Info

if ($totalTests -eq $maxTests) {
    Write-ColorOutput "Tous les tests sont passés avec succès !" $Colors.Success
}
elseif ($totalTests -gt ($maxTests * 0.8)) {
    Write-ColorOutput "La plupart des tests sont passés avec succès !" $Colors.Success
}
else {
    Write-ColorOutput "Plusieurs tests ont échoué. Vérifiez la configuration du backend." $Colors.Warning
}

Write-ColorOutput ""
Write-ColorOutput "Conseils pour le débogage:" $Colors.Info
Write-ColorOutput "   - Vérifiez que le backend est démarré sur Render" $Colors.Info
Write-ColorOutput "   - Vérifiez la configuration de la base de données" $Colors.Info
Write-ColorOutput "   - Vérifiez les logs du backend pour plus de détails" $Colors.Info
Write-ColorOutput "   - Utilisez -Verbose pour voir les réponses détaillées" $Colors.Info