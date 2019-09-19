function Read-JiraIssueLink {
    [CmdletBinding()]
    param (
        # issue link object
        [Parameter(Mandatory,Position=0,ValueFromPipeline)]
        [pscustomobject]
        $Data,

        # the issue with the link
        [Parameter(Mandatory, Position=1)]
        [int]
        $IssueId,

        # the issue with the link
        [Parameter(Mandatory, Position=2)]
        [string]
        $IssueKey,

        # Refresh ID
        [Parameter(Mandatory,Position=3)]
        [int]
        $RefreshId
    )
    
    begin {
        
    }
    
    process {
        if ($Data.inwardIssue) {
            $inid = $Data.inwardIssue.id
            $inKey = $Data.inwardIssue.key
            $outId = $IssueId
            $outKey = $IssueKey
        } elseif ($Data.outwardIssue) {
            $outId = $Data.outwardIssue.id
            $outKey = $Data.outwardIssue.key
            $inId = $IssueId
            $inKey = $IssueKey
        } else {
            throw "Malformed issue link $Data"
        }

        [PSCustomObject]@{
            Issue_Link_Id = $Data.id
            Link_Type_Id = $Data.type.id
            In_Issue_Id = $inId
            In_Issue_Key = $inKey
            Out_Issue_Id = $outId
            Out_Issue_Key = $outKey
            Refresh_Id = $RefreshId
        }
    }
    
    end {
    }
}