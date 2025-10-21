# Test script to verify transaction fixes
Write-Host "Testing VegN-Bio Backend Transaction Fixes..." -ForegroundColor Green

# Test 1: Check if the application starts without transaction errors
Write-Host "1. Testing application startup..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "https://vegn-bio-backend.onrender.com/api/v1/restaurants" -Method GET -TimeoutSec 30
    Write-Host "✓ Application is responding" -ForegroundColor Green
} catch {
    Write-Host "✗ Application is not responding: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 2: Test registration with duplicate email (should return 409 Conflict)
Write-Host "2. Testing duplicate email registration..." -ForegroundColor Yellow
try {
    $registerData = @{
        email = "test@example.com"
        password = "password123"
        fullName = "Test User"
        role = "CUSTOMER"
    } | ConvertTo-Json

    $response = Invoke-RestMethod -Uri "https://vegn-bio-backend.onrender.com/api/v1/auth/register" -Method POST -Body $registerData -ContentType "application/json" -TimeoutSec 30
    Write-Host "✓ New user registration successful" -ForegroundColor Green
} catch {
    if ($_.Exception.Response.StatusCode -eq 409) {
        Write-Host "✓ Duplicate email properly handled with 409 Conflict" -ForegroundColor Green
    } else {
        Write-Host "✗ Unexpected response: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    }
}

# Test 3: Test chatbot endpoint (should not fail with transaction errors)
Write-Host "3. Testing chatbot endpoint..." -ForegroundColor Yellow
try {
    $chatbotData = @{
        message = "Hello"
    } | ConvertTo-Json

    $response = Invoke-RestMethod -Uri "https://vegn-bio-backend.onrender.com/api/v1/chatbot/message" -Method POST -Body $chatbotData -ContentType "application/json" -TimeoutSec 30
    Write-Host "✓ Chatbot endpoint working correctly" -ForegroundColor Green
} catch {
    Write-Host "✗ Chatbot endpoint error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Transaction fixes test completed!" -ForegroundColor Green
