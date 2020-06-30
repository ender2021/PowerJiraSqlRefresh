function Remove-JiraWorklogs {
    [CmdletBinding()]
    param (
        # The list of project keys for which to retrieve versions
        [Parameter(Mandatory,Position=0)]
        [int]
        $LastRefreshUnix,

        # The sql instance to update data in
        [Parameter(Mandatory,Position=1)]
        [string]
        $SqlInstance,

        # The sql database to update data in
        [Parameter(Mandatory,Position=2)]
        [string]
        $SqlDatabase,

        # The schema to use when updating data
        [Parameter(Position=3)]
        [string]
        $SchemaName="dbo"
    )
    
    begin {
        Write-Verbose "Getting deleted Worklogs"
        $tableName = "tbl_stg_Jira_Worklog_Delete"

        # the jira api adds an extra three digits to the unix timestamp for thousandths of a second
        # have to multiply our real unix timestamp by 1000 to add those digits for Jira
        $since = $LastRefreshUnix * 1000

        #setup for looping
        $idList = @()
        $lastPageReached = $false

        $sqlConnSplat = @{
            DatabaseServer = $SqlInstance
            DatabaseName = $SqlDatabase
            SchemaName = $SchemaName
        }
    }
    
    process {
        do {
            Write-Verbose "Getting Worklogs deleted since $since"
            #get a set of results
            $result = Invoke-JiraGetDeletedWorklogIds -StartUnixStamp $since

            #process the results, if there were more than zero
            if ($result.values.Count -ne 0) {
                #get the set of ids from the results, remove any that we've already retrieved in this batch, and add this set to the full list
                $ids = $result.values | ForEach-Object { [int]$_.worklogId } | Where-Object { $idList -notcontains $_ }
                $idList += $ids
            }

            #set the stamp for the potential next call
            $since = $result.until

            #check if we've reached the last page
            if ($result.lastPage) {
                $lastPageReached = $true
            }

            #keep going unless we've reached the end of the results
        } while (!$lastPageReached)
    }
    
    end {
        $toWrite = $idList | ForEach-Object { [PSCustomObject]@{ Worklog_Id = [int]$_ } }
        Write-AtlassianData @sqlConnSplat -Data $toWrite -TableName $tableName
    }
}