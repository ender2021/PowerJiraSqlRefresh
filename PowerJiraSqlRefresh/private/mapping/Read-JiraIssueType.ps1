function Read-JiraIssueType {
    [CmdletBinding()]
    param (
        # Issue type object
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
            Issue_Type_Id = $Data.id
            Name = $Data.name
            Description = $Data.description
            Icon_Url = $Data.iconUrl
            Subtask_Type = [boolean]$Data.subtask
            Refresh_Id = $RefreshId
        }
    }
    
    end {
    }
}