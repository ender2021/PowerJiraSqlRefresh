function Update-JiraWorklogs {
    [CmdletBinding()]
    param (
        # The list of project keys for which to retrieve versions
        [Parameter(Mandatory,Position=0)]
        [int]
        $LastRefreshUnix,

        # The ID value of the refresh underway
        [Parameter(Mandatory,Position=1)]
        [int]
        $RefreshId,

        # The sql instance to update data in
        [Parameter(Mandatory,Position=2)]
        [string]
        $SqlInstance,

        # The sql database to update data in
        [Parameter(Mandatory,Position=3)]
        [string]
        $SqlDatabase,

        # The schema to use when updating data
        [Parameter(Position=4)]
        [string]
        $SchemaName="dbo"
    )
    
    begin {
        Write-Verbose "Begin Jira Worklog Update"
        $tableName = "tbl_stg_Jira_Worklog"

        # the jira api adds an extra three digits to the unix timestamp for thousandths of a second
        # have to multiply our real unix timestamp by 1000 to add those digits for Jira
        $since = $LastRefreshUnix * 1000

        #setup for looping
        $idList = @()
        $logs = @()
        $lastPageReached = $false
    }
    
    process {
        do {
            Write-Verbose "Getting Jira Worklogs updated since $since"
            #get a set of results
            $result = Invoke-JiraGetUpdatedWorklogIds -StartUnixStamp $since

            #process the results, if there were more than zero
            if ($result.values.Count -ne 0) {
                #get the set of ids from the results, remove any that we've already retrieved in this batch, and add this set to the full list
                $ids = $result.values | ForEach-Object { $_.worklogId } | Where-Object { $idList -notcontains $_ }
                $idList += $ids

                #get the worklog data, transform it into objects, and keep them
                $logsRaw = Invoke-JiraGetWorklogsById $ids
                $logs +=  $logsRaw | Read-JiraWorklog -RefreshId $RefreshId
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
        Write-Verbose "Writing Jira Worklogs to staging table"
        $logs | Write-SqlTableData -ServerInstance $SqlInstance -DatabaseName $SqlDatabase -SchemaName $SchemaName -TableName $tableName
        Write-Verbose "End Jira Worklogs Update"
    }
}