# Function to track web requests
function Track-WebRequests {
    param (
        [string]$Url = "https://discord.com"
    )

    # Create a new WebRequest instance
    $webRequest = [System.Net.WebRequest]::Create($Url)
    $webRequest.Method = "GET"

    try {
        # Get the response
        $webResponse = $webRequest.GetResponse()
        $responseStream = $webResponse.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($responseStream)
        $responseData = $reader.ReadToEnd()

        # Extract headers from the response
        $responseHeaders = $webResponse.Headers
        $authorizationHeader = $responseHeaders["Authorization"]

        # Output the data
        Write-Output "URL: $Url"
        Write-Output "Authorization Header: $authorizationHeader"
    } catch {
        Write-Error "Error: $($_.Exception.Message)"
    } finally {
        if ($responseStream) {
            $responseStream.Close()
        }
        if ($reader) {
            $reader.Close()
        }
    }
}

# Track requests to discord.com
Track-WebRequests -Url "https://discord.com"

# Function to track all web requests
function Track-AllWebRequests {
    # Create a new HttpWebRequest instance
    $httpWebRequest = [System.Net.HttpWebRequest]::Create("https://discord.com")
    $httpWebRequest.Method = "GET"

    try {
        # Get the response
        $httpWebResponse = $httpWebRequest.GetResponse()
        $responseStream = $httpWebResponse.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($responseStream)
        $responseData = $reader.ReadToEnd()

        # Extract headers from the response
        $responseHeaders = $httpWebResponse.Headers
        $authorizationHeader = $responseHeaders["Authorization"]

        # Output the request and response details
        Write-Output "Request URL: $($httpWebRequest.RequestUri)"
        Write-Output "Authorization Header: $authorizationHeader"

        if ($httpWebResponse -ne $null) {
            Write-Output "Response Status Code: $($httpWebResponse.StatusCode)"
        }
    } catch {
        Write-Error "Error: $($_.Exception.Message)"
    } finally {
        if ($responseStream) {
            $responseStream.Close()
        }
        if ($reader) {
            $reader.Close()
        }
    }
}

# Track all web requests
Track-AllWebRequests
