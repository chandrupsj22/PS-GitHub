# Set variables
$teamCityUrl = "http://localhost:8088"
$buildTypeId = "GitHubTestRepo_Build"
$xmlFilePath = "C:\Users\chand\OneDrive\Documents\WindowsPowerShell\Modules\PS-GitHub\Branch_Products\RA Branching\settings.xml"

# Get the current file modification timestamp
$currentTimestamp = (Get-Item $xmlFilePath).LastWriteTimeUtc.ToString("yyyy-MM-ddTHH:mm:ssZ")

# Construct the REST API URL to check for modifications
$modificationsUrl = "$teamCityUrl/admin/app/rest/changes?buildType=$buildTypeId&sinceDate=$currentTimestamp"

# Send a GET request to the modifications URL
$modificationsResponse = Invoke-RestMethod -Uri $modificationsUrl -Method Get

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
        "Authorization" = "Bearer eyJ0eXAiOiAiVENWMiJ9.VGljaUlZLXpfamlyVmZKZXBRZFZacEIxclRN.NGRjOTM4NDgtZjc0NC00NzZiLTg5ZjktMTQ3ZGNkN2MwOThk"
        "Content-Type" = "application/xml"
    }

    # Send a POST request to trigger the build
    Invoke-RestMethod -Uri $buildTriggerUrl -Method Post -Body ($body | ConvertTo-Json) -Headers $headers
}
