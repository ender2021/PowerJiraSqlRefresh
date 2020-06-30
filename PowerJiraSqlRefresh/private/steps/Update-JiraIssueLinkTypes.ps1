function Update-JiraIssueLinkTypes {
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
        Write-Verbose "Updating Issue Link Types"
        $tableName = "tbl_stg_Jira_Issue_Link_Type"
        $types = @()

        $sqlConnSplat = @{
            DatabaseServer = $SqlInstance
            DatabaseName = $SqlDatabase
            SchemaName = $SchemaName
        }
    }
    
    process {
        Write-Verbose "Getting Issue Link Types"
        $types += (Invoke-JiraGetIssueLinkTypes) | Read-JiraIssueLinkType -RefreshId $RefreshId
    }
    
    end {
        Write-AtlassianData @sqlConnSplat -Data $types -TableName $tableName
    }
}