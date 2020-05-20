function Read-JiraDeployment {
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
            Display_Name = $Data.displayName
            Deployment_Url = $Data.url
            State = $Data.state
            Last_Updated = $Data.lastUpdated
            Pipeline_Id = $Data.pipelineId
            Pipeline_Display_Name = $Data.pipelineDisplayName
            Pipeline_Url = $Data.pipelineUrl
            Environment_Id = $Data.environment.id
            Refresh_Id = $RefreshId
        }
    }
    
    end {
    }
}