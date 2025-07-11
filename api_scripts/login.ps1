param(
    [string]$Email = "giuseppe@bellavista.com",
    [string]$Password = "cashier123",
    [string]$BusinessSlug = "bella-vista-italian",
    [string]$BaseUrl = "http://localhost:3031/api",
    [switch]$CopyToClipboard
)

# Function to make API calls
function Invoke-ApiCall {
    param(
        [string]$Method,
        [string]$Endpoint,
        [string]$Body = "",
        [string]$BaseUrl = "http://localhost:3031/api"
    )

    $Uri = "$BaseUrl$Endpoint"
    $Headers = @{
        "Content-Type" = "application/json"
    }

    Write-Host "[Login Request]" -ForegroundColor Cyan
    Write-Host "   URL: $Uri" -ForegroundColor Yellow
    Write-Host "   Email: $Email" -ForegroundColor Yellow
    Write-Host "   Business: $BusinessSlug" -ForegroundColor Yellow

    try {
        $Response = Invoke-RestMethod -Uri $Uri -Method $Method -Headers $Headers -Body $Body

        Write-Host "[Login Successful!]" -ForegroundColor Green
        return $Response
    }
    catch {
        $StatusCode = $_.Exception.Response.StatusCode.value__
        $ErrorMessage = $_.Exception.Message
        
        Write-Host "[Login Failed ($StatusCode)]" -ForegroundColor Red
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
Write-Host "[Login Script]" -ForegroundColor Cyan
Write-Host "=============" -ForegroundColor Cyan

# Set credentials for viewer user
$email = "antonio@bellavista.com"
$password = "viewer123"
$business = "bella-vista-italian"

$LoginBody = @{
    email = $email
    password = $password
    businessSlug = $business
} | ConvertTo-Json

$Response = Invoke-ApiCall -Method "POST" -Endpoint "/auth/login" -Body $LoginBody -BaseUrl $BaseUrl

if ($Response -and $Response.token) {
    Write-Host "\n[JWT Token]" -ForegroundColor Green
    Write-Host "===========" -ForegroundColor Green
    Write-Host $Response.token -ForegroundColor Yellow
    
    if ($CopyToClipboard) {
        $Response.token | Set-Clipboard
        Write-Host "\n[Token copied to clipboard!]" -ForegroundColor Green
    }
    
    Write-Host "\n[User Info]" -ForegroundColor Green
    Write-Host "===========" -ForegroundColor Green
    Write-Host "   Name: $($Response.user.name)" -ForegroundColor Yellow
    Write-Host "   Email: $($Response.user.email)" -ForegroundColor Yellow
    Write-Host "   Role: $($Response.user.role)" -ForegroundColor Yellow
    Write-Host "   Business: $($Response.user.business.name)" -ForegroundColor Yellow
    
    Write-Host "\n[Usage Examples]" -ForegroundColor Cyan
    Write-Host "================" -ForegroundColor Cyan
    Write-Host "   # Use token in api-call.ps1:" -ForegroundColor White
    Write-Host "   .\scripts\api-call.ps1 -Method `"GET`" -Endpoint `"/sales`" -Token `"$($Response.token)`"" -ForegroundColor Gray
    
    Write-Host "\n   # Set as environment variable:" -ForegroundColor White
    Write-Host "   `$env:API_TOKEN = `"$($Response.token)`"" -ForegroundColor Gray
    
    Write-Host "\n   # Use in PowerShell session:" -ForegroundColor White
    Write-Host "   `$Token = `"$($Response.token)`"" -ForegroundColor Gray
    
    return $Response.token
} else {
    Write-Host "\n[Failed to get token]" -ForegroundColor Red
    return $null
} 