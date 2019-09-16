function Update-JiraIssues {
    [CmdletBinding()]
    param (
        # The JQL to use when retrieving issues to update
        [Parameter(Mandatory,Position=0)]
        [string]
        $Jql,

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
        Write-Verbose "Begin Jira Issue Update"
        $issueTable = "tbl_stg_Jira_Issue"
        $sprintTable = "tbl_stg_Jira_Sprint"
        $issueSprintTable = "tbl_stg_Jira_Issue_Sprint"
        $issueComponentTable = "tbl_stg_Jira_Issue_Component"
        $issueFixVersionTable = "tbl_stg_Jira_Issue_Fix_Version"
        
        #results arrays
        $allIssues = @()
        $allSprints = @()

        # arrays to hold one to many relationship information
        $issueSprints = @()
        $issueComponents = @()
        $issueFixVersions = @()

        #looping variables
        $startAt = 0
        $lastPageReached = $false
    }
    
    process {
        Write-Verbose "Getting Jira Issues using JQL $Jql"
        do {
            #keep current list of all Ids
            $idList = $allIssues | ForEach-Object { $_.Issue_Id }

            #get results
            Write-Verbose ("Requesting results $startAt to " + [string]($startAt + 100))
            $result = Invoke-JiraSearchIssues -Jql $jql -GET -MaxResults 100 -StartAt $startAt

            #if there were results, process them
            if ($result.issues.Count -ne 0) {
                #parse issue results into objects (and grab other objects along the way)
                $allIssues += $result.issues | Where-Object { $idList -notcontains $_.id } | ForEach-Object {
                    #capture convenience variables
                    $issue = $_
                    $issueId = $issue.id
                    $fields = $issue.fields
                    
                    # create and keep issue component mappings
                    if ($fields.components -and $fields.components.Count -gt 0) {
                        $issueComponents += $fields.components | ForEach-Object { $_.id } | Read-JiraIssueComponent -IssueId $issueId -RefreshId $refreshId
                    }
        
                    # create and keep issue fix version mappings
                    if ($fields.fixVersions -and $fields.fixVersions.Count -gt 0) {
                        $issueFixVersions += $fields.fixVersions | ForEach-Object { $_.id } | Read-JiraIssueVersion -IssueId $issueId -RefreshId $refreshId
                    }
        
                    # create and keep sprint information
                    $sprints = $fields.customfield_10127
                    if ($sprints -and $sprints.Count -gt 0) {
                        #parse sprints
                        $sprintList = $sprints | Where-Object { $_ } | Read-JiraSprint -RefreshId $refreshId
                        
                        #add new ones to the master list
                        $currSprintIds = $allSprints | ForEach-Object { $_.Sprint_Id }
                        $allSprints += $sprintList | Where-Object { $currSprintIds -notcontains $_.Sprint_Id }
        
                        #add to the list of issue sprint mappings
                        $issueSprints += $currSprintIds | Read-JiraIssueSprint -IssueId $issueId -RefreshId $refreshId
                    }
        
                    # create and return issue object
                    Read-JiraIssue -Data $issue -RefreshId $refreshId
                }
            }
        
            #iterate the start counter
            $startAt += $result.issues.Count

            #check to see if we're at the end
            if ($idList.Count -eq $result.total) {
                $lastPageReached = $true
            }

            #keep going unless we've hit the last page of results
        } while (!$lastPageReached)
    }
    
    end {
        Write-Verbose "Writing Jira Issues to staging table"
        $allIssues | Write-SqlTableData -ServerInstance $SqlInstance -DatabaseName $SqlDatabase -SchemaName $SchemaName -TableName $issueTable

        Write-Verbose "Writing Jira Sprints to staging table"
        $allSprints | Write-SqlTableData -ServerInstance $sqlInstance -DatabaseName $sqlDatabase -SchemaName $schemaName -TableName $sprintTable

        Write-Verbose "Writing Jira Issue-Sprint Mappings to staging table"
        $issueSprints | Write-SqlTableData -ServerInstance $sqlInstance -DatabaseName $sqlDatabase -SchemaName $schemaName -TableName $issueSprintTable

        Write-Verbose "Writing Jira Issue-Component Mappings to staging table"
        $issueComponents | Write-SqlTableData -ServerInstance $sqlInstance -DatabaseName $sqlDatabase -SchemaName $schemaName -TableName $issueComponentTable

        Write-Verbose "Writing Jira Issue-Version Mappings to staging table"
        $issueFixVersions | Write-SqlTableData -ServerInstance $sqlInstance -DatabaseName $sqlDatabase -SchemaName $schemaName -TableName $issueFixVersionTable

        Write-Verbose "End Jira Issue Update"
    }
}