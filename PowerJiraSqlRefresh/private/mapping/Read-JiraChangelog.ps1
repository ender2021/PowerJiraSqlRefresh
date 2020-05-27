function Read-JiraChangelog {
    [CmdletBinding()]
    param (
        # Deployment object
        [Parameter(Mandatory,Position=0,ValueFromPipeline)]
        [pscustomobject]
        $Data,

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
            Changelog_Id = $Data.id
            Author_User_Id = if ($Data.author) {$Data.author.accountId} else { $null }
            Created_Date = $Data.created
            Changelog_Items = ConvertTo-Json -InputObject $Data.items
            Issue_Id = $IssueId
            Refresh_Id = $RefreshId
        }
    }
    
    end {
    }
}