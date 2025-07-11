#!/bin/bash

BASE_URL="http://localhost:3031"
API_PREFIX="/api"

echo "🔍 Quick API Endpoint Test"
echo "=========================="

# Test 1: Health check
echo -e "\n1️⃣ Testing server health..."
curl -s "$BASE_URL/health" | jq '.' || echo "❌ Server not responding"

# Test 2: API health
echo -e "\n2️⃣ Testing API health..."
curl -s "$BASE_URL$API_PREFIX/health" | jq '.' || echo "❌ API not responding"

# Test 3: Check for OpenAPI docs
echo -e "\n3️⃣ Checking for OpenAPI documentation..."
for endpoint in "/docs" "/swagger" "/swagger-ui" "/api-docs" "/openapi.json" "/swagger.json"; do
    if curl -s -o /dev/null -w "%{http_code}" "$BASE_URL$endpoint" | grep -q "200"; then
        echo "✅ Found OpenAPI docs at: $endpoint"
        echo "📖 Open: http://localhost:3031$endpoint"
        break
    fi
done

# Test 4: Login
echo -e "\n4️⃣ Testing login..."
LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL$API_PREFIX/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "giuseppe@bellavista.com",
    "password": "cashier123",
    "businessSlug": "bella-vista-italian"
  }')

echo "$LOGIN_RESPONSE" | jq '.'

TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.token // empty')
USER_ID=$(echo "$LOGIN_RESPONSE" | jq -r '.user.id // empty')

if [ -n "$TOKEN" ] && [ -n "$USER_ID" ]; then
    echo "✅ Login successful"
    echo "   User ID: $USER_ID"
    
    # Test 5: Regular sale
    echo -e "\n5️⃣ Testing regular sale creation..."
    SALE_RESPONSE=$(curl -s -X POST "$BASE_URL$API_PREFIX/sales" \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $TOKEN" \
      -d "{
        \"userId\": $USER_ID,
        \"totalAmount\": 25.99,
        \"paymentMethod\": \"cash\",
        \"status\": \"completed\",
        \"notes\": \"Test sale from curl\"
      }")
    
    echo "$SALE_RESPONSE" | jq '.'
    
    # Test 6: Split payment
    echo -e "\n6️⃣ Testing split payment creation..."
    SPLIT_RESPONSE=$(curl -s -X POST "$BASE_URL$API_PREFIX/sales/split" \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $TOKEN" \
      -d "{
        \"userId\": $USER_ID,
        \"totalAmount\": 50.00,
        \"customerName\": \"Test Group\",
        \"customerPhone\": \"555-1234\",
        \"customerEmail\": \"test@example.com\",
        \"notes\": \"Test split payment from curl\",
        \"payments\": [
          {
            \"amount\": 30.00,
            \"method\": \"credit_card\",
            \"customerName\": \"John Doe\",
            \"customerPhone\": \"555-1111\",
            \"reference\": \"CC123456\"
          },
          {
            \"amount\": 20.00,
            \"method\": \"cash\",
            \"customerName\": \"Jane Smith\",
            \"customerPhone\": \"555-2222\"
          }
        ]
      }")
    
    echo "$SPLIT_RESPONSE" | jq '.'
    
else
    echo "❌ Login failed"
fi

echo -e "\n✅ Quick test complete!" 