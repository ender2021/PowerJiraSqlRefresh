function Read-JiraIssueLabel {
    [CmdletBinding()]
    param (
        # SprintId
        [Parameter(Mandatory,Position=0,ValueFromPipeline)]
        [string]
        $Label,

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
            Label = $Label
            Issue_Id = $IssueId
            Refresh_Id = $RefreshId
        }
    }
    
    end {
    }
}