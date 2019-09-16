function Read-JiraIssueSprint {
    [CmdletBinding()]
    param (
        # SprintId
        [Parameter(Mandatory,Position=0,ValueFromPipeline)]
        [int]
        $SprintId,

        # Issue
        [Parameter(Mandatory,Position=1)]
        [int]
        $IssueId,

        # Refresh ID
        [Parameter(Mandatory,Position=2)]
        [int]
        $RefreshId
    )
    
    begin {
    }
    
    process {
        [PSCustomObject]@{
            Sprint_Id = $SprintId
            Issue_Id = $IssueId
            Refresh_Id = $RefreshId
        }
    }
    
    end {
    }
}