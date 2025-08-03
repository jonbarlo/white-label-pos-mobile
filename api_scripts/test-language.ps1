# Test Language API Endpoints
# This script tests the language management endpoints

$baseUrl = "http://localhost:3031/api"
$token = ""

# Function to make API calls
function Invoke-ApiCall {
    param(
        [string]$Method,
        [string]$Endpoint,
        [object]$Body = $null,
        [hashtable]$Headers = @{}
    )
    
    $uri = "$baseUrl$Endpoint"
    $headers["Content-Type"] = "application/json"
    
    if ($token) {
        $headers["Authorization"] = "Bearer $token"
    }
    
    $params = @{
        Uri = $uri
        Method = $Method
        Headers = $headers
    }
    
    if ($Body) {
        $params.Body = $Body | ConvertTo-Json -Depth 10
    }
    
    try {
        $response = Invoke-RestMethod @params
        Write-Host "✅ Success: $Method $Endpoint" -ForegroundColor Green
        Write-Host "Response: $($response | ConvertTo-Json -Depth 10)" -ForegroundColor Cyan
        return $response
    }
    catch {
        Write-Host "❌ Error: $Method $Endpoint" -ForegroundColor Red
        Write-Host "Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Yellow
        Write-Host "Message: $($_.Exception.Message)" -ForegroundColor Yellow
        if ($_.Exception.Response) {
            $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
            $responseBody = $reader.ReadToEnd()
            Write-Host "Response: $responseBody" -ForegroundColor Yellow
        }
        return $null
    }
}

Write-Host "🌍 Testing Language API Endpoints" -ForegroundColor Magenta
Write-Host "=================================" -ForegroundColor Magenta

# Test 1: Get language settings (without auth - should work)
Write-Host "`n📋 Test 1: Get language settings (no auth)" -ForegroundColor Blue
$response = Invoke-ApiCall -Method "GET" -Endpoint "/language"

# Test 2: Get language settings with Accept-Language header
Write-Host "`n📋 Test 2: Get language settings with Accept-Language: es-CR" -ForegroundColor Blue
$headers = @{
    "Accept-Language" = "es-CR"
}
$response = Invoke-ApiCall -Method "GET" -Endpoint "/language" -Headers $headers

# Test 3: Get language settings with query parameter
Write-Host "`n📋 Test 3: Get language settings with ?lang=es-CR" -ForegroundColor Blue
$response = Invoke-ApiCall -Method "GET" -Endpoint "/language?lang=es-CR"

# Test 4: Update language (without auth - should fail)
Write-Host "`n📋 Test 4: Update language (no auth - should fail)" -ForegroundColor Blue
$body = @{
    language = "es-CR"
}
$response = Invoke-ApiCall -Method "PUT" -Endpoint "/language" -Body $body

Write-Host "`n✅ Language API tests completed!" -ForegroundColor Green
Write-Host "Note: Update language endpoint requires authentication" -ForegroundColor Yellow 