function Read-JiraIssueVersion {
    [CmdletBinding()]
    param (
        # Version 
        [Parameter(Mandatory,Position=0,ValueFromPipeline)]
        [int]
        $VersionId,

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
            Version_Id = $VersionId
            Refresh_Id = $RefreshId
        }
    }
    
    end {
    }
}