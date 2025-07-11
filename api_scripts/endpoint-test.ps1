param(
    [string]$Email = "giuseppe@bellavista.com",
    [string]$Password = "cashier123",
    [string]$BusinessSlug = "bella-vista-italian",
    [string]$BaseUrl = "http://localhost:3031/api",
    [switch]$SkipAuth,
    [string]$Token = ""
)

# Import the login script functions
$LoginScriptPath = Join-Path $PSScriptRoot "login.ps1"
if (Test-Path $LoginScriptPath) {
    . $LoginScriptPath
}

# Function to make API calls
function Invoke-ApiCall {
    param(
        [string]$Method,
        [string]$Endpoint,
        [string]$Body = "",
        [string]$Token = "",
        [string]$BaseUrl = "http://localhost:3031/api"
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

# Function to test authentication endpoints
function Test-AuthEndpoints {
    param([string]$Token)

    Write-Host "`n🔐 Testing Authentication Endpoints..." -ForegroundColor Magenta
    Write-Host "=====================================" -ForegroundColor Magenta

    # Test login (should work)
    Write-Host "`n📝 Test: Login" -ForegroundColor Blue
    $LoginBody = @{
        email = $Email
        password = $Password
        businessSlug = $BusinessSlug
    } | ConvertTo-Json
    Invoke-ApiCall -Method "POST" -Endpoint "/auth/login" -Body $LoginBody

    # Test invalid login
    Write-Host "`n📝 Test: Invalid Login" -ForegroundColor Blue
    $InvalidLoginBody = @{
        email = "invalid@email.com"
        password = "wrongpassword"
        businessSlug = $BusinessSlug
    } | ConvertTo-Json
    Invoke-ApiCall -Method "POST" -Endpoint "/auth/login" -Body $InvalidLoginBody

    # Test profile (if authenticated)
    if ($Token) {
        Write-Host "`n📝 Test: Get Profile" -ForegroundColor Blue
        Invoke-ApiCall -Method "GET" -Endpoint "/auth/profile" -Token $Token
    }
}

# Function to test sales endpoints
function Test-SalesEndpoints {
    param([string]$Token)

    Write-Host "`n💰 Testing Sales Endpoints..." -ForegroundColor Magenta
    Write-Host "=============================" -ForegroundColor Magenta

    # Test get sales
    Write-Host "`n📝 Test: Get Sales" -ForegroundColor Blue
    Invoke-ApiCall -Method "GET" -Endpoint "/sales" -Token $Token

    # Test get sales stats
    Write-Host "`n📝 Test: Get Sales Stats" -ForegroundColor Blue
    Invoke-ApiCall -Method "GET" -Endpoint "/sales/stats" -Token $Token

    # Test create sale - minimal
    Write-Host "`n📝 Test: Create Sale (Minimal)" -ForegroundColor Blue
    $MinimalSaleBody = @{
        userId = 3
        totalAmount = 15.50
    } | ConvertTo-Json
    $SaleResponse = Invoke-ApiCall -Method "POST" -Endpoint "/sales" -Body $MinimalSaleBody -Token $Token

    # Test create sale - full
    Write-Host "`n📝 Test: Create Sale (Full)" -ForegroundColor Blue
    $FullSaleBody = @{
        userId = 3
        businessId = 1
        totalAmount = 25.75
        paymentMethod = "card"
        status = "completed"
        notes = "Test sale from endpoint testing"
    } | ConvertTo-Json
    Invoke-ApiCall -Method "POST" -Endpoint "/sales" -Body $FullSaleBody -Token $Token

    # Test get specific sale (if we have a sale ID)
    if ($SaleResponse -and $SaleResponse.id) {
        Write-Host "`n📝 Test: Get Specific Sale" -ForegroundColor Blue
        Invoke-ApiCall -Method "GET" -Endpoint "/sales/$($SaleResponse.id)" -Token $Token
    }
}

# Function to test split payment endpoints
function Test-SplitPaymentEndpoints {
    param([string]$Token)

    Write-Host "`n💳 Testing Split Payment Endpoints..." -ForegroundColor Magenta
    Write-Host "====================================" -ForegroundColor Magenta

    # Test get split billing stats
    Write-Host "`n📝 Test: Get Split Billing Stats" -ForegroundColor Blue
    Invoke-ApiCall -Method "GET" -Endpoint "/sales/split/stats" -Token $Token

    # Test create split payment
    Write-Host "`n📝 Test: Create Split Payment" -ForegroundColor Blue
    $SplitBody = @{
        userId = 3
        totalAmount = 75.00
        customerName = "Group Order Test"
        customerPhone = "555-9999"
        customerEmail = "group-test@example.com"
        notes = "Split payment test from endpoint testing"
        items = @(
            @{
                itemId = 1
                quantity = 2
                unitPrice = 25.00
            },
            @{
                itemId = 2
                quantity = 1
                unitPrice = 25.00
            }
        )
        payments = @(
            @{
                amount = 30.00
                method = "credit_card"
                customerName = "Alice Johnson"
                customerPhone = "555-1111"
                reference = "CC-TEST-001"
            },
            @{
                amount = 25.00
                method = "cash"
                customerName = "Bob Smith"
                customerPhone = "555-2222"
            },
            @{
                amount = 20.00
                method = "debit_card"
                customerName = "Carol Davis"
                customerPhone = "555-3333"
                reference = "DC-TEST-001"
            }
        )
    } | ConvertTo-Json -Depth 10

    $SplitResponse = Invoke-ApiCall -Method "POST" -Endpoint "/sales/split" -Body $SplitBody -Token $Token

    # Test get split payment details (if we have a split ID)
    if ($SplitResponse -and $SplitResponse.id) {
        Write-Host "`n📝 Test: Get Split Payment Details" -ForegroundColor Blue
        Invoke-ApiCall -Method "GET" -Endpoint "/sales/split/$($SplitResponse.id)" -Token $Token
    }
}

# Function to test inventory endpoints
function Test-InventoryEndpoints {
    param([string]$Token)

    Write-Host "`n📦 Testing Inventory Endpoints..." -ForegroundColor Magenta
    Write-Host "=================================" -ForegroundColor Magenta

    # Test get inventory items
    Write-Host "`n📝 Test: Get Inventory Items" -ForegroundColor Blue
    Invoke-ApiCall -Method "GET" -Endpoint "/inventory" -Token $Token

    # Test get inventory stats
    Write-Host "`n📝 Test: Get Inventory Stats" -ForegroundColor Blue
    Invoke-ApiCall -Method "GET" -Endpoint "/inventory/stats" -Token $Token
}

# Function to test business endpoints
function Test-BusinessEndpoints {
    param([string]$Token)

    Write-Host "`n🏢 Testing Business Endpoints..." -ForegroundColor Magenta
    Write-Host "=================================" -ForegroundColor Magenta

    # Test get business info
    Write-Host "`n📝 Test: Get Business Info" -ForegroundColor Blue
    Invoke-ApiCall -Method "GET" -Endpoint "/business" -Token $Token

    # Test get business settings
    Write-Host "`n📝 Test: Get Business Settings" -ForegroundColor Blue
    Invoke-ApiCall -Method "GET" -Endpoint "/business/settings" -Token $Token
}

# Function to test user management endpoints
function Test-UserManagementEndpoints {
    param([string]$Token)

    Write-Host "`n👥 Testing User Management Endpoints..." -ForegroundColor Magenta
    Write-Host "=======================================" -ForegroundColor Magenta

    # Test get users
    Write-Host "`n📝 Test: Get Users" -ForegroundColor Blue
    Invoke-ApiCall -Method "GET" -Endpoint "/users" -Token $Token

    # Test get user roles
    Write-Host "`n📝 Test: Get User Roles" -ForegroundColor Blue
    Invoke-ApiCall -Method "GET" -Endpoint "/users/roles" -Token $Token
}

# Function to test reports endpoints
function Test-ReportsEndpoints {
    param([string]$Token)

    Write-Host "`n📊 Testing Reports Endpoints..." -ForegroundColor Magenta
    Write-Host "=================================" -ForegroundColor Magenta

    # Test get revenue report
    Write-Host "`n📝 Test: Get Revenue Report" -ForegroundColor Blue
    Invoke-ApiCall -Method "GET" -Endpoint "/reports/revenue" -Token $Token

    # Test get sales report
    Write-Host "`n📝 Test: Get Sales Report" -ForegroundColor Blue
    Invoke-ApiCall -Method "GET" -Endpoint "/reports/sales" -Token $Token
}

# Main execution
Write-Host "🚀 Endpoint Testing Script" -ForegroundColor Cyan
Write-Host "=========================" -ForegroundColor Cyan
Write-Host "Base URL: $BaseUrl" -ForegroundColor Yellow
Write-Host "Email: $Email" -ForegroundColor Yellow
Write-Host "Business: $BusinessSlug" -ForegroundColor Yellow

# Get authentication token
$AuthToken = $Token
if (-not $SkipAuth -and -not $Token) {
    Write-Host "`n🔐 Getting authentication token..." -ForegroundColor Cyan
    
    # Call the login function from login.ps1
    $LoginBody = @{
        email = $Email
        password = $Password
        businessSlug = $BusinessSlug
    } | ConvertTo-Json

    $LoginResponse = Invoke-ApiCall -Method "POST" -Endpoint "/auth/login" -Body $LoginBody -BaseUrl $BaseUrl
    
    if ($LoginResponse -and $LoginResponse.token) {
        $AuthToken = $LoginResponse.token
        Write-Host "✅ Authentication successful!" -ForegroundColor Green
    } else {
        Write-Host "❌ Authentication failed!" -ForegroundColor Red
        Write-Host "Continuing with unauthenticated tests..." -ForegroundColor Yellow
    }
}

# Run all endpoint tests
Test-AuthEndpoints -Token $AuthToken
Test-SalesEndpoints -Token $AuthToken
Test-SplitPaymentEndpoints -Token $AuthToken
Test-InventoryEndpoints -Token $AuthToken
Test-BusinessEndpoints -Token $AuthToken
Test-UserManagementEndpoints -Token $AuthToken
Test-ReportsEndpoints -Token $AuthToken

Write-Host "`n🏁 Endpoint Testing Complete!" -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan 