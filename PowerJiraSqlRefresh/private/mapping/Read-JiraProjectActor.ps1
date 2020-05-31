function Read-JiraProjectActor {
    [CmdletBinding()]
    param (
        # Version object
        [Parameter(Mandatory,Position=0,ValueFromPipeline)]
        [pscustomobject]
        $Data,

        # Project
        [Parameter(Mandatory,Position=1)]
        [string]
        $ProjectKey,

        # Refresh ID
        [Parameter(Mandatory,Position=2)]
        [int]
        $RefreshId
    )
    
    begin {
        $toReturn = @()
    }
    
    process {
        foreach ($actor in $Data.actors) {
            $toReturn += [PSCustomObject]@{
                Actor_Id = [int]$actor.id
                Project_Key = $ProjectKey
                Role_Id = [int]$Data.id
                Type = $actor.type
                Actor = if ([bool]($actor.PSobject.Properties.name -match "actorGroup")) { $actor.actorGroup.name } else { $actor.actorUser.accountId }
                Refresh_Id = $RefreshId
            }
        }
        
    }
    
    end {
        $toReturn
    }
}