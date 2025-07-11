# API Testing Scripts

This directory contains scripts to test the backend API endpoints directly.

## Quick Start

### Option 1: PowerShell (Windows)
```powershell
# Run comprehensive endpoint testing
.\test-endpoints-direct.ps1

# Or with custom base URL
.\test-endpoints-direct.ps1 -BaseUrl "http://your-server:3031"
```

### Option 2: Bash (Linux/Mac/WSL)
```bash
# Make script executable
chmod +x quick-test.sh

# Run quick endpoint test
./quick-test.sh
```

## What These Scripts Do

### `test-endpoints-direct.ps1`
- ✅ Tests server health and connectivity
- 📖 Discovers OpenAPI/Swagger documentation endpoints
- 🔐 Authenticates with the API
- 💰 Tests regular sale creation
- 💳 Tests split payment creation
- 📊 Provides detailed error messages and response data

### `quick-test.sh`
- Fast curl-based testing
- Checks for OpenAPI docs
- Tests authentication and sales endpoints
- Requires `jq` for JSON formatting

## OpenAPI Documentation

The scripts will automatically try to find the OpenAPI documentation at common endpoints:
- `/docs`
- `/swagger`
- `/swagger-ui`
- `/api-docs`
- `/openapi.json`
- `/swagger.json`

If found, you can open the URL in your browser to view the interactive API documentation.

## Manual Testing

You can also test endpoints manually using curl:

```bash
# Login
curl -X POST http://localhost:3031/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "giuseppe@bellavista.com",
    "password": "cashier123",
    "businessSlug": "bella-vista-italian"
  }'

# Create regular sale (replace TOKEN with actual token)
curl -X POST http://localhost:3031/api/sales \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer TOKEN" \
  -d '{
    "userId": 1,
    "totalAmount": 25.99,
    "paymentMethod": "cash",
    "status": "completed",
    "notes": "Test sale"
  }'

# Create split payment (replace TOKEN with actual token)
curl -X POST http://localhost:3031/api/sales/split \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer TOKEN" \
  -d '{
    "userId": 1,
    "totalAmount": 50.00,
    "customerName": "Test Group",
    "customerPhone": "555-1234",
    "customerEmail": "test@example.com",
    "notes": "Test split payment",
    "payments": [
      {
        "amount": 30.00,
        "method": "credit_card",
        "customerName": "John Doe",
        "customerPhone": "555-1111",
        "reference": "CC123456"
      },
      {
        "amount": 20.00,
        "method": "cash",
        "customerName": "Jane Smith",
        "customerPhone": "555-2222"
      }
    ]
  }'
```

## Troubleshooting

### Common Issues

1. **Server not responding**
   - Check if the backend server is running on port 3031
   - Verify the base URL in the script matches your server

2. **Authentication failed**
   - Verify the test credentials are correct
   - Check if the business slug exists

3. **500 Internal Server Error**
   - Check server logs for detailed error messages
   - Verify the request payload matches the API contract

4. **OpenAPI docs not found**
   - The backend might not have Swagger/OpenAPI enabled
   - Check the backend configuration for documentation endpoints

### Debug Mode

The PowerShell script includes detailed logging that shows:
- Request URLs and payloads
- Response data or error messages
- HTTP status codes
- Response body for errors

## API Contract Verification

These scripts help verify that:
- ✅ The API endpoints are accessible
- ✅ The request/response formats match expectations
- ✅ Authentication works correctly
- ✅ Sale creation (regular and split) functions properly
- ✅ Error handling is working as expected

Run these scripts to quickly validate the backend API before testing the Flutter app. 