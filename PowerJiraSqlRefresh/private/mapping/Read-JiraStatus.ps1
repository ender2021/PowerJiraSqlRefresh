function Read-JiraStatus {
    [CmdletBinding()]
    param (
        # Status object
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
            Status_Id = $Data.id
            Status_Catgory_Id = $Data.statusCategory.id
            Name = $Data.name
            Description = $Data.description
            Icon_Url = $Data.iconUrl
            Refresh_Id = $RefreshId
        }
    }
    
    end {
    }
}