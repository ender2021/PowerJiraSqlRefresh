function Update-JiraPriorities {
    [CmdletBinding()]
    param (
        # The ID value of the refresh underway
        [Parameter(Mandatory,Position=0)]
        [int]
        $RefreshId,

        # The sql instance to update data in
        [Parameter(Mandatory,Position=1)]
        [string]
        $SqlInstance,

        # The sql database to update data in
        [Parameter(Mandatory,Position=2)]
        [string]
        $SqlDatabase,

        # The schema to use when updating data
        [Parameter(Position=3)]
        [string]
        $SchemaName="dbo"
    )
    
    begin {
        Write-Verbose "Updating Priorities"
        $tableName = "tbl_stg_Jira_Priority"
        $priorities = @()

        $sqlConnSplat = @{
            DatabaseServer = $SqlInstance
            DatabaseName = $SqlDatabase
            SchemaName = $SchemaName
        }
    }
    
    process {
        Write-Verbose "Getting Priorities"
        $priorities += (Invoke-JiraGetPriorities) | Read-JiraPriority -RefreshId $RefreshId
    }
    
    end {
        Write-AtlassianData @sqlConnSplat -Data $priorities -TableName $tableName
    }
}