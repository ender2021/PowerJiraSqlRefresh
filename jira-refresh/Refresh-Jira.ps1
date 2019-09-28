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

####################################################
#  CONFIGURATION                                   #
####################################################

#configure the database targets
$sqlSplat = @{
    SqlInstance = "localhost"
    SqlDatabase = "Jira"
}

#configure what type of refresh to do (F = Full, D = Differential)
$RefreshTypes = @{
    Full = "F"
    Differential = "D"
}
$refreshType = $RefreshTypes.Differential

#configuration of the projects to pull
$getAll = $true
$projectKeys = if($getAll) {
    $null
} else {
    @("GROPGDIS","GDISPROJ","GDISTRAIN","GRPRIAREP","GRPRIAWEB","SFSDEVOPS","GFO","GSIS","GSPP","GSISPLAN")
}

####################################################
#  GET PREVIOUS BATCH INFO / CLEAR PREVIOUS BATCH  #
####################################################

if ($refreshType -eq $RefreshTypes.Full) {
    Write-Verbose "Clearing database..."
    Clear-JiraRefresh @sqlSplat
    $lastRefreshStamp = 0
    $lastRefreshDate = (Get-Date '1970-01-01')
} else {
    Write-Verbose "Reading previous batch info..."
    $lastRefresh = Get-LastJiraRefresh @sqlSplat
    $lastRefreshStamp = $lastRefresh.Refresh_Start_Unix
    $lastRefreshDate = $lastRefresh.Refresh_Start
}

####################################################
#  BEGIN THE REFRESH BATCH                         #
####################################################

Write-Verbose "Beginning batch..."
Clear-JiraStaging @sqlSplat
$refreshId = Start-JiraRefresh -RefreshType $refreshType @sqlSplat

####################################################
#  OPEN JIRA SESSION                               #
####################################################

Open-JiraSession -UserName $JiraCredentials.UserName -Password $JiraCredentials.ApiToken -HostName $JiraCredentials.HostName

####################################################
#  REFRESH STEP 0 - CONFIGURE                      #
####################################################

Write-Verbose "Beginning data staging..."

# define a convenient hash for splatting the basic refresh arguments
$refreshSplat = @{
    RefreshId = $refreshId
} + $sqlSplat

####################################################
#  REFRESH STEP 1 - NO CONTEXT DATA                #
####################################################

# these are mostly lookup tables
Update-JiraProjectCategories @refreshSplat
Update-JiraStatusCategories @refreshSplat
Update-JiraStatuses @refreshSplat
Update-JiraResolutions @refreshSplat
Update-JiraPriorities @refreshSplat
Update-JiraIssueLinkTypes @refreshSplat
Update-JiraUsers @refreshSplat

####################################################
#  REFRESH STEP 2 - PROJECTS                       #
####################################################

# update projects, and in the process get a full project key list if necessary
$projectKeys = Update-JiraProjects -ProjectKeys $projectKeys @refreshSplat | ForEach-Object { $_.Project_Key }

####################################################
#  REFRESH STEP 3 - PROJECT TAXONS                 #
####################################################

# next do the updates where the only context is the list of projects
$projectKeys | Update-JiraVersions @refreshSplat
$projectKeys | Update-JiraComponents @refreshSplat

####################################################
#  REFRESH STEP 4 - WORKLOGS                       #
####################################################

# worklogs are refreshed based on the last unix timestamp of a refresh
# need to both update changed / new worklogs, and remove any that have been deleted
Update-JiraWorklogs -LastRefreshUnix $lastRefreshStamp @refreshSplat
Remove-JiraWorklogs -LastRefreshUnix $lastRefreshStamp @sqlSplat

####################################################
#  REFRESH STEP 5 - ISSUES                       #
####################################################

# issues are retrieved using jql crafted from the date of last refresh and optionally a project key list

# first format the date stamp and create the updated date clause
$jqlUpdateDate = (Get-Date $lastRefreshDate -format "yyyy-MM-dd HH:mm")
$updateJql = "updatedDate >= '$jqlUpdateDate'"

# if we're refreshing a specific list of projects, create the clause; otherwise, don't add a project clause
$projectJql = if($getAll) {
    ""
} else {
    " AND Project in (" + ($projectKeys -join ",") + ")"
}

# update issues with the crafted JQL
Update-JiraIssues -Jql ($updateJql + $projectJql) @refreshSplat

#if we're doing a diff refresh, pull down ALL issue IDs for the listed projects, in order to detect deleted issues
if ($refreshType -eq $RefreshTypes.Differential) {
    # use the project list if we're doing a list, otherwise use a "true = true" type clause to get everything
    if ($getAll) {
        Update-JiraDeletedIssues -Jql "project is not EMPTY" @sqlSplat
    } else {
        Update-JiraDeletedIssues -Jql $projectJql @sqlSplat
    }
}

####################################################
#  CLOSE JIRA SESSION                              #
####################################################

Close-JiraSession

####################################################
#  SYNC STAGING TO LIVE TABLES                     #
####################################################

Write-Verbose "Synchronizing staging to live tables..."
Sync-JiraStaging -SyncDeleted ($refreshType -eq $RefreshTypes.Differential) @sqlSplat

####################################################
#  RECORD BATCH END                                #
####################################################

Write-Verbose "Recording batch end..."
Stop-JiraRefresh @refreshSplat

Write-Verbose "Batch completed!"