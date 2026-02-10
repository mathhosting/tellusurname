# Function to track web requests
function Track-WebRequests {
    param (
        [string]$Url = "https://discord.com"
    )

    # Create a new WebClient instance
    $webClient = New-Object System.Net.WebClient

    try {
        # Download the data
        $data = $webClient.DownloadData($Url)

        # Extract headers from the response
        $responseHeaders = $webClient.ResponseHeaders
        $authorizationHeader = $responseHeaders["Authorization"]

        # Output the data
        Write-Output "URL: $Url"
        Write-Output "Authorization Header: $authorizationHeader"
    } catch {
        Write-Error "Error: $($_.Exception.Message)"
    }
}

# Track requests to discord.com
Track-WebRequests -Url "https://discord.com"

# Function to track all web requests
function Track-AllWebRequests {
    # Create a new HttpClient instance
    $httpClient = New-Object System.Net.Http.HttpClient

    # Add a handler to intercept requests
    $handler = New-Object System.Net.Http.HttpClientHandler
    $httpClient = New-Object System.Net.Http.HttpClient($handler)

    # Start tracking
    $handler.MessageSent += {
        param ($sender, $e)
        $request = $e.RequestMessage
        $response = $e.ResponseMessage

        # Output the request and response details
        Write-Output "Request URL: $($request.RequestUri)"
        Write-Output "Authorization Header: $($request.Headers.Authorization)"

        if ($response -ne $null) {
            Write-Output "Response Status Code: $($response.StatusCode)"
        }
    }

    # Example usage: Send a request to discord.com
    $response = $httpClient.GetAsync("https://discord.com").Result
    Write-Output "Example Request Completed"
}

# Track all web requests
Track-AllWebRequests
