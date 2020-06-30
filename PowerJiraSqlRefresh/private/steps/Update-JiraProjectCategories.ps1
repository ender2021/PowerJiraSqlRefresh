function Update-JiraProjectCategories {
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
        Write-Verbose "Updating Project Categories"
        $tableName = "tbl_stg_Jira_Project_Category"
        $categories = @()

        $sqlConnSplat = @{
            DatabaseServer = $SqlInstance
            DatabaseName = $SqlDatabase
            SchemaName = $SchemaName
        }
    }
    
    process {
        Write-Verbose "Getting Project Categories"
        $categories += (Invoke-JiraGetAllProjectCategories) | Read-JiraProjectCategory -RefreshId $RefreshId
    }
    
    end {
        Write-AtlassianData @sqlConnSplat -Data $categories -TableName $tableName
    }
}