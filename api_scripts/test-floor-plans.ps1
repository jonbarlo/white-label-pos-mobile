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
Write-Host "[Floor Plans API Testing]" -ForegroundColor Cyan
Write-Host "===========================" -ForegroundColor Cyan

# Test 1: Login to get token
Write-Host "`n[Test 1: Authentication]" -ForegroundColor Magenta
$LoginBody = @{
    email = "marco@italiandelight.com"
    password = "password123"
    businessSlug = "italian-delight"
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

# Test 2: Get all floor plans
Write-Host "`n[Test 2: Get All Floor Plans]" -ForegroundColor Magenta
$FloorPlansResponse = Invoke-ApiCall -Method "GET" -Endpoint "/floor-plans" -Token $Token -BaseUrl $BaseUrl -ApiPrefix $ApiPrefix

if ($FloorPlansResponse) {
    Write-Host "✅ Floor plans request successful" -ForegroundColor Green
    
    # Analyze the response structure
    if ($FloorPlansResponse.success) {
        Write-Host "   Success: $($FloorPlansResponse.success)" -ForegroundColor Green
        
        if ($FloorPlansResponse.data) {
            $FloorPlansData = $FloorPlansResponse.data
            Write-Host "   Data type: $($FloorPlansData.GetType().Name)" -ForegroundColor Yellow
            Write-Host "   Data count: $($FloorPlansData.Count)" -ForegroundColor Yellow
            
            if ($FloorPlansData.Count -gt 0) {
                $FirstFloorPlan = $FloorPlansData[0]
                Write-Host "   First floor plan fields:" -ForegroundColor Yellow
                $FirstFloorPlan.PSObject.Properties | ForEach-Object {
                    Write-Host "     $($_.Name): $($_.Value) ($($_.Value.GetType().Name))" -ForegroundColor Gray
                }
            }
        }
    }
} else {
    Write-Host "❌ Floor plans request failed" -ForegroundColor Red
}

# Test 3: Get tables
Write-Host "`n[Test 3: Get All Tables]" -ForegroundColor Magenta
$TablesResponse = Invoke-ApiCall -Method "GET" -Endpoint "/tables" -Token $Token -BaseUrl $BaseUrl -ApiPrefix $ApiPrefix

if ($TablesResponse) {
    Write-Host "✅ Tables request successful" -ForegroundColor Green
    
    if ($TablesResponse.success) {
        Write-Host "   Success: $($TablesResponse.success)" -ForegroundColor Green
        
        if ($TablesResponse.data) {
            $TablesData = $TablesResponse.data
            Write-Host "   Data type: $($TablesData.GetType().Name)" -ForegroundColor Yellow
            Write-Host "   Data count: $($TablesData.Count)" -ForegroundColor Yellow
            
            if ($TablesData.Count -gt 0) {
                $FirstTable = $TablesData[0]
                Write-Host "   First table fields:" -ForegroundColor Yellow
                $FirstTable.PSObject.Properties | ForEach-Object {
                    Write-Host "     $($_.Name): $($_.Value) ($($_.Value.GetType().Name))" -ForegroundColor Gray
                }
            }
        }
    }
} else {
    Write-Host "❌ Tables request failed" -ForegroundColor Red
}

Write-Host "`n[Floor Plans API Testing Complete]" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan 