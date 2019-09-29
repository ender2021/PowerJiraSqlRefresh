function Read-JiraWorklog {
    [CmdletBinding()]
    param (
        # Worklog object
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
            Worklog_Id = $Data.id
            Issue_Id = $Data.issueId
            Time_Spent = $Data.timeSpent
            Time_Spent_Seconds = $Data.timeSpentSeconds
            Start_Date = [datetime]$Data.started
            Create_Date = [datetime]$Data.created
            Update_Date = [datetime]$Data.updated
            Create_User_Id = if($Data.author -and $Data.author.accountId) {$Data.author.accountId} else {''}
            Create_User_Name = if($Data.author -and $Data.author.displayName) {$Data.author.displayName} else {''}
            Update_User_Id = if($Data.updateAuthor -and $Data.updateAuthor.accountId) {$Data.updateAuthor.accountId} else {''}
            Update_User_Name = if($Data.updateAuthor -and $Data.updateAuthor.displayName) {$Data.updateAuthor.displayName} else {''}
            Comment = $Data.comment
            Refresh_Id = $RefreshId
        }
    }
    
    end {
    }
}