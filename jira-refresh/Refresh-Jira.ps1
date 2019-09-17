#import modules
Import-Module PowerJira
Import-Module SqlServer

#import the variable $JiraCredentials
Import-Module (Join-Path -Path $PSScriptRoot -ChildPath \credentials\Credentials.psm1) -Force

#import mapping functions
Get-ChildItem -Path .\mapping -Filter *.ps1 |ForEach-Object {
    . $_.FullName
}

#import the step functions
Get-ChildItem -Path .\steps -Filter *.ps1 |ForEach-Object {
    . $_.FullName
}

#configure the script targets
$sqlInstance = "localhost"
$sqlDatabase = "Jira"
#$projectKeys = @("GROPGDIS","GDISPROJ","GDISTRAIN","GRPRIAREP","GRPRIAWEB","SFSDEVOPS","GFO","GSIS")
$projectKeys = @("GROPGDIS")

####################################################
#  GET PREVIOUS BATCH INFO                         #
####################################################

Write-Verbose "Reading previous batch info..."
$lastRefresh = Get-LastJiraRefresh $sqlInstance $sqlDatabase
$lastRefreshStamp = $lastRefresh.Refresh_Start_Unix
$lastRefreshDate = $lastRefresh.Refresh_Start

####################################################
#  BEGIN THE REFRESH BATCH                         #
####################################################

Write-Verbose "Beginning batch..."
Clear-JiraStaging $sqlInstance $sqlDatabase
$refreshId = Start-JiraRefresh $sqlInstance $sqlDatabase

####################################################
#  OPEN JIRA SESSION                               #
####################################################

Open-JiraSession -UserName $JiraCredentials.UserName -Password $JiraCredentials.ApiToken -HostName $JiraCredentials.HostName

####################################################
#  REFRESH STEPS                                   #
####################################################

Write-Verbose "Beginning data staging..."

Update-JiraWorklogs -LastRefreshUnix $lastRefreshStamp -RefreshId $refreshId -SqlInstance $sqlInstance -SqlDatabase $sqlDatabase
Remove-JiraWorklogs -LastRefreshUnix $lastRefreshStamp -SqlInstance $sqlInstance -SqlDatabase $sqlDatabase

Update-JiraProjectCategories -RefreshId $refreshId -SqlInstance $sqlInstance -SqlDatabase $sqlDatabase

Update-JiraStatusCategories -RefreshId $refreshId -SqlInstance $sqlInstance -SqlDatabase $sqlDatabase

Update-JiraStatuses -RefreshId $refreshId -SqlInstance $sqlInstance -SqlDatabase $sqlDatabase

$projectKeys | Update-JiraProjects -RefreshId $refreshId -SqlInstance $sqlInstance -SqlDatabase $sqlDatabase

$projectKeys | Update-JiraVersions -RefreshId $refreshId -SqlInstance $sqlInstance -SqlDatabase $sqlDatabase

$projectKeys | Update-JiraComponents -RefreshId $refreshId -SqlInstance $sqlInstance -SqlDatabase $sqlDatabase

$updatedDate = Get-Date $lastRefreshDate -format "yyyy-MM-dd HH:mm"
$jql = "Project in (" + ($projectKeys -join ",") + ") AND updatedDate >= '$updatedDate'"
Update-JiraIssues -Jql $jql -RefreshId $refreshId -SqlInstance $sqlInstance -SqlDatabase $sqlDatabase

####################################################
#  CLOSE JIRA SESSION                              #
####################################################

Close-JiraSession

####################################################
#  SYNC STAGING TO LIVE TABLES                     #
####################################################

Write-Verbose "Synchronizing staging to live tables..."
Sync-JiraStaging $sqlInstance $sqlDatabase

####################################################
#  RECORD BATCH END                                #
####################################################

Write-Verbose "Recording batch end..."
Stop-JiraRefresh $refreshId $sqlInstance $sqlDatabase

Write-Verbose "Batch completed!"