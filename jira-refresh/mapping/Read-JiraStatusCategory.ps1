function Read-JiraStatusCategory {
    [CmdletBinding()]
    param (
        # Status category object
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
            Status_Category_Id = $Data.id
            Name = $Data.name
            Key = $Data.key
            Color_Name = $Data.colorName
            Refresh_Id = $RefreshId
        }
    }
    
    end {
    }
}