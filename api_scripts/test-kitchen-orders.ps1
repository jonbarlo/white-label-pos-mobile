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
        Write-Host "   Data: $($Response | ConvertTo-Json -Depth 5)" -ForegroundColor Green
        
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
Write-Host "[Kitchen Orders Testing]" -ForegroundColor Cyan
Write-Host "=========================" -ForegroundColor Cyan

# Test 1: Login to get token
Write-Host "`n[Test 1: Authentication]" -ForegroundColor Magenta
$LoginBody = @{
    email = "admin@demo.com"
    password = "admin123"
    businessSlug = "demo-restaurant"
} | ConvertTo-Json

$LoginResponse = Invoke-ApiCall -Method "POST" -Endpoint "/auth/login" -Body $LoginBody -BaseUrl $BaseUrl -ApiPrefix $ApiPrefix

if ($LoginResponse -and $LoginResponse.token) {
    $Token = $LoginResponse.token
    $BusinessId = $LoginResponse.business.id
    Write-Host "✅ Login successful, got token" -ForegroundColor Green
    Write-Host "   User: $($LoginResponse.user.name)" -ForegroundColor Yellow
    Write-Host "   Business: $($LoginResponse.business.name)" -ForegroundColor Yellow
    Write-Host "   Business ID: $BusinessId" -ForegroundColor Yellow
} else {
    Write-Host "❌ Login failed" -ForegroundColor Red
    exit 1
}

# Test 2: Get Kitchen Orders
Write-Host "`n[Test 2: Kitchen Orders]" -ForegroundColor Magenta
$KitchenOrdersResponse = Invoke-ApiCall -Method "GET" -Endpoint "/kitchen/orders?businessId=$BusinessId" -Token $Token -BaseUrl $BaseUrl -ApiPrefix $ApiPrefix

if ($KitchenOrdersResponse) {
    Write-Host "✅ Kitchen orders request successful" -ForegroundColor Green
    if ($KitchenOrdersResponse.data) {
        Write-Host "   Orders count: $($KitchenOrdersResponse.data.Count)" -ForegroundColor Yellow
        foreach ($order in $KitchenOrdersResponse.data) {
            Write-Host "   Order: $($order.orderNumber), Status: $($order.status), Items: $($order.items.Count)" -ForegroundColor Yellow
        }
    } else {
        Write-Host "   No data field in response" -ForegroundColor Red
        Write-Host "   Response structure: $($KitchenOrdersResponse | ConvertTo-Json -Depth 3)" -ForegroundColor Gray
    }
} else {
    Write-Host "❌ Kitchen orders request failed" -ForegroundColor Red
}

# Test 3: Get Kitchen Orders without businessId (to see if it's required)
Write-Host "`n[Test 3: Kitchen Orders without businessId]" -ForegroundColor Magenta
$KitchenOrdersResponse2 = Invoke-ApiCall -Method "GET" -Endpoint "/kitchen/orders" -Token $Token -BaseUrl $BaseUrl -ApiPrefix $ApiPrefix

if ($KitchenOrdersResponse2) {
    Write-Host "✅ Kitchen orders request without businessId successful" -ForegroundColor Green
    if ($KitchenOrdersResponse2.data) {
        Write-Host "   Orders count: $($KitchenOrdersResponse2.data.Count)" -ForegroundColor Yellow
    } else {
        Write-Host "   No data field in response" -ForegroundColor Red
        Write-Host "   Response structure: $($KitchenOrdersResponse2 | ConvertTo-Json -Depth 3)" -ForegroundColor Gray
    }
} else {
    Write-Host "❌ Kitchen orders request without businessId failed" -ForegroundColor Red
}

Write-Host "`n[Kitchen Orders Testing Complete]" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan 