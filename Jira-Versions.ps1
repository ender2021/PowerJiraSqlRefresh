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
#  UPDATE VERSIONS                                 #
####################################################

foreach ($key in $projectKeys) {
    (Invoke-JiraGetProjectVersions $key) | ForEach-Object {
        [PSCustomObject]@{
            Version_Id = [int]$_.id
            Project_Id = [int]$_.projectId
            Name = $_.name
            Archived = [boolean]$_.archived
            Released = [boolean]$_.released
            Start_Date = if ($_.startDate) {[datetime]$_.startDate} else {$null}
            Release_Date = if ($_.releaseDate) {[datetime]$_.releaseDate} else {$null}
            User_Start_Date = if ($_.userStartDate) {[datetime]$_.userStartDate} else {$null}
            User_Release_Date = if ($_.userReleaseDate) {[datetime]$_.userReleaseDate} else {$null}
            Refresh_Id = $refreshId
        }
    } | Write-SqlTableData -ServerInstance $sqlInstance -DatabaseName $sqlDatabase -SchemaName $schemaName -TableName "tbl_Jira_Version"
}