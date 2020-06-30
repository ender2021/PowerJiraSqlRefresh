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
        $tableName = "tbl_stg_Jira_Issue_All_Id"
        
        #results arrays
        $allIssueIds = @()
        $fatalError = $false

        #looping variables
        $startAt = 0
        $lastPageReached = $false

        $sqlConnSplat = @{
            DatabaseServer = $SqlInstance
            DatabaseName = $SqlDatabase
            SchemaName = $SchemaName
        }
    }
    
    process {
        Write-Verbose "Getting all Issue Ids using JQL $Jql"
        do {
            #get results
            Write-Verbose ("Getting Issue results $startAt to " + [string]($startAt + 100))
            try {
                $result = Invoke-JiraSearchIssues -Jql $jql -GET -MaxResults 100 -StartAt $startAt -Fields "id" -ErrorAction "Stop"

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
            } catch [System.Exception] {
                #don't terminate the powershell process, but don't proceed with the delete synchronization
                Write-Error "Fatal Error: deleted issue synchronization will not complete."
                $fatalError = $true
                $lastPageReached = $true
            }

            #keep going unless we've hit the last page of results
        } while (!$lastPageReached)
    }
    
    end {
        if (!$fatalError) {
            $toWrite = $allIssueIds | ForEach-Object { [pscustomobject]@{ Issue_Id = [int]$_ } }
            Write-AtlassianData @sqlConnSplat -Data $toWrite -TableName $tableName
            return $true
        } else {
            Write-Verbose "Skipping delete synchronization step"
            return $false
        }
    }
}