####################################################
#  AVAILABLE GLOBAL VARS                           #
####################################################

# $sqlInstance = the connection string for the sql server
# $sqlDatabase = the name of the sql database to store data in
# $schemaName = the schema name to use when accessing the database
# $refreshId = the id of the refresh record currently running
# $lastRefreshStamp = the Unix timestamp of the last refresh date
# $projectKeys = array of project keys for when pulls are based on project

####################################################
#  UPDATE WORKLOGS                                 #
####################################################

# the jira api adds an extra three digits to the unix timestamp for thousandths of a second
# have to multiply our real unix timestamp by 1000 to add those digits for Jira
$since = $lastRefreshStamp * 1000
$idList = @()
do {
    $isNotLast = $false
    $result = Invoke-JiraGetUpdatedWorklogIds -StartUnixStamp $since
    if ($result.values.Count -ne 0) {
        $ids = ($result.values | ForEach-Object { $_.worklogId })
        (Invoke-JiraGetWorklogsById $ids) | ForEach-Object {
            [PSCustomObject]@{
                Worklog_Id = $_.id
                Issue_Id = $_.issueId
                Time_Spent = $_.timeSpent
                Time_Spent_Seconds = $_.timeSpentSeconds
                Start_Date = [datetime]$_.started
                Create_Date = [datetime]$_.created
                Update_Date = [datetime]$_.updated
                Create_User_Id = if($_.author -and $_.author.accountId) {$_.author.accountId} else {''}
                Create_User_Name = if($_.author -and $_.author.displayName) {$_.author.displayName} else {''}
                Update_User_Id = if($_.updateAuthor -and $_.updateAuthor.accountId) {$_.updateAuthor.accountId} else {''}
                Update_User_Name = if($_.updateAuthor -and $_.updateAuthor.displayName) {$_.updateAuthor.displayName} else {''}
                Comment = $_.comment
                Refresh_Id = $refreshId
            }
        } | Where-Object { $idList -notcontains $_.Worklog_Id } | Write-SqlTableData -ServerInstance $sqlInstance -DatabaseName $sqlDatabase -SchemaName $schemaName -TableName "tbl_Jira_Worklogs"

        $idList += $ids
    }

    if (!$result.lastPage) {
        $since = $result.until
        $isNotLast = $true
    }
} while ($isNotLast)