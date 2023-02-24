# Set the path of the PowerShell module directory to monitor
$moduleDirectory = "C:\Users\chand\OneDrive\Documents\WindowsPowerShell\Modules\PS-GitHub"
$Auth64Encoded = "eyJ0eXAiOiAiVENWMiJ9.VGljaUlZLXpfamlyVmZKZXBRZFZacEIxclRN.NGRjOTM4NDgtZjc0NC00NzZiLTg5ZjktMTQ3ZGNkN2MwOThk"

# Set the path of the file that will store the state of the directory
$stateFilePath = "C:\State\MyModuleDirectory.state"

# Check if the state file exists
if (Test-Path $stateFilePath) {
    # Read the state of the directory from the state file
    $previousState = Get-Content $stateFilePath
} else {
    # If the state file doesn't exist, create it and set the state to empty
    New-Item -ItemType File -Path $stateFilePath | Out-Null
    $previousState = ""
}

# Get the current state of the directory
$currentState = Get-ChildItem -Recurse $moduleDirectory | Get-FileHash | Out-String

# Compare the current state with the previous state
if ($currentState -ne $previousState) {
    # If there are differences, update the state file and trigger a TeamCity build
    Set-Content $stateFilePath $currentState
    #Invoke-RestMethod -Uri "http://localhost:8088/admin/editBuild.html?id=buildType:GitHubTestRepo_Build"  -Method POST -Headers @{'Authorization'= "Bearer $Auth64Encoded"}
    #Invoke-RestMethod -Uri "http://localhost:8088/admin/action.html?add2Queue=GitHubTestRepo_Build"  -Method POST -Headers @{'Authorization'= "Bearer $Auth64Encoded"}
    Invoke-RestMethod -Uri "http://localhost:8088/admin/editTriggers.html?id=buildType:GitHubTestRepo_Build"  -Method POST -Headers @{'Authorization'= "Bearer $Auth64Encoded"}
}

# http://localhost:8111/httpAuth/action.html?add2Queue=GitHubTestRepo_Build
# http://localhost:8088/httpAuth//login.html
# http://localhost:8088/viewType.html?buildTypeId=GitHubTestRepo_Build
# curl -X GET -H "Accept: application/json" -H "Authorization: Bearer eyJ0eXAiOiAiVENWMiJ9.VGljaUlZLXpfamlyVmZKZXBRZFZacEIxclRN.NGRjOTM4NDgtZjc0NC00NzZiLTg5ZjktMTQ3ZGNkN2MwOThk" http://localhost:8088/app/rest/server

#http://localhost:8088/admin/action.html?add2Queue=GitHubTestRepo_Build

# http://localhost:8088/admin/editTriggers.html?id=buildType:GitHubTestRepo_Build