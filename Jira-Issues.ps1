####################################################
#  AVAILABLE GLOBAL VARS                           #
####################################################

# $sqlInstance = the connection string for the sql server
# $sqlDatabase = the name of the sql database to store data in
# $schemaName = the schema name to use when accessing the database
# $refreshId = the id of the refresh record currently running
# $lastRefreshDate = the datetime of the last refresh date
# $lastRefreshStamp = the Unix timestamp of the last refresh date
# $projectKeys = array of project keys for when pulls are based on project

####################################################
#  UPDATE ISSUES                                   #
####################################################

# the jira api adds an extra three digits to the unix timestamp for thousandths of a second
# have to multiply our real unix timestamp by 1000 to add those digits for Jira
$updatedDate = Get-Date $lastRefreshDate -format "yyyy-MM-dd HH:mm"

$jql = "Project in (" + ($projectKeys -join ",") + ") AND updatedDate >= '$updatedDate'"

# arrays to hold one to many relationship information
$issueComponents = @()
$issueFixVersions = @()
$issueSprints = @()

$allSprints = @()
$idList = @()
$startAt = 0
do {
    $isNotLast = $false
    $result = Invoke-JiraSearchIssues -Jql $jql -GET -MaxResults 100 -StartAt $startAt
    if ($result.issues.Count -ne 0) {
        $ids = @()
        $result.issues | ForEach-Object {
            #add issue id to list
            $issueId = $_.id
            $ids += $issueId

            # capture sub-objects if this isn't a repeat issue
            if ($idList -notcontains $issueId) {
                # create and keep issue component mappings
                if ($_.fields.components -and $_.fields.components.Count -gt 0) {
                    $issueComponents += $_.fields.components | ForEach-Object {
                        [PSCustomObject]@{
                            Issue_Id = $issueId
                            Component_Id = $_.id
                            Refresh_Id = $refreshId
                        } 
                    } | Where-Object { $_.Component_Id }
                }

                # create and keep issue fix version mappings
                if ($_.fields.fixVersions -and $_.fields.fixVersions.Count -gt 0) {
                    $issueFixVersions += $_.fields.fixVersions | ForEach-Object {
                        [PSCustomObject]@{
                            Issue_Id = $issueId
                            Version_Id = $_.id
                            Refresh_Id = $refreshId
                        } 
                    } | Where-Object { $_.Version_Id }
                }

                # create and keep sprint information
                $sprints = $_.fields.customfield_10127
                if ($sprints -and $sprints.Count -gt 0) {
                    $issueSprints += $sprints | Where-Object { $_ } | ForEach-Object {
                        #extract the meaningful bit from the string
                        $var = $_ -match '\[(.*)\]'
                        $raw = $Matches[0]

                        #have to take a weird approach to parsing due to the delimiter also being a valid character in the Goal value
                        #sample value: "id=865,rapidViewId=187,state=ACTIVE,name=GSIS Sprint 3,goal=Complete PowerBI Registration reporting, complete a POC for report embedding, develop the outline of the student profile and 1 tab, and begin addressing data service .Net core conversions,startDate=2019-09-04T18:54:32.477Z,endDate=2019-09-14T00:00:00.000Z,completeDate=<null>,sequence=865"
                        $sections = $raw -split '='
                        $data = @()
                        $data += $sections | ForEach-Object {
                            if ($_ -eq "[id") {
                                return ''
                            } elseif ($_.ToString().EndsWith(']')) { 
                                return $_.ToString().Substring(0, $_.ToString().Length - 1)
                            }
                            else { return $_.ToString().Substring(0, $_.ToString().LastIndexOf(',')) }
                        }
                        #load the parsed array into a custom object
                        $sprint = [pscustomobject]@{
                            Sprint_Id = [int]$data[1]
                            Rapid_View_Id = [int]$data[2]
                            State = $data[3]
                            Name = $data[4]
                            Goal = $data[5]
                            Start_Date = [datetime](Get-Date $data[6])
                            End_Date = [datetime](Get-Date $data[7])
                            Complete_Date = if ($data[8] -eq '<null>') { $null } else { [datetime](Get-Date $data[8]) }
                            Sequence = [int]$data[9]
                            Refresh_Id = $refreshId
                        }

                        #if we don't have it in the master sprint list for list load, add it
                        if (($allSprints | ForEach-Object { $_.Sprint_Id }) -notcontains $sprint.Sprint_Id) {
                            $allSprints += $sprint
                        }

                        #return the required issue sprints entries
                        [PSCustomObject]@{
                            Sprint_Id = $sprint.Sprint_Id
                            Issue_Id = $issueId
                            Refresh_Id = $refreshId
                        }
                    }
                }
                
            }
            

            # create and return issue object
            [PSCustomObject]@{
                Issue_Id = $issueId
                Issue_Key = $_.key
                Issue_Type_Id = $_.fields.issueType.id
                Project_Id = $_.fields.project.id
                Project_Key = $_.fields.project.key
                Time_Spent = $_.fields.timespent
                Aggregate_Time_Spent = $_.fields.aggregateTimeSpent
                Resolution_Date = $_.fields.resolutionDate
                Work_Ratio = $_.fields.workRatio
                Created_Date = $_.fields.created
                Time_Estimate = $_.fields.timeEstimate
                Aggregate_Time_Original_Estimate = $_.fields.aggregateTimeOriginalEstimate
                Updated_Date = $_.fields.updated
                Time_Original_Estimate = $_.fields.timeOriginalEstimate
                Description = $_.fields.description
                Aggregate_Time_Estimate = $_.fields.aggregateTimeEstimate
                Summary = $_.fields.summary
                Due_Date = $_.fields.dueDate
                Flagged = if($_.fields.customfield_10302) {$true} else {$false}
                External_Reporter_Name = $_.fields.customfield_10303
                External_Reporter_Email = $_.fields.customfield_10304
                External_Reporter_Department = $_.fields.customfield_10305
                Desired_Date = $_.fields.customfield_10349
                Chart_Date_Of_First_Response = $_.fields.customfield_10100
                Start_Date = $_.fields.customfield_10332
                Story_Points = $_.fields.customfield_10129
                Epic_Key = $_.fields.customfield_10123
                Resolution_Id = if ($_.fields.resolution) { $_.fields.resolution.id } else { $null }
                Priority_Id = $_.fields.priority.id
                Assignee_User_Id = if ($_.fields.assignee) {$_.fields.assignee.accountId} else { $null }
                Assignee_User_Name = if ($_.fields.assignee) {$_.fields.assignee.displayName} else { $null }
                Status_Id = $_.fields.status.id
                Creator_User_Id = if ($_.fields.creator) {$_.fields.creator.accountId} else { $null }
                Creator_User_Name = if ($_.fields.creator) {$_.fields.creator.displayName} else { $null }
                Reporter_User_Id = if ($_.fields.reporter) {$_.fields.reporter.accountId} else { $null }
                Reporter_User_Name = if ($_.fields.reporter) {$_.fields.reporter.displayName} else { $null }
                Votes = $_fields.votes.votes
                Parent_Id = if ($_.fields.parent) {$_.fields.parent.id} else {$null}
                Parent_Key = if ($_.fields.parent) {$_.fields.parent.key} else {$null}
                Refresh_Id = $refreshId
            }
        } | Where-Object { $idList -notcontains $_.Issue_Id } | Write-SqlTableData -ServerInstance $sqlInstance -DatabaseName $sqlDatabase -SchemaName $schemaName -TableName "tbl_Jira_Issue"
        
        $idList += $ids
    }

    if ($idList.Count -ne $result.total) {
        $startAt += $ids.Count
        $isNotLast = $true
    }
} while ($isNotLast)

#write sprints to the database
$allSprints | Write-SqlTableData -ServerInstance $sqlInstance -DatabaseName $sqlDatabase -SchemaName $schemaName -TableName "tbl_Jira_Sprint"

#write issue sprint mappings to the database
$issueSprints | Write-SqlTableData -ServerInstance $sqlInstance -DatabaseName $sqlDatabase -SchemaName $schemaName -TableName "tbl_Jira_Issue_Sprint"

#write issue component mappings to the database
$issueComponents | Write-SqlTableData -ServerInstance $sqlInstance -DatabaseName $sqlDatabase -SchemaName $schemaName -TableName "tbl_Jira_Issue_Component"

#write issue fix version mappings to the database
$issueFixVersions | Write-SqlTableData -ServerInstance $sqlInstance -DatabaseName $sqlDatabase -SchemaName $schemaName -TableName "tbl_Jira_Issue_Fix_Version"
