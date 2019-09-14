#import modules
Import-Module PowerJira
Import-Module SqlServer

#import the variable $JiraCredentials
Import-Module (Join-Path -Path $PSScriptRoot -ChildPath \credentials\Credentials.psm1) -Force

#configure the script targets
$sqlInstance = "localhost"
$sqlDatabase = "Jira"
$schemaName = "dbo"
$projectKeys = @("GROPGDIS","GDISPROJ","GDISTRAIN","GRPRIAREP","GRPRIAWEB","SFSDEVOPS","GFO","GSIS")

####################################################
#  BEGIN THE REFRESH BATCH                         #
####################################################

Write-Verbose "Beginning batch..."
$lastRefresh = Invoke-SqlCmd -ServerInstance $sqlInstance -Database $sqlDatabase -Query "EXEC dbo.usp_Jira_Get_Max_Refresh"
$lastRefreshStamp = $lastRefresh.Refresh_Start_Unix
$lastRefreshDate = $lastRefresh.Refresh_Start

@(
    [PSCustomObject]@{
        Refresh_Id = ''
        Refresh_Start = [datetime](Get-Date)
        Refresh_Start_Unix = [int][double]::Parse((Get-Date -UFormat %s))
    }
) | Write-SqlTableData -ServerInstance $sqlInstance -DatabaseName $sqlDatabase -SchemaName "dbo" -TableName "tbl_Jira_Refresh"

$thisRefresh = Invoke-SqlCmd -ServerInstance $sqlInstance -Database $sqlDatabase -Query "EXEC dbo.usp_Jira_Get_Max_Refresh"
$refreshId = $thisRefresh.Refresh_Id

Invoke-SqlCmd -ServerInstance $sqlInstance -Database $sqlDatabase -Query "EXEC dbo.usp_Jira_Staging_Clear"

####################################################
#  OPEN JIRA SESSION                               #
####################################################

Open-JiraSession -UserName $JiraCredentials.UserName -Password $JiraCredentials.ApiToken -HostName $JiraCredentials.HostName

####################################################
#  REFRESH STEPS                                   #
####################################################

Write-Verbose "Staging worklogs..."
. .\Jira-Worklogs.ps1

Write-Verbose "Staging project categories..."
. .\Jira-ProjectCategories.ps1

Write-Verbose "Staging projects..."
. .\Jira-Projects.ps1

Write-Verbose "Staging components..."
. .\Jira-Components.ps1

Write-Verbose "Staging versions..."
. .\Jira-Versions.ps1

Write-Verbose "Staging issues..."
. .\Jira-Issues.ps1

####################################################
#  CLOSE JIRA SESSION                              #
####################################################

Close-JiraSession

####################################################
#  SYNC STAGING TO LIVE TABLES                     #
####################################################

Write-Verbose "Synchronizing staging..."
Invoke-SqlCmd -ServerInstance $sqlInstance -Database $sqlDatabase -Query "EXEC dbo.usp_Jira_Staging_Synchronize"

####################################################
#  RECORD BATCH END                                #
####################################################

$sql = Invoke-SqlCmd -ServerInstance $sqlInstance -Database $sqlDatabase -Query "EXEC dbo.usp_Jira_Update_Refresh_End $refreshId"
Write-Verbose "Batch completed!"