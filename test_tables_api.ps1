# Test Tables API Endpoint
$BaseUrl = "http://localhost:3031/api"

# Step 1: Login to get token
Write-Host "[Step 1: Login]" -ForegroundColor Cyan
$LoginBody = @{
    email = "giuseppe@bellavista.com"
    password = "cashier123"
    businessSlug = "bella-vista-italian"
} | ConvertTo-Json

try {
    $LoginResponse = Invoke-RestMethod -Uri "$BaseUrl/auth/login" -Method "POST" -Headers @{"Content-Type"="application/json"} -Body $LoginBody
    $Token = $LoginResponse.token
    Write-Host "✅ Login successful" -ForegroundColor Green
    Write-Host "   User: $($LoginResponse.user.name)" -ForegroundColor Yellow
    Write-Host "   Business: $($LoginResponse.business.name)" -ForegroundColor Yellow
    Write-Host "   Business Type: $($LoginResponse.business.type)" -ForegroundColor Yellow
} catch {
    Write-Host "❌ Login failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Step 2: Test tables endpoint
Write-Host "`n[Step 2: Test Tables Endpoint]" -ForegroundColor Cyan
try {
    $TablesResponse = Invoke-RestMethod -Uri "$BaseUrl/tables" -Method "GET" -Headers @{
        "Content-Type" = "application/json"
        "Authorization" = "Bearer $Token"
    }
    Write-Host "✅ Tables endpoint successful" -ForegroundColor Green
    Write-Host "   Tables found: $($TablesResponse.Count)" -ForegroundColor Yellow
    if ($TablesResponse.Count -gt 0) {
        Write-Host "   First table: $($TablesResponse[0] | ConvertTo-Json)" -ForegroundColor Yellow
    }
} catch {
    $StatusCode = $_.Exception.Response.StatusCode.value__
    Write-Host "❌ Tables endpoint failed ($StatusCode): $($_.Exception.Message)" -ForegroundColor Red
    
    # Try to get response body
    try {
        $ResponseStream = $_.Exception.Response.GetResponseStream()
        $Reader = New-Object System.IO.StreamReader($ResponseStream)
        $ResponseBody = $Reader.ReadToEnd()
        Write-Host "   Response Body: $ResponseBody" -ForegroundColor Red
    } catch {
        Write-Host "   Could not read response body" -ForegroundColor Red
    }
}

# Step 3: Test business endpoint to check business type
Write-Host "`n[Step 3: Check Business Type]" -ForegroundColor Cyan
try {
    $BusinessResponse = Invoke-RestMethod -Uri "$BaseUrl/businesses" -Method "GET" -Headers @{
        "Content-Type" = "application/json"
        "Authorization" = "Bearer $Token"
    }
    Write-Host "✅ Business endpoint successful" -ForegroundColor Green
    foreach ($business in $BusinessResponse) {
        Write-Host "   Business: $($business.name) (Type: $($business.type))" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ Business endpoint failed: $($_.Exception.Message)" -ForegroundColor Red
} 