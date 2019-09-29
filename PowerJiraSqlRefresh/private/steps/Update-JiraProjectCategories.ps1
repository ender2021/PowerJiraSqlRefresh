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
    }
    
    process {
        Write-Verbose "Getting Project Categories"
        $categories += (Invoke-JiraGetAllProjectCategories) | Read-JiraProjectCategory -RefreshId $RefreshId
    }
    
    end {
        Write-Verbose "Writing Project Categories to staging table"
        $categories | Write-SqlTableData -ServerInstance $SqlInstance -DatabaseName $SqlDatabase -SchemaName $SchemaName -TableName $tableName
    }
}