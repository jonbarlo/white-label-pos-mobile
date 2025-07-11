param(
    [string]$BaseUrl = "http://localhost:3031",
    [string]$ApiPrefix = "/api"
)

# Function to make API calls
function Invoke-ApiCall {
    param(
        [string]$Method,
        [string]$Endpoint,
        [string]$Body = "",
        [string]$Token = "",
        [string]$BaseUrl = "http://localhost:3031",
        [string]$ApiPrefix = "/api"
    )

    $Uri = "$BaseUrl$ApiPrefix$Endpoint"
    $Headers = @{
        "Content-Type" = "application/json"
    }
    
    if ($Token) {
        $Headers["Authorization"] = "Bearer $Token"
    }

    Write-Host "[API Request]" -ForegroundColor Cyan
    Write-Host "   Method: $Method" -ForegroundColor Yellow
    Write-Host "   URL: $Uri" -ForegroundColor Yellow
    if ($Body) {
        Write-Host "   Body: $Body" -ForegroundColor Yellow
    }

    try {
        $Response = Invoke-RestMethod -Uri $Uri -Method $Method -Headers $Headers -Body $Body

        Write-Host "[API Response]" -ForegroundColor Green
        Write-Host "   Status: Success" -ForegroundColor Green
        Write-Host "   Data: $($Response | ConvertTo-Json -Depth 3)" -ForegroundColor Green
        
        return $Response
    }
    catch {
        $StatusCode = $_.Exception.Response.StatusCode.value__
        $ErrorMessage = $_.Exception.Message
        
        Write-Host "[API Error ($StatusCode)]" -ForegroundColor Red
        Write-Host "   $ErrorMessage" -ForegroundColor Red
        
        # Try to get response body for more details
        try {
            $ResponseStream = $_.Exception.Response.GetResponseStream()
            $Reader = New-Object System.IO.StreamReader($ResponseStream)
            $ResponseBody = $Reader.ReadToEnd()
            Write-Host "   Response Body: $ResponseBody" -ForegroundColor Red
        }
        catch {
            Write-Host "   Could not read response body" -ForegroundColor Red
        }
        
        return $null
    }
}

# Main execution
Write-Host "[Direct Endpoint Testing]" -ForegroundColor Cyan
Write-Host "=========================" -ForegroundColor Cyan

# Test 1: Check if server is running
Write-Host "`n[Test 1: Server Health Check]" -ForegroundColor Magenta
$HealthResponse = Invoke-ApiCall -Method "GET" -Endpoint "/health" -BaseUrl $BaseUrl -ApiPrefix ""
if ($HealthResponse) {
    Write-Host "✅ Server is running" -ForegroundColor Green
} else {
    Write-Host "❌ Server is not responding" -ForegroundColor Red
    exit 1
}

# Test 2: Check API health
Write-Host "`n[Test 2: API Health Check]" -ForegroundColor Magenta
$ApiHealthResponse = Invoke-ApiCall -Method "GET" -Endpoint "/health" -BaseUrl $BaseUrl -ApiPrefix $ApiPrefix
if ($ApiHealthResponse) {
    Write-Host "✅ API is responding" -ForegroundColor Green
} else {
    Write-Host "❌ API is not responding" -ForegroundColor Red
}

# Test 3: Get OpenAPI/Swagger docs
Write-Host "`n[Test 3: OpenAPI Documentation]" -ForegroundColor Magenta
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
            Write-Host "   ✅ Found OpenAPI docs at: $endpoint" -ForegroundColor Green
            Write-Host "   📖 Open your browser to: http://localhost:3031$endpoint" -ForegroundColor Cyan
            break
        }
    }
    catch {
        Write-Host "   ❌ Not found: $endpoint" -ForegroundColor Gray
    }
}

# Test 4: Login to get token
Write-Host "`n[Test 4: Authentication]" -ForegroundColor Magenta
$LoginBody = @{
    email = "giuseppe@bellavista.com"
    password = "cashier123"
    businessSlug = "bella-vista-italian"
} | ConvertTo-Json

$LoginResponse = Invoke-ApiCall -Method "POST" -Endpoint "/auth/login" -Body $LoginBody -BaseUrl $BaseUrl -ApiPrefix $ApiPrefix

if ($LoginResponse -and $LoginResponse.token) {
    $Token = $LoginResponse.token
    Write-Host "✅ Login successful, got token" -ForegroundColor Green
    Write-Host "   User: $($LoginResponse.user.name)" -ForegroundColor Yellow
    Write-Host "   Business: $($LoginResponse.business.name)" -ForegroundColor Yellow
} else {
    Write-Host "❌ Login failed" -ForegroundColor Red
    exit 1
}

# Test 5: Test regular sale creation
Write-Host "`n[Test 5: Regular Sale Creation]" -ForegroundColor Magenta
$SaleBody = @{
    userId = $LoginResponse.user.id
    totalAmount = 25.99
    paymentMethod = "cash"
    status = "completed"
    notes = "Test sale from direct endpoint testing"
} | ConvertTo-Json

$SaleResponse = Invoke-ApiCall -Method "POST" -Endpoint "/sales" -Body $SaleBody -Token $Token -BaseUrl $BaseUrl -ApiPrefix $ApiPrefix

if ($SaleResponse) {
    Write-Host "✅ Regular sale creation successful" -ForegroundColor Green
    Write-Host "   Sale ID: $($SaleResponse.sale.id)" -ForegroundColor Yellow
} else {
    Write-Host "❌ Regular sale creation failed" -ForegroundColor Red
}

# Test 6: Test split payment creation
Write-Host "`n[Test 6: Split Payment Creation]" -ForegroundColor Magenta
$SplitPaymentBody = @{
    userId = $LoginResponse.user.id
    totalAmount = 50.00
    customerName = "Test Group Order"
    customerPhone = "555-1234"
    customerEmail = "test@example.com"
    notes = "Test split payment from direct endpoint testing"
    payments = @(
        @{
            amount = 30.00
            method = "credit_card"
            customerName = "John Doe"
            customerPhone = "555-1111"
            reference = "CC123456"
        },
        @{
            amount = 20.00
            method = "cash"
            customerName = "Jane Smith"
            customerPhone = "555-2222"
        }
    )
} | ConvertTo-Json -Depth 3

$SplitPaymentResponse = Invoke-ApiCall -Method "POST" -Endpoint "/sales/split" -Body $SplitPaymentBody -Token $Token -BaseUrl $BaseUrl -ApiPrefix $ApiPrefix

if ($SplitPaymentResponse) {
    Write-Host "✅ Split payment creation successful" -ForegroundColor Green
    Write-Host "   Sale ID: $($SplitPaymentResponse.sale.id)" -ForegroundColor Yellow
    Write-Host "   Payments count: $($SplitPaymentResponse.sale.payments.Count)" -ForegroundColor Yellow
} else {
    Write-Host "❌ Split payment creation failed" -ForegroundColor Red
}

Write-Host "`n[Direct Endpoint Testing Complete]" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan 