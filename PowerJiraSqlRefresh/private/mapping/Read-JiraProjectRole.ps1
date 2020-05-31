function Read-JiraProjectRole {
    [CmdletBinding()]
    param (
        # User object
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
            Role_Id = [int]$Data.id
            Name = $Data.name
            Refresh_Id = $RefreshId
        }
    }
    
    end {
    }
}