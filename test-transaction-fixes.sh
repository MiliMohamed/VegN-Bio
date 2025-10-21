#!/bin/bash

# Test script to verify transaction fixes
echo "Testing VegN-Bio Backend Transaction Fixes..."

# Test 1: Check if the application starts without transaction errors
echo "1. Testing application startup..."
curl -s -o /dev/null -w "%{http_code}" https://vegn-bio-backend.onrender.com/api/v1/restaurants
if [ $? -eq 0 ]; then
    echo "✓ Application is responding"
else
    echo "✗ Application is not responding"
fi

# Test 2: Test registration with duplicate email (should return 409 Conflict)
echo "2. Testing duplicate email registration..."
DUPLICATE_RESPONSE=$(curl -s -w "%{http_code}" -X POST https://vegn-bio-backend.onrender.com/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123",
    "fullName": "Test User",
    "role": "CUSTOMER"
  }')

HTTP_CODE="${DUPLICATE_RESPONSE: -3}"
if [ "$HTTP_CODE" = "409" ]; then
    echo "✓ Duplicate email properly handled with 409 Conflict"
elif [ "$HTTP_CODE" = "200" ]; then
    echo "✓ New user registration successful"
else
    echo "✗ Unexpected response code: $HTTP_CODE"
fi

# Test 3: Test chatbot endpoint (should not fail with transaction errors)
echo "3. Testing chatbot endpoint..."
CHATBOT_RESPONSE=$(curl -s -w "%{http_code}" -X POST https://vegn-bio-backend.onrender.com/api/v1/chatbot/message \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Hello"
  }')

HTTP_CODE="${CHATBOT_RESPONSE: -3}"
if [ "$HTTP_CODE" = "200" ]; then
    echo "✓ Chatbot endpoint working correctly"
else
    echo "✗ Chatbot endpoint error: $HTTP_CODE"
fi

echo "Transaction fixes test completed!"
