function Read-JiraIssueComponent {
    [CmdletBinding()]
    param (
        # Component 
        [Parameter(Mandatory,Position=0,ValueFromPipeline)]
        [int]
        $ComponentId,

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
            Issue_Id = $IssueId
            Component_Id = $ComponentId
            Refresh_Id = $RefreshId
        }
    }
    
    end {
    }
}