function Update-JiraDeletedIssues {
    [CmdletBinding()]
    param (
        # The JQL to use when retrieving issues
        [Parameter(Mandatory,Position=0)]
        [string]
        $Jql,

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
        Write-Verbose "Performing deleted Issue check"
        $table = "tbl_stg_Jira_Issue_All_Id"
        
        #results arrays
        $allIssueIds = @()

        #looping variables
        $startAt = 0
        $lastPageReached = $false
    }
    
    process {
        Write-Verbose "Getting all Issue Ids using JQL $Jql"
        do {
            #get results
            Write-Verbose ("Getting Issue results $startAt to " + [string]($startAt + 100))
            $result = Invoke-JiraSearchIssues -Jql $jql -GET -MaxResults 100 -StartAt $startAt -Fields "id"

            #if there were results, process them
            if ($result.issues.Count -ne 0) {
                $allIssueIds += $result.issues | Where-Object { $allIssueIds -notcontains $_.id } | ForEach-Object { [int]$_.id }
            } else {
                $lastPageReached = $true
            }
        
            #iterate the start counter
            $startAt += $result.issues.Count

            #check to see if we're at the end
            if ($allIssueIds.Count -ge $result.total) {
                $lastPageReached = $true
            }

            #keep going unless we've hit the last page of results
        } while (!$lastPageReached)
    }
    
    end {
        Write-Verbose "Writing all Issue Ids to staging table"
        $allIssueIds | ForEach-Object { [pscustomobject]@{ Issue_Id = [int]$_ } } | Write-SqlTableData -ServerInstance $SqlInstance -DatabaseName $SqlDatabase -SchemaName $SchemaName -TableName $table -Force
    }
}