function Read-JiraPriority {
    [CmdletBinding()]
    param (
        # Priority object
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
            Priority_Id = $Data.id
            Name = $Data.name
            Description = $Data.description
            Icon_Url = $Data.iconUrl
            Status_Color = $Data.statusColor
            Refresh_Id = $RefreshId
        }
    }
    
    end {
    }
}