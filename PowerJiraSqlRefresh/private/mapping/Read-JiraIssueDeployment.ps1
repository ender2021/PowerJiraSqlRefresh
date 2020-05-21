function Read-JiraIssueDeployment {
    [CmdletBinding()]
    param (
        # Deployment Url
        [Parameter(Mandatory,Position=0,ValueFromPipeline)]
        [string]
        $DeploymentUrl,

        # Issue
        [Parameter(Mandatory,Position=1)]
        [int]
        $IssueId,

        # Refresh ID
        [Parameter(Mandatory,Position=2)]
        [int]
        $RefreshId
    )
    
    begin {
    }
    
    process {
        [PSCustomObject]@{
            Issue_Id = $IssueId
            Deployment_Url = $DeploymentUrl
            Refresh_Id = $RefreshId
        }
    }
    
    end {
    }
}