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
#  UPDATE PROJECTS                                 #
####################################################

foreach ($key in $projectKeys) {
    Invoke-JiraGetProject $key | ForEach-Object {
        [PSCustomObject]@{
            Project_Id = $_.id
            Project_Key = $_.key
            Description = $_.description
            Lead_User_Id = $_.lead.accountId
            Lead_User_Name = $_.lead.displayName
            Category_Id = $_.projectCategory.id
            Project_Type_Key = $_.projectTypeKey
            Simplified = [boolean]$_.simplified
            Style = $_.style
            Private = [boolean]$_.isPrivate
            Refresh_Id = $refreshId
        }
    } | Write-SqlTableData -ServerInstance $sqlInstance -DatabaseName $sqlDatabase -SchemaName $schemaName -TableName "tbl_Jira_Project"
}