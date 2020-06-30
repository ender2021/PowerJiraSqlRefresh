function Update-JiraIssues {
    [CmdletBinding()]
    param (
        # The JQL to use when retrieving issues to update
        [Parameter(Mandatory,Position=0)]
        [string]
        $Jql,

        # Keys of projects to be obfuscated
        [Parameter(Position=1)]
        [string[]]
        $Obfuscate,

        # The ID value of the refresh underway
        [Parameter(Mandatory,Position=2)]
        [int]
        $RefreshId,

        # The sql instance to update data in
        [Parameter(Mandatory,Position=3)]
        [string]
        $SqlInstance,

        # The sql database to update data in
        [Parameter(Mandatory,Position=4)]
        [string]
        $SqlDatabase,

        # The schema to use when updating data
        [Parameter(Position=5)]
        [string]
        $SchemaName="dbo",

        # Synchronization options to override the defaults
        [Parameter()]
        [hashtable]
        $SyncOptions
    )
    
    begin {
        Write-Verbose "Updating Issues"
        $issueTable = "tbl_stg_Jira_Issue"
        $sprintTable = "tbl_stg_Jira_Sprint"
        $changelogTable = "tbl_stg_Jira_Changelog"
        $issueTypeTable = "tbl_stg_Jira_Issue_Type"
        $issueSprintTable = "tbl_stg_Jira_Issue_Sprint"
        $issueComponentTable = "tbl_stg_Jira_Issue_Component"
        $issueFixVersionTable = "tbl_stg_Jira_Issue_Fix_Version"
        $issueLabelTable = "tbl_stg_Jira_Issue_Label"
        $issueLinkTable = "tbl_stg_Jira_Issue_Link"
        
        #results arrays
        $allChangelogs = @()
        $allIssues = @()
        $allIssueTypes = @()
        $allSprints = @()

        # arrays to hold one to many relationship information
        $issueSprints = @()
        $issueComponents = @()
        $issueFixVersions = @()
        $issueLabels = @()
        $issueLinks = @()

        #looping variables
        $startAt = 0
        $lastPageReached = $false

        #options
        $syncChangelogs = $null -ne $SyncOptions -and $SyncOptions.ContainsKey("Changelogs") -and $SyncOptions.Changelogs -ne $false
    
        $sqlConnSplat = @{
            DatabaseServer = $SqlInstance
            DatabaseName = $SqlDatabase
            SchemaName = $SchemaName
        }
    }
    
    process {
        Write-Verbose "Getting Issues using JQL $Jql"
        if (!$syncChangelogs) { Write-Verbose "Skipping Changelogs" }
        do {
            #keep current list of all Ids
            $idList = $allIssues | ForEach-Object { $_.Issue_Id }

            #get results
            Write-Verbose ("Getting Issue results $startAt to " + [string]($startAt + 100))
            $searchParams = @{
                Jql = $jql
                GET = $true
                MaxResults = 100
                StartAt = $startAt
            }
            if ($syncChangelogs) { $searchParams.Add("Expand","changelog") }
            $result = Invoke-JiraSearchIssues @searchParams

            #if there were results, process them
            if ($result.issues.Count -ne 0) {
                #parse issue results into objects (and grab other objects along the way)
                $allIssues += $result.issues | Where-Object { $idList -notcontains $_.id } | ForEach-Object {
                    #capture convenience variables
                    $issue = $_
                    $issueId = $issue.id
                    $fields = $issue.fields
                    $issueProjectKey = $fields.project.key

                    # create and keep issue component mappings
                    if ($fields.components -and $fields.components.Count -gt 0) {
                        $issueComponents += $fields.components | ForEach-Object { $_.id } | Read-JiraIssueComponent -IssueId $issueId -RefreshId $refreshId
                    }
        
                    # create and keep issue fix version mappings
                    if ($fields.fixVersions -and $fields.fixVersions.Count -gt 0) {
                        $issueFixVersions += $fields.fixVersions | ForEach-Object { $_.id } | Read-JiraIssueVersion -IssueId $issueId -RefreshId $refreshId
                    }

                    # create and keep issue type information, if we don't have it already
                    if (($allIssueTypes | ForEach-Object { $_.Issue_Type_Id }) -notcontains $fields.issueType.id) {
                        $allIssueTypes += Read-JiraIssueType -Data $fields.issueType -RefreshId $refreshId
                    }

                    # capture label data
                    if ($fields.labels -and $fields.labels.Count -gt 0) {
                        $issueLabels += $fields.labels | Read-JiraIssueLabel -IssueId $issueId -RefreshId $refreshId
                    }

                    #capture issue link data
                    if ($fields.issueLinks -and $fields.issueLinks.Count -gt 0) {
                        #get a list of parsed relationships
                        $tempLinks = $fields.issueLinks | Read-JiraIssueLink -IssueId $issueId -IssueKey $issue.key -RefreshId $refreshId

                        #loop through the list we parsed and check to make sure we don't already have it from the other issue in the link
                        #if we don't, added it to the master list
                        foreach($link in $tempLinks) {
                            $count = ($issueLinks | Where-Object {
                                        ($_.Out_Issue_Id -eq $link.Out_Issue_Id) -and
                                        ($_.In_Issue_Id -eq $link.In_Issue_Id) -and
                                        ($_.Link_Type_Id -eq $link.Link_Type_Id)
                                     }).Length
                            if ($count -eq 0) { $issueLinks += $link }
                        }
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
                        $issueSprints += $sprintList | ForEach-Object { [int]$_.Sprint_Id } | Read-JiraIssueSprint -IssueId $issueId -RefreshId $refreshId
                    }

                    # capture changelog data
                    if ($syncChangelogs -and $issue.changelog.histories -and $issue.changelog.histories.Count -gt 0) {
                        $allChangelogs += $issue.changelog.histories | Where-Object { $_ } | Read-JiraChangelog -IssueId $issueId -RefreshId $RefreshId
                    }

                    # create and return issue object
                    $readSplat = @{
                        Data = $issue
                        RefreshId = $refreshId
                        Obfuscate = $Obfuscate -contains $issueProjectKey
                    }
                    Read-JiraIssue @readSplat
                }
            } else {
                $lastPageReached = $true
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
        Write-AtlassianData @sqlConnSplat -Data $allIssueTypes -TableName $issueTypeTable
        Write-AtlassianData @sqlConnSplat -Data $allSprints -TableName $sprintTable
        Write-AtlassianData @sqlConnSplat -Data $allIssues -TableName $issueTable
        Write-AtlassianData @sqlConnSplat -Data $issueLabels -TableName $issueLabelTable
        Write-AtlassianData @sqlConnSplat -Data $issueLinks -TableName $issueLinkTable
        Write-AtlassianData @sqlConnSplat -Data $issueSprints -TableName $issueSprintTable
        Write-AtlassianData @sqlConnSplat -Data $issueComponents -TableName $issueComponentTable
        Write-AtlassianData @sqlConnSplat -Data $issueFixVersions -TableName $issueFixVersionTable
        if ($syncChangelogs) { Write-AtlassianData @sqlConnSplat -Data $allChangelogs -TableName $changelogTable }
    }
}