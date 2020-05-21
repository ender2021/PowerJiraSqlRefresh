function Read-JiraDeploymentEnvironment {
    [CmdletBinding()]
    param (
        # Deployment object
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
            Environment_Id = $Data.environment.id
            Environment_Type = $Data.environment.type
            Display_Name = $Data.environment.displayName
            Refresh_Id = $RefreshId
        }
    }
    
    end {
    }
}