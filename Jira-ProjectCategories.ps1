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
(Invoke-JiraGetAllProjectCategories) | ForEach-Object {
    [PSCustomObject]@{
        Project_Category_Id = $_.id
        Name = $_.name
        Description = $_.description
        Refresh_Id = $refreshId
    }
} | Write-SqlTableData -ServerInstance $sqlInstance -DatabaseName $sqlDatabase -SchemaName $schemaName -TableName "tbl_stg_Jira_Project_Category"