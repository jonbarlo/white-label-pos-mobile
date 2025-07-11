param(
    [string]$Token = "",
    [string]$BaseUrl = "http://localhost:3031/api"
)

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
Write-Host "[Split Payment Test]" -ForegroundColor Cyan
Write-Host "===================" -ForegroundColor Cyan

if (-not $Token) {
    Write-Host "[Error] No token provided. Please run login.ps1 first to get a token." -ForegroundColor Red
    exit 1
}

# Test 1: Simple split payment request
Write-Host "`n[Test 1: Simple Split Payment]" -ForegroundColor Magenta

$SplitPaymentBody = @{
    userId = 3
    totalAmount = 50.00
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

$Response = Invoke-ApiCall -Method "POST" -Endpoint "/sales/split" -Body $SplitPaymentBody -Token $Token -BaseUrl $BaseUrl

if ($Response) {
    Write-Host "`n[Test 1: SUCCESS]" -ForegroundColor Green
} else {
    Write-Host "`n[Test 1: FAILED]" -ForegroundColor Red
}

# Test 2: Split payment with items
Write-Host "`n[Test 2: Split Payment with Items]" -ForegroundColor Magenta

$SplitPaymentWithItemsBody = @{
    userId = 3
    totalAmount = 75.00
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
            unitPrice = 25.00
        }
    )
    payments = @(
        @{
            amount = 25.00
            method = "credit_card"
            customerName = "Alice Johnson"
            customerPhone = "555-3333"
            reference = "CC789012"
        },
        @{
            amount = 25.00
            method = "debit_card"
            customerName = "Bob Wilson"
            customerPhone = "555-4444"
            reference = "DC345678"
        },
        @{
            amount = 25.00
            method = "cash"
            customerName = "Carol Davis"
            customerPhone = "555-5555"
        }
    )
} | ConvertTo-Json -Depth 3

$Response2 = Invoke-ApiCall -Method "POST" -Endpoint "/sales/split" -Body $SplitPaymentWithItemsBody -Token $Token -BaseUrl $BaseUrl

if ($Response2) {
    Write-Host "`n[Test 2: SUCCESS]" -ForegroundColor Green
} else {
    Write-Host "`n[Test 2: FAILED]" -ForegroundColor Red
}

Write-Host "`n[Split Payment Test Complete]" -ForegroundColor Cyan 