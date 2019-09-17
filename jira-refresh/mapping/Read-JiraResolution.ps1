function Read-JiraResolution {
    [CmdletBinding()]
    param (
        # Resolution object
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
            Resolution_Id = $Data.id
            Name = $Data.name
            Description = $Data.description
            Refresh_Id = $RefreshId
        }
    }
    
    end {
    }
}