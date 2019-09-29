function Update-JiraComponents {
    [CmdletBinding()]
    param (
        # The list of project keys for which to retrieve components
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
        Write-Verbose "Begin Jira Component Update"
        $tableName = "tbl_stg_Jira_Component"
        $components = @()
    }
    
    process {
        Write-Verbose "Getting Jira Components for Project Key $_"
        $components += (Invoke-JiraGetProjectComponents $_) | Read-JiraComponent -RefreshId $RefreshId
    }
    
    end {
        Write-Verbose "Writing Jira Components to staging table"
        $components | Write-SqlTableData -ServerInstance $SqlInstance -DatabaseName $SqlDatabase -SchemaName $SchemaName -TableName $tableName
        Write-Verbose "End Jira Component Update"
    }
}