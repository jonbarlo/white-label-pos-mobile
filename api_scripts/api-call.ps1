param(
    [Parameter(Mandatory=$true)]
    [string]$Method,
    
    [Parameter(Mandatory=$true)]
    [string]$Endpoint,
    
    [string]$Body = "",
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

# Make the API call
Invoke-ApiCall -Method $Method -Endpoint $Endpoint -Body $Body -Token $Token -BaseUrl $BaseUrl 