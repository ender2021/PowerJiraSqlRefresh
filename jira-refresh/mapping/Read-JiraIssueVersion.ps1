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
            Version_Id = $VersionId
            Issue_Id = $IssueId
            Refresh_Id = $RefreshId
        }
    }
    
    end {
    }
}