# Function to track web requests and filter for message requests
function Track-DiscordMessageRequests {
    param (
        [string]$Url = "https://discord.com/api/v9/channels/1462925917432054048/messages",
        [string]$AuthorizationToken
    )

    while ($true) {
        # Create a new WebRequest instance
        $webRequest = [System.Net.WebRequest]::Create($Url)
        $webRequest.Method = "POST"
        $webRequest.ContentType = "application/json"
        $webRequest.Headers["Authorization"] = "Bearer $AuthorizationToken"

        # Example JSON payload for the POST request
        $jsonPayload = @{
            content = "Hello, world!"
        } | ConvertTo-Json

        # Convert the JSON payload to a byte array
        $byteArray = [System.Text.Encoding]::UTF8.GetBytes($jsonPayload)

        # Set the content length
        $webRequest.ContentLength = $byteArray.Length

        try {
            # Get the request stream and write the JSON payload
            $requestStream = $webRequest.GetRequestStream()
            $requestStream.Write($byteArray, 0, $byteArray.Length)
            $requestStream.Close()

            # Get the response
            $webResponse = $webRequest.GetResponse()
            $responseStream = $webResponse.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($responseStream)
            $responseData = $reader.ReadToEnd()

            # Output the request and response details
            Write-Output "Request URL: $Url"
            Write-Output "Request Method: POST"
            Write-Output "Authorization Header: Bearer $AuthorizationToken"
            Write-Output "Response Status Code: $($webResponse.StatusCode)"
            Write-Output "Response Data: $responseData"
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

# Replace with your actual Discord bot token or user token
$discordToken = "YOUR_DISCORD_TOKEN_HERE"

# Track requests to discord.com and filter for message requests
Track-DiscordMessageRequests -Url "https://discord.com/api/v9/channels/1462925917432054048/messages" -AuthorizationToken $discordToken
