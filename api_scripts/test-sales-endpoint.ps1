# Test the sales endpoint with the exact payload from Flutter app
param(
    [string]$BaseUrl = "http://localhost:3031/api"
)

Write-Host "🔍 Testing sales endpoint with Flutter app payload..." -ForegroundColor Cyan

# First, login to get a token
Write-Host "🔐 Logging in..." -ForegroundColor Yellow
$loginBody = @{
    email = "maria@italiandelight.com"
    password = "maria123"
    businessSlug = "italian-delight"
} | ConvertTo-Json

try {
    $loginResponse = Invoke-RestMethod -Uri "$BaseUrl/auth/login" -Method POST -Body $loginBody -ContentType "application/json"
    $token = $loginResponse.token
    Write-Host "✅ Login successful" -ForegroundColor Green
} catch {
    Write-Host "❌ Login failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Test the sales endpoint with the exact payload from Flutter app
$salesPayload = @{
    userId = 22
    businessId = 4
    customerName = "Guest"
    customerEmail = "guest@pos.com"
    totalAmount = 16.99
    paymentMethod = "card"
    status = "completed"
    orderItems = @(
        @{
            itemId = 11
            quantity = 1
            unitPrice = 16.99
        }
    )
} | ConvertTo-Json -Depth 3

Write-Host "🛒 Testing sales endpoint..." -ForegroundColor Yellow
Write-Host "📤 Request payload:" -ForegroundColor Gray
Write-Host $salesPayload -ForegroundColor Gray

try {
    $headers = @{
        "Authorization" = "Bearer $token"
        "Content-Type" = "application/json"
    }
    
    $response = Invoke-RestMethod -Uri "$BaseUrl/sales/with-items" -Method POST -Body $salesPayload -Headers $headers
    Write-Host "✅ Sales creation successful!" -ForegroundColor Green
    Write-Host "📥 Response:" -ForegroundColor Gray
    $response | ConvertTo-Json -Depth 3 | Write-Host -ForegroundColor Gray
} catch {
    Write-Host "❌ Sales creation failed!" -ForegroundColor Red
    Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
    Write-Host "Error Message: $($_.Exception.Message)" -ForegroundColor Red
    
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host "Response Body: $responseBody" -ForegroundColor Red
    }
} 