function Read-JiraIssue {
    [CmdletBinding()]
    param (
        # Issue object
        [Parameter(Mandatory,Position=0,ValueFromPipeline)]
        [pscustomobject]
        $Data,

        # Refresh ID
        [Parameter(Mandatory,Position=1)]
        [int]
        $RefreshId
    )
    
    begin {
    }
    
    process {
        [PSCustomObject]@{
            Issue_Id = $Data.id
            Issue_Key = $Data.key
            Issue_Type_Id = $Data.fields.issueType.id
            Project_Id = $Data.fields.project.id
            Project_Key = $Data.fields.project.key
            Time_Spent = $Data.fields.timespent
            Aggregate_Time_Spent = $Data.fields.aggregateTimeSpent
            Resolution_Date = $Data.fields.resolutionDate
            Work_Ratio = $null #$Data.fields.workRatio
            Created_Date = $Data.fields.created
            Time_Estimate = $Data.fields.timeEstimate
            Aggregate_Time_Original_Estimate = $Data.fields.aggregateTimeOriginalEstimate
            Updated_Date = $Data.fields.updated
            Time_Original_Estimate = $Data.fields.timeOriginalEstimate
            Description = $Data.fields.description
            Aggregate_Time_Estimate = $Data.fields.aggregateTimeEstimate
            Summary = $Data.fields.summary
            Due_Date = $Data.fields.dueDate
            Flagged = if($Data.fields.customfield_10302) {$true} else {$false}
            External_Reporter_Name = $Data.fields.customfield_10303
            External_Reporter_Email = $Data.fields.customfield_10304
            External_Reporter_Department = $Data.fields.customfield_10305
            Desired_Date = $Data.fields.customfield_10349
            Chart_Date_Of_First_Response = $Data.fields.customfield_10100
            Start_Date = $Data.fields.customfield_10332
            Story_Points = $Data.fields.customfield_10129
            Epic_Key = $Data.fields.customfield_10123
            Resolution_Id = if ($Data.fields.resolution) { $Data.fields.resolution.id } else { $null }
            Priority_Id = $Data.fields.priority.id
            Assignee_User_Id = if ($Data.fields.assignee) {$Data.fields.assignee.accountId} else { $null }
            Assignee_User_Name = if ($Data.fields.assignee) {$Data.fields.assignee.displayName} else { $null }
            Status_Id = $Data.fields.status.id
            Creator_User_Id = if ($Data.fields.creator) {$Data.fields.creator.accountId} else { $null }
            Creator_User_Name = if ($Data.fields.creator) {$Data.fields.creator.displayName} else { $null }
            Reporter_User_Id = if ($Data.fields.reporter) {$Data.fields.reporter.accountId} else { $null }
            Reporter_User_Name = if ($Data.fields.reporter) {$Data.fields.reporter.displayName} else { $null }
            Votes = $Datafields.votes.votes
            Parent_Id = if ($Data.fields.parent) {$Data.fields.parent.id} else {$null}
            Parent_Key = if ($Data.fields.parent) {$Data.fields.parent.key} else {$null}
            Epic_Name = if ($Data.fields.customfield_10125) {$Data.fields.customfield_10125} else {$null}
            Refresh_Id = $RefreshId
        }
    }
    
    end {
    }
}