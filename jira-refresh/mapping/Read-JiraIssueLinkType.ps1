function Read-JiraIssueLinkType {
    [CmdletBinding()]
    param (
        # Issue Link TYpe object
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
            Issue_Link_Type_Id = $Data.id
            Name = $Data.name
            Inward_Label = $Data.inward
            Outward_Label = $Data.outward
            Refresh_Id = $RefreshId
        }
    }
    
    end {
    }
}