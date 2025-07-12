# PowerShell script to login and call any API endpoint with authentication
param(
    [string]$Email = "antonio@bellavista.com",
    [string]$Password = "viewer123",
    [string]$BusinessSlug = "bella-vista-italian",
    [string]$Endpoint = "/api/kitchen/orders",
    [string]$Query = "businessId=1&status=preparing"
)

Write-Host "--- Logging in as $Email ---"
$loginBody = @{ email = $Email; password = $Password; businessSlug = $BusinessSlug } | ConvertTo-Json
$loginResponse = Invoke-RestMethod -Uri "http://localhost:3031/api/auth/login" -Method Post -Body $loginBody -ContentType "application/json"

if (-not $loginResponse.token) {
    Write-Host "Login failed! Response:"
    $loginResponse | ConvertTo-Json -Depth 10
    exit 1
}

$token = $loginResponse.token
Write-Host "--- Login successful. Token: $token ---"

# Build full API URL
$apiUrl = "http://localhost:3031$Endpoint"
if ($Query) {
    $apiUrl = "$apiUrl?$Query"
}

Write-Host "--- Calling API: $apiUrl ---"
$headers = @{ Authorization = "Bearer $token" }
try {
    $apiResponse = Invoke-RestMethod -Uri $apiUrl -Headers $headers -Method Get
    Write-Host "--- API Response ---"
    $apiResponse | ConvertTo-Json -Depth 10
} catch {
    Write-Host "API call failed! Error: $_"
} 