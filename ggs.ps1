# Import necessary modules
Import-Module .\WebRequestTracker.psm1

# Function to track web requests
function Track-WebRequests {
    param (
        [string]$Url = "https://discord.com"
    )

    # Create a new WebClient instance
    $webClient = New-Object System.Net.WebClient

    # Add event handler for downloading data
    $webClient.DownloadDataCompleted += {
        param ($sender, $e)
        if ($e.Error -ne $null) {
            Write-Error "Error: $($e.Error.Message)"
        } else {
            # Extract headers from the response
            $responseHeaders = $webClient.ResponseHeaders
            $authorizationHeader = $responseHeaders["Authorization"]

            # Output the data
            Write-Output "URL: $($e.Result.OriginalString)"
            Write-Output "Authorization Header: $authorizationHeader"
        }
    }

    # Start the asynchronous request
    $webClient.DownloadDataAsync($Url)
}

# Track requests to discord.com
Track-WebRequests -Url "https://discord.com"

# Function to track all web requests
function Track-AllWebRequests {
    # Create a new WebRequestTracker instance
    $tracker = New-Object WebRequestTracker

    # Add event handler for tracking requests
    $tracker.RequestTracked += {
        param ($sender, $e)
        $request = $e.Request
        $response = $e.Response

        # Output the request and response details
        Write-Output "Request URL: $($request.RequestUri)"
        Write-Output "Authorization Header: $($request.Headers["Authorization"])"

        if ($response -ne $null) {
            Write-Output "Response Status Code: $($response.StatusCode)"
        }
    }

    # Start tracking
    $tracker.StartTracking()
}

# Track all web requests
Track-AllWebRequests
