param(
    [string]$Method = "GET",
    [string]$Endpoint = "",
    [string]$Body = "",
    [string]$Token = "",
    [string]$BaseUrl = "http://localhost:3031/api",
    [switch]$Verbose
)

# Function to make API calls
function Invoke-ApiCall {
    param(
        [string]$Method,
        [string]$Endpoint,
        [string]$Body = "",
        [string]$Token = "",
        [string]$BaseUrl = "http://localhost:3031/api",
        [switch]$Verbose
    )

    $Uri = "$BaseUrl$Endpoint"
    $Headers = @{
        "Content-Type" = "application/json"
    }

    if ($Token) {
        $Headers["Authorization"] = "Bearer $Token"
    }

    Write-Host "🌐 API Call:" -ForegroundColor Cyan
    Write-Host "   Method: $Method" -ForegroundColor Yellow
    Write-Host "   URL: $Uri" -ForegroundColor Yellow
    
    if ($Body) {
        Write-Host "   Body: $Body" -ForegroundColor Yellow
    }
    
    if ($Token) {
        Write-Host "   Token: [Present]" -ForegroundColor Yellow
    }

    try {
        if ($Method -eq "GET") {
            $Response = Invoke-RestMethod -Uri $Uri -Method $Method -Headers $Headers
        } else {
            $Response = Invoke-RestMethod -Uri $Uri -Method $Method -Headers $Headers -Body $Body
        }

        Write-Host "✅ Success Response:" -ForegroundColor Green
        $Response | ConvertTo-Json -Depth 10 | Write-Host -ForegroundColor Green
        
        return $Response
    }
    catch {
        $StatusCode = $_.Exception.Response.StatusCode.value__
        $ErrorMessage = $_.Exception.Message
        
        Write-Host "❌ Error Response ($StatusCode):" -ForegroundColor Red
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

# Function to test sale creation with different payloads
function Test-SaleCreation {
    param([string]$Token)

    Write-Host "`n🧪 Testing Sale Creation..." -ForegroundColor Magenta

    # Test 1: Minimal required fields
    Write-Host "`n📝 Test 1: Minimal fields (userId, totalAmount)" -ForegroundColor Blue
    $Body1 = '{"userId": 3, "totalAmount": 10.00}'
    Invoke-ApiCall -Method "POST" -Endpoint "/sales" -Body $Body1 -Token $Token

    # Test 2: With payment method
    Write-Host "`n📝 Test 2: With payment method" -ForegroundColor Blue
    $Body2 = '{"userId": 3, "totalAmount": 10.00, "paymentMethod": "card"}'
    Invoke-ApiCall -Method "POST" -Endpoint "/sales" -Body $Body2 -Token $Token

    # Test 3: With businessId (what we were sending before)
    Write-Host "`n📝 Test 3: With businessId" -ForegroundColor Blue
    $Body3 = '{"userId": 3, "businessId": 1, "totalAmount": 10.00, "paymentMethod": "card", "status": "completed"}'
    Invoke-ApiCall -Method "POST" -Endpoint "/sales" -Body $Body3 -Token $Token

    # Test 4: With all fields
    Write-Host "`n📝 Test 4: With all fields" -ForegroundColor Blue
    $Body4 = '{"userId": 3, "businessId": 1, "totalAmount": 10.00, "paymentMethod": "card", "status": "completed", "notes": "Test sale"}'
    Invoke-ApiCall -Method "POST" -Endpoint "/sales" -Body $Body4 -Token $Token
}

# Function to test split payment creation
function Test-SplitPayment {
    param([string]$Token)

    Write-Host "`n🧪 Testing Split Payment Creation..." -ForegroundColor Magenta

    $SplitBody = @{
        userId = 3
        totalAmount = 100.00
        customerName = "Group Order"
        customerPhone = "555-1234"
        customerEmail = "group@example.com"
        notes = "Split between 3 people"
        items = @(
            @{
                itemId = 1
                quantity = 2
                unitPrice = 25.00
            },
            @{
                itemId = 2
                quantity = 1
                unitPrice = 50.00
            }
        )
        payments = @(
            @{
                amount = 40.00
                method = "credit_card"
                customerName = "John Doe"
                customerPhone = "555-1111"
                reference = "CC123456"
            },
            @{
                amount = 35.00
                method = "cash"
                customerName = "Jane Smith"
                customerPhone = "555-2222"
            },
            @{
                amount = 25.00
                method = "debit_card"
                customerName = "Bob Wilson"
                customerPhone = "555-3333"
                reference = "DC789012"
            }
        )
    } | ConvertTo-Json -Depth 10

    Invoke-ApiCall -Method "POST" -Endpoint "/sales/split" -Body $SplitBody -Token $Token
}

# Function to test authentication
function Test-Authentication {
    Write-Host "`n🧪 Testing Authentication..." -ForegroundColor Magenta

    $LoginBody = '{"email": "giuseppe@bellavista.com", "password": "cashier123", "businessSlug": "bella-vista-italian"}'
    $Response = Invoke-ApiCall -Method "POST" -Endpoint "/auth/login" -Body $LoginBody

    if ($Response -and $Response.token) {
        Write-Host "✅ Login successful, token received" -ForegroundColor Green
        return $Response.token
    } else {
        Write-Host "❌ Login failed" -ForegroundColor Red
        return $null
    }
}

# Main execution
Write-Host "🚀 API Testing Script" -ForegroundColor Cyan
Write-Host "===================" -ForegroundColor Cyan

# Test authentication first
$Token = Test-Authentication

if ($Token) {
    # Test sale creation
    Test-SaleCreation -Token $Token
    
    # Test split payment
    Test-SplitPayment -Token $Token
    
    # Test other endpoints
    Write-Host "`n🧪 Testing Other Endpoints..." -ForegroundColor Magenta
    
    Write-Host "`n📝 Test: Get sales" -ForegroundColor Blue
    Invoke-ApiCall -Method "GET" -Endpoint "/sales" -Token $Token
    
    Write-Host "`n📝 Test: Get sales stats" -ForegroundColor Blue
    Invoke-ApiCall -Method "GET" -Endpoint "/sales/stats" -Token $Token
    
    Write-Host "`n📝 Test: Get split billing stats" -ForegroundColor Blue
    Invoke-ApiCall -Method "GET" -Endpoint "/sales/split/stats" -Token $Token
} else {
    Write-Host "❌ Cannot proceed without authentication token" -ForegroundColor Red
}

Write-Host "`n🏁 API Testing Complete" -ForegroundColor Cyan 