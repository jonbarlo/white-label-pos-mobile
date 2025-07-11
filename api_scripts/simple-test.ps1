param(
    [string]$BaseUrl = "http://localhost:3031",
    [string]$ApiPrefix = "/api"
)

Write-Host "Direct Endpoint Testing" -ForegroundColor Cyan
Write-Host "=======================" -ForegroundColor Cyan

# Test 1: Check if server is running
Write-Host "`nTest 1: Server Health Check" -ForegroundColor Magenta
try {
    $Response = Invoke-WebRequest -Uri "$BaseUrl/health" -Method "GET" -TimeoutSec 5
    Write-Host "SUCCESS: Server is running" -ForegroundColor Green
    Write-Host "Response: $($Response.Content)" -ForegroundColor Gray
} catch {
    Write-Host "ERROR: Server is not responding" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Test 2: Check API health
Write-Host "`nTest 2: API Health Check" -ForegroundColor Magenta
try {
    $Response = Invoke-WebRequest -Uri "$BaseUrl$ApiPrefix/health" -Method "GET" -TimeoutSec 5
    Write-Host "SUCCESS: API is responding" -ForegroundColor Green
    Write-Host "Response: $($Response.Content)" -ForegroundColor Gray
} catch {
    Write-Host "ERROR: API is not responding" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: Get OpenAPI/Swagger docs
Write-Host "`nTest 3: OpenAPI Documentation" -ForegroundColor Magenta
Write-Host "Trying common OpenAPI endpoints..." -ForegroundColor Yellow

$OpenApiEndpoints = @(
    "/docs",
    "/swagger",
    "/swagger-ui",
    "/api-docs",
    "/openapi.json",
    "/swagger.json"
)

foreach ($endpoint in $OpenApiEndpoints) {
    Write-Host "   Trying: $endpoint" -ForegroundColor Gray
    try {
        $Response = Invoke-WebRequest -Uri "$BaseUrl$endpoint" -Method "GET" -TimeoutSec 5
        if ($Response.StatusCode -eq 200) {
            Write-Host "   SUCCESS: Found OpenAPI docs at: $endpoint" -ForegroundColor Green
            Write-Host "   Open your browser to: http://localhost:3031$endpoint" -ForegroundColor Cyan
            break
        }
    } catch {
        Write-Host "   NOT FOUND: $endpoint" -ForegroundColor Gray
    }
}

# Test 4: Login to get token
Write-Host "`nTest 4: Authentication" -ForegroundColor Magenta
$LoginBody = @{
    email = "giuseppe@bellavista.com"
    password = "cashier123"
    businessSlug = "bella-vista-italian"
} | ConvertTo-Json

try {
    $Response = Invoke-RestMethod -Uri "$BaseUrl$ApiPrefix/auth/login" -Method "POST" -Body $LoginBody -ContentType "application/json"
    if ($Response.token) {
        $Token = $Response.token
        $UserId = $Response.user.id
        $BusinessId = $Response.business.id
        Write-Host "SUCCESS: Login successful, got token" -ForegroundColor Green
        Write-Host "User: $($Response.user.name)" -ForegroundColor Yellow
        Write-Host "Business: $($Response.business.name)" -ForegroundColor Yellow
        
        $Headers = @{
            "Content-Type" = "application/json"
            "Authorization" = "Bearer $Token"
        }

        # Test 5: /api/sales
        Write-Host "`nTest 5: Create Sale (/api/sales)" -ForegroundColor Magenta
        $SaleBody = @{
            businessId = $BusinessId
            userId = $UserId
            totalAmount = 1193.49
            status = "completed"
        } | ConvertTo-Json
        try {
            $SaleResponse = Invoke-RestMethod -Uri "$BaseUrl$ApiPrefix/sales" -Method "POST" -Headers $Headers -Body $SaleBody
            Write-Host "SUCCESS: Sale creation successful" -ForegroundColor Green
            Write-Host "Response: $($SaleResponse | ConvertTo-Json -Depth 3)" -ForegroundColor Yellow
        } catch {
            Write-Host "ERROR: Sale creation failed" -ForegroundColor Red
            Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
        }

        # Test 6: /api/sales/with-items
        Write-Host "`nTest 6: Create Sale with Items (/api/sales/with-items)" -ForegroundColor Magenta
        $SaleWithItemsBody = @{
            businessId = $BusinessId
            userId = $UserId
            totalAmount = 1193.49
            status = "completed"
            orderItems = @(
                @{
                    itemId = 1
                    quantity = 2
                    unitPrice = 599.99
                }
            )
        } | ConvertTo-Json -Depth 3
        try {
            $SaleWithItemsResponse = Invoke-RestMethod -Uri "$BaseUrl$ApiPrefix/sales/with-items" -Method "POST" -Headers $Headers -Body $SaleWithItemsBody
            Write-Host "SUCCESS: Sale with items creation successful" -ForegroundColor Green
            Write-Host "Response: $($SaleWithItemsResponse | ConvertTo-Json -Depth 3)" -ForegroundColor Yellow
        } catch {
            Write-Host "ERROR: Sale with items creation failed" -ForegroundColor Red
            Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        Write-Host "ERROR: Login failed - no token received" -ForegroundColor Red
    }
} catch {
    Write-Host "ERROR: Login failed" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "`nDirect Endpoint Testing Complete" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan 