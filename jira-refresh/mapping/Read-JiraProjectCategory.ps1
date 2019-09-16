function Read-JiraProjectCategory {
    [CmdletBinding()]
    param (
        # Project category object
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
            Project_Category_Id = $Data.id
            Name = $Data.name
            Description = $Data.description
            Refresh_Id = $RefreshId
        }
    }
    
    end {
    }
}