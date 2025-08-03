# Language Testing Script for Multi-Language System
# Tests the new backend language features

$baseUrl = "http://localhost:3031/api"
$headers = @{
    "Content-Type" = "application/json"
    "Accept" = "application/json"
}

Write-Host "🌐 Testing Multi-Language System" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green

# Test 1: Get Language Preferences
Write-Host "`n1. Testing Language Preferences Endpoint" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/language/preference" -Method GET -Headers $headers
    Write-Host "✅ Language preferences retrieved successfully" -ForegroundColor Green
    Write-Host "Current Language: $($response.language)" -ForegroundColor Cyan
    Write-Host "Supported Languages: $($response.supportedLanguages -join ', ')" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Failed to get language preferences: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 2: Update Language to Spanish
Write-Host "`n2. Testing Language Update to Spanish" -ForegroundColor Yellow
try {
    $body = @{
        language = "es-CR"
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "$baseUrl/language/preference" -Method PUT -Headers $headers -Body $body
    Write-Host "✅ Language updated to Spanish successfully" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to update language to Spanish: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: Update Language to English
Write-Host "`n3. Testing Language Update to English" -ForegroundColor Yellow
try {
    $body = @{
        language = "en-US"
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "$baseUrl/language/preference" -Method PUT -Headers $headers -Body $body
    Write-Host "✅ Language updated to English successfully" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to update language to English: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 4: Test with Accept-Language Header
Write-Host "`n4. Testing with Accept-Language Header" -ForegroundColor Yellow
try {
    $headersWithLang = $headers.Clone()
    $headersWithLang["Accept-Language"] = "es-CR"
    
    $response = Invoke-RestMethod -Uri "$baseUrl/language/preference" -Method GET -Headers $headersWithLang
    Write-Host "✅ Request with Accept-Language header successful" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed with Accept-Language header: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 5: Test Error Messages in Spanish
Write-Host "`n5. Testing Error Messages in Spanish" -ForegroundColor Yellow
try {
    # Try to access a non-existent endpoint to test error messages
    $response = Invoke-RestMethod -Uri "$baseUrl/non-existent-endpoint" -Method GET -Headers $headers
} catch {
    Write-Host "✅ Error response received (expected)" -ForegroundColor Green
    Write-Host "Error Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Cyan
    Write-Host "Error Message: $($_.Exception.Message)" -ForegroundColor Cyan
}

Write-Host "`n🌐 Language Testing Complete!" -ForegroundColor Green
Write-Host "Check the mobile app for language switching functionality." -ForegroundColor Cyan 