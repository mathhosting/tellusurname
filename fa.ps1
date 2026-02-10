# Function to track web requests and filter for message requests
function Track-DiscordMessageRequests {
    param (
        [string]$Url = "https://discord.com/app"
    )

    while ($true) {
        # Create a new WebRequest instance
        $webRequest = [System.Net.WebRequest]::Create($Url)
        $webRequest.Method = "GET"

        try {
            # Get the response
            $webResponse = $webRequest.GetResponse()
            $responseStream = $webResponse.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($responseStream)
            $responseData = $reader.ReadToEnd()

            # Check if the response contains message data
            if ($responseData -match "messages") {
                # Extract headers from the response
                $responseHeaders = $webResponse.Headers
                $authorizationHeader = $responseHeaders["Authorization"]

                # Output the data
                Write-Output "URL: $Url"
                Write-Output "Authorization Header: $authorizationHeader"
                Write-Output "Response Data: $responseData"
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

        # Wait for a short period before the next request
        Start-Sleep -Seconds 5
    }
}

# Track requests to discord.com and filter for message requests
Track-DiscordMessageRequests -Url "https://discord.com/api/v9/channels/{channel.id}/messages"
