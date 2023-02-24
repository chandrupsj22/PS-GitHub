$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = "C:\Users\chand\OneDrive\Documents\WindowsPowerShell\Modules\PS-GitHub"
$watcher.Filter = "*.ps1"
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

$action = {
    $headers = @{
        "Authorization" = "Bearer eyJ0eXAiOiAiVENWMiJ9.VGljaUlZLXpfamlyVmZKZXBRZFZacEIxclRN.NGRjOTM4NDgtZjc0NC00NzZiLTg5ZjktMTQ3ZGNkN2MwOThk"
        "Content-Type" = "application/xml"
    }
    $url = "http://localhost:8088/httpAuth/app/rest/buildQueue"
    $body = "<build><buildType id='GitHubTestRepo_Build'/></build>"
    Invoke-RestMethod -Uri $url -Method POST -Headers $headers -Body $body
}

$onChange = Register-ObjectEvent $watcher "Changed" -Action $action
while ($true) { Start-Sleep -Seconds 1 }
#end
