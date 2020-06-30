function Update-JiraProjectActors {
    [CmdletBinding()]
    param (
        # The list of project keys for which to retrieve details
        [Parameter(Mandatory,Position=0,ValueFromPipeline)]
        [string[]]
        $ProjectKeys,

        # The ID value of the refresh underway
        [Parameter(Mandatory,Position=1)]
        [int]
        $RefreshId,

        # The sql instance to update data in
        [Parameter(Mandatory,Position=2)]
        [string]
        $SqlInstance,

        # The sql database to update data in
        [Parameter(Mandatory,Position=3)]
        [string]
        $SqlDatabase,

        # The schema to use when updating data
        [Parameter(Position=4)]
        [string]
        $SchemaName="dbo"
    )
    
    begin {
        Write-Verbose "Updating Project Roles and Actors"

        $actorTableName = "tbl_stg_Jira_Project_Actor"
        $actors = @()
        
        $roleTableName = "tbl_stg_Jira_Project_Role"
        $roles = @()

        $sqlConnSplat = @{
            DatabaseServer = $SqlInstance
            DatabaseName = $SqlDatabase
            SchemaName = $SchemaName
        }
    }
    
    process {
        #first get a list of all project roles
        Write-Verbose "Getting Project Roles"
        $roles += Invoke-JiraGetAllProjectRoles | Read-JiraProjectRole -RefreshId $RefreshId

        #then loop through projects, loop through roles, and retrieve all the actors
        foreach($key in $ProjectKeys) {
            Write-Verbose "Getting Project Actors for Project Key $key"
            $projectRoles = Invoke-JiraGetProjectRolesForProject $key
            foreach($role in $projectRoles.psobject.properties) {
                $roleUrl = [string]$role.value.ToString()
                $roleId = [int]$roleUrl.Substring($roleUrl.LastIndexOf("/") + 1)
                $actors += Invoke-JiraGetProjectRoleForProject $key $roleId | Where-Object { $_ } | Read-JiraProjectActor -ProjectKey $key -RefreshId $RefreshId
            }
        }
    }
    
    end {
        Write-AtlassianData @sqlConnSplat -Data $roles -TableName $roleTableName
        Write-AtlassianData @sqlConnSplat -Data $actors -TableName $actorTableName
    }
}