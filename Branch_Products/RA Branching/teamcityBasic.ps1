# Set variables
$teamCityUrl = "http://localhost:8088"
$buildTypeId = "GitHubTestRepo_Build"
$xmlFilePath = "C:\Users\chand\OneDrive\Documents\WindowsPowerShell\Modules\PS-GitHub\Branch_Products\RA Branching\settings.xml"
$username = "chandrupsj22"
$password = "Cpriya@321"

# Get the current file modification timestamp
$currentTimestamp = (Get-Item $xmlFilePath).LastWriteTimeUtc.ToString("yyyy-MM-ddTHH:mm:ssZ")

# Construct the REST API URL to check for modifications
$modificationsUrl = "$teamCityUrl/admin/editBuild.html?id=buildType:GitHubTestRepo_Build&sinceDate=$currentTimestamp"

# Create a credential object with the appropriate credentials
$credential = New-Object System.Management.Automation.PSCredential ($username, (ConvertTo-SecureString $password -AsPlainText -Force))

# Send a GET request to the modifications URL, passing the credential object as the value of the -Credential parameter
$modificationsResponse = Invoke-RestMethod -Uri $modificationsUrl -Method Get -Credential $credential

# If modifications were found, trigger a build
if ($modificationsResponse.change) {
    # Construct the REST API URL to trigger a build
    $buildTriggerUrl = "$teamCityUrl/httpAuth/app/rest/buildQueue"
    $body = @{
        "buildType" = @{
            "id" = "$buildTypeId"
        }
    }
    $headers = @{
        "Content-Type" = "application/json"
    }

    # Send a POST request to trigger the build, passing the credential object as the value of the -Credential parameter
    Invoke-RestMethod -Uri $buildTriggerUrl -Method Post -Body ($body | ConvertTo-Json) -Headers $headers -Credential $credential
}

http://localhost:8088/admin/editBuild.html?id=buildType:GitHubTestRepo_Build