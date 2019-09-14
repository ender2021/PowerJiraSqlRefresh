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
#  UPDATE COMPONENTS                               #
####################################################

foreach ($key in $projectKeys) {
    (Invoke-JiraGetProjectComponents $key) | ForEach-Object {
        [PSCustomObject]@{
            Component_Id = [int]$_.id
            Project_Key = $_.project
            Project_Id = [int]$_.projectId
            Name = $_.name
            Description = $_.description
            Lead_User_Id = if ($_.lead -and $_.lead.accountId) {$_.lead.accountId} else {$null}
            Lead_User_Name = if ($_.lead -and $_.lead.displayName) {$_.lead.displayName} else {$null}
            Assignee_Type = $_.assigneeType
            realAssigneeType = $_.realAssigneeType
            Assignee_Type_Valid = [boolean]$_.isAssigneeTypeValid
            Refresh_Id = $refreshId
        }
    } | Write-SqlTableData -ServerInstance $sqlInstance -DatabaseName $sqlDatabase -SchemaName $schemaName -TableName "tbl_stg_Jira_Component"
}